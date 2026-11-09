import { test } from 'node:test';
import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { mkdtempSync, mkdirSync, writeFileSync, rmSync, existsSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, dirname } from 'node:path';
import { pathToFileURL } from 'node:url';
import { sourceDiff, runCli } from '../tools/source-diff.mjs';

const tmp = (p) => mkdtempSync(join(tmpdir(), `devorb-sd-${p}-`));

function git(cwd, ...args) {
  return execFileSync('git', args, {
    cwd,
    encoding: 'utf8',
    env: {
      ...process.env,
      GIT_AUTHOR_NAME: 't',
      GIT_AUTHOR_EMAIL: 't@t',
      GIT_COMMITTER_NAME: 't',
      GIT_COMMITTER_EMAIL: 't@t',
    },
  }).trim();
}

// A local "remote" served over file:// so the partial clone path is really exercised.
function makeRemote(initial) {
  const dir = tmp('remote');
  git(dir, 'init', '-q', '-b', 'main');
  git(dir, 'config', 'uploadpack.allowFilter', 'true');
  git(dir, 'config', 'core.autocrlf', 'false');
  const remote = {
    dir,
    url: pathToFileURL(dir).href,
    commit(write = {}, remove = [], msg = 'c') {
      for (const [p, body] of Object.entries(write)) {
        mkdirSync(dirname(join(dir, p)), { recursive: true });
        writeFileSync(join(dir, p), body);
      }
      for (const p of remove) rmSync(join(dir, p));
      git(dir, 'add', '-A');
      git(dir, 'commit', '-q', '-m', msg);
      return git(dir, 'rev-parse', 'HEAD');
    },
    mv(from, to) {
      mkdirSync(dirname(join(dir, to)), { recursive: true });
      git(dir, 'mv', from, to);
      git(dir, 'commit', '-q', '-m', 'mv');
      return git(dir, 'rev-parse', 'HEAD');
    },
  };
  remote.first = remote.commit(initial);
  return remote;
}

const BODY = 'line one\nline two\nline three\nline four\nline five\nline six\n';
const base = () => ({ 'skills/a/SKILL.md': BODY, 'README.md': 'r' });
const goneUrl = () => pathToFileURL(join(tmp('gone'), 'nope')).href;

function setup(initial = base(), extra = {}) {
  const remote = makeRemote(initial);
  const cacheDir = tmp('cache');
  const source = {
    name: 'src',
    url: remote.url,
    lastAbsorbed: remote.first,
    paths: ['skills/', 'hooks/', 'plugins/'],
    ...extra,
  };
  return { remote, cacheDir, source, run: () => sourceDiff(source, { cacheDir }) };
}

test('no new commits', async () => {
  const { remote, run } = setup();
  const r = await run();
  assert.equal(r.status, 'no-change');
  assert.deepEqual(r.files, []);
  assert.equal(r.from, remote.first);
  assert.equal(r.to, remote.first);
  assert.equal(r.name, 'src');
  assert.equal(r.textReuse, true);
});

test('textReuse false is reported', async () => {
  const { run } = setup(base(), { textReuse: false });
  assert.equal((await run()).textReuse, false);
});

test('change in a tracked path', async () => {
  const { remote, run } = setup();
  const to = remote.commit({ 'skills/a/SKILL.md': BODY + 'more\n' });
  const r = await run();
  assert.equal(r.status, 'changed');
  assert.deepEqual(r.files, [{ path: 'skills/a/SKILL.md', change: 'M' }]);
  assert.equal(r.to, to);
  assert.deepEqual(r.newSkills, []);
});

test('change outside tracked paths', async () => {
  const { remote, run } = setup();
  remote.commit({ 'README.md': 'changed' });
  const r = await run();
  assert.equal(r.status, 'no-change');
  assert.deepEqual(r.files, []);
});

test('new skill folder', async () => {
  const { remote, run } = setup();
  remote.commit({ 'skills/b/SKILL.md': 'b', 'skills/b/notes.md': 'n' });
  assert.deepEqual((await run()).newSkills, ['skills/b']);
});

test('new skill in a nested path', async () => {
  const { remote, run } = setup();
  remote.commit({ 'plugins/x/skills/b/SKILL.md': 'b' });
  assert.deepEqual((await run()).newSkills, ['plugins/x/skills/b']);
});

test('new file in an existing skill is not a new skill', async () => {
  const { remote, run } = setup();
  remote.commit({ 'skills/a/extra.md': 'x' });
  const r = await run();
  assert.deepEqual(r.files, [{ path: 'skills/a/extra.md', change: 'A' }]);
  assert.deepEqual(r.newSkills, []);
});

