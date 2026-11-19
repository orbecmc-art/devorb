import { test } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, mkdirSync, writeFileSync, realpathSync, readFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import vm from 'node:vm';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { findSections, findSectionsRoot, sectionNodes, checkFloor } from '../skills/ui-review/scripts/rules.mjs';
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
  const plan = planShots(3000, [s(0, false), s(1, true), s(2, false)]);
  assert.deepEqual(plan.perSection.map((p) => p.index), [0, 2]);
  assert.deepEqual(plan.skipped, [{ index: 1, reason: 'hidden' }]);
});
const sec = (index, top, height) => ({ index, x: 0, top, height, width: 1440, bg: '', hidden: false, headings: [] });
test('planShots keeps sections inside the 16000px image and scrolls to the rest', () => {
  const plan = planShots(40000, [sec(0, 1000, 800), sec(1, 15500, 2000), sec(2, 30000, 3000), sec(3, 31000, 0)]);
  assert.deepEqual(plan.perSection[0], { index: 0, shot: 'section-0', scrollTo: null, clip: { x: 0, y: 1000, width: 1440, height: 800 } });
  assert.deepEqual(plan.perSection[1], { index: 1, shot: 'section-1', scrollTo: 15500, clip: { x: 0, y: 0, width: 1440, height: 900 } });
  assert.equal(plan.perSection.find((p) => p.index === 2).scrollTo, 30000);
  assert.deepEqual(plan.skipped, [{ index: 3, reason: 'empty' }]);
});
test('planShots shoots a tall section past the full image in viewport-height slices', () => {
  const plan = planShots(40000, [sec(1, 20000, 2000)]);
  assert.deepEqual(plan.perSection, [
    { index: 1, shot: 'section-1', scrollTo: 20000, clip: { x: 0, y: 0, width: 1440, height: 900 } },
    { index: 1, shot: 'section-1-2', scrollTo: 20900, clip: { x: 0, y: 0, width: 1440, height: 900 } },
    { index: 1, shot: 'section-1-3', scrollTo: 21800, clip: { x: 0, y: 0, width: 1440, height: 200 } }
  ]);
  assert.deepEqual(plan.truncated, []);
});
test('planShots stops at 8 slices and reports the rest as truncated', () => {
  const plan = planShots(40000, [sec(4, 20000, 10000)]);
  assert.equal(plan.perSection.length, 8);
  assert.equal(plan.perSection.at(-1).shot, 'section-4-8');
  assert.equal(plan.perSection.at(-1).scrollTo, 26300);
  assert.deepEqual(plan.truncated, [{ shot: 'section-4', error: 'truncated: 7200px of 10000px' }]);
});
test('planShots clamps a clip to the page', () => {
  assert.equal(planShots(3000, [sec(0, 2500, 1000)]).perSection[0].clip.height, 500);
  assert.deepEqual(planShots(3000, [sec(0, -1350, 2000)]).perSection[0].clip, { x: 0, y: 0, width: 1440, height: 650 });
});
test('planShots skips a section that lies wholly above or below the page as empty', () => {
  assert.deepEqual(planShots(3000, [sec(0, -1350, 1350), sec(1, 3000, 500)]).skipped, [{ index: 0, reason: 'empty' }, { index: 1, reason: 'empty' }]);
});

