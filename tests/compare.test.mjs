import { test } from 'node:test';
import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import {
  chmodSync, existsSync, mkdirSync, mkdtempSync, readFileSync, readdirSync, readlinkSync, rmSync, statSync, symlinkSync, writeFileSync,
} from 'node:fs';
import { tmpdir } from 'node:os';
import { basename, dirname, join } from 'node:path';
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

test('parseArms accepts only the known arms', () => {
  assert.deepEqual(parseArms('devorb,none'), ['devorb', 'none']);
  assert.deepEqual(parseArms('devorb,ui-ux-pro-max,none'), ['devorb', 'ui-ux-pro-max', 'none']);
  assert.throws(() => parseArms('devorb,hallmark'), /hallmark/);
  assert.deepEqual(parseArms('superpowers,mattpocock-skills,none'), ['superpowers', 'mattpocock-skills', 'none']);
  assert.throws(() => parseArms('devorb,trailofbits-skills'), /trailofbits-skills/);
});

test('evalArgs builds the planned command line', () => {
  assert.deepEqual(
    evalArgs({ armDir: 'a', caseGlob: 'debugging-*', runs: 3, model: 'm', maxCostUsd: 20, jsonPath: 'o.json', ablation: 'none' }),
    ['plugin', 'eval', 'a', '--case', 'debugging-*', '--runs', '3', '--model', 'm', '--scaffold', '--allow-tools', 'Bash', 'Edit', 'Write', 'WebFetch',
      '--ablation', 'none', '--json', 'o.json', '--max-cost-usd', '20', '--threshold', '0', '--trust-plugin', '--no-publish'],
  );
});

test('evalArgs adds --eval-dir for the reserved suite only', () => {
  const base = { armDir: 'a', caseGlob: '*', runs: 2, model: 'm', maxCostUsd: 5, jsonPath: 'o.json', ablation: 'none' };
  assert.deepEqual(evalArgs({ ...base, evalDir: 'evals-reserved' }).slice(0, 7), ['plugin', 'eval', 'a', '--case', '*', '--eval-dir', 'evals-reserved']);
  assert.deepEqual(evalArgs({ ...base, evalDir: 'evals' }), evalArgs(base));
});

test('evalArgs adds -j after --max-cost-usd only for more than one run at once', () => {
  const base = { armDir: 'a', caseGlob: '*', runs: 2, model: 'm', maxCostUsd: 5, jsonPath: 'o.json', ablation: 'none' };
  const args = evalArgs({ ...base, concurrency: 3 });
  assert.deepEqual(args.slice(args.indexOf('--max-cost-usd'), args.indexOf('--threshold')), ['--max-cost-usd', '5', '-j', '3']);
  assert.deepEqual(args.filter((x) => x !== '-j' && x !== '3'), evalArgs(base));
  assert.deepEqual(evalArgs({ ...base, concurrency: 1 }), evalArgs(base));
});

test('summarize reads a real eval result', () => {
  const json = JSON.parse(read(new URL('./fixtures/eval-result.json', import.meta.url)));
  const s = summarize(json, ['probe', 'ponytail-probe', 'debugging-gone']);
  const near = (a, b) => assert.ok(Math.abs(a - b) < 1e-9, `${a} vs ${b}`);
  const { costUsd: probeCost, ...probe } = s.cases.probe;
  assert.deepEqual(probe, { score: 1, passRate: 1, runs: 1, errors: 0, maxTurns: 0 });
  near(probeCost, 0.0539035 + 0.0444267); // with and without arms
  const { costUsd: onlyCost, ...only } = s.cases['ponytail-only-probe'];
  assert.deepEqual(only, { score: 0.75, passRate: 0, runs: 1, errors: 0, maxTurns: 0 });
  near(onlyCost, 0.0623431 + 0.0412562);
  assert.equal(s.costUsd, 0.31493);
  near(Object.values(s.cases).reduce((sum, c) => sum + c.costUsd, 0), s.costUsd);
  assert.equal(s.partial, false);
  assert.deepEqual(s.missing, ['debugging-gone']);
  assert.deepEqual(summarize(json).missing, []);
});

