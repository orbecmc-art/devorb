import { execFile, spawn } from 'node:child_process';
import { createHash } from 'node:crypto';
import { copyFileSync, existsSync, mkdirSync, readFileSync, rmSync, statSync, writeFileSync } from 'node:fs';
import { devNull } from 'node:os';
import { basename, dirname, join, relative, sep } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { promisify } from 'node:util';

const run = promisify(execFile);

const ARMS = ['devorb', 'superpowers', 'mattpocock-skills', 'none'];
const SOURCE_ARMS = new Set(['superpowers', 'mattpocock-skills']);
// Owner decision of 2026-11-10: superpowers and ponytail always run at the latest commit of their default branch.
const LATEST = new Set(['superpowers', 'ponytail']);
const SUITES = ['evals', 'evals-reserved'];
// Answers the agent under test must not read: docs/ holds the bugs and fixes the cases test,
// fusion/results/ earlier reports, fusion/ledger/ rules made for reserved cases, .superpowers/ the coordinator ledger.
const NOT_IN_DEVORB_ARM = [...SUITES.map((s) => `${s}/`), 'docs/', 'fusion/results/', 'fusion/ledger/', '.superpowers/'];
const FULL_SHA = /^[0-9a-f]{40}$/;
const NETWORK_TIMEOUT_MS = 120_000;
const LOCAL_TIMEOUT_MS = 30_000;
const EPSILON = 1e-9;
const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');
const USAGE =
  'usage: node tools/compare.mjs --skill <name|all> --arms <a,b,c> [--with-ponytail] [--baseline-only] [--reserved] [--ablation <mode>] [--runs <n>]\n' +
  '  --baseline-only skips devorb; without --arms it runs superpowers,mattpocock-skills,none\n';

export function parseArms(text) {
  const arms = text.split(',').map((a) => a.trim());
  for (const a of arms) {
    if (!ARMS.includes(a)) throw new Error(`unknown arm ${JSON.stringify(a)}: use ${ARMS.join(', ')}`);
  }
  return arms;
}

export function evalArgs({ armDir, caseGlob, runs, model, maxCostUsd, jsonPath, ablation, evalDir = 'evals' }) {
  return [
    'plugin', 'eval', armDir, '--case', caseGlob,
    ...(evalDir === 'evals' ? [] : ['--eval-dir', evalDir]),
    '--runs', String(runs), '--model', model, '--scaffold', '--allow-tools', 'Bash', 'Edit', 'Write',
    '--ablation', ablation, '--json', jsonPath, '--max-cost-usd', String(maxCostUsd), '--threshold', '0', '--trust-plugin', '--no-publish',
  ];
}

// Values are case pass rates per arm. Baseline = best non-devorb arm; one run of tolerance.
export function decide({ cases, runs }) {
  const regressions = [];
  const belowBar = [];
  const gaps = [];
  let judged = 0;
  for (const [name, arms] of Object.entries(cases)) {
    if (typeof arms.devorb !== 'number') continue;
    judged++;
    const baselines = Object.entries(arms).filter(([a]) => a !== 'devorb').map(([, v]) => v);
    const best = Math.max(0, ...baselines);
    if (best - arms.devorb > 1 / runs + EPSILON) regressions.push(name);
    if (arms.devorb === 0 && baselines.length > 0 && best === 0) gaps.push(name);
    else if (arms.devorb < 2 / 3 - EPSILON) belowBar.push(name);
  }
  return { accepted: judged > 0 && regressions.length === 0 && belowBar.length === 0, regressions, belowBar, gaps };
}

// One `claude plugin eval --json` output: score and pass rate of arm `with`, cost of every arm
// (so per-case costs add up to the total under with-without), and runs the tool itself failed
// (`error`), which say nothing about the skill. Cases that failed to load are absent.
export function summarize(json, expectedCases = []) {
  const cases = {};
  for (const c of json.cases) {
    const allRuns = Object.values(c.arms ?? {}).flat();
    cases[c.name] = {
      score: c.aggregates.score,
      passRate: c.aggregates.passRate,
      costUsd: allRuns.reduce((sum, r) => sum + (r.costUsd ?? 0) + (r.judgeCostUsd ?? 0), 0),
      runs: c.arms?.with?.length ?? 0,
      errors: allRuns.filter((r) => r.error != null).length,
    };
  }
  return { cases, costUsd: json.costUsd, partial: json.partial === true, missing: expectedCases.filter((n) => !(n in cases)) };
}