// a folder that holds a fake node_modules/playwright, as `npm i playwright` would leave it
const withPlaywright = (source = '') => {
  const dir = realpathSync(mkdtempSync(join(tmpdir(), 'devorb-pw-'))); // realpath: macOS tmpdir is a symlink
  mkdirSync(join(dir, 'node_modules', 'playwright'), { recursive: true });
  writeFileSync(join(dir, 'node_modules', 'playwright', 'package.json'), '{"name":"playwright","main":"index.js"}');
  writeFileSync(join(dir, 'node_modules', 'playwright', 'index.js'), source);
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
  const ligare = JSON.parse(readFileSync(new URL('./fixtures/design/dom-ligare-shell.json', import.meta.url)));
  const billow = JSON.parse(readFileSync(new URL('./fixtures/design/dom-billow-shape.json', import.meta.url)));
  for (const tree of [shell, narrowAndShort, ligare]) {
    const root = window.__devorbFindSectionsRoot(tree);
    assert.equal(root, findSectionsRoot(tree));
    assert.deepEqual([...window.__devorbSectionNodes(root)], sectionNodes(root));
  }
  for (const tree of [shell, narrowAndShort, ligare, billow]) {
    const inPage = window.__devorbFindSections(tree);
    const expected = findSections(tree);
    assert.equal(inPage.root, expected.root);
    assert.deepEqual([...inPage.nodes], expected.nodes);
  }
  assert.equal(sectionNodes(main).length, 3);
});

const shoot = (cwd, ...args) => {
  const env = { ...process.env };
  delete env.DEVORB_PLAYWRIGHT_DIR;
  return spawnSync(process.execPath, [fileURLToPath(new URL('../skills/ui-review/scripts/shoot.mjs', import.meta.url)), 'http://x/', join(cwd, 'out'), ...args], { cwd, env, encoding: 'utf8' });
};
test('the CLI exits 3 with both install options, the out-of-project one first, when playwright is missing', () => {
  const r = shoot(empty());
  assert.equal(r.status, 3, r.stderr);
  assert.match(r.stdout, /^NEED: npm i --prefix <temp dir> playwright[\s\S]*--pw <dir>[\s\S]*npm i -D playwright && npx playwright install chromium/);
});
test('the CLI refuses a mode that is only an inherited property', () => {
  const r = shoot(empty(), '--mode', 'toString');
  assert.equal(r.status, 1);
  assert.match(r.stderr, /^usage: .*exit 2/);
});
test('the CLI exits 2 with one summary line naming the failed checks and widths', () => {
  // a fake page whose metrics fail heading-ratio and body-size at every width
  const r = shoot(withPlaywright(`
    const metrics = { url: 'http://x/', sections: [], text: [{ role: 'h1', fontSize: 12 }, { role: 'body', fontSize: 12 }], buttons: [], textColors: [], spacing: [], images: [] };
    const page = {
      goto: async () => {}, waitForLoadState: async () => {}, addScriptTag: async () => {}, waitForTimeout: async () => {}, screenshot: async () => {},
      evaluate: async (fn) => (String(fn).includes('__devorbMetrics') ? metrics : String(fn).includes('innerHeight') ? [0, 1] : 100)
    };
    exports.chromium = { launch: async () => ({ newContext: async () => ({ addInitScript: async () => {}, newPage: async () => page, close: async () => {} }), close: async () => {} }) };`), '--widths', '1440,390');
  assert.equal(r.status, 2, r.stderr);
  assert.equal(r.stdout, 'FAIL: heading-ratio, body-size at 1440, 390\n');
});
test('the CLI exits once done, even while a browser helper still holds the browser stderr pipe', () => {
  // system Chrome leaves its updater and crash handler holding the browser's stderr for minutes: a long sleep stands in
  const r = spawnSync(process.execPath, [fileURLToPath(new URL('../skills/ui-review/scripts/shoot.mjs', import.meta.url)), 'http://x/', join(empty(), 'out'), '--widths', '1440'], {
    cwd: withPlaywright(`
    const metrics = { url: 'http://x/', sections: [], text: [{ role: 'h1', fontSize: 48 }, { role: 'body', fontSize: 16 }], buttons: [], textColors: [], spacing: [], images: [] };
    const page = {
      goto: async () => {}, waitForLoadState: async () => {}, addScriptTag: async () => {}, waitForTimeout: async () => {}, screenshot: async () => {},
      evaluate: async (fn) => (String(fn).includes('__devorbMetrics') ? metrics : String(fn).includes('innerHeight') ? [0, 1] : 100)
    };
    exports.chromium = { launch: async () => {
      const helper = require('node:child_process').spawn('sleep', ['30'], { stdio: ['ignore', 'pipe', 'pipe'] });
      return { newContext: async () => ({ addInitScript: async () => {}, newPage: async () => page, close: async () => {} }), close: async () => {}, helper };
    } };`),
    env: { ...process.env, DEVORB_PLAYWRIGHT_DIR: '' }, encoding: 'utf8', timeout: 10000
  });
  assert.equal(r.status, 0, `status ${r.status} signal ${r.signal}: ${r.stderr}`);
});
// a fake Playwright page that logs every goto and screenshot option set to CALLS; the sections, the page height,
// the screenshot body and the answer to the scroll-to-section evaluate are JavaScript source
const fakeShooter = ({ sections = '[{ index: 0, x: 0, top: 0, height: 500, width: 1440, hidden: false }]', pageHeight = 1000, screenshot = '', scroll = '0' } = {}) => withPlaywright(`
  const { appendFileSync } = require('node:fs');
  const log = (kind, opts) => appendFileSync(process.env.CALLS, JSON.stringify({ kind, ...opts }) + '\\n');
  const metrics = { url: 'http://x/', sections: ${sections}, text: [], buttons: [], textColors: [], spacing: [], images: [] };
  const tries = {};
  const page = {
    goto: async (url, opts) => log('goto', opts), waitForLoadState: async () => {}, addScriptTag: async () => {}, waitForTimeout: async () => {},
    screenshot: async (opts) => { log('screenshot', opts); const name = opts.path.split('/').pop(); tries[name] = (tries[name] ?? 0) + 1; ${screenshot} },
    evaluate: async (fn) => { const f = String(fn); if (f.includes('__devorbReveal')) log('reveal'); return f.includes('__devorbMetrics') ? metrics : f.includes('innerHeight') ? [0, 1] : f.includes('scrollY') ? ${scroll} : ${pageHeight}; }
  };
  exports.chromium = { launch: async () => ({ newContext: async () => ({ addInitScript: async () => {}, newPage: async () => page, close: async () => {} }), close: async () => {} }) };`);
