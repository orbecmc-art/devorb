import { test } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, mkdirSync, readFileSync, existsSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { slugFromUrl, buildTokens, sectionsMarkdown } from '../skills/visual-direction/scripts/capture.mjs';

const CAPTURE = fileURLToPath(new URL('../skills/visual-direction/scripts/capture.mjs', import.meta.url));
const pilot = JSON.parse(readFileSync(new URL('./fixtures/design/metrics-pilot.json', import.meta.url), 'utf8'));
const cli = (...args) => spawnSync(process.execPath, [CAPTURE, ...args], { encoding: 'utf8' });

test('slugFromUrl joins host without www and last path segment in kebab-case', () => {
  assert.equal(slugFromUrl('https://base.agenciadevalor.com/pilot'), 'base-agenciadevalor-pilot');
  assert.equal(slugFromUrl('https://www.Example.com/'), 'example');
});
test('buildTokens gives the heading ratio and the palette', () => {
  const t = buildTokens(pilot);
  assert.ok(Math.abs(t.headingRatio - 3.2) < 0.2, `ratio ${t.headingRatio}`);
  assert.deepEqual(t.textColors, pilot.textColors);
  assert.deepEqual(t.sectionBgs, ['rgb(10, 10, 10)', 'rgb(255, 255, 255)', 'rgb(245, 245, 245)']);
  assert.deepEqual(t.spacing, [8, 16, 24, 32, 48, 64, 80, 96]);
  assert.deepEqual(Object.keys(t.type[0]), ['role', 'fontSize', 'lineHeight', 'fontWeight', 'letterSpacing', 'fontFamily']);
});
test('sectionsMarkdown writes one numbered line per visible section and the movement line', () => {
  const lines = sectionsMarkdown(pilot, pilot).trim().split('\n');
  assert.equal(lines.length, 7);
  assert.equal(lines[0], '1. 20% · fundo rgb(10, 10, 10) · títulos: "Hero" · 390: 20%');
  assert.equal(lines[5].slice(0, 2), '6.');
  assert.equal(lines[6], 'Movimento observado: <preencher olhando os prints e a página>');
});
test('a fourth reference pack is refused with exit 4', () => {
  const root = mkdtempSync(join(tmpdir(), 'devorb-cap-'));
  for (const s of ['a', 'b', 'c']) mkdirSync(join(root, 'design', 'referencias', s), { recursive: true });
  const r = cli('https://d.example/x', root, '--dry-run');
  assert.equal(r.status, 4);
  assert.match(r.stdout + r.stderr, /MAX 3 referências: a, b, c/);
});
test('dry-run writes the pack skeleton without a browser', () => {
  const root = mkdtempSync(join(tmpdir(), 'devorb-cap-'));
  const r = cli('https://www.d.example/x', root, '--dry-run');
  assert.equal(r.status, 0, r.stderr);
  const dir = join(root, 'design', 'referencias', 'd-x');
  assert.equal(readFileSync(join(dir, 'url.txt'), 'utf8').trim(), 'https://www.d.example/x');
  assert.match(readFileSync(join(dir, 'notas.md'), 'utf8'), /## Levar[\s\S]*## Não levar/);
  assert.equal(readFileSync(join(dir, 'tokens.json'), 'utf8').trim(), '{}');
  assert.ok(existsSync(join(dir, 'secoes.md')));
});
test('capture exits 3 with the NEED message when playwright is missing', () => {
  const root = mkdtempSync(join(tmpdir(), 'devorb-cap-'));
  const env = { ...process.env, DEVORB_PLAYWRIGHT_DIR: '' };
  const r = spawnSync(process.execPath, [CAPTURE, 'file:///x.html', root], { encoding: 'utf8', cwd: root, env });
  assert.equal(r.status, 3);
  assert.match(r.stdout, /^NEED: /);
});
