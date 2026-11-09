import { execFile } from 'node:child_process';
import { createHash } from 'node:crypto';
import { existsSync, mkdirSync, readFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { basename, dirname, join } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { promisify } from 'node:util';

const run = promisify(execFile);

const SCRIPT_EXT = new Set(['.sh', '.cmd', '.py', '.js', '.mjs', '.ts', '.ps1']);
const SCRIPT_DIRS = new Set(['hooks', 'scripts']);
const SHA = /^[0-9a-f]{7,64}$/i;

// Everything fetched from a source is untrusted: git is only ever asked to read
// objects. No checkout (so no source file lands on disk and no hook can fire),
// no shell, no prompts, hooks disabled.
async function git(source, cacheDir, args, { cwd, env = {} } = {}) {
  const noHooks = join(cacheDir, '.no-hooks');
  mkdirSync(noHooks, { recursive: true });
  try {
    const { stdout } = await run('git', ['-c', `core.hooksPath=${noHooks}`, ...args], {
      cwd,
      encoding: 'utf8',
      maxBuffer: 256 * 1024 * 1024,
      env: { ...process.env, GIT_TERMINAL_PROMPT: '0', ...env },
    });
    return stdout;
  } catch (e) {
    const detail = (e.stderr || e.message || '').toString().trim().split('\n').slice(0, 3).join(' | ');
    throw new Error(`source ${source.name}: git ${args[0]} failed: ${detail}`, { cause: e });
  }
}

const repoDir = (source, cacheDir) => {
  const safe = source.name.replace(/[^A-Za-z0-9._-]/g, '_');
  const hash = createHash('sha1').update(source.url).digest('hex').slice(0, 8);
  return join(cacheDir, `${safe}-${hash}`);
};

async function ensureRepo(source, cacheDir) {
  const dir = repoDir(source, cacheDir);
  if (existsSync(join(dir, '.git', 'HEAD'))) {
    await git(source, cacheDir, ['fetch', '--quiet', '--prune', '--no-tags', 'origin'], { cwd: dir });
    await git(source, cacheDir, ['remote', 'set-head', 'origin', '--auto'], { cwd: dir });
  } else {
    mkdirSync(cacheDir, { recursive: true });
    await git(source, cacheDir, [
      'clone', '--quiet', '--filter=blob:none', '--no-checkout', '--no-tags', '--', source.url, dir,
    ]);
  }
  return dir;
}

function parseNameStatus(out) {
  const parts = out.split('\0');
  const files = [];
  for (let i = 0; i < parts.length && parts[i] !== ''; ) {
    const code = parts[i][0];
    if (code === 'R' || code === 'C') {
      files.push({ path: parts[i + 2], change: code === 'R' ? 'R' : 'A' });
      i += 3;
    } else {
      files.push({ path: parts[i + 1], change: code === 'A' || code === 'D' ? code : 'M' });
      i += 2;
    }
  }
  return files;
}

const isScriptOrHook = (path) => {
  const segs = path.split('/');
  const file = segs.pop();
  const dot = file.lastIndexOf('.');
  const ext = dot > 0 ? file.slice(dot).toLowerCase() : '';
  return segs.some((s) => SCRIPT_DIRS.has(s.toLowerCase())) || SCRIPT_EXT.has(ext);
};

export async function sourceDiff(source, { cacheDir }) {
  const dir = await ensureRepo(source, cacheDir);
  const g = (args, opts) => git(source, cacheDir, args, { cwd: dir, ...opts });

  const to = (await g(['rev-parse', 'refs/remotes/origin/HEAD^{commit}'])).trim();
  const from = source.lastAbsorbed;
  const result = {
    name: source.name,
    from,
    to,
    textReuse: source.textReuse !== false,
    status: 'no-change',
    files: [],
    newSkills: [],
    scriptsOrHooks: [],
  };

  // Missing commit and non-ancestor pin (rewritten history) both mean sha-missing,
  // so a warm cache (old commit still in the object store) agrees with a cold one.
  // Only git's "no" exit code (1) counts; any other failure rejects.
  const exitsOne = async (args, env) => {
    try {
      await g(args, { env });
      return false;
    } catch (e) {
      if (e.cause?.code === 1) return true;
      throw e;
    }
  };
  if (!SHA.test(from)) return { ...result, status: 'sha-missing' };
  const missing = await exitsOne(['rev-parse', '--verify', '--quiet', `${from}^{commit}`], { GIT_NO_LAZY_FETCH: '1' });
  if (missing || (await exitsOne(['merge-base', '--is-ancestor', from, to]))) {
    return { ...result, status: 'sha-missing' };
  }
  if ((await g(['rev-parse', `${from}^{commit}`])).trim() === to) return result;

  const out = await g(['diff', '--name-status', '-z', '-M', `${from}..${to}`, '--', ...source.paths]);
  const files = parseNameStatus(out);
  const newSkills = files
    .filter((f) => f.change === 'A' && basename(f.path) === 'SKILL.md' && dirname(f.path) !== '.')
    .map((f) => dirname(f.path));

  return {
    ...result,
    status: files.length ? 'changed' : 'no-change',
    files,
    newSkills: [...new Set(newSkills)].sort(),
    scriptsOrHooks: files.map((f) => f.path).filter(isScriptOrHook).sort(),
  };
}

const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');

export async function runCli(
  args,
  {
    sourcesFile = join(ROOT, 'fusion', 'sources.json'),
    cacheDir = join(tmpdir(), 'devorb-source-diff'),
    out = (s) => process.stdout.write(s),
    err = (s) => process.stderr.write(s),
  } = {},
) {
  if (!args.includes('--json')) {
    err('usage: node tools/source-diff.mjs --json\n');
    return 2;
  }
  const { sources } = JSON.parse(readFileSync(sourcesFile, 'utf8'));
  const results = [];
  let failed = 0;
  for (const source of sources.filter((s) => s.trackedForFusion !== false)) {
    try {
      results.push(await sourceDiff(source, { cacheDir }));
    } catch (e) {
      failed++;
      err(`${source.name}: ${e.message}\n`);
    }
  }
  out(`${JSON.stringify(results, null, 2)}\n`);
  return failed ? 1 : 0;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  process.exitCode = await runCli(process.argv.slice(2));
}