const runFake = (cwd) => {
  const calls = join(cwd, 'calls.jsonl');
  const r = spawnSync(process.execPath, [fileURLToPath(new URL('../skills/ui-review/scripts/shoot.mjs', import.meta.url)), 'http://x/', join(cwd, 'out'), '--widths', '1440'], { cwd, env: { ...process.env, DEVORB_PLAYWRIGHT_DIR: '', CALLS: calls }, encoding: 'utf8' });
  assert.ok([0, 2].includes(r.status), `status ${r.status}: ${r.stderr}`);
  assert.equal(r.stderr, '');
  const log = readFileSync(calls, 'utf8').trim().split('\n').map((l) => JSON.parse(l));
  return { log, shots: log.filter((c) => c.kind === 'screenshot'), shotErrors: JSON.parse(readFileSync(join(cwd, 'out', '1440', 'metrics.json'), 'utf8')).shotErrors };
};
test('a failing shot is retried once with the caret hidden, then logged, and the run goes on', () => {
  // full.png always times out, section-0 only the first time
  const { log, shots, shotErrors } = runFake(fakeShooter({ screenshot: "if (name === 'full.png' || (name === 'section-0.png' && tries[name] === 1)) throw new Error('Timeout 60000ms exceeded.\\nCall log: …');" }));
  assert.deepEqual(shotErrors, [{ shot: 'full', error: 'Timeout 60000ms exceeded.' }]);
  assert.deepEqual(shots.map((c) => [c.path.split('/').pop(), c.caret]), [['full.png', undefined], ['full.png', 'hide'], ['section-0.png', undefined], ['section-0.png', 'hide']]);
  assert.ok(shots.every((c) => c.animations === 'disabled' && c.timeout === 60000), JSON.stringify(shots));
  assert.deepEqual(log.filter((c) => c.kind === 'goto').map((c) => c.waitUntil), ['domcontentloaded']);
});
test('the reveal runs again right before every shot', () => {
  // a looping script can hide content again between the measure and a shot
  const { log } = runFake(fakeShooter({ sections: '[{ index: 0, x: 0, top: 0, height: 500, width: 1440, hidden: false }, { index: 1, x: 0, top: 20000, height: 500, width: 1440, hidden: false }]', pageHeight: 20500 }));
  const kinds = log.map((c) => c.kind).filter((k) => k !== 'goto');
  const shots = kinds.flatMap((k, i) => (k === 'screenshot' ? [kinds[i - 1]] : []));
  assert.deepEqual(shots, ['reveal', 'reveal', 'reveal']);
});
test('a section the window cannot scroll up to the top of is clipped lower in the window', () => {
  const { shots } = runFake(fakeShooter({ sections: '[{ index: 0, x: 0, top: 20000, height: 500, width: 1440, hidden: false }]', pageHeight: 20500, scroll: '300' }));
  assert.deepEqual(shots[1].clip, { x: 0, y: 300, width: 1440, height: 500 });
  assert.equal(shots[1].fullPage, false);
});
test('a scroll that throws is logged for its section and the run goes on', () => {
  const sections = '[{ index: 0, x: 0, top: 20000, height: 500, width: 1440, hidden: false }, { index: 1, x: 0, top: 0, height: 500, width: 1440, hidden: false }]';
  const { shots, shotErrors } = runFake(fakeShooter({ sections, pageHeight: 20500, scroll: "(() => { throw new Error('scroll failed\\nCall log: …'); })()" }));
  assert.deepEqual(shotErrors, [{ shot: 'section-0', error: 'scroll failed' }]);
  assert.deepEqual(shots.map((c) => c.path.split('/').pop()), ['full.png', 'section-1.png']);
});
test('the CLI exits 3 without a stack trace when no browser launches', () => {
  const r = shoot(withPlaywright("exports.chromium = { launch: async () => { throw new Error(\"browserType.launch: Executable doesn't exist at /nowhere\"); } };"));
  assert.equal(r.status, 3, r.stderr);
  assert.match(r.stdout, /npx playwright install chromium/);
  assert.equal(r.stderr, '');
});

