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

test('both licenses are present', () => {
  assert.ok(exists('LICENSES/superpowers-MIT.txt'));
  assert.ok(exists('LICENSES/mattpocock-skills-MIT.txt'));
});

test('registry has the 17 skills of the spec', () => {
  assert.equal(Object.keys(registry).length, 17);
  assert.equal(registry.evolving.invocation, 'manual');
  assert.equal(registry['using-devorb'].invocation, 'hook');
  assert.equal(registry.implementing.ceilingTokens, 5000);
});

test('package.json sets the Node floor for the test glob', () => {
  assert.deepEqual(pkg.engines, { node: '>=22' });
});