// Fetched sources are untrusted: no shell, hooks disabled, symlinks checked out as
// plain files (so nothing written into the arm can escape it), every call time-limited.
async function git(args, { cwd, what }) {
  const timeout = args[0] === 'fetch' || args[0] === 'ls-remote' ? NETWORK_TIMEOUT_MS : LOCAL_TIMEOUT_MS;
  try {
    const { stdout } = await run('git', ['-c', `core.hooksPath=${devNull}`, '-c', 'core.symlinks=false', ...args], {
      cwd,
      encoding: 'utf8',
      maxBuffer: 64 * 1024 * 1024,
      timeout,
      env: { ...process.env, GIT_TERMINAL_PROMPT: '0', GIT_SSH_COMMAND: 'ssh -o BatchMode=yes' },
    });
    return stdout;
  } catch (e) {
    if (e.killed) throw new Error(`${what}: git ${args[0]} timed out after ${timeout / 1000}s`, { cause: e });
    const detail = (e.stderr || e.message || '').toString().trim().split('\n').slice(0, 3).join(' | ');
    throw new Error(`${what}: git ${args[0]} failed: ${detail}`, { cause: e });
  }
}

export async function resolveRef(source) {
  if (!LATEST.has(source.name)) return source.lastAbsorbed;
  const sha = (await git(['ls-remote', '--', source.url, 'HEAD'], { what: `source ${source.name}` })).split('\t')[0].trim();
  if (!FULL_SHA.test(sha)) throw new Error(`source ${source.name}: git ls-remote returned no HEAD commit`);
  return sha;
}

const fresh = (dir) => {
  rmSync(dir, { recursive: true, force: true });
  mkdirSync(dir, { recursive: true });
};

const readJson = (root, p) => {
  try {
    return JSON.parse(readFileSync(join(root, p), 'utf8'));
  } catch (e) {
    throw new Error(`cannot use ${p}: ${e.message}`, { cause: e });
  }
};

function findSource(root, name) {
  const source = readJson(root, 'fusion/sources.json').sources?.find((s) => s.name === name);
  if (!source) throw new Error(`source ${name}: not in fusion/sources.json`);
  return source;
}

async function fetchAt(source, sha, dest) {
  if (!FULL_SHA.test(sha ?? '')) throw new Error(`source ${source.name}: ref must be a full commit sha, got ${JSON.stringify(sha)}`);
  fresh(dest);
  const what = `source ${source.name}`;
  await git(['init', '--quiet'], { cwd: dest, what });
  await git(['fetch', '--quiet', '--depth', '1', '--no-tags', '--', source.url, sha], { cwd: dest, what });
  await git(['checkout', '--quiet', 'FETCH_HEAD'], { cwd: dest, what });
  rmSync(join(dest, '.git'), { recursive: true, force: true });
}

const isFile = (p) => {
  try {
    return statSync(p).isFile();
  } catch {
    return false;
  }
};

// Working tree files, uncommitted ones included; ignored files (results, .arms) left out.
async function listFiles(root) {
  const out = await git(['ls-files', '-co', '--exclude-standard', '-z'], { cwd: root, what: 'devorb' });
  const files = out.split('\0').filter((p) => p && !p.startsWith('.arms/') && isFile(join(root, p)));
  return [...new Set(files)].sort();
}

function copyFiles(root, files, dest) {
  for (const p of files) {
    mkdirSync(dirname(join(dest, p)), { recursive: true });
    copyFileSync(join(root, p), join(dest, p));
  }
}

const inSuite = (p, suite) => p.startsWith(`${suite}/`);
const posix = (p) => p.split(sep).join('/');