// DomNode plus the scroll fields the page converter adds
const box = (tag, h, kids = [], scroll = {}) => ({ tag, rect: { x: 0, y: 0, w: 1200, h }, scrollHeight: h, clientHeight: h, overflowY: 'visible', ...scroll, children: kids });
const appShell = (mainScroll, wrapped = false) => {
  const sections = [0, 1, 2, 3].map(() => box('section', 600));
  const content = wrapped ? [box('div', 2400, sections)] : sections;
  return box('body', 800, [box('div', 800, [box('aside', 800), box('main', 800, content, mainScroll)])]);
};
const loadCollector = () => {
  const window = {};
  vm.runInNewContext(readFileSync(new URL('../skills/ui-review/scripts/collect-in-page.js', import.meta.url), 'utf8'), { window });
  return window;
};
test('findScroller picks the overflowing main of an app shell', () => {
  const tree = appShell({ scrollHeight: 2400, overflowY: 'auto' });
  assert.equal(loadCollector().__devorbFindScroller(tree).tag, 'main');
});
test('findScroller climbs from a wrapper root to its scrolling ancestor', () => {
  const tree = appShell({ scrollHeight: 2400, overflowY: 'scroll' }, true);
  assert.equal(loadCollector().__devorbFindScroller(tree).tag, 'main');
});
test('findScroller gives null when only the window scrolls or overflow is hidden', () => {
  const { __devorbFindScroller: findScroller } = loadCollector();
  assert.equal(findScroller(appShell({})), null);
  assert.equal(findScroller(appShell({ scrollHeight: 2400, overflowY: 'hidden' })), null);
});