test('hooks and scripts are flagged', async () => {
  const { remote, run } = setup();
  remote.commit({
    'hooks/session-start': 'x',
    'skills/a/scripts/x.sh': 'x',
    'skills/a/run.py': 'x',
    'skills/a/notes.md': 'x',
  });
  const r = await run();
  assert.deepEqual(r.scriptsOrHooks, ['hooks/session-start', 'skills/a/run.py', 'skills/a/scripts/x.sh']);
});

test('tracked file deleted', async () => {
  const { remote, run } = setup({ ...base(), 'skills/a/scripts/old.sh': 'x' });
  remote.commit({}, ['skills/a/scripts/old.sh']);
  const r = await run();
  assert.deepEqual(r.files, [{ path: 'skills/a/scripts/old.sh', change: 'D' }]);
  assert.deepEqual(r.scriptsOrHooks, ['skills/a/scripts/old.sh']);
});

test('rename reports the new path everywhere', async () => {
  const { remote, run } = setup({ ...base(), 'skills/a/old.sh': BODY });
  remote.mv('skills/a/old.sh', 'skills/a/scripts/new.sh');
  const r = await run();
  assert.deepEqual(r.files, [{ path: 'skills/a/scripts/new.sh', change: 'R' }]);
  assert.deepEqual(r.scriptsOrHooks, ['skills/a/scripts/new.sh']);
});

test('rewritten history', async () => {
  const { remote, cacheDir, source } = setup();
  const r = await sourceDiff({ ...source, lastAbsorbed: 'f'.repeat(40) }, { cacheDir });
  assert.equal(r.status, 'sha-missing');
  assert.deepEqual(r.files, []);
  assert.equal(r.to, remote.first);
});

test('lastAbsorbed that looks like an option is sha-missing, not passed to git', async () => {
  const { cacheDir, source } = setup();
  const r = await sourceDiff({ ...source, lastAbsorbed: '--output=x' }, { cacheDir });
  assert.equal(r.status, 'sha-missing');
});

test('second call with the same cacheDir fetches', async () => {
  const { remote, cacheDir, run } = setup();
  await run();
  assert.ok(existsSync(cacheDir));
  const to = remote.commit({ 'skills/a/SKILL.md': BODY + 'new\n' });
  const r = await run();
  assert.equal(r.status, 'changed');
  assert.equal(r.to, to);
});

test('unreachable source rejects naming the source', async () => {
  await assert.rejects(
    sourceDiff({ name: 'ghost', url: goneUrl(), lastAbsorbed: 'a'.repeat(40), paths: ['skills/'] }, { cacheDir: tmp('cache') }),
    /ghost/,
  );
});

function cliSetup(sources) {
  const dir = tmp('cli');
  const sourcesFile = join(dir, 'sources.json');
  writeFileSync(sourcesFile, JSON.stringify({ sources }));
  let out = '';
  let err = '';
  return {
    sourcesFile,
    cacheDir: tmp('cache'),
    out: (s) => { out += s; },
    err: (s) => { err += s; },
    get stdout() { return out; },
    get stderr() { return err; },
  };
}

test('--json skips ponytail', async () => {
  const { source } = setup();
  const ponytail = { name: 'ponytail', url: goneUrl(), trackedForFusion: false, lastAbsorbed: 'a'.repeat(40), paths: ['skills/'] };
  const io = cliSetup([source, ponytail]);
  const code = await runCli(['--json'], io);
  assert.equal(code, 0);
  assert.deepEqual(JSON.parse(io.stdout).map((r) => r.name), ['src']);
  assert.equal(io.stderr, '');
});

test('--json prints reachable results, reports the failed source and exits non-zero', async () => {
  const { source } = setup();
  const ghost = { name: 'ghost', url: goneUrl(), lastAbsorbed: 'a'.repeat(40), paths: ['skills/'] };
  const io = cliSetup([ghost, source]);
  const code = await runCli(['--json'], io);
  assert.notEqual(code, 0);
  assert.deepEqual(JSON.parse(io.stdout).map((r) => r.name), ['src']);
  assert.match(io.stderr, /ghost/);
});

test('history rewritten after a warm cache is sha-missing too', async () => {
  const { remote, cacheDir, source } = setup();
  const pinned = remote.commit({ 'skills/a/SKILL.md': BODY + 'pinned\n' });
  const pin = { ...source, lastAbsorbed: pinned };
  assert.equal((await sourceDiff(pin, { cacheDir })).status, 'no-change'); // warms the cache
  git(remote.dir, 'reset', '-q', '--hard', remote.first);
  const rewritten = remote.commit({ 'skills/a/SKILL.md': BODY + 'rewritten\n' });
  const r = await sourceDiff(pin, { cacheDir });
  assert.equal(r.status, 'sha-missing');
  assert.deepEqual(r.files, []);
  assert.equal(r.to, rewritten);
});