export async function prepareArm({ name, ref }, { root, suite = 'evals', withPonytail = false, ponytailRef }) {
  if (!ARMS.includes(name)) throw new Error(`unknown arm ${JSON.stringify(name)}`);
  const files = await listFiles(root);
  let dir;
  if (name === 'none') {
    dir = join(root, '.arms', 'none');
    fresh(dir);
    mkdirSync(join(dir, '.claude-plugin'));
    writeFileSync(join(dir, '.claude-plugin', 'plugin.json'), '{"name":"none"}\n');
  } else if (name === 'devorb') {
    const sha = (await git(['rev-parse', '--short', 'HEAD'], { cwd: root, what: 'devorb' })).trim();
    dir = join(root, '.arms', `devorb@${sha}`);
    fresh(dir);
    copyFiles(root, files.filter((p) => !NOT_IN_DEVORB_ARM.some((x) => p.startsWith(x))), dir);
  } else {
    dir = join(root, '.arms', `${name}@${ref}`);
    await fetchAt(findSource(root, name), ref, dir);
  }
  // A run can read a sibling suite through the plugin root: keep only the active one.
  for (const s of SUITES) rmSync(join(dir, s), { recursive: true, force: true });
  const suiteFiles = files.filter((p) => inSuite(p, suite));
  copyFiles(root, suiteFiles, dir);

  if (withPonytail) {
    const ponytailDir = join(dir, '_extra', 'ponytail');
    await fetchAt(findSource(root, 'ponytail'), ponytailRef, ponytailDir);
    // `plugins:` replaces the target, so it lists the arm itself too; paths must stay inside the arm.
    for (const p of suiteFiles.filter((f) => basename(f) === 'case.yaml')) {
      const file = join(dir, p);
      const text = readFileSync(file, 'utf8');
      if (/^plugins\s*:/m.test(text)) throw new Error(`${p}: already has plugins:, cannot add ponytail`);
      const plugins = [relative(dirname(file), dir), relative(dirname(file), ponytailDir)].map(posix);
      writeFileSync(file, `${text}${text.endsWith('\n') ? '' : '\n'}plugins: ${JSON.stringify(plugins)}\n`);
    }
  }
  return dir;
}

const globRegex = (glob) =>
  new RegExp(`^${[...glob].map((c) => (c === '*' ? '.*' : c === '?' ? '.' : c.replace(/[.+^${}()|[\]\\]/g, '\\$&'))).join('')}$`);

function suiteCases(root, files, suite) {
  return files
    .filter((p) => inSuite(p, suite) && basename(p) === 'case.yaml')
    .map((p) => {
      const dir = dirname(p);
      const name = readFileSync(join(root, p), 'utf8').match(/^name:[ \t]*["']?([^"'\r\n]+?)["']?[ \t]*$/m)?.[1] ?? basename(dir);
      const hash = createHash('sha256');
      for (const f of files.filter((x) => x.startsWith(`${dir}/`))) {
        hash.update(`${f.slice(dir.length + 1)}\0`).update(readFileSync(join(root, f))).update('\0');
      }
      return { name, hash: hash.digest('hex') };
    });
}

function parseArgs(argv) {
  const opts = { withPonytail: false, baselineOnly: false, reserved: false, ablation: 'none' };
  const flags = { '--with-ponytail': 'withPonytail', '--baseline-only': 'baselineOnly', '--reserved': 'reserved' };
  const values = { '--skill': 'skill', '--arms': 'arms', '--ablation': 'ablation', '--runs': 'runs' };
  for (let i = 0; i < argv.length; i++) {
    if (flags[argv[i]]) opts[flags[argv[i]]] = true;
    else if (values[argv[i]] && i + 1 < argv.length) opts[values[argv[i]]] = argv[++i];
    else throw new Error(`unknown or incomplete option ${JSON.stringify(argv[i])}`);
  }
  if (opts.baselineOnly) opts.arms ??= 'superpowers,mattpocock-skills,none';
  if (!opts.skill || !opts.arms) throw new Error('--skill and --arms are required');
  if (!/^(all|[a-z0-9][a-z0-9-]*)$/.test(opts.skill)) throw new Error(`bad skill name ${JSON.stringify(opts.skill)}`);
  if (opts.runs !== undefined && !/^[1-9]\d*$/.test(opts.runs)) throw new Error(`--runs must be a positive integer, got ${JSON.stringify(opts.runs)}`);
  return opts;
}

function runClaude(claude, args) {
  return new Promise((resolve, reject) => {
    const child = spawn(claude, args, { stdio: ['ignore', 'inherit', 'inherit'] });
    child.on('error', (e) => reject(new Error(`cannot run ${claude}: ${e.message}`, { cause: e })));
    child.on('close', resolve);
  });
}

const pct = (v) => `${Math.round(v * 100)}%`;
const usd = (v) => `US$ ${v.toFixed(4)}`;
const list = (xs, none) => (xs.length ? xs.map((x) => `\`${x}\``).join(', ') : none);

