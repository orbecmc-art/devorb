import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

// Task D2 moves this file into skills/visual-direction/references/ and updates this path.
const PATH = '../fusion/ui-sources.json';
const data = JSON.parse(readFileSync(new URL(PATH, import.meta.url), 'utf8'));

const KINDS = ['foundation', 'specialist', 'standout', 'screens', 'gallery', 'systems'];
const ACCESS = ['free', 'free-and-paid', 'paid'];
const READING = ['text', 'browser', 'account'];

// The owner's list: every source in the description of the video, minus social and affiliate links.
const OWNER_LIST = [
  'shadcn/ui', 'Base UI', 'Radix', 'Sonner', 'Vaul', 'cmdk', 'NumberFlow',
  'Beautiful UI', 'RareUI', 'Magic UI', 'Aceternity UI', '21st.dev', 'Mobbin',
];
// Whole-site galleries, suggested by Claude and approved by the owner on 2026-11-09.
const GALLERIES = ['Awwwards', 'Minimal Gallery', 'Land-book', 'Lapa Ninja', 'SiteInspire', 'Godly (now Recent)'];

// Sent by the owner on 2026-11-10.
const OWNER_SENT = ['getdesign.md'];

const names = (from) => data.entries.filter((e) => e.from === from).map((e) => e.name).sort();

test('ui sources keep the owner list from the video, the approved galleries and what the owner sent', () => {
  assert.match(data.source, /youtube\.com\/watch\?v=zsCGS-Yzjnw/);
  assert.deepEqual(names('video'), [...OWNER_LIST].sort());
  assert.deepEqual(names('gallery'), [...GALLERIES].sort());
  assert.deepEqual(names('owner'), [...OWNER_SENT].sort());
  assert.equal(data.entries.length, OWNER_LIST.length + GALLERIES.length + OWNER_SENT.length);
});

test('brand systems are studied for structure, never applied to a client', () => {
  for (const e of data.entries.filter((x) => x.kind === 'systems')) assert.match(e.note, /never apply/i, e.name);
  assert.match(data.rules.join(' '), /Operate/);
});

test('every ui source is complete', () => {
  const styles = Object.keys(data.styles);
  for (const e of data.entries) {
    assert.match(e.url, /^https:\/\//, e.name);
    assert.ok(KINDS.includes(e.kind), `${e.name}: kind ${e.kind}`);
    assert.ok(ACCESS.includes(e.access), `${e.name}: access ${e.access}`);
    assert.ok(READING.includes(e.reading), `${e.name}: reading ${e.reading}`);
    assert.ok(e.for && e.license, `${e.name}: for and license`);
    for (const s of e.styles) assert.ok(styles.includes(s), `${e.name}: unknown style ${s}`);
    if (['standout', 'screens', 'gallery'].includes(e.kind)) assert.ok(e.styles.length > 0, `${e.name}: needs a style`);
    for (const [s, urls] of Object.entries(e.byStyle ?? {})) {
      assert.ok(e.styles.includes(s), `${e.name}: byStyle ${s} not in its styles`);
      for (const u of urls) assert.match(u, /^https:\/\//, `${e.name}: ${u}`);
    }
  }
});

test('a clean brief has a gallery it can read without a browser', () => {
  assert.ok(data.entries.some((e) => e.kind === 'gallery' && e.reading === 'text' && e.styles.includes('clean')));
});

test('every style a client can ask for leads somewhere', () => {
  for (const [style, words] of Object.entries(data.styles)) {
    assert.ok(words.length > 0, `${style}: words a client would use`);
    assert.ok(data.entries.some((e) => e.styles.includes(style)), `${style}: no source carries it`);
  }
});

test('the one-standout rule and the default-look warning travel with the list', () => {
  assert.match(data.rules.join(' '), /one standout/i);
  assert.match(data.rules.join(' '), /default shadcn/i);
});
