import { test } from 'node:test';
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { copyFileSync, existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('..', import.meta.url));
const hookPath = join(root, 'hooks', 'session-start');
const wrapperPath = join(root, 'hooks', 'run-hook.cmd');

// Resolved here, while PATH still works. On Windows a bare `bash` may be the WSL launcher in
// System32, and Git's bin\bash.exe is a wrapper that repairs PATH, which would make the empty-PATH
// tests prove nothing. usr\bin\bash.exe is the real binary.
function findBash() {
  if (process.platform === 'win32') {
    const candidates = [
      'C:\\Program Files\\Git\\usr\\bin\\bash.exe',
      'C:\\Program Files (x86)\\Git\\usr\\bin\\bash.exe',
      process.env.LOCALAPPDATA && join(process.env.LOCALAPPDATA, 'Programs', 'Git', 'usr', 'bin', 'bash.exe'),
    ];
    return candidates.find((c) => c && existsSync(c)) ?? null;
  }
  const r = spawnSync('sh', ['-c', 'command -v bash'], { encoding: 'utf8' });
  return (r.status === 0 && r.stdout.trim()) || null;
}

const bash = findBash();
const needsBash = { skip: bash ? false : 'no bash found on this machine, so the hook cannot run' };

function spawnBash(args, env = {}) {
  const base = { ...process.env };
  // process.env spreads with the key `Path` on Windows. Left in place, it would survive beside the
  // overriding `PATH` and keep the real search path alive.
  if ('PATH' in env) for (const key of Object.keys(base)) if (/^path$/i.test(key)) delete base[key];
  return spawnSync(bash, args, { env: { ...base, ...env }, encoding: 'utf8' });
}

const runHook = (env, script = hookPath) => spawnBash([script], env);
const context = (r) => JSON.parse(r.stdout).hookSpecificOutput.additionalContext;

test('hook emits the bootstrap as additionalContext', needsBash, () => {
  const out = JSON.parse(runHook({ CLAUDE_PLUGIN_ROOT: root }).stdout);
  assert.equal(out.hookSpecificOutput.hookEventName, 'SessionStart');
  assert.match(out.hookSpecificOutput.additionalContext, /using-devorb/);
  assert.ok(out.hookSpecificOutput.additionalContext.length <= 10000);
});

test('hook carries the skill body intact, in a wrapper without old names', needsBash, () => {
  const text = context(runHook({ CLAUDE_PLUGIN_ROOT: root }));
  const body = readFileSync(join(root, 'skills', 'using-devorb', 'SKILL.md'), 'utf8').trimEnd();
  assert.ok(text.includes(body), 'the JSON round trip changed the skill body');
  for (const blocked of ['superpowers:', '/grill-me', 'setup-matt-pocock', 'docs/agents/', 'ready-for-agent', '.scratch/']) {
    assert.ok(!text.includes(blocked), blocked);
  }
});

test('the emptied PATH really reaches bash', needsBash, () => {
  // Checks the lookup, not the value: Git for Windows' bash reports an empty PATH as `=`.
  const r = spawnBash(['-c', 'command -v cat || printf none'], { PATH: '' });
  assert.equal(r.stdout, 'none');
});

test('hook works with an empty PATH', needsBash, () => {
  const r = runHook({ CLAUDE_PLUGIN_ROOT: root, PATH: '' });
  assert.equal(r.status, 0);
  assert.equal(r.stderr, '');
  assert.doesNotThrow(() => JSON.parse(r.stdout));
});

test('hook survives a missing skill file', needsBash, () => {
  const tmp = mkdtempSync(join(tmpdir(), 'devorb-hook-'));
  try {
    mkdirSync(join(tmp, 'hooks'));
    const copy = join(tmp, 'hooks', 'session-start');
    copyFileSync(hookPath, copy);
    const r = runHook({ CLAUDE_PLUGIN_ROOT: tmp }, copy);
    assert.equal(r.status, 0);
    assert.equal(r.stderr, '');
    assert.match(context(r), /Error reading using-devorb skill/);
  } finally {
    rmSync(tmp, { recursive: true, force: true });
  }
});

test('hook has no platform branches', needsBash, () => {
  const r = runHook({ CURSOR_PLUGIN_ROOT: root, COPILOT_CLI: '1', MUSE_PLUGIN_ROOT: root });
  assert.deepEqual(Object.keys(JSON.parse(r.stdout)), ['hookSpecificOutput']);
});

test('the wrapper reaches the hook with an empty PATH', needsBash, () => {
  const r = spawnBash([wrapperPath, 'session-start'], { PATH: '' });
  assert.equal(r.status, 0);
  assert.equal(r.stderr, '');
  assert.match(context(r), /using-devorb/);
});

test('the wrapper exits quietly when no shell can run the hook', needsBash, () => {
  // Bash always sets $BASH on start, so it is unset here to stand in for a harness without bash.
  const r = spawnBash(['-c', 'unset BASH; . "$0" session-start', wrapperPath], { PATH: '' });
  assert.equal(r.status, 0);
  assert.equal(r.stdout, '');
  assert.equal(r.stderr, '');
});

test('hooks.json runs the wrapper on every session start and every user message', () => {
  const config = JSON.parse(readFileSync(join(root, 'hooks', 'hooks.json'), 'utf8'));
  assert.deepEqual(config, {
    hooks: {
      SessionStart: [
        {
          matcher: 'startup|clear|compact',
          hooks: [
            {
              type: 'command',
              command: '"${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd" session-start',
              powershell: '& "${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd" session-start',
              shell: 'bash',
              async: false,
            },
          ],
        },
      ],
      UserPromptSubmit: [
        {
          hooks: [
            {
              type: 'command',
              command: '"${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd" user-prompt',
              powershell: '& "${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd" user-prompt',
              shell: 'bash',
              async: false,
            },
          ],
        },
      ],
    },
  });
});

test('hook scripts are executable in the git index', () => {
  const r = spawnSync('git', ['ls-files', '-s', 'hooks/run-hook.cmd', 'hooks/session-start', 'hooks/user-prompt'], {
    cwd: root,
    encoding: 'utf8',
  });
  assert.equal(r.status, 0, r.stderr);
  const modes = Object.fromEntries(
    r.stdout
      .trim()
      .split('\n')
      .filter(Boolean)
      .map((line) => [line.split('\t')[1], line.split(' ')[0]]),
  );
  assert.deepEqual(modes, { 'hooks/run-hook.cmd': '100755', 'hooks/session-start': '100755', 'hooks/user-prompt': '100755' });
});

// Long sessions and app prompts that want a task list first pushed the flow skill out in real use:
// a short reminder rides on every user message.
test('user-prompt hook reminds which skill to invoke, in a few tokens, with an empty PATH', needsBash, () => {
  const r = spawnBash([wrapperPath, 'user-prompt'], { PATH: '' });
  assert.equal(r.status, 0);
  assert.equal(r.stderr, '');
  const out = JSON.parse(r.stdout).hookSpecificOutput;
  assert.equal(out.hookEventName, 'UserPromptSubmit');
  assert.match(out.additionalContext, /devorb:debugging/);
  assert.match(out.additionalContext, /devorb:aligning/);
  assert.match(out.additionalContext, /style/i);
  assert.ok(Buffer.byteLength(out.additionalContext) <= 400, `${Buffer.byteLength(out.additionalContext)} bytes`);
});
