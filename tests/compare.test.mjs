import { test } from 'node:test';
import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { chmodSync, existsSync, mkdirSync, mkdtempSync, readFileSync, readdirSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { decide, evalArgs, parseArms, prepareArm, resolveRef, runCli, summarize } from '../tools/compare.mjs';

// Isolate from the machine: no inherited GIT_* variables, no global or system git config.
for (const k of Object.keys(process.env)) if (k.startsWith('GIT_')) delete process.env[k];
const NULL_DEVICE = process.platform === 'win32' ? 'NUL' : '/dev/null';
process.env.GIT_CONFIG_GLOBAL = NULL_DEVICE;
process.env.GIT_CONFIG_SYSTEM = NULL_DEVICE;

const tmp = (p) => mkdtempSync(join(tmpdir(), `devorb-cmp-${p}-`));
const read = (p) => readFileSync(p, 'utf8');

function git(cwd, ...args) {
  return execFileSync('git', args, {
    cwd,
    encoding: 'utf8',
    env: { ...process.env, GIT_AUTHOR_NAME: 't', GIT_AUTHOR_EMAIL: 't@t', GIT_COMMITTER_NAME: 't', GIT_COMMITTER_EMAIL: 't@t' },
  }).trim();
}

function writeTree(dir, files) {
  for (const [p, body] of Object.entries(files)) {
    mkdirSync(dirname(join(dir, p)), { recursive: true });
    writeFileSync(join(dir, p), body);
  }
}

// A committed git repo; served over file:// when used as a source.
function repo(files) {
  const dir = tmp('repo');
  git(dir, 'init', '-q', '-b', 'main');
  writeTree(dir, files);
  git(dir, 'add', '-A');
  git(dir, 'commit', '-q', '-m', 'c');
  return { dir, url: pathToFileURL(dir).href, sha: git(dir, 'rev-parse', 'HEAD') };
}

const CASE = (name) => `schema_version: "1.0"\nname: ${name}\nexecution:\n  prompt: >-\n    do it\n`;

// A small DevOrb-like root: two suites, ignored results, local sources.
function makeRoot() {
  const ponytail = repo({ '.claude-plugin/plugin.json': '{"name":"ponytail"}', 'skills/p/SKILL.md': 'p' });
  const superpowers = repo({
    '.claude-plugin/plugin.json': '{"name":"superpowers"}',
    'skills/s/SKILL.md': 's',
    'evals/theirs/case.yaml': CASE('theirs'),
    'evals-reserved/theirs/case.yaml': CASE('theirs'),
  });
  // mattpocock-skills reuses this repo, pinned one commit behind its HEAD.
  superpowers.pin = superpowers.sha;
  writeTree(superpowers.dir, { 'skills/s/NEW.md': 'newer' });
  git(superpowers.dir, 'add', '-A');
  git(superpowers.dir, 'commit', '-q', '-m', 'newer');
  superpowers.sha = git(superpowers.dir, 'rev-parse', 'HEAD');
  const root = repo({
    '.gitignore': '.arms/\nevals/**/results/\n',
    '.claude-plugin/plugin.json': '{"name":"devorb"}',
    'skills/x/SKILL.md': 'x',
    'evals/demo-one/case.yaml': CASE('demo-one'),
    'evals/demo-one/graders/g.md': '---\ntype: regex\npattern: ok\n---\n',
    'evals/other-two/case.yaml': CASE('other-two'),
    'evals-reserved/demo-hold/case.yaml': CASE('demo-hold'),
    'docs/x.md': 'the bug and its fix',
    'fusion/results/r.md': 'an earlier report',
    'fusion/ledger/debugging.md': 'a rule made for a reserved case',
    'fusion/eval-config.json': '{ "model": "m", "maxCostUsd": 1 }',
    'fusion/skills.json': '{ "demo": { "level": "light" } }',
    'fusion/sources.json': JSON.stringify({
      sources: [
        { name: 'superpowers', url: superpowers.url, lastAbsorbed: 'a'.repeat(40), paths: ['skills/'] },
        { name: 'mattpocock-skills', url: superpowers.url, lastAbsorbed: superpowers.pin, paths: ['skills/'] },
        { name: 'ponytail', url: ponytail.url, lastAbsorbed: 'b'.repeat(40), paths: ['skills/'], trackedForFusion: false },
      ],
    }),
  });
  writeTree(root.dir, { 'skills/x/NEW.md': 'uncommitted', 'evals/demo-one/results/old.json': '{}', '.superpowers/l.md': 'ledger' });
  return { root: root.dir, ponytail, superpowers };
}

const d = (cases, runs = 3) => decide({ cases, runs });

test('decide follows the plan', () => {
  assert.deepEqual(d({ c: { devorb: 1, sp: 0.5 } }).regressions, []);
  assert.deepEqual(d({ c: { devorb: 0.33, sp: 1 } }).regressions, ['c']);
  assert.deepEqual(d({ c: { devorb: 0.7, sp: 1 } }).regressions, []); // dentro de 1/3
  assert.deepEqual(d({ c: { devorb: 0.5, sp: 0.6 } }).belowBar, ['c']); // abaixo de 2/3
  assert.deepEqual(d({ c: { devorb: 0, sp: 0 } }).gaps, ['c']); // nenhum braço chega lá: lacuna
  assert.equal(d({ c: { devorb: 0, sp: 0 } }).accepted, true);
  assert.equal(d({ c: { devorb: 0.33, sp: 1 } }).accepted, false);
  assert.equal(d({}).accepted, false); // nenhum caso encontrado não conta como aprovado
  assert.deepEqual(d({ c: { devorb: 1, none: 0 } }).regressions, []);
});

test('decide: exact thirds stay within one run, and a gap is not below the bar', () => {
  assert.deepEqual(d({ c: { devorb: 2 / 3, sp: 1 } }), { accepted: true, regressions: [], belowBar: [], gaps: [] });
  assert.deepEqual(d({ c: { devorb: 1 / 3, sp: 1 } }).regressions, ['c']);
  assert.deepEqual(d({ c: { devorb: 0.5, sp: 1 } }, 2).regressions, []);
  assert.deepEqual(d({ c: { devorb: 0, sp: 0, none: 0 } }), { accepted: true, regressions: [], belowBar: [], gaps: ['c'] });
  assert.deepEqual(d({ c: { devorb: 0, none: 1 / 3 } }).belowBar, ['c']);
  assert.deepEqual(d({ c: { devorb: 0 } }), { accepted: false, regressions: [], belowBar: ['c'], gaps: [] }, 'a gap needs a baseline');
});

test('decide ignores cases without devorb (baseline-only runs)', () => {
  assert.deepEqual(d({ c: { sp: 0, none: 0 } }), { accepted: false, regressions: [], belowBar: [], gaps: [] });
  assert.deepEqual(d({ c: { sp: 1 }, e: { devorb: 1, sp: 1 } }).accepted, true);
});

test('parseArms accepts only the four arms', () => {
  assert.deepEqual(parseArms('devorb,none'), ['devorb', 'none']);
  assert.deepEqual(parseArms('superpowers,mattpocock-skills,none'), ['superpowers', 'mattpocock-skills', 'none']);
  assert.throws(() => parseArms('devorb,trailofbits-skills'), /trailofbits-skills/);
});

test('evalArgs builds the planned command line', () => {
  assert.deepEqual(
    evalArgs({ armDir: 'a', caseGlob: 'debugging-*', runs: 3, model: 'm', maxCostUsd: 20, jsonPath: 'o.json', ablation: 'none' }),
    ['plugin', 'eval', 'a', '--case', 'debugging-*', '--runs', '3', '--model', 'm', '--scaffold', '--allow-tools', 'Bash', 'Edit', 'Write',
      '--ablation', 'none', '--json', 'o.json', '--max-cost-usd', '20', '--threshold', '0', '--trust-plugin', '--no-publish'],
  );
});

test('evalArgs adds --eval-dir for the reserved suite only', () => {
  const base = { armDir: 'a', caseGlob: '*', runs: 2, model: 'm', maxCostUsd: 5, jsonPath: 'o.json', ablation: 'none' };
  assert.deepEqual(evalArgs({ ...base, evalDir: 'evals-reserved' }).slice(0, 7), ['plugin', 'eval', 'a', '--case', '*', '--eval-dir', 'evals-reserved']);
  assert.deepEqual(evalArgs({ ...base, evalDir: 'evals' }), evalArgs(base));
});

test('summarize reads a real eval result', () => {
  const json = JSON.parse(read(new URL('./fixtures/eval-result.json', import.meta.url)));
  const s = summarize(json, ['probe', 'ponytail-probe', 'debugging-gone']);
  const near = (a, b) => assert.ok(Math.abs(a - b) < 1e-9, `${a} vs ${b}`);
  const { costUsd: probeCost, ...probe } = s.cases.probe;
  assert.deepEqual(probe, { score: 1, passRate: 1, runs: 1 });
  near(probeCost, 0.0539035 + 0.0444267); // with and without arms
  const { costUsd: onlyCost, ...only } = s.cases['ponytail-only-probe'];
  assert.deepEqual(only, { score: 0.75, passRate: 0, runs: 1 });
  near(onlyCost, 0.0623431 + 0.0412562);
  assert.equal(s.costUsd, 0.31493);
  near(Object.values(s.cases).reduce((sum, c) => sum + c.costUsd, 0), s.costUsd);
  assert.equal(s.partial, false);
  assert.deepEqual(s.missing, ['debugging-gone']);
  assert.deepEqual(summarize(json).missing, []);
});

test('prepareArm none: empty plugin plus only the active suite', async () => {
  const { root } = makeRoot();
  const dir = await prepareArm({ name: 'none' }, { root });
  assert.equal(dir, join(root, '.arms', 'none'));
  assert.deepEqual(readdirSync(dir).sort(), ['.claude-plugin', 'evals']);
  assert.deepEqual(JSON.parse(read(join(dir, '.claude-plugin', 'plugin.json'))), { name: 'none' });
  assert.ok(existsSync(join(dir, 'evals', 'demo-one', 'graders', 'g.md')));
  assert.ok(!existsSync(join(dir, 'evals', 'demo-one', 'results')), 'ignored results are not copied');

  const rsv = await prepareArm({ name: 'none' }, { root, suite: 'evals-reserved' });
  assert.deepEqual(readdirSync(rsv).sort(), ['.claude-plugin', 'evals-reserved']);
});

test('prepareArm devorb: working tree with uncommitted files, one suite, no .git', async () => {
  const { root } = makeRoot();
  const dir = await prepareArm({ name: 'devorb' }, { root });
  assert.equal(dir, join(root, '.arms', `devorb@${git(root, 'rev-parse', '--short', 'HEAD')}`));
  assert.equal(read(join(dir, 'skills', 'x', 'NEW.md')), 'uncommitted');
  assert.ok(existsSync(join(dir, 'evals', 'demo-one', 'case.yaml')));
  assert.ok(existsSync(join(dir, 'fusion', 'sources.json')));
  for (const gone of ['evals-reserved', '.git', '.arms', 'docs', 'fusion/results', 'fusion/ledger', '.superpowers']) {
    assert.ok(!existsSync(join(dir, gone)), gone);
  }

  writeFileSync(join(root, 'skills', 'x', 'NEW.md'), 'edited');
  await prepareArm({ name: 'devorb' }, { root });
  assert.equal(read(join(dir, 'skills', 'x', 'NEW.md')), 'edited', 'rebuilt on every call');
});

test('prepareArm source: fetched at the sha, its own suites replaced by ours', async () => {
  const { root, superpowers } = makeRoot();
  const dir = await prepareArm({ name: 'superpowers', ref: superpowers.sha }, { root, suite: 'evals-reserved' });
  assert.equal(dir, join(root, '.arms', `superpowers@${superpowers.sha}`));
  assert.equal(read(join(dir, 'skills', 's', 'SKILL.md')), 's');
  assert.deepEqual(readdirSync(join(dir, 'evals-reserved')), ['demo-hold']);
  for (const gone of ['evals', '.git']) assert.ok(!existsSync(join(dir, gone)), gone);
  await assert.rejects(prepareArm({ name: 'superpowers', ref: 'main' }, { root }), /superpowers/);
});

test('prepareArm with ponytail copies it inside the arm and points every case at both plugins', async () => {
  const { root, ponytail } = makeRoot();
  const dir = await prepareArm({ name: 'devorb' }, { root, withPonytail: true, ponytailRef: ponytail.sha });
  assert.equal(read(join(dir, '_extra', 'ponytail', 'skills', 'p', 'SKILL.md')), 'p');
  assert.ok(!existsSync(join(dir, '_extra', 'ponytail', '.git')));
  for (const c of ['demo-one', 'other-two']) {
    assert.match(read(join(dir, 'evals', c, 'case.yaml')), /\nplugins: \["\.\.\/\.\.","\.\.\/\.\.\/_extra\/ponytail"\]\n$/);
  }
  assert.doesNotMatch(read(join(root, 'evals', 'demo-one', 'case.yaml')), /plugins/, 'the root copy is untouched');

  writeFileSync(join(root, 'evals', 'other-two', 'case.yaml'), `${CASE('other-two')}plugins: ["../.."]\n`);
  await assert.rejects(prepareArm({ name: 'none' }, { root, withPonytail: true, ponytailRef: ponytail.sha }), /other-two.*plugins/);
});

test('resolveRef: superpowers and ponytail follow the remote HEAD, others their pin', async () => {
  const { root, superpowers, ponytail } = makeRoot();
  const { sources } = JSON.parse(read(join(root, 'fusion', 'sources.json')));
  const by = (n) => sources.find((s) => s.name === n);
  assert.equal(await resolveRef(by('superpowers')), superpowers.sha);
  assert.equal(await resolveRef(by('ponytail')), ponytail.sha);
  assert.notEqual(superpowers.pin, superpowers.sha);
  assert.equal(await resolveRef(by('mattpocock-skills')), superpowers.pin, 'its pin, not the remote HEAD');
});

function io(root, claude) {
  let out = '';
  let err = '';
  return {
    root,
    claude,
    out: (s) => { out += s; },
    err: (s) => { err += s; },
    get stdout() { return out; },
    get stderr() { return err; },
  };
}

test('CLI rejects a null model and an unknown arm before running anything', async () => {
  const { root } = makeRoot();
  const bad = io(root, '/nonexistent/claude');
  assert.notEqual(await runCli(['--skill', 'demo', '--arms', 'devorb,trailofbits-skills'], bad), 0);
  assert.match(bad.stderr, /trailofbits-skills/);

  writeFileSync(join(root, 'fusion', 'eval-config.json'), '{ "model": null, "maxCostUsd": 20 }');
  const nul = io(root, '/nonexistent/claude');
  assert.notEqual(await runCli(['--skill', 'demo', '--arms', 'devorb,none'], nul), 0);
  assert.match(nul.stderr, /model/);
  assert.ok(!existsSync(join(root, '.arms')));
});

// Fake `claude`: logs "<arm dir name> <runs> <case glob>" and writes a result where
// devorb passes every run, superpowers half and none nothing.
function fakeClaude() {
  const dir = tmp('bin');
  const bin = join(dir, 'claude.mjs');
  writeFileSync(bin, `#!/usr/bin/env node
import { appendFileSync, writeFileSync } from 'node:fs';
import { basename } from 'node:path';
const a = process.argv.slice(2);
const at = (f) => a[a.indexOf(f) + 1];
const arm = basename(a[2]);
appendFileSync(new URL('./log', import.meta.url), arm + ' ' + at('--runs') + ' ' + at('--case') + '\\n');
const rate = arm.startsWith('devorb') ? 1 : arm === 'none' ? 0 : 0.5;
writeFileSync(at('--json'), JSON.stringify({ costUsd: 0.25, partial: false, cases: [
  { name: 'demo-one', aggregates: { score: rate, passRate: rate }, arms: { with: [{ costUsd: 0.2, judgeCostUsd: 0.05 }] } },
] }));
`);
  chmodSync(bin, 0o755);
  return { bin, log: () => read(join(dir, 'log')).trim().split('\n') };
}

test('CLI runs each arm, caches source baselines per case and writes the report', async () => {
  const { root, superpowers } = makeRoot();
  const fake = fakeClaude();
  const devorb = `devorb@${git(root, 'rev-parse', '--short', 'HEAD')}`;
  const first = io(root, fake.bin);
  assert.equal(await runCli(['--skill', 'demo', '--arms', 'devorb,superpowers,none'], first), 0, first.stderr);
  assert.deepEqual(fake.log(), [`${devorb} 2 demo-*`, `superpowers@${superpowers.sha} 2 demo-*`, 'none 2 demo-*']);

  const reportPath = first.stdout.split('\n').find((l) => l.endsWith('-demo.md'));
  assert.ok(reportPath && existsSync(reportPath), first.stdout);
  assert.equal(dirname(reportPath), join(root, 'fusion', 'results'));
  const report = read(reportPath);
  assert.match(report, /demo-one/);
  assert.match(report, /Aprovado: sim/);
  assert.match(first.stdout, /accepted: true/);

  const cacheFile = join(root, 'fusion', 'results', 'baselines', `superpowers@${superpowers.sha}`, 'evals', 'demo-one.json');
  const cached = JSON.parse(read(cacheFile));
  assert.equal(cached.model, 'm');
  assert.equal(cached.runs, 2);
  assert.equal(cached.withPonytail, false);
  assert.equal(cached.ablation, 'none');
  assert.match(cached.caseHash, /^[0-9a-f]{64}$/);
  assert.deepEqual(cached.summary, { score: 0.5, passRate: 0.5, costUsd: 0.25, runs: 1 });

  const second = io(root, fake.bin);
  assert.equal(await runCli(['--skill', 'demo', '--arms', 'devorb,superpowers,none'], second), 0, second.stderr);
  assert.equal(fake.log().length, 5, 'superpowers came from the cache');
  assert.match(read(reportPath), /\| superpowers@[0-9a-f]{7} \| 50% \| 0\.50 \| US\$ 0\.2500 \(cache\) \|/);

  writeFileSync(join(root, 'evals', 'demo-one', 'graders', 'g.md'), '---\ntype: regex\npattern: changed\n---\n');
  assert.equal(await runCli(['--skill', 'demo', '--arms', 'superpowers', '--runs', '3'], io(root, fake.bin)), 0);
  assert.deepEqual(fake.log().slice(5), [`superpowers@${superpowers.sha} 3 demo-*`], 'a changed case runs again');
});

test('CLI --baseline-only defaults to the source arms and none, with mattpocock-skills at its pin', async () => {
  const { root, superpowers } = makeRoot();
  const fake = fakeClaude();
  const run = io(root, fake.bin);
  assert.equal(await runCli(['--skill', 'demo', '--baseline-only'], run), 0, run.stderr);
  assert.deepEqual(fake.log(), [`superpowers@${superpowers.sha} 2 demo-*`, `mattpocock-skills@${superpowers.pin} 2 demo-*`, 'none 2 demo-*']);
  assert.match(read(run.stdout.trim().split('\n').at(-1)), /só linhas de base/);

  const empty = io(root, fake.bin);
  assert.equal(await runCli(['--skill', 'demo', '--baseline-only', '--arms', 'devorb'], empty), 2);
  assert.match(empty.stderr, /no arm/);
  assert.equal(empty.stdout, '');
  assert.equal(fake.log().length, 3);
});

// The eval loader rejects a plain YAML scalar holding ": " (the 5 evolving cases failed to load).
test('grader frontmatter has no unquoted value containing ": "', () => {
  const bad = [];
  const walk = (dir) => {
    for (const e of readdirSync(dir, { withFileTypes: true })) {
      const p = join(dir, e.name);
      if (e.isDirectory()) walk(p);
      else if (e.name.endsWith('.md') && /[/\\]graders$/.test(dir)) {
        const fm = read(p).match(/^---\r?\n([\s\S]*?)\r?\n---/)?.[1] ?? '';
        for (const line of fm.split(/\r?\n/)) {
          const value = line.match(/^\s*[\w-]+:\s+(.*)$/)?.[1];
          if (value && !/^['"]/.test(value) && value.includes(': ')) bad.push(`${p}: ${line}`);
        }
      }
    }
  };
  for (const suite of ['evals', 'evals-reserved']) {
    const dir = new URL(`../${suite}`, import.meta.url);
    if (existsSync(dir)) walk(fileURLToPath(dir));
  }
  assert.deepEqual(bad, []);
});
