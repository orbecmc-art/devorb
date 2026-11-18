import { test } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { patternIds, usedIds, draw } from '../skills/visual-direction/scripts/draw.mjs';

const DRAW = fileURLToPath(new URL('../skills/visual-direction/scripts/draw.mjs', import.meta.url));
const REFS = fileURLToPath(new URL('../skills/visual-direction/references/', import.meta.url));
const cli = (cwd, ...args) => spawnSync(process.execPath, [DRAW, ...args], { encoding: 'utf8', cwd });

test('patternIds finds the 10 hero and 12 section ids', () => {
  const hero = patternIds(readFileSync(REFS + 'hero-patterns.md', 'utf8'));
  const section = patternIds(readFileSync(REFS + 'section-patterns.md', 'utf8'));
  assert.equal(hero.length, 10);
  assert.equal(section.length, 12);
  assert.ok(hero.includes('hero:centred-product-halo'));
  assert.ok(section.includes('section:proof-grid'));
});

test('usedIds orders ids by their last appearance', () => {
  assert.deepEqual(usedIds(['… hero:a … section:b', '… hero:a']), ['section:b', 'hero:a']);
});

test('draw leaves out a used id while unused ones fill the count', () => {
  const got = draw(['hero:a', 'hero:b', 'hero:c'], ['hero:b'], 2, () => 0);
  assert.equal(got.length, 2);
  assert.ok(!got.includes('hero:b'), `got ${got}`);
});

test('draw with every fit used returns the oldest use first', () => {
  assert.deepEqual(draw(['hero:a', 'hero:b'], ['hero:b', 'hero:a'], 1), ['hero:b']);
  assert.deepEqual(draw(['hero:a', 'hero:b'], ['hero:b', 'hero:a'], 2), ['hero:b', 'hero:a']);
});

test('CLI reads docs/devorb/specs and skips the id the specs used', () => {
  const root = mkdtempSync(join(tmpdir(), 'devorb-draw-'));
  const specs = join(root, 'docs', 'devorb', 'specs');
  mkdirSync(specs, { recursive: true });
  writeFileSync(join(specs, '2026-01-01-a-design.md'), '- First screen: `hero:centred-product-halo`\n');
  writeFileSync(join(specs, '2026-02-01-b-design.md'), '- Hero: hero:centred-product-halo\n');
  const r = cli(root, '--fits', 'hero:centred-product-halo,hero:object-cut-by-fold', '--count', '1');
  assert.equal(r.status, 0, r.stderr);
  assert.equal(r.stdout, 'hero:object-cut-by-fold\n');
});

test('CLI with a missing specs folder treats the history as empty', () => {
  const root = mkdtempSync(join(tmpdir(), 'devorb-draw-'));
  const r = cli(root, '--fits', 'section:proof-grid', '--count', '3', '--specs', join(root, 'nope'));
  assert.equal(r.status, 0, r.stderr);
  assert.equal(r.stdout, 'section:proof-grid\n');
});

test('CLI exits 1 on an id outside the pattern files', () => {
  const root = mkdtempSync(join(tmpdir(), 'devorb-draw-'));
  const r = cli(root, '--fits', 'hero:nope', '--count', '1');
  assert.equal(r.status, 1);
  assert.match(r.stdout + r.stderr, /UNKNOWN: hero:nope/);
});
