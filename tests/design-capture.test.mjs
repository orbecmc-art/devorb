import { test } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, mkdirSync, readFileSync, writeFileSync, existsSync, readdirSync } from 'node:fs';
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
  assert.equal(lines[0], '0. 20% · fundo rgb(10, 10, 10) · títulos: "Hero" · 390: 20%');
  assert.equal(lines[5].slice(0, 2), '5.');
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
test('slugFromUrl falls back to ref when nothing is left', () => {
  assert.equal(slugFromUrl('file:///'), 'ref');
});
test('re-capturing a slug keeps the hand-written notes', () => {
  const root = mkdtempSync(join(tmpdir(), 'devorb-cap-'));
  assert.equal(cli('https://d.example/x', root, '--dry-run').status, 0);
  const notas = join(root, 'design', 'referencias', 'd-x', 'notas.md');
  writeFileSync(notas, '## Levar\n- o grid\n\n## Não levar\n');
  assert.equal(cli('https://d.example/x', root, '--dry-run').status, 0);
  assert.match(readFileSync(notas, 'utf8'), /- o grid/);
});
test('an exit-3 run on a new slug leaves no pack directory', () => {
  const root = mkdtempSync(join(tmpdir(), 'devorb-cap-'));
  const env = { ...process.env, DEVORB_PLAYWRIGHT_DIR: '' };
  const r = spawnSync(process.execPath, [CAPTURE, 'https://d.example/x', root], { encoding: 'utf8', cwd: root, env });
  assert.equal(r.status, 3);
  assert.equal(existsSync(join(root, 'design', 'referencias', 'd-x')), false);
});
test('sectionsMarkdown numbers each line by its section index, so line N is section-N.png past a hidden section', () => {
  const m = structuredClone(pilot);
  m.sections[2].hidden = true;
  m.sections[1].headings = ['Two\n   lines'];
  const lines = sectionsMarkdown(m, m).trim().split('\n');
  assert.deepEqual(lines.slice(0, -1).map((l) => l.split('.')[0]), ['0', '1', '3', '4', '5']);
  assert.match(lines[1], /títulos: "Two lines"/);
});
test('re-capturing a slug keeps a hand-written secoes.md, and dry-run keeps tokens.json', () => {
  const root = mkdtempSync(join(tmpdir(), 'devorb-cap-'));
  assert.equal(cli('https://d.example/x', root, '--dry-run').status, 0);
  const dir = join(root, 'design', 'referencias', 'd-x');
  writeFileSync(join(dir, 'secoes.md'), '0. hero com mockup\n');
  writeFileSync(join(dir, 'tokens.json'), '{"kept":true}\n');
  assert.equal(cli('https://d.example/x', root, '--dry-run').status, 0);
  assert.equal(readFileSync(join(dir, 'secoes.md'), 'utf8'), '0. hero com mockup\n');
  assert.equal(readFileSync(join(dir, 'tokens.json'), 'utf8'), '{"kept":true}\n');
});
test('a slug that holds another URL is refused with exit 5 naming both URLs', () => {
  const root = mkdtempSync(join(tmpdir(), 'devorb-cap-'));
  assert.equal(cli('https://d.example/x', root, '--dry-run').status, 0);
  const r = cli('https://e.example/y', root, '--slug', 'd-x', '--dry-run');
  assert.equal(r.status, 5);
  assert.match(r.stdout + r.stderr, /https:\/\/d\.example\/x[\s\S]*https:\/\/e\.example\/y/);
  assert.equal(readFileSync(join(root, 'design', 'referencias', 'd-x', 'url.txt'), 'utf8').trim(), 'https://d.example/x');
});
test('a re-capture that fails mid-shoot leaves the old shots and no temp folder', () => {
  const root = mkdtempSync(join(tmpdir(), 'devorb-cap-'));
  assert.equal(cli('https://d.example/x', root, '--dry-run').status, 0);
  const dir = join(root, 'design', 'referencias', 'd-x');
  mkdirSync(join(dir, '1440'));
  writeFileSync(join(dir, '1440', 'section-5.png'), 'old');
  const pw = mkdtempSync(join(tmpdir(), 'devorb-pw-'));
  mkdirSync(join(pw, 'node_modules', 'playwright'), { recursive: true });
  writeFileSync(join(pw, 'node_modules', 'playwright', 'package.json'), '{"name":"playwright","main":"index.js"}');
  // a fake page: shots get written, then the floor check throws on metrics with no text samples
  writeFileSync(join(pw, 'node_modules', 'playwright', 'index.js'), `
    const page = {
      goto: async () => {}, waitForLoadState: async () => {}, addScriptTag: async () => {}, waitForTimeout: async () => {},
      evaluate: async (fn) => {
        const s = String(fn);
        if (s.includes('__devorbMetrics')) return { sections: [0, 1, 2, 3, 4, 5].map((index) => ({ index, hidden: index !== 5, x: 0, top: 0, width: 10, height: 10 })) };
        if (s.includes('innerHeight')) return [0, 1];
        if (s.includes('documentElement')) return 100;
      },
      screenshot: async ({ path }) => require('node:fs').writeFileSync(path, 'new')
    };
    exports.chromium = { launch: async () => ({ newContext: async () => ({ newPage: async () => page, close: async () => {} }), close: async () => {} }) };`);
  const r = spawnSync(process.execPath, [CAPTURE, 'https://d.example/x', root], { encoding: 'utf8', cwd: root, env: { ...process.env, DEVORB_PLAYWRIGHT_DIR: pw } });
  assert.notEqual(r.status, 0);
  assert.equal(readFileSync(join(dir, '1440', 'section-5.png'), 'utf8'), 'old');
  assert.deepEqual(readdirSync(dir).sort(), ['1440', 'notas.md', 'secoes.md', 'tokens.json', 'url.txt']);
});