// a fake element; style holds the computed values that differ from the page default
const el = (tag, h, kids = [], extra = {}) => ({
  tagName: tag.toUpperCase(), children: kids, childNodes: [], parentElement: null, scrollHeight: h, clientHeight: h, style: {}, attrs: {}, textContent: '',
  getAttribute: () => null, setAttribute(name, value) { this.attrs[name] = value; }, closest: () => null, querySelector: () => null,
  getBoundingClientRect: () => ({ x: 0, y: 0, width: 1200, height: h }), querySelectorAll: () => [], contains(o) { return o === this || descendants(this).includes(o); }, ...extra
});
// like Chromium, innerText is empty under visibility: hidden while textContent keeps the words
const text = (tag, style, extra = {}) => Object.defineProperty(el(tag, 20, [], { style, textContent: 'Plans', ...extra }), 'innerText', { get() { return this.style.visibility === 'hidden' ? '' : 'Plans'; } });
// a fixed layer (a header or a drawer) holding one element
const fixedLayer = (child) => (child.parentElement = el('div', 100, [child], { style: { position: 'fixed' } }));
const descendants = (e) => e.children.flatMap((c) => [c, ...descendants(c)]);
// a page with two sections, a heading broken over lines and two signed copies of one photo, at a logged-in URL;
// content goes in the first section, and animations are what document.getAnimations() gives
const fakePage = ({ content = [], animations = [] } = {}) => {
  const style = { overflowY: 'visible', backgroundColor: 'rgb(1, 2, 3)', opacity: '1', visibility: 'visible', position: 'static', paddingTop: '0', paddingBottom: '0', fontSize: '16px', lineHeight: '24px', fontWeight: '400', fontFamily: 'Georgia' };
  const heading = { innerText: '  Quiet tools\n    for loud work ' };
  const body = el('body', 800, [el('main', 800, [el('section', 800, content, { querySelectorAll: () => [heading] }), el('section', 800)])]);
  // an inline style write lands in the element's style, like CSSStyleDeclaration.setProperty, and is logged with its priority
  for (const e of descendants(body)) e.style.setProperty = function (name, value, priority) { this[name] = value; (this.writes ??= []).push([name, value, priority]); };
  const img = (src) => ({ currentSrc: src, src, getBoundingClientRect: () => ({ width: 100 }) });
  const head = { appended: [], appendChild(node) { this.appended.push(node); } };
  return {
    window: {}, getComputedStyle: (e) => ({ ...style, ...e.style }), innerWidth: 1200, scrollX: 0, scrollY: 0,
    location: { href: 'https://app.example/painel?token=x#y' },
    document: {
      body, head, scrollingElement: body, getAnimations: () => [...animations], createElement: (tag) => ({ tagName: tag.toUpperCase() }),
      querySelectorAll: (sel) => (sel === 'body *' ? descendants(body) : []),
      images: [img('https://cdn.example/a.jpg?token=s1#z'), img('https://cdn.example/a.jpg?token=s2')]
    }
  };
};
// a site script that wins over the reveal's inline writes (a transition, a later inline !important): the element stays as it is
const stubborn = (...els) => els.forEach((e) => (e.style.setProperty = () => {}));
const runCollector = (page) => vm.runInNewContext(readFileSync(new URL('../skills/ui-review/scripts/collect-in-page.js', import.meta.url), 'utf8'), page);
test('the collector strips query and hash from the page and image URLs, and collapses heading whitespace', () => {
  const page = fakePage();
  vm.runInNewContext(readFileSync(new URL('../skills/ui-review/scripts/collect-in-page.js', import.meta.url), 'utf8'), page);
  const m = page.window.__devorbMetrics();
  assert.doesNotMatch(JSON.stringify(m), /token/);
  assert.equal(m.url, 'https://app.example/painel');
  assert.deepEqual([...m.sections[0].headings], ['Quiet tools for loud work']);
  assert.deepEqual([...m.fills], []);
  assert.equal(checkFloor({ ...m, text: [{ role: 'h1', fontSize: 48 }, { role: 'body', fontSize: 16 }] }, 'operate').find((c) => c.id === 'photo-repeat').status, 'WARN');
});

