import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, existsSync } from 'node:fs';

const read = (p) => JSON.parse(readFileSync(new URL(`../${p}`, import.meta.url), 'utf8'));
const exists = (p) => existsSync(new URL(`../${p}`, import.meta.url));

const plugin = read('.claude-plugin/plugin.json');
const market = read('.claude-plugin/marketplace.json');
const sources = read('fusion/sources.json');
const registry = read('fusion/skills.json');
const pkg = read('package.json');

test('plugin and marketplace agree', () => {
  assert.equal(plugin.name, 'devorb');
  assert.match(plugin.version, /^\d+\.\d+\.\d+$/);
  assert.equal(market.name, 'devorb');
  assert.equal(market.plugins[0].name, 'devorb');
  assert.equal(market.plugins[0].source, './');
  assert.equal(market.plugins[0].version, undefined);
});

test('package.json is private and carries no version', () => {
  assert.equal(pkg.private, true);
  assert.equal('version' in pkg, false);
});

test('sources are pinned to full commits', () => {
  for (const s of sources.sources) assert.match(s.lastAbsorbed, /^[0-9a-f]{40}$/);
});

test('new sources track only the folders chosen for fusion', () => {
  const paths = Object.fromEntries(sources.sources.map((s) => [s.name, s.paths]));
  assert.deepEqual(paths['karpathy-skills'], ['skills/karpathy-guidelines/']);
  assert.deepEqual(paths['anthropic-skills'], ['skills/webapp-testing/']);
  assert.deepEqual(paths['trailofbits-skills'], [
    'plugins/variant-analysis/skills/',
    'plugins/patching-bugs/skills/implement-patch/',
    'plugins/property-based-testing/skills/',
    'plugins/differential-review/skills/',
    'plugins/spec-to-code-compliance/skills/',
    'plugins/fp-check/skills/',
  ]);
  assert.deepEqual(paths['spartan-toolkit'], [
    'toolkit/skills/browser-qa/',
    'toolkit/skills/js-security-audit/',
    'toolkit/skills/service-debugging/',
  ]);
});

test('ecc tracks skill folders, or only SKILL.md when the folder holds a script', () => {
  const ecc = sources.sources.find((s) => s.name === 'ecc');
  assert.ok(ecc?.paths.length > 0);
  for (const p of ecc.paths) assert.match(p, /^skills\/[a-z0-9-]+\/(SKILL\.md)?$/);
});

test('no source tracks code the monthly cycle would refuse every time it changes', () => {
  for (const s of sources.sources) {
    for (const p of s.paths) assert.doesNotMatch(p, /\.(ts|js|mjs|cjs|sh|py|ps1|cmd)$/, `${s.name}: ${p}`);
  }
});

test('impeccable tracks its source, not the generated per-agent copies', () => {
  const impeccable = sources.sources.find((s) => s.name === 'impeccable');
  assert.ok(impeccable?.paths.length > 0);
  for (const p of impeccable.paths) assert.match(p, /^skill\//);
});

test('design sources only lend ideas', () => {
  const names = ['impeccable', 'hallmark', 'taste-skill', 'frontend-design', 'emil-skills', 'scroll-craft', 'paper-shaders', 'diagram-design', 'ui-ux-pro-max'];
  for (const name of names) {
    assert.equal(sources.sources.find((s) => s.name === name)?.textReuse, false, name);
  }
});

test('gstack tracks source files, never generated skills, folders or code', () => {
  const gstack = sources.sources.find((s) => s.name === 'gstack');
  assert.ok(gstack?.paths.length > 0);
  for (const p of gstack.paths) {
    assert.doesNotMatch(p, /\/$/, `${p}: a folder brings files regenerated with the shared preamble`);
    assert.doesNotMatch(p, /(^|\/)SKILL\.md$/, `${p}: generated from SKILL.md.tmpl`);
    assert.doesNotMatch(p, /\.(ts|js|mjs|sh|py)$/, `${p}: the cycle refuses scripts every month`);
  }
});

test('ecc and gstack only lend ideas, because parts of them derive from third parties', () => {
  for (const name of ['ecc', 'gstack']) {
    assert.equal(sources.sources.find((s) => s.name === name)?.textReuse, false, name);
  }
});

test('only permissive sources with a license file may lend text', () => {
  for (const s of sources.sources) {
    if (s.textReuse === false) continue;
    assert.match(s.license, /^(MIT|Apache-2\.0)$/, s.name);
    assert.ok(s.licenseFile && exists(s.licenseFile), `${s.name}: license file`);
  }
});

test('security-audit is an automatic base skill that joins the bootstrap when done', () => {
  const s = registry['security-audit'];
  assert.equal(s?.invocation, 'auto');
  assert.equal(s.sector, undefined);
  assert.equal(s.bootstrap, 'when-done');
  assert.equal(s.ceilingTokens, 2500);
});

test('registry has the 3 mobile skills of the spec', () => {
  const mobile = Object.keys(registry).filter((name) => registry[name].sector === 'mobile').sort();
  assert.deepEqual(mobile, ['device-testing', 'mobile-release', 'native-app']);
  for (const name of mobile) {
    assert.equal(registry[name].invocation, 'auto', name);
    assert.equal(registry[name].ceilingTokens, 2500, name);
  }
});

test('mobile sources only lend ideas', () => {
  for (const name of ['expo-skills', 'android-skills', 'material-3-skill']) {
    assert.equal(sources.sources.find((s) => s.name === name)?.textReuse, false, name);
  }
});

test('registry has the 20 base skills and the 5 design skills of the spec', () => {
  const design = Object.keys(registry).filter((name) => registry[name].sector === 'design');
  const base = Object.keys(registry).filter((name) => !registry[name].sector);
  assert.equal(base.length, 20);
  assert.deepEqual(design.sort(), ['design-system', 'diagram', 'motion', 'ui-review', 'visual-direction']);
  for (const name of design) {
    assert.equal(registry[name].ceilingTokens, 2500, name);
    assert.equal(registry[name].invocation, 'auto', name);
  }
  assert.equal(registry['using-devorb'].invocation, 'hook');
  assert.equal(registry.implementing.ceilingTokens, 5000);
  assert.equal(registry['browser-testing'].invocation, 'auto');
  assert.equal(registry['browser-testing'].level, 'light');
  assert.equal(registry['browser-testing'].ceilingTokens, 2500);
});

test('package.json sets the Node floor for the test glob', () => {
  assert.deepEqual(pkg.engines, { node: '>=22' });
});

test('every skill but the bootstrap triggers by itself', () => {
  for (const [name, s] of Object.entries(registry))
    assert.equal(s.invocation, name === 'using-devorb' ? 'hook' : 'auto', name);
});
