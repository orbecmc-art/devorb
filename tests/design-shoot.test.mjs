import { test } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, mkdirSync, writeFileSync, realpathSync, readFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import vm from 'node:vm';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { findSectionsRoot, sectionNodes } from '../skills/ui-review/scripts/rules.mjs';
import { parseArgs, planShots, resolvePlaywright } from '../skills/ui-review/scripts/shoot.mjs';

test('parseArgs applies the defaults', () => {
  assert.deepEqual(parseArgs(['http://x/', 'out']), { url: 'http://x/', out: 'out', widths: [1440, 1024, 768, 390], mode: 'persuade', scroll: true, pw: undefined });
});
test('parseArgs reads widths, mode, no-scroll and pw', () => {
  assert.deepEqual(parseArgs(['http://x/', 'out', '--widths', '1440,390', '--mode', 'operate', '--no-scroll', '--pw', '/p']), { url: 'http://x/', out: 'out', widths: [1440, 390], mode: 'operate', scroll: false, pw: '/p' });
});
test('planShots caps the full-page clip at 16000px', () => {
  assert.equal(planShots(40000, []).fullClip, 16000);
  assert.equal(planShots(3000, []).fullClip, 3000);
});
test('planShots shoots only visible sections, by index', () => {
  const s = (index, hidden) => ({ index, top: 0, height: 500, width: 1440, bg: '', hidden, headings: [] });
  assert.deepEqual(planShots(3000, [s(0, false), s(1, true), s(2, false)]).perSection, [0, 2]);
});

// a folder that holds a fake node_modules/playwright, as `npm i playwright` would leave it
const withPlaywright = () => {
  const dir = realpathSync(mkdtempSync(join(tmpdir(), 'devorb-pw-'))); // realpath: macOS tmpdir is a symlink
  mkdirSync(join(dir, 'node_modules', 'playwright'), { recursive: true });
  writeFileSync(join(dir, 'node_modules', 'playwright', 'package.json'), '{"name":"playwright","main":"index.js"}');
  writeFileSync(join(dir, 'node_modules', 'playwright', 'index.js'), '');
  return dir;
};
const empty = () => mkdtempSync(join(tmpdir(), 'devorb-empty-'));
const echo = async (url) => ({ url });
delete process.env.DEVORB_PLAYWRIGHT_DIR;

test('resolvePlaywright gives null when the import fails', async () => {
  const importer = async () => { throw new Error('boom'); };
  assert.equal(await resolvePlaywright({ importer, cwd: withPlaywright() }), null);
});
test('resolvePlaywright gives null when no folder has playwright', async () => {
  assert.equal(await resolvePlaywright({ importer: echo, cwd: empty(), dir: empty() }), null);
});
test('resolvePlaywright prefers the project over --pw', async () => {
  const [cwd, dir] = [withPlaywright(), withPlaywright()];
  const { url } = await resolvePlaywright({ importer: echo, cwd, dir });
  assert.ok(url.startsWith('file://') && url.includes(cwd), url);
});
test('resolvePlaywright falls back to --pw, then to DEVORB_PLAYWRIGHT_DIR', async () => {
  const dir = withPlaywright();
  assert.ok((await resolvePlaywright({ importer: echo, cwd: empty(), dir })).url.includes(dir));
  process.env.DEVORB_PLAYWRIGHT_DIR = dir;
  try {
    assert.ok((await resolvePlaywright({ importer: echo, cwd: empty() })).url.includes(dir));
  } finally {
    delete process.env.DEVORB_PLAYWRIGHT_DIR;
  }
});

test('the in-page copy of the section algorithm matches rules.mjs', () => {
  const window = {};
  vm.runInNewContext(readFileSync(new URL('../skills/ui-review/scripts/collect-in-page.js', import.meta.url), 'utf8'), { window });
  const shell = JSON.parse(readFileSync(new URL('./fixtures/design/dom-app-shell.json', import.meta.url)));
  const narrowAndShort = structuredClone(shell);
  const main = findSectionsRoot(narrowAndShort);
  main.children.push({ tag: 'div', rect: { x: 240, y: 1400, w: 600, h: 400 }, children: [] }, { tag: 'hr', rect: { x: 240, y: 1800, w: 1272, h: 100 }, children: [] });
  for (const tree of [shell, narrowAndShort]) {
    const root = window.__devorbFindSectionsRoot(tree);
    assert.equal(root, findSectionsRoot(tree));
    assert.deepEqual([...window.__devorbSectionNodes(root)], sectionNodes(root));
  }
  assert.equal(sectionNodes(main).length, 3);
});

test('the CLI exits 3 with both install options when playwright is missing', () => {
  const env = { ...process.env };
  delete env.DEVORB_PLAYWRIGHT_DIR;
  const cwd = empty();
  const r = spawnSync(process.execPath, [fileURLToPath(new URL('../skills/ui-review/scripts/shoot.mjs', import.meta.url)), 'http://x/', join(cwd, 'out')], { cwd, env, encoding: 'utf8' });
  assert.equal(r.status, 3, r.stderr);
  assert.match(r.stdout, /NEED: npm i -D playwright && npx playwright install chromium/);
  assert.match(r.stdout, /--pw <dir>/);
});