test('__devorbReveal finishes animations, skips infinite ones and marks hidden content', () => {
  let finished = 0;
  const animations = [{ finish: () => finished++ }, { finish: () => { throw Object.assign(new Error('infinite'), { name: 'InvalidStateError' }); } }];
  const faded = text('div', { opacity: '0' });
  const page = fakePage({ content: [faded], animations });
  runCollector(page);
  assert.equal(page.window.__devorbReveal(), 1);
  assert.equal(finished, 1);
  assert.ok('data-devorb-reveal' in faded.attrs);
  assert.deepEqual(page.document.head.appended.map((n) => n.tagName), ['STYLE']);
  assert.match(page.document.head.appended[0].textContent, /\[data-devorb-reveal\]\{opacity:1!important;visibility:visible!important\}/);
  assert.equal(page.window.__devorbMetrics().revealed, 1);
  page.window.__devorbReveal();
  assert.equal(page.document.head.appended.length, 1);
});
test('__devorbReveal finishes the transitions its own style starts', () => {
  // a transition outranks !important, so the faded element would still be mid-fade when measured
  let finished = 0;
  const animations = [];
  const page = fakePage({ content: [text('div', { opacity: '0' })], animations });
  const append = page.document.head.appendChild;
  page.document.head.appendChild = function (node) { animations.push({ finish: () => finished++ }); return append.call(this, node); };
  runCollector(page);
  page.window.__devorbReveal();
  assert.equal(finished, 1);
});
test('__devorbReveal shows visibility-hidden text and skips content inside a fixed layer', () => {
  const autoAlpha = text('p', { opacity: '0', visibility: 'hidden' });
  const inDrawer = text('p', { opacity: '0' });
  const page = fakePage({ content: [autoAlpha, fixedLayer(inDrawer)] });
  runCollector(page);
  assert.equal(page.window.__devorbReveal(), 1);
  assert.ok('data-devorb-reveal' in autoAlpha.attrs);
  assert.deepEqual(inDrawer.attrs, {});
});
// a rotator: one phrase showing, the others absolutely placed on top of it; the last one sits below, apart
const rotator = () => {
  const box = (y) => () => ({ x: 0, y, width: 600, height: 20 });
  const phrases = [text('span', {}, { getBoundingClientRect: box(0) }), text('span', { position: 'absolute', opacity: '0' }, { getBoundingClientRect: box(5) }), text('span', { position: 'absolute', opacity: '0' }, { getBoundingClientRect: box(40) })];
  const parent = el('div', 60, phrases);
  for (const p of phrases) p.parentElement = parent;
  return { parent, phrases };
};
// an aria-hidden element whose closest('[aria-hidden=true]') is itself, inside a parent holding the siblings given
const ariaHidden = (siblings = []) => {
  const e = text('li', { opacity: '0' }, { closest(sel) { return sel === '[aria-hidden=true]' ? this : null; } });
  const parent = el('ul', 60, [...siblings, e]);
  for (const c of parent.children) c.parentElement = parent;
  return { e, parent };
};
test('__devorbReveal leaves aria-hidden slides beside a showing one and stacked rotator phrases alone', () => {
  const slide = ariaHidden([text('li', {})]);
  // decorative, beside only other aria-hidden layers (a veil that shows): a scroll reveal like any other
  const panel = ariaHidden([text('div', {}, { getAttribute: (name) => (name === 'aria-hidden' ? 'true' : null) })]);
  const { parent, phrases } = rotator();
  const page = fakePage({ content: [slide.parent, panel.parent, parent] });
  runCollector(page);
  assert.equal(page.window.__devorbReveal(), 2);
  assert.deepEqual([slide.e, panel.e, ...phrases].map((e) => 'data-devorb-reveal' in e.attrs), [false, true, false, false, true]);
  assert.equal(page.window.__devorbMetrics().sections[0].hiddenContent, 0); // the inline writes show the panel and the phrase apart
});
test('hiddenContent leaves out what sits inside a stacked rotator phrase', () => {
  // a phrase that wraps its words in a span: the span is not faded itself, only through the phrase
  const { parent, phrases } = rotator();
  const word = text('span', {});
  word.parentElement = phrases[1];
  phrases[1].children = [word];
  const page = fakePage({ content: [parent] });
  stubborn(phrases[2]);
  runCollector(page);
  assert.equal(page.window.__devorbMetrics().sections[0].hiddenContent, 1); // only the phrase apart, below
});
test('hiddenContent leaves out a closed accordion and the slides nested in an inactive one', () => {
  // a collapsed panel clips its words away; a hidden slide's own aria-hidden layers sit beside only each other
  const words = text('p', {});
  const accordion = el('div', 0, [words], { style: { opacity: '0', overflow: 'hidden' }, getBoundingClientRect: () => ({ x: 0, y: 0, width: 1200, height: 0 }) });
  words.parentElement = accordion;
  const inner = text('div', {}, { closest(sel) { return sel === '[aria-hidden=true]' ? this : null; } });
  const slide = ariaHidden([text('li', {})]).e;
  slide.textContent = 'Plans';
  slide.children = [inner];
  inner.parentElement = slide;
  const page = fakePage({ content: [accordion, slide.parentElement] });
  runCollector(page);
  assert.equal(page.window.__devorbMetrics().sections[0].hiddenContent, 0);
});
test('__devorbReveal writes opacity and visibility inline with !important on what it marks', () => {
  // a site's own inline !important outranks the reveal style sheet, so the reveal writes inline too
  const faded = text('div', { opacity: '0' });
  const page = fakePage({ content: [faded] });
  runCollector(page);
  page.window.__devorbReveal();
  assert.deepEqual(faded.style.writes, [['opacity', '1', 'important'], ['visibility', 'visible', 'important']]);
});
test('the reveal style lets content-visibility sections paint', () => {
  const page = fakePage();
  runCollector(page);
  page.window.__devorbReveal();
  assert.match(page.document.head.appended[0].textContent, /\*\{content-visibility:visible!important;contain-intrinsic-size:none!important\}/);
});
test('__devorbMetrics reveals again what a looping script hid after the reveal, and revealed counts every mark', () => {
  const early = text('p', { opacity: '0' });
  const late = text('p', {});
  const page = fakePage({ content: [early, late] });
  runCollector(page);
  assert.equal(page.window.__devorbReveal(), 1);
  late.style.opacity = '0';
  const m = page.window.__devorbMetrics();
  assert.equal(m.sections[0].hiddenContent, 0);
  assert.ok('data-devorb-reveal' in late.attrs);
  assert.equal(m.revealed, 2);
});
test('hiddenContent counts each element by its own opacity, not the product with its ancestors', () => {
  // a faded box counts once, not once per child; two half-faded layers are not hidden
  const word = text('span', {});
  const box = text('div', { opacity: '0' });
  box.children = [word];
  word.parentElement = box;
  const inner = text('span', { opacity: '0.3' });
  const half = text('div', { opacity: '0.3' });
  half.children = [inner];
  inner.parentElement = half;
  const page = fakePage({ content: [box, half] });
  stubborn(box);
  runCollector(page);
  assert.equal(page.window.__devorbMetrics().sections[0].hiddenContent, 1);
});
test('fills holds each button background once', () => {
  const page = fakePage({ content: ['rgb(0, 0, 255)', 'rgb(0, 0, 255)', 'rgb(255, 0, 0)'].map((backgroundColor) => text('button', { backgroundColor })) });
  runCollector(page);
  assert.deepEqual([...page.window.__devorbMetrics().fills], ['rgb(0, 0, 255)', 'rgb(255, 0, 0)']);
});
test('a faded popup inside a link or button is a hover state: neither revealed nor counted', () => {
  const popup = text('div', { position: 'absolute', opacity: '0' });
  const button = el('button', 40, [popup], { closest(sel) { return sel.split(', ').includes('button') ? this : null; } });
  popup.parentElement = button;
  const page = fakePage({ content: [button] });
  runCollector(page);
  assert.equal(page.window.__devorbReveal(), 0);
  assert.equal(page.window.__devorbMetrics().sections[0].hiddenContent, 0);
});
test('a faded block under a tabindex=-1 skip-link target or a link that wraps the sections is a scroll reveal, not a popup', () => {
  // main#main tabindex=-1 is a focus target, not a control; a link around the sections is a wrapper, not a popup owner
  const underMain = text('p', { position: 'absolute', opacity: '0' });
  const underWrapper = text('p', { position: 'absolute', opacity: '0' });
  const page = fakePage({ content: [underMain, underWrapper] });
  const main = page.document.body.children[0];
  const matches = (sel, part) => sel.split(', ').includes(part);
  underMain.parentElement = el('div', 100, [], { closest: (sel) => (matches(sel, '[tabindex]') ? main : null) });
  underWrapper.parentElement = el('div', 100, [], { closest: (sel) => (matches(sel, 'a') ? main : null) });
  runCollector(page);
  assert.equal(page.window.__devorbReveal(), 2);
});
test('a faded block under a tabindex=-1 element is counted when the reveal cannot show it', () => {
  const p = text('p', { position: 'absolute', opacity: '0' });
  const page = fakePage({ content: [p] });
  p.parentElement = el('main', 100, [], { closest(sel) { return sel.split(', ').includes('[tabindex]') ? this : null; } });
  stubborn(p);
  runCollector(page);
  assert.equal(page.window.__devorbMetrics().sections[0].hiddenContent, 1);
});
test('__devorbReveal leaves a closed dialog, tooltip and listbox hidden', () => {
  const withRole = (role) => text('div', { opacity: '0' }, { closest(sel) { return sel.split(', ').includes(`[role=${role}]`) ? this : null; } });
  const popups = ['dialog', 'tooltip', 'listbox'].map(withRole);
  const page = fakePage({ content: [...popups, text('p', { opacity: '0' })] });
  runCollector(page);
  assert.equal(page.window.__devorbReveal(), 1);
  assert.deepEqual(popups.map((e) => e.attrs), [{}, {}, {}]);
});
test('hiddenContent counts faded and visibility-hidden text in a section, not fixed overlays or menus', () => {
  const inMenu = (sel) => (sel.includes('[role=menu]') ? {} : null);
  const hidden = [text('p', { opacity: '0.05' }), text('p', { opacity: '0', visibility: 'hidden' }), text('p', { visibility: 'hidden' })];
  const page = fakePage({ content: [
    ...hidden, text('div', { position: 'fixed', opacity: '0' }), fixedLayer(text('p', { opacity: '0' })), text('div', { visibility: 'hidden' }, { closest: inMenu })
  ] });
  stubborn(...hidden);
  runCollector(page);
  const m = page.window.__devorbMetrics();
  assert.equal(m.sections[0].hiddenContent, 3); // what the reveal marked and could not show
  assert.equal(m.sections[1].hiddenContent, 0);
  assert.equal(m.revealed, 3);
});

const revealInit = () => readFileSync(new URL('../skills/ui-review/scripts/reveal-init.js', import.meta.url), 'utf8');
test('reveal-init reports every observed entry as visible', () => {
  const window = { IntersectionObserver: class { constructor(cb) { this.cb = cb; } fire(e) { this.cb(e, this); } disconnect() {} } };
  vm.runInNewContext(revealInit(), { window });
  let got;
  const obs = new window.IntersectionObserver((e) => (got = e));
  obs.fire([{ target: 't', isIntersecting: false, intersectionRatio: 0, time: 5 }]);
  assert.deepEqual(got.map((e) => ({ ...e })), [{ target: 't', isIntersecting: true, intersectionRatio: 1, time: 5 }]);
  assert.equal(typeof obs.disconnect, 'function');
});
test('reveal-init does nothing without IntersectionObserver', () => {
  const window = {};
  vm.runInNewContext(revealInit(), { window });
  assert.deepEqual(Object.keys(window), []);
});
