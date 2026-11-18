// Real-browser checks for shoot.mjs and capture.mjs. Skipped unless Playwright resolves from the
// repo or DEVORB_PLAYWRIGHT_DIR, so `npm test` needs no install.
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, readFileSync, writeFileSync, existsSync, readdirSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { resolvePlaywright, shootPage } from '../skills/ui-review/scripts/shoot.mjs';

const skip = (await resolvePlaywright()) ? false : 'Playwright not found in the repo or DEVORB_PLAYWRIGHT_DIR';
const fixture = (name) => new URL(`./fixtures/design/${name}`, import.meta.url).href;
const CAPTURE = fileURLToPath(new URL('../skills/visual-direction/scripts/capture.mjs', import.meta.url));
const capture = (root) => spawnSync(process.execPath, [CAPTURE, fixture('hero.html'), root, '--slug', 'hero'], { encoding: 'utf8', cwd: root });

test('shootPage finds the three hero sections and reveals the scroll-in one', { skip }, async () => {
  const out = mkdtempSync(join(tmpdir(), 'devorb-shoot-'));
  const m = (await shootPage(fixture('hero.html'), out, { widths: [1440] }))[1440];
  assert.equal(m.sections.length, 3);
  assert.deepEqual(m.sections.map((s) => s.hidden), [false, false, false]);
  assert.ok(existsSync(join(out, '1440', 'section-2.png')));
});

test('shootPage measures an app shell through its inner scroller', { skip }, async () => {
  const out = mkdtempSync(join(tmpdir(), 'devorb-shoot-'));
  const m = (await shootPage(fixture('app-shell.html'), out, { widths: [1440] }))[1440];
  assert.equal(m.sections.length, 4);
  assert.ok(m.sections.some((s) => s.top > 800), JSON.stringify(m.sections.map((s) => s.top)));
  assert.deepEqual(m.sections.map((s) => s.hidden), [false, false, false, false]);
});

test('capture writes a hero pack, then a re-capture keeps hand-written lines and drops stale shots', { skip }, () => {
  const root = mkdtempSync(join(tmpdir(), 'devorb-cap-'));
  const dir = join(root, 'design', 'referencias', 'hero');
  assert.equal(spawnSync(process.execPath, [CAPTURE, fixture('hero.html'), root, '--slug', 'hero', '--dry-run'], { encoding: 'utf8' }).status, 0);
  let r = capture(root);
  assert.equal(r.status, 0, r.stdout + r.stderr);
  const lines = readFileSync(join(dir, 'secoes.md'), 'utf8').trim().split('\n');
  assert.deepEqual(lines.map((l) => l.split(' ')[0]), ['0.', '1.', '2.', 'Movimento']);
  assert.match(lines[0], /títulos: "Quiet tools for loud work"/);
  writeFileSync(join(dir, 'secoes.md'), '0. hero escrito à mão\n');
  writeFileSync(join(dir, '1440', 'section-9.png'), 'stale');
  r = capture(root);
  assert.equal(r.status, 0, r.stdout + r.stderr);
  assert.equal(readFileSync(join(dir, 'secoes.md'), 'utf8'), '0. hero escrito à mão\n');
  assert.equal(existsSync(join(dir, '1440', 'section-9.png')), false);
  assert.deepEqual(readdirSync(dir).sort(), ['1440', '390', 'notas.md', 'secoes.md', 'tokens.json', 'url.txt']);
});
