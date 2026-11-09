import { execFile } from 'node:child_process';
import { createHash } from 'node:crypto';
import { existsSync, mkdirSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { basename, dirname, join } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { promisify } from 'node:util';

const run = promisify(execFile);

const SCRIPT_EXT = new Set(['.sh', '.cmd', '.py', '.js', '.mjs', '.ts', '.ps1']);
const SCRIPT_DIRS = new Set(['hooks', 'scripts']);
const SHA = /^[0-9a-f]{7,64}$/i;
const SAFE_PATH = /^[A-Za-z0-9._\-/@+]+$/;
const NETWORK_TIMEOUT_MS = 120_000;
const LOCAL_TIMEOUT_MS = 30_000;

// Everything fetched from a source is untrusted: git is only ever asked to read
// objects. No checkout (so no source file lands on disk and no hook can fire),
// no shell, no prompts, hooks disabled, every call time-limited.
// `ctx.timeoutMs` overrides the limits (tests only).
async function git({ source, cacheDir, timeoutMs }, args, { cwd, env = {}, raw = false } = {}) {
  const noHooks = join(cacheDir, '.no-hooks');
  mkdirSync(noHooks, { recursive: true });
  const timeout = timeoutMs ?? (args[0] === 'clone' || args[0] === 'fetch' ? NETWORK_TIMEOUT_MS : LOCAL_TIMEOUT_MS);
  try {
    const { stdout } = await run('git', ['-c', `core.hooksPath=${noHooks}`, ...args], {
      cwd,
      encoding: raw ? 'buffer' : 'utf8',
      maxBuffer: 256 * 1024 * 1024,
      timeout,
      env: { ...process.env, GIT_TERMINAL_PROMPT: '0', GIT_SSH_COMMAND: 'ssh -o BatchMode=yes', ...env },
    });
    return stdout;
  } catch (e) {
    if (e.killed) {
      throw new Error(`source ${source.name}: git ${args[0]} timed out after ${timeout / 1000}s`, { cause: e });
    }
    const detail = (e.stderr || e.message || '').toString().trim().split('\n').slice(0, 3).join(' | ');
    throw new Error(`source ${source.name}: git ${args[0]} failed: ${detail}`, { cause: e });
  }
}

const repoDir = (source, cacheDir) => {
  const safe = source.name.replace(/[^A-Za-z0-9._-]/g, '_');
  const hash = createHash('sha1').update(source.url).digest('hex').slice(0, 8);
  return join(cacheDir, `${safe}-${hash}`);
};

async function ensureRepo(ctx) {
  const { source, cacheDir } = ctx;
  const dir = repoDir(source, cacheDir);
  if (existsSync(join(dir, '.git', 'HEAD'))) {
    await git(ctx, ['fetch', '--quiet', '--prune', '--no-tags', 'origin'], { cwd: dir });
    await git(ctx, ['remote', 'set-head', 'origin', '--auto'], { cwd: dir });
  } else {
    mkdirSync(cacheDir, { recursive: true });
    try {
      await git(ctx, ['clone', '--quiet', '--filter=blob:none', '--no-checkout', '--no-tags', '--', source.url, dir]);
    } catch (e) {
      rmSync(dir, { recursive: true, force: true }); // never leave a half clone to be "fetched" next time
      throw e;
    }
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
  // Deterministic order: `--show` / `--diff` address files by their index here.
  return files.sort((a, b) => (a.path < b.path ? -1 : a.path > b.path ? 1 : 0));
}

const isScriptOrHook = (path) => {
  const segs = path.split('/');
  const file = segs.pop();
  const dot = file.lastIndexOf('.');
  const ext = dot > 0 ? file.slice(dot).toLowerCase() : '';
  return segs.some((s) => SCRIPT_DIRS.has(s.toLowerCase())) || SCRIPT_EXT.has(ext);
};

function validateSource(source) {
  const name = typeof source?.name === 'string' && source.name ? source.name : '(unnamed)';
  const bad = (why) => new Error(`source ${name}: ${why}`);
  if (name === '(unnamed)') throw bad('name is missing');
  if (typeof source.url !== 'string' || !source.url) throw bad('url is missing');
  if (!Array.isArray(source.paths) || source.paths.length === 0) throw bad('paths missing or empty');
  if (source.paths.some((p) => typeof p !== 'string' || !p)) throw bad('paths must be non-empty strings');
}

async function analyze(source, { cacheDir, timeoutMs }) {
  validateSource(source);
  const ctx = { source, cacheDir, timeoutMs };
  const dir = await ensureRepo(ctx);
  const g = (args, opts) => git(ctx, args, { cwd: dir, ...opts });

  const to = (await g(['rev-parse', 'refs/remotes/origin/HEAD^{commit}'])).trim();
  const from = source.lastAbsorbed;

  // Checked on every run: a path that vanished (or never existed) must keep showing up.
  const missingPaths = [];
  for (const p of source.paths) {
    if ((await g(['ls-tree', '--name-only', to, '--', p])).trim() === '') missingPaths.push(p);
  }

  const result = {
    name: source.name,
    from,
    to,
    textReuse: source.textReuse !== false,
    status: 'no-change',
    files: [],
    newSkills: [],
    scriptsOrHooks: [],
    oddPaths: [],
    missingPaths,
  };
  const done = (r) => ({ result: r, ctx, dir });

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
  if (!SHA.test(from)) return done({ ...result, status: 'sha-missing' });
  const missing = await exitsOne(['rev-parse', '--verify', '--quiet', `${from}^{commit}`], { GIT_NO_LAZY_FETCH: '1' });
  if (missing || (await exitsOne(['merge-base', '--is-ancestor', from, to]))) {
    return done({ ...result, status: 'sha-missing' });
  }
  if ((await g(['rev-parse', `${from}^{commit}`])).trim() === to) return done(result);

  const out = await g(['diff', '--name-status', '-z', '-M', `${from}..${to}`, '--', ...source.paths]);
  const files = parseNameStatus(out);
  const newSkills = files
    .filter((f) => f.change === 'A' && basename(f.path) === 'SKILL.md' && dirname(f.path) !== '.')
    .map((f) => dirname(f.path));

  return done({
    ...result,
    status: files.length ? 'changed' : 'no-change',
    files,
    newSkills: [...new Set(newSkills)].sort(),
    scriptsOrHooks: files.map((f) => f.path).filter(isScriptOrHook).sort(),
    oddPaths: files.map((f) => f.path).filter((p) => !SAFE_PATH.test(p)).sort(),
  });
}

export async function sourceDiff(source, opts) {
  return (await analyze(source, opts)).result;
}

const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');

function loadSources(sourcesFile) {
  const parsed = JSON.parse(readFileSync(sourcesFile, 'utf8'));
  if (!Array.isArray(parsed?.sources) || parsed.sources.length === 0) {
    throw new Error('"sources" is missing or empty');
  }
  return parsed.sources;
}

// `--show` / `--diff`: file paths come from a third party, so they only ever travel
// as execFile arguments (never a shell), after `--` for diff and glued to the commit
// id for show. Lazy blob fetching stays allowed: the clone is partial.
async function fileCommand(mode, [name, rawIndex], sources, { cacheDir }, out, err) {
  const source = sources.find((s) => s.trackedForFusion !== false && s.name === name);
  if (!source) {
    err(`unknown source ${JSON.stringify(name)}\n`);
    return 1;
  }
  if (!/^\d+$/.test(rawIndex ?? '')) {
    err(`index must be a non-negative integer, got ${JSON.stringify(rawIndex)}\n`);
    return 1;
  }
  const { result, ctx, dir } = await analyze(source, { cacheDir });
  if (result.status !== 'changed') {
    err(`source ${source.name}: status is ${result.status}, there are no files to ${mode.slice(2)}\n`);
    return 1;
  }
  const index = Number(rawIndex);
  const file = result.files[index];
  if (!file) {
    err(`source ${source.name}: no file at index ${index} (${result.files.length} files)\n`);
    return 1;
  }
  if (mode === '--show') {
    if (file.change === 'D') {
      err(`source ${source.name}: ${JSON.stringify(file.path)} was deleted at ${result.to}; nothing to show\n`);
      return 0;
    }
    out(await git(ctx, ['cat-file', 'blob', `${result.to}:${file.path}`], { cwd: dir, raw: true }));
  } else {
    out(
      await git(ctx, ['diff', '--no-color', '--no-ext-diff', '--no-textconv', '-M', `${result.from}..${result.to}`, '--', file.path], {
        cwd: dir,
        env: { GIT_LITERAL_PATHSPECS: '1' },
      }),
    );
  }
  return 0;
}

export async function runCli(
  args,
  {
    sourcesFile = join(ROOT, 'fusion', 'sources.json'),
    cacheDir = join(tmpdir(), 'devorb-source-diff'),
    out = (s) => process.stdout.write(s),
    err = (s) => process.stderr.write(s),
  } = {},
) {
  const isFile = args[0] === '--show' || args[0] === '--diff';
  if (!isFile && !args.includes('--json')) {
    err('usage: node tools/source-diff.mjs --json | --show <source> <index> | --diff <source> <index>\n');
    return 2;
  }
  let sources;
  try {
    sources = loadSources(sourcesFile);
  } catch (e) {
    err(`cannot use ${sourcesFile}: ${e.message}\n`);
    return 1;
  }
  if (isFile) {
    if (args.length !== 3) {
      err(`usage: node tools/source-diff.mjs ${args[0]} <source> <index>\n`);
      return 2;
    }
    try {
      return await fileCommand(args[0], args.slice(1), sources, { cacheDir }, out, err);
    } catch (e) {
      err(`${e.message}\n`);
      return 1;
    }
  }

  const results = [];
  let failed = 0;
  for (const source of sources.filter((s) => s.trackedForFusion !== false)) {
    try {
      results.push(await sourceDiff(source, { cacheDir }));
    } catch (e) {
      failed++;
      err(`${source?.name ?? '(unnamed)'}: ${e.message}\n`);
    }
  }
  out(`${JSON.stringify(results, null, 2)}\n`);
  return failed ? 1 : 0;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  process.exitCode = await runCli(process.argv.slice(2));
}