test('summarize counts tool errors apart from runs that hit the case max_turns', () => {
  const json = JSON.parse(read(new URL('./fixtures/eval-result.json', import.meta.url)));
  const run = (name) => json.cases.find((c) => c.name === name).arms.with[0];
  run('probe').error = 'sandbox failed to start';
  run('ponytail-probe').error = 'exit 1: Reached maximum number of turns (8)';
  run('ponytail-only-probe').error = '';
  const s = summarize(json);
  assert.deepEqual([s.cases.probe.errors, s.cases.probe.maxTurns], [1, 0]);
  assert.deepEqual([s.cases['ponytail-probe'].errors, s.cases['ponytail-probe'].maxTurns], [0, 1], 'max_turns is the agent, scored by graders');
  assert.equal(s.cases['ponytail-probe'].score, 1);
  assert.deepEqual([s.cases['ponytail-only-probe'].errors, s.cases['ponytail-only-probe'].maxTurns], [0, 0], 'an empty error is no error');
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

test('prepareArm ui-ux-pro-max: the whole repo at its pin, without stack/', async () => {
  const { root } = makeRoot();
  const uiux = repo({
    '.claude-plugin/plugin.json': '{"name":"ui-ux-pro-max"}',
    '.claude/skills/u/SKILL.md': 'u',
    'stack/big.bin': 'heavy',
    'src/ui-ux-pro-max/data/colors.csv': 'c',
  });
  const sourcesPath = join(root, 'fusion', 'sources.json');
  const sources = JSON.parse(read(sourcesPath));
  const entry = { name: 'ui-ux-pro-max', url: uiux.url, lastAbsorbed: uiux.sha, paths: ['src/ui-ux-pro-max/data/colors.csv'] };
  sources.sources.push(entry);
  writeFileSync(sourcesPath, JSON.stringify(sources));
  assert.equal(await resolveRef(entry), uiux.sha, 'its pin, not the remote HEAD');
  const dir = await prepareArm({ name: 'ui-ux-pro-max', ref: uiux.sha }, { root });
  assert.equal(dir, join(root, '.arms', `ui-ux-pro-max@${uiux.sha}`));
  assert.equal(read(join(dir, '.claude-plugin', 'plugin.json')), '{"name":"ui-ux-pro-max"}');
  assert.equal(read(join(dir, '.claude', 'skills', 'u', 'SKILL.md')), 'u');
  assert.equal(read(join(dir, 'src', 'ui-ux-pro-max', 'data', 'colors.csv')), 'c');
  assert.deepEqual(readdirSync(join(dir, 'evals')).sort(), ['demo-one', 'other-two']);
  for (const gone of ['stack', '.git']) assert.ok(!existsSync(join(dir, gone)), gone);
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

test('a source url starting with "-" is never read as a git option', async () => {
  const { root } = makeRoot();
  const marker = join(tmp('marker'), 'ran');
  const url = `--upload-pack=touch ${marker} #`;
  await assert.rejects(resolveRef({ name: 'superpowers', url }), /superpowers/);
  writeFileSync(join(root, 'fusion', 'sources.json'), JSON.stringify({ sources: [{ name: 'superpowers', url, lastAbsorbed: 'a'.repeat(40), paths: ['skills/'] }] }));
  await assert.rejects(prepareArm({ name: 'superpowers', ref: 'a'.repeat(40) }, { root }), /superpowers/);
  assert.ok(!existsSync(marker), 'the url ran as a command');
});

// A fake git install prefix, laid out like CommandLineTools/usr.
function fakeGitPrefix() {
  const prefix = tmp('git');
  writeTree(prefix, { 'bin/git': '#!/bin/sh\n', 'share/git-core/templates/description': 'd' });
  chmodSync(join(prefix, 'bin', 'git'), 0o755);
  mkdirSync(join(prefix, 'libexec', 'git-core'), { recursive: true });
  symlinkSync('../../bin/git', join(prefix, 'libexec', 'git-core', 'git-add'));
  return prefix;
}

test('prepareArm bundles git from the prefix into the arm, or skips with a note when a piece is missing', async () => {
  const { root } = makeRoot();
  const prefix = fakeGitPrefix();
  const dir = await prepareArm({ name: 'none' }, { root, gitPrefix: async () => prefix });
  const git = join(dir, '_extra', 'git');
  assert.ok(statSync(join(git, 'bin', 'git')).mode & 0o100, 'git stays executable');
  assert.equal(readlinkSync(join(git, 'libexec', 'git-core', 'git-add')), '../../bin/git', 'relative links kept, so they resolve inside the arm');
  assert.equal(read(join(git, 'share', 'git-core', 'templates', 'description')), 'd');

  rmSync(join(prefix, 'libexec'), { recursive: true });
  let reason = '';
  const again = await prepareArm({ name: 'none' }, { root, gitPrefix: async () => prefix, onGitSkip: (r) => { reason = r; } });
  assert.ok(!existsSync(join(again, '_extra')));
  assert.match(reason, /git-core/);
});

test('prepareArm leaves no partial git when copying fails midway', async () => {
  const { root } = makeRoot();
  const prefix = fakeGitPrefix();
  const locked = join(prefix, 'libexec', 'git-core', 'git-locked');
  writeFileSync(locked, 'x');
  chmodSync(locked, 0); // bin/git copies, then git-core fails
  let reason = '';
  const dir = await prepareArm({ name: 'none' }, { root, gitPrefix: async () => prefix, onGitSkip: (r) => { reason = r; } });
  assert.ok(!existsSync(join(dir, '_extra', 'git')), 'partial git left in the arm');
  assert.match(reason, /EACCES|permission/i);
});

function io(root, claude, gitPrefix = null) {
  let out = '';
  let err = '';
  return {
    root,
    claude,
    gitPrefix,
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
// devorb passes every run, superpowers half and none nothing. `mode(...)` switches it:
// `partial` exits 2 with partial: true, `error` marks every run as failed, `cases` lists
// the cases it reports, and `omit: { arm, case }` drops one case for arms starting with `arm`.
function fakeClaude() {
  const dir = tmp('bin');
  const bin = join(dir, 'claude.mjs');
  writeFileSync(bin, `#!/usr/bin/env node
import { appendFileSync, existsSync, readFileSync, writeFileSync } from 'node:fs';
import { basename } from 'node:path';
const a = process.argv.slice(2);
const at = (f) => a[a.indexOf(f) + 1];
const arm = basename(a[2]);
const modeFile = new URL('./mode.json', import.meta.url);
const mode = existsSync(modeFile) ? JSON.parse(readFileSync(modeFile, 'utf8')) : {};
appendFileSync(new URL('./log', import.meta.url), arm + ' ' + at('--runs') + ' ' + at('--case') + '\\n');
appendFileSync(new URL('./env', import.meta.url), [arm, process.env.PATH.split(':')[0], process.env.GIT_EXEC_PATH ?? '-', process.env.HOME ?? '-'].join(' ') + '\\n');
appendFileSync(new URL('./ablation', import.meta.url), arm + ' ' + at('--ablation') + '\\n');
appendFileSync(new URL('./args', import.meta.url), JSON.stringify(a) + '\\n');
const rate = arm.startsWith('devorb') ? 1 : arm === 'none' ? 0 : 0.5;
const names = (mode.cases ?? ['demo-one']).filter((n) => !(mode.omit && arm.startsWith(mode.omit.arm) && n === mode.omit.case));
writeFileSync(at('--json'), JSON.stringify({ costUsd: 0.25 * names.length, partial: !!mode.partial, cases: names.map((name) => (
  { name, aggregates: { score: rate, passRate: rate }, arms: { with: [{ costUsd: 0.2, judgeCostUsd: 0.05, error: typeof mode.error === 'string' ? mode.error : mode.error ? 'boom' : null }] } }
)) }));
process.exitCode = mode.partial ? 2 : 0;
`);
  chmodSync(bin, 0o755);
  return {
    bin,
    log: () => read(join(dir, 'log')).trim().split('\n'),
    env: () => read(join(dir, 'env')).trim().split('\n'),
    ablation: () => read(join(dir, 'ablation')).trim().split('\n'),
    args: () => read(join(dir, 'args')).trim().split('\n').map((l) => JSON.parse(l)),
    mode: (m) => writeFileSync(join(dir, 'mode.json'), JSON.stringify(m)),
  };
}

test('CLI runs claude with the bundled git first on PATH, and with the plain env when bundling fails', async () => {
  const { root } = makeRoot();
  const fake = fakeClaude();
  const git = join(root, '.arms', 'none', '_extra', 'git');
  const run = io(root, fake.bin, async () => fakeGitPrefix());
  assert.equal(await runCli(['--skill', 'demo', '--arms', 'none'], run), 0, run.stderr);
  assert.deepEqual(fake.env(), [`none ${join(git, 'bin')} ${join(git, 'libexec', 'git-core')} ${process.env.HOME}`], 'the rest of the env (HOME, auth) passes through');
  assert.doesNotMatch(read(run.stdout.trim().split('\n').at(-1)), /git não empacotado/);

  const skip = io(root, fake.bin, async () => { throw new Error('Command failed: xcrun --find git\nxcrun: error: unable to find git'); });
  assert.equal(await runCli(['--skill', 'demo', '--arms', 'none'], skip), 0, skip.stderr);
  assert.match(skip.stderr, /git não empacotado no braço none: .*unable to find git/);
  assert.match(read(skip.stdout.trim().split('\n').at(-1)), /\n- git não empacotado no braço `none`: Command failed: xcrun --find git \| xcrun: error: unable to find git\n/);
  assert.ok(!existsSync(git));
  assert.equal(fake.env()[1], `none ${process.env.PATH.split(':')[0]} - ${process.env.HOME}`);
});

test('CLI runs the none arm without ablation and names reports apart by suite, ponytail and ablation', async () => {
  const { root } = makeRoot();
  const fake = fakeClaude();
  const report = async (...flags) => {
    const run = io(root, fake.bin);
    assert.equal(await runCli(['--skill', 'demo', ...flags], run), 0, run.stderr);
    return basename(run.stdout.split('\n').find((l) => l.endsWith('.md')));
  };
  const date = new Date().toLocaleDateString('sv-SE');
  assert.equal(await report('--arms', 'devorb,none', '--ablation', 'with-without'), `${date}-demo-with-without.md`);
  const devorb = `devorb@${git(root, 'rev-parse', '--short', 'HEAD')}`;
  assert.deepEqual(fake.ablation(), [`${devorb} with-without`, 'none none'], 'the no-plugin arm has nothing to ablate');
  assert.equal(await report('--arms', 'devorb', '--with-ponytail'), `${date}-demo-ponytail.md`);
  assert.equal(await report('--arms', 'none', '--reserved', '--with-ponytail', '--ablation', 'with-without'), `${date}-demo-reserved-ponytail-with-without-baseline.md`);

  const bad = io(root, fake.bin);
  assert.equal(await runCli(['--skill', 'demo', '--arms', 'none', '--ablation', '../x'], bad), 2);
  assert.match(bad.stderr, /ablation/);
});

test('CLI passes --concurrency through as -j, keeps it out of the cache key and rejects bad values', async () => {
  const { root, superpowers } = makeRoot();
  const fake = fakeClaude();
  const jobs = () => fake.args().map((a) => (a.includes('-j') ? a[a.indexOf('-j') + 1] : '-'));
  assert.equal(await runCli(['--skill', 'demo', '--arms', 'devorb,superpowers', '--concurrency', '3'], io(root, fake.bin)), 0);
  assert.deepEqual(jobs(), ['3', '3']);
  const cacheFile = join(root, 'fusion', 'results', 'baselines', `superpowers@${superpowers.sha}`, 'evals', 'demo-one.json');
  assert.equal('concurrency' in JSON.parse(read(cacheFile)), false);

  assert.equal(await runCli(['--skill', 'demo', '--arms', 'devorb,superpowers'], io(root, fake.bin)), 0);
  assert.deepEqual(jobs(), ['3', '3', '-'], 'default 1 adds no -j, and the cached baseline is reused');

  for (const bad of ['0', '9', '2.5', 'x']) {
    const run = io(root, fake.bin);
    assert.equal(await runCli(['--skill', 'demo', '--arms', 'none', '--concurrency', bad], run), 2, bad);
    assert.match(run.stderr, /--concurrency/);
  }
  assert.equal(fake.args().length, 3);
});

test('CLI drops a git the source ships, so claude gets the plain env', async () => {
  const { root } = makeRoot();
  const source = repo({ '.claude-plugin/plugin.json': '{"name":"superpowers"}', '_extra/git/bin/git': '#!/bin/sh\n' });
  chmodSync(join(source.dir, '_extra', 'git', 'bin', 'git'), 0o755);
  git(source.dir, 'commit', '-q', '-am', 'executable');
  const sha = git(source.dir, 'rev-parse', 'HEAD');
  writeFileSync(join(root, 'fusion', 'sources.json'), JSON.stringify({ sources: [{ name: 'superpowers', url: source.url, lastAbsorbed: 'a'.repeat(40), paths: ['skills/'] }] }));
  const fake = fakeClaude();
  const run = io(root, fake.bin); // gitPrefix null: what non-darwin and a failed xcrun look like
  assert.equal(await runCli(['--skill', 'demo', '--arms', 'superpowers'], run), 0, run.stderr);
  assert.ok(!existsSync(join(root, '.arms', `superpowers@${sha}`, '_extra', 'git')));
  assert.deepEqual(fake.env(), [`superpowers@${sha} ${process.env.PATH.split(':')[0]} - ${process.env.HOME}`]);
});

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
  assert.deepEqual(cached.summary, { score: 0.5, passRate: 0.5, costUsd: 0.25, runs: 1, errors: 0, maxTurns: 0 });

  const second = io(root, fake.bin);
  assert.equal(await runCli(['--skill', 'demo', '--arms', 'devorb,superpowers,none'], second), 0, second.stderr);
  assert.equal(fake.log().length, 5, 'superpowers came from the cache');
  assert.match(read(reportPath), /\| superpowers@[0-9a-f]{7} \| 50% \| 0\.50 \| US\$ 0\.2500 \(cache\) \|/);

  writeFileSync(join(root, 'evals', 'demo-one', 'graders', 'g.md'), '---\ntype: regex\npattern: changed\n---\n');
  assert.equal(await runCli(['--skill', 'demo', '--arms', 'superpowers'], io(root, fake.bin)), 0);
  assert.deepEqual(fake.log().slice(5), [`superpowers@${superpowers.sha} 2 demo-*`], 'a changed case runs again');

  writeFileSync(cacheFile, '{ not json');
  const corrupt = io(root, fake.bin);
  assert.equal(await runCli(['--skill', 'demo', '--arms', 'superpowers'], corrupt), 0, corrupt.stderr);
  assert.equal(fake.log().length, 7, 'an unreadable cache file is a miss');
  assert.equal(JSON.parse(read(cacheFile)).summary.passRate, 0.5);
});

test('CLI never caches partial runs or runs with errors, and names the baseline-only report apart', async () => {
  const { root, superpowers } = makeRoot();
  const fake = fakeClaude();
  const cacheFile = join(root, 'fusion', 'results', 'baselines', `superpowers@${superpowers.sha}`, 'evals', 'demo-one.json');
  const reportOf = (run) => run.stdout.trim().split('\n').at(-1);

  fake.mode({ partial: true });
  const partial = io(root, fake.bin);
  assert.equal(await runCli(['--skill', 'demo', '--arms', 'superpowers'], partial), 0, partial.stderr);
  assert.ok(reportOf(partial).endsWith('-demo-baseline.md'), reportOf(partial));
  assert.match(read(reportOf(partial)), /Rodadas parciais \(teto de custo atingido\): `superpowers@[0-9a-f]{7}`/);
  assert.ok(!existsSync(cacheFile), 'partial run cached');

  fake.mode({ error: true });
  const failed = io(root, fake.bin);
  assert.equal(await runCli(['--skill', 'demo', '--arms', 'superpowers'], failed), 0, failed.stderr);
  assert.match(read(reportOf(failed)), /Rodadas com erro da ferramenta: `superpowers@[0-9a-f]{7}: demo-one \(1\)`/);
  assert.ok(!existsSync(cacheFile), 'run with errors cached');

  fake.mode({});
  assert.equal(await runCli(['--skill', 'demo', '--arms', 'superpowers'], io(root, fake.bin)), 0);
  assert.ok(existsSync(cacheFile));
});

test('CLI does not accept when a devorb case is missing', async () => {
  const { root } = makeRoot();
  writeTree(root, { 'evals/demo-two/case.yaml': CASE('demo-two') });
  const fake = fakeClaude();
  fake.mode({ cases: ['demo-one', 'demo-two'], omit: { arm: 'devorb', case: 'demo-two' } });
  const run = io(root, fake.bin);
  assert.equal(await runCli(['--skill', 'demo', '--arms', 'devorb,none'], run), 0, run.stderr);
  assert.match(run.stdout, /accepted: false/);
  const report = read(run.stdout.split('\n').find((l) => l.endsWith('-demo.md')));
  assert.match(report, /Aprovado: não \(casos do devorb ausentes\)/);
  assert.match(report, /Casos ausentes \(não carregaram ou não rodaram\): `devorb@[0-9a-f]{7}: demo-two`/);
});

test('CLI does not accept when an eval run errors, even if the pass rates would', async () => {
  const { root } = makeRoot();
  const fake = fakeClaude();
  fake.mode({ error: true });
  const run = io(root, fake.bin);
  assert.equal(await runCli(['--skill', 'demo', '--arms', 'devorb,superpowers'], run), 0, run.stderr);
  assert.match(run.stdout, /accepted: false/);
  const report = read(run.stdout.split('\n').find((l) => l.endsWith('-demo.md')));
  assert.match(report, /Aprovado: não \(rodadas com erro da ferramenta\)/);
  assert.match(report, /Regressões \(pior que a melhor linha de base por mais de uma rodada\): nenhuma/);
});

test('CLI reports runs that hit the case max_turns without blocking approval or caching', async () => {
  const { root, superpowers } = makeRoot();
  const fake = fakeClaude();
  fake.mode({ error: 'exit 1: Reached maximum number of turns (8)' });
  const run = io(root, fake.bin);
  assert.equal(await runCli(['--skill', 'demo', '--arms', 'devorb,superpowers'], run), 0, run.stderr);
  assert.match(run.stdout, /accepted: true/);
  const report = read(run.stdout.split('\n').find((l) => l.endsWith('-demo.md')));
  assert.match(report, /Rodadas com erro da ferramenta: nenhuma/);
  assert.match(report, /Rodadas que atingiram o limite de turnos do caso: `devorb@[0-9a-f]{7}: demo-one \(1\)`, `superpowers@[0-9a-f]{7}: demo-one \(1\)`/);
  const cacheFile = join(root, 'fusion', 'results', 'baselines', `superpowers@${superpowers.sha}`, 'evals', 'demo-one.json');
  assert.equal(JSON.parse(read(cacheFile)).summary.maxTurns, 1);
});

test('CLI --baseline-only defaults to the source arms and none, with mattpocock-skills at its pin', async () => {
  const { root, superpowers } = makeRoot();
  const fake = fakeClaude();
  const run = io(root, fake.bin);
  assert.equal(await runCli(['--skill', 'demo', '--baseline-only'], run), 0, run.stderr);
  assert.deepEqual(fake.log(), [`superpowers@${superpowers.sha} 2 demo-*`, `mattpocock-skills@${superpowers.pin} 2 demo-*`, 'none 2 demo-*']);
  assert.ok(run.stdout.trim().endsWith('-demo-baseline.md'), run.stdout);
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