function report({ date, skill, suite, caseGlob, runs, model, ablation, ponytailRef, arms, caseNames, outcome, accepted, blockers, hasDevorb }) {
  const lines = [
    `# Comparação de versões: ${skill}`,
    '',
    `- Data: ${date}`,
    `- Suíte: \`${suite}\`, casos \`${caseGlob}\`, ${runs} rodadas por caso, modelo \`${model}\`, ablação \`${ablation}\``,
    `- Ponytail: ${ponytailRef ? `sim, em \`${ponytailRef}\`` : 'não'}`,
    `- Braços: ${list(arms.map((a) => a.label), 'nenhum')}`,
    '',
    '| Caso | Braço | Aprovação | Pontuação | Custo |',
    '|---|---|---|---|---|',
  ];
  for (const c of caseNames) {
    for (const a of arms) {
      const r = a.cases[c];
      lines.push(r
        ? `| ${c} | ${a.label} | ${pct(r.passRate)} | ${r.score.toFixed(2)} | ${usd(r.costUsd)}${r.cached ? ' (cache)' : ''} |`
        : `| ${c} | ${a.label} | ausente | - | - |`);
    }
  }
  const missing = arms.filter((a) => a.missing.length).map((a) => `${a.label}: ${a.missing.join(', ')}`);
  const errors = arms.flatMap((a) => caseNames.filter((c) => a.cases[c]?.errors).map((c) => `${a.label}: ${c} (${a.cases[c].errors})`));
  const verdict = !hasDevorb ? 'não se aplica (só linhas de base)' : accepted ? 'sim' : blockers.length ? `não (${blockers.join(', ')})` : 'não';
  lines.push(
    '',
    `Custo total desta execução: ${usd(arms.reduce((s, a) => s + a.costUsd, 0))} (linhas de base em cache não contam).`,
    '',
    `- Casos ausentes (não carregaram ou não rodaram): ${list(missing, 'nenhum')}`,
    `- Rodadas parciais (teto de custo atingido): ${list(arms.filter((a) => a.partial).map((a) => a.label), 'nenhuma')}`,
    `- Rodadas com erro da ferramenta: ${list(errors, 'nenhuma')}`,
    '',
    '## Decisão',
    '',
    `- Aprovado: ${verdict}`,
    `- Regressões (pior que a melhor linha de base por mais de uma rodada): ${list(outcome.regressions, 'nenhuma')}`,
    `- Abaixo da barra de 2/3: ${list(outcome.belowBar, 'nenhum')}`,
    `- Lacunas (nenhum braço passa): ${list(outcome.gaps, 'nenhuma')}`,
    '',
  );
  return lines.join('\n');
}

async function compare(opts, armNames, { root, claude, out }) {
  const config = readJson(root, 'fusion/eval-config.json');
  if (!config.model) throw new Error('fusion/eval-config.json: model is null; set the eval model first');
  const registry = readJson(root, 'fusion/skills.json');
  const runs = opts.runs ? Number(opts.runs) : registry[opts.skill]?.level === 'light' ? 2 : 3;
  const suite = opts.reserved ? 'evals-reserved' : 'evals';
  const caseGlob = opts.skill === 'all' ? '*' : `${opts.skill}-*`;
  const pattern = globRegex(caseGlob);
  const expected = suiteCases(root, await listFiles(root), suite).filter((c) => pattern.test(c.name));
  if (expected.length === 0) throw new Error(`no case in ${suite}/ matches ${caseGlob}`);
  const caseNames = expected.map((c) => c.name).sort();

  const ponytailRef = opts.withPonytail ? await resolveRef(findSource(root, 'ponytail')) : null;
  const key = { model: config.model, runs, withPonytail: opts.withPonytail, ponytailRef, ablation: opts.ablation };
  const arms = [];
  for (const name of armNames) {
    const ref = SOURCE_ARMS.has(name) ? await resolveRef(findSource(root, name)) : undefined;
    const arm = { name, label: ref ? `${name}@${ref.slice(0, 7)}` : name, cases: {}, missing: [], partial: false, costUsd: 0 };
    const cacheDir = ref && join(root, 'fusion', 'results', 'baselines', `${name}@${ref}`, suite);
    for (const c of cacheDir ? expected : []) {
      const file = join(cacheDir, `${c.name}.json`);
      let hit = null;
      try {
        hit = JSON.parse(readFileSync(file, 'utf8'));
      } catch {} // absent or unreadable: a miss
      if (hit && hit.caseHash === c.hash && Object.entries(key).every(([k, v]) => hit[k] === v)) {
        arm.cases[c.name] = { ...hit.summary, cached: true };
      }
    }
    // shortcut: one uncached case reruns the whole glob; split per case if baselines get expensive.
    if (expected.some((c) => !arm.cases[c.name])) {
      const armDir = await prepareArm({ name, ref }, { root, suite, withPonytail: opts.withPonytail, ponytailRef });
      if (!ref) arm.label = basename(armDir);
      const jsonPath = join(armDir, 'eval-result.json');
      out(`${arm.label}: claude plugin eval ${caseGlob}\n`);
      const code = await runClaude(
        claude,
        evalArgs({ armDir, caseGlob, runs, model: config.model, maxCostUsd: config.maxCostUsd, jsonPath, ablation: opts.ablation, evalDir: suite }),
      );
      if (!existsSync(jsonPath)) throw new Error(`arm ${arm.label}: claude plugin eval exited ${code} without writing ${jsonPath}`);
      const s = summarize(JSON.parse(readFileSync(jsonPath, 'utf8')), caseNames);
      Object.assign(arm, { missing: s.missing, partial: s.partial || code === 2, costUsd: s.costUsd ?? 0 });
      Object.assign(arm.cases, s.cases);
      if (cacheDir && !arm.partial) {
        mkdirSync(cacheDir, { recursive: true });
        for (const c of expected.filter((x) => s.cases[x.name] && s.cases[x.name].errors === 0)) {
          writeFileSync(join(cacheDir, `${c.name}.json`), `${JSON.stringify({ caseHash: c.hash, ...key, summary: s.cases[c.name] }, null, 2)}\n`);
        }
      }
    }
    arms.push(arm);
  }

  const decideCases = Object.fromEntries(
    caseNames.map((c) => [c, Object.fromEntries(arms.filter((a) => a.cases[c]).map((a) => [a.name, a.cases[c].passRate]))]),
  );
  const outcome = decide({ cases: decideCases, runs });
  const devorb = arms.find((a) => a.name === 'devorb');
  // The plan gates on the printed `accepted:`, so anything that makes the rates untrustworthy blocks it:
  // an errored baseline run lowers the best baseline and can hide a regression.
  const blockers = [];
  if (devorb?.missing.length) blockers.push('casos do devorb ausentes');
  if (arms.some((a) => caseNames.some((c) => a.cases[c]?.errors))) blockers.push('rodadas com erro da ferramenta');
  const accepted = outcome.accepted && !!devorb && blockers.length === 0;
  const date = new Date().toLocaleDateString('sv-SE'); // YYYY-MM-DD in local time
  // A baseline-only report never overwrites the day's devorb verdict.
  const reportPath = join(root, 'fusion', 'results', `${date}-${opts.skill}${opts.reserved ? '-reserved' : ''}${devorb ? '' : '-baseline'}.md`);
  mkdirSync(dirname(reportPath), { recursive: true });
  writeFileSync(
    reportPath,
    report({ date, skill: opts.skill, suite, caseGlob, runs, model: config.model, ablation: opts.ablation, ponytailRef, arms, caseNames, outcome, accepted, blockers, hasDevorb: !!devorb }),
  );
  out(`${reportPath}\n`);
  if (devorb) out(`accepted: ${accepted}\n`);
  return 0;
}

export async function runCli(
  argv,
  { root = ROOT, claude = 'claude', out = (s) => process.stdout.write(s), err = (s) => process.stderr.write(s) } = {},
) {
  let opts;
  let arms;
  try {
    opts = parseArgs(argv);
    arms = parseArms(opts.arms).filter((a) => !(opts.baselineOnly && a === 'devorb'));
    if (arms.length === 0) throw new Error('no arm left to run: --baseline-only skips devorb');
  } catch (e) {
    err(`${e.message}\n${USAGE}`);
    return 2;
  }
  try {
    return await compare(opts, arms, { root, claude, out });
  } catch (e) {
    err(`${e.message}\n`);
    return 1;
  }
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  process.exitCode = await runCli(process.argv.slice(2));
}
