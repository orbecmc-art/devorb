// Runs the cases of one suite outside the `claude plugin eval` sandbox, for skills the sandbox
// blocks (Chromium does not launch inside it). Each run is `claude -p --restricted` in a fresh
// temp folder: the owner's login, without their settings, hooks, plugins or MCP servers.
// It writes the part of `claude plugin eval --json` that compare.mjs summarizes.
// Nothing confines the agent here: only run cases you wrote, against plugins you trust.
import { spawn } from 'node:child_process';
import { cpSync, existsSync, mkdirSync, mkdtempSync, readdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { basename, join } from 'node:path';

const JUDGE_MODEL = 'claude-haiku-5-5';
const VOTES = 3;
const MAX_TURNS_ERROR = 'Reached maximum number of turns';

const unquote = (v) => {
  const s = v.trim();
  if (s.startsWith("'") && s.endsWith("'")) return s.slice(1, -1).replace(/''/g, "'");
  if (s.startsWith('"') && s.endsWith('"')) return JSON.parse(s);
  return s;
};

// shortcut: reads only the YAML our own cases use (flat keys, one level of nesting, `>-` and `|`
// blocks, `[a, b]` lists); a case needing more fails loudly instead of running half-read.
export function parseYaml(text) {
  const root = {};
  const lines = text.replace(/\r\n/g, '\n').split('\n');
  let parent = null;
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    if (!line.trim() || /^\s*#/.test(line)) continue;
    const m = line.match(/^( *)([\w-]+):(?:\s+(.*))?$/);
    if (!m) throw new Error(`unsupported YAML line ${i + 1}: ${JSON.stringify(line)}`);
    const [, indent, key, raw = ''] = m;
    const target = indent.length === 0 ? root : parent;
    if (!target) throw new Error(`unsupported YAML nesting at line ${i + 1}`);
    let value;
    const value0 = raw.replace(/\s+#.*$/, '');
    if (/^[>|]-?$/.test(value0)) {
      const block = [];
      while (i + 1 < lines.length && (lines[i + 1].startsWith(`${indent}  `) || !lines[i + 1].trim())) block.push(lines[++i]);
      while (block.length && !block.at(-1).trim()) block.pop();
      const pad = Math.min(...block.filter((l) => l.trim()).map((l) => l.match(/^ */)[0].length));
      const body = block.map((l) => l.slice(pad));
      value = value0[0] === '|'
        ? body.join('\n')
        : body.reduce((acc, l) => (l === '' ? `${acc}\n` : acc === '' || acc.endsWith('\n') ? acc + l : `${acc} ${l}`), '');
    } else if (value0 === '') {
      value = {};
      if (indent.length === 0) parent = value;
    } else if (/^\[.*\]$/.test(value0)) {
      value = value0.slice(1, -1).split(',').map(unquote).filter(Boolean);
    } else {
      value = unquote(raw.startsWith("'") || raw.startsWith('"') ? raw : value0);
      if (/^-?\d+(\.\d+)?$/.test(value)) value = Number(value);
    }
    target[key] = value;
  }
  return root;
}

export function parseGrader(text, name) {
  const [, fm, body = ''] = text.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?([\s\S]*)$/) ?? [];
  if (fm === undefined) throw new Error(`grader ${name}: no frontmatter`);
  return { name, weight: 1, ...parseYaml(fm), body: body.trim() };
}

// The text a grader looks at: the whole trace, the final answer, or one file of the work folder.
function subject(spec, run) {
  if (spec === 'trace') return run.trace;
  if (spec === 'last_message') return run.lastMessage;
  if (spec?.source === 'file') return existsSync(join(run.cwd, spec.path)) ? readFileSync(join(run.cwd, spec.path), 'utf8') : null;
  throw new Error(`unsupported grader target ${JSON.stringify(spec)}`);
}

export function gradeRegex(g, run) {
  const text = subject(g.target, run);
  if (text === null) return { passed: false, explanation: `${g.target.path} missing` };
  const found = new RegExp(g.pattern, g.flags ?? '').test(text);
  return { passed: g.match === 'not_contains' ? !found : found, explanation: found ? 'pattern found' : 'pattern not found' };
}

export function score(results) {
  const total = results.reduce((s, r) => s + r.weight, 0);
  return { score: total ? results.reduce((s, r) => s + (r.passed ? r.weight : 0), 0) / total : 0, passed: results.every((r) => r.passed) };
}

function runProcess(cmd, args, { cwd, timeoutMs, onLine, stdin }) {
  return new Promise((resolve, reject) => {
    // Own process group, so a server the agent left running dies with the run.
    const child = spawn(cmd, args, { cwd, detached: true, stdio: [stdin === undefined ? 'ignore' : 'pipe', 'pipe', 'pipe'] });
    let out = '';
    let err = '';
    let buf = '';
    let timedOut = false;
    const kill = () => { try { process.kill(-child.pid, 'SIGKILL'); } catch {} };
    const timer = setTimeout(() => { timedOut = true; kill(); }, timeoutMs);
    if (stdin !== undefined) child.stdin.end(stdin);
    child.stdout.on('data', (d) => {
      out += d;
      buf += d;
      let n;
      while ((n = buf.indexOf('\n')) >= 0) { onLine?.(buf.slice(0, n)); buf = buf.slice(n + 1); }
    });
    child.stderr.on('data', (d) => { err += d; });
    child.on('error', (e) => { clearTimeout(timer); reject(new Error(`cannot run ${cmd}: ${e.message}`, { cause: e })); });
    child.on('close', (code) => { clearTimeout(timer); kill(); resolve({ code, out, err, timedOut }); });
  });
}

async function judge(claude, g, text) {
  const prompt = [
    'Você é o juiz de um teste automático. Leia o critério e o conteúdo e decida se o conteúdo passa.',
    '', '## Critério', '', g.body, '', '## Conteúdo', '', text ?? '(arquivo ausente)', '',
    'Responda com PASS ou FAIL sozinho na primeira linha e uma frase de motivo na segunda.',
  ].join('\n');
  const votes = [];
  let cost = 0;
  for (let i = 0; i < VOTES; i++) {
    const r = await runProcess(claude, ['-p', '--restricted', '--tools', '', '--strict-mcp-config', '--no-session-persistence',
      '--model', JUDGE_MODEL, '--max-turns', '1', '--output-format', 'json'], { cwd: tmpdir(), timeoutMs: 300_000, stdin: prompt });
    let res = {};
    try { res = JSON.parse(r.out); } catch {}
    cost += res.total_cost_usd ?? 0;
    votes.push(/^\W*PASS\b/i.test(res.result ?? ''));
  }
  const passed = votes.filter(Boolean).length * 2 > VOTES;
  return { passed, explanation: `judge votes: ${votes.map((v) => (v ? 'PASS' : 'FAIL')).join(' ')}`, cost };
}

async function runOnce({ claude, armDir, withPlugin, kase, model, traceOut }) {
  const base = mkdtempSync(join(tmpdir(), 'devorb-outside-'));
  const cwd = join(base, 'cwd');
  mkdirSync(cwd);
  const startedAt = new Date().toISOString();
  try {
    const timeoutMs = (kase.execution.timeout_seconds ?? 900) * 1000;
    if (kase.context?.scaffold_script) {
      const s = await runProcess('bash', [join(kase.dir, kase.context.scaffold_script)], { cwd, timeoutMs: 600_000 });
      if (s.code !== 0) return { score: 0, passed: false, costUsd: 0, judgeCostUsd: 0, startedAt, error: `scaffold exited ${s.code}: ${s.err.slice(-500)}`, graders: [] };
    }
    const tools = kase.execution.allowed_tools ?? ['Read', 'Edit', 'Write', 'Glob', 'Grep', 'Bash'];
    const lines = [];
    const r = await runProcess(claude, [
      '-p', kase.execution.prompt, '--restricted', '--tools', tools.join(','), '--allowedTools', tools.join(','),
      '--permission-mode', 'acceptEdits', '--strict-mcp-config', '--no-session-persistence', '--model', model,
      '--max-turns', String(kase.execution.max_turns ?? 40), '--output-format', 'stream-json', '--verbose',
      ...(withPlugin ? ['--plugin-dir', armDir] : []),
    ], { cwd, timeoutMs, onLine: (l) => lines.push(l) });
    const trace = lines.join('\n');
    writeFileSync(traceOut, `${trace}\n`);
    const events = lines.flatMap((l) => { try { return [JSON.parse(l)]; } catch { return []; } });
    const result = events.findLast((e) => e.type === 'result') ?? {};
    const lastText = events.filter((e) => e.type === 'assistant').flatMap((e) => e.message?.content ?? []).filter((c) => c.type === 'text').at(-1)?.text;
    const run = { cwd, trace, lastMessage: result.result ?? lastText ?? '' };
    const error = r.timedOut ? `timed out after ${timeoutMs / 1000}s`
      : result.subtype === 'error_max_turns' ? MAX_TURNS_ERROR
      : !result.type ? `claude exited ${r.code} without a result: ${r.err.slice(-500)}` : null;
    const graders = [];
    let judgeCostUsd = 0;
    for (const g of kase.graders) {
      let v;
      if (g.type === 'regex') v = gradeRegex(g, run);
      else if (g.type === 'llm') {
        v = await judge(claude, g, subject(g.focus ?? 'last_message', run));
        judgeCostUsd += v.cost;
      } else throw new Error(`grader ${g.name}: unsupported type ${g.type}`);
      graders.push({ name: g.name, weight: g.weight, passed: v.passed, explanation: v.explanation });
    }
    // A background subagent can end the session in a second result: turns add up, cost is cumulative.
    const turns = events.filter((e) => e.type === 'result').reduce((s, e) => s + (e.num_turns ?? 0), 0);
    return { ...score(graders), turns, costUsd: result.total_cost_usd ?? 0, judgeCostUsd, startedAt, error, graders };
  } finally {
    rmSync(base, { recursive: true, force: true });
  }
}

async function pool(tasks, n) {
  const out = new Array(tasks.length);
  let next = 0;
  await Promise.all(Array.from({ length: Math.min(n, tasks.length) }, async () => {
    while (next < tasks.length) { const i = next++; out[i] = await tasks[i](); }
  }));
  return out;
}

export function loadCases(suiteDir, pattern) {
  return readdirSync(suiteDir, { withFileTypes: true })
    .filter((e) => e.isDirectory() && existsSync(join(suiteDir, e.name, 'case.yaml')))
    .map((e) => {
      const dir = join(suiteDir, e.name);
      const c = parseYaml(readFileSync(join(dir, 'case.yaml'), 'utf8'));
      const gdir = join(dir, 'graders');
      const graders = readdirSync(gdir).filter((f) => f.endsWith('.md')).sort()
        .map((f) => parseGrader(readFileSync(join(gdir, f), 'utf8'), basename(f, '.md')));
      return { ...c, name: c.name ?? e.name, dir, graders };
    })
    .filter((c) => pattern.test(c.name));
}

// Same inputs as one `claude plugin eval` call from compare.mjs; the arm runs as `with`.
export async function evalOutside({ claude = 'claude', armDir, pattern, evalDir, runs, model, jsonPath, concurrency = 1, maxCostUsd = Infinity }) {
  const withPlugin = existsSync(join(armDir, '.claude-plugin', 'plugin.json')) && basename(armDir) !== 'none';
  const cases = loadCases(join(armDir, evalDir), pattern);
  const traces = `${jsonPath}.traces`;
  rmSync(traces, { recursive: true, force: true });
  mkdirSync(traces, { recursive: true });
  let spent = 0;
  let partial = false;
  const tasks = cases.flatMap((kase) => Array.from({ length: runs }, (_, i) => async () => {
    if (spent >= maxCostUsd) { partial = true; return null; }
    const r = await runOnce({ claude, armDir, withPlugin, kase, model, traceOut: join(traces, `${kase.name}-${i}.jsonl`) });
    spent += r.costUsd + r.judgeCostUsd;
    return { kase: kase.name, r };
  }));
  const done = (await pool(tasks, concurrency)).filter(Boolean);
  const out = {
    costUsd: done.reduce((s, d) => s + d.r.costUsd + d.r.judgeCostUsd, 0),
    partial,
    cases: cases.map((c) => {
      const rs = done.filter((d) => d.kase === c.name).map((d) => d.r);
      const n = rs.length || 1;
      return { name: c.name, arms: { with: rs }, aggregates: { score: rs.reduce((s, r) => s + r.score, 0) / n, passRate: rs.filter((r) => r.passed).length / n } };
    }),
  };
  writeFileSync(jsonPath, `${JSON.stringify(out, null, 2)}\n`);
  return out;
}
