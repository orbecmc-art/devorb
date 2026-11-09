import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

// Task D2 moves this file into skills/visual-direction/references/ and updates this path.
const PATH = '../fusion/ui-sources.json';
const data = JSON.parse(readFileSync(new URL(PATH, import.meta.url), 'utf8'));

const KINDS = ['foundation', 'specialist', 'standout', 'screens'];
const ACCESS = ['free', 'free-and-paid', 'paid'];

// The owner's list: every source in the description of the video, minus social and affiliate links.
const OWNER_LIST = [
  'shadcn/ui', 'Base UI', 'Radix', 'Sonner', 'Vaul', 'cmdk', 'NumberFlow',
  'Beautiful UI', 'RareUI', 'Magic UI', 'Aceternity UI', '21st.dev', 'Mobbin',
];

test('ui sources keep the owner list from the video', () => {
  assert.match(data.source, /youtube\.com\/watch\?v=zsCGS-Yzjnw/);
  assert.deepEqual(data.entries.map((e) => e.name).sort(), [...OWNER_LIST].sort());
});

test('every ui source is complete', () => {
  const styles = Object.keys(data.styles);
  for (const e of data.entries) {
    assert.match(e.url, /^https:\/\//, e.name);
    assert.ok(KINDS.includes(e.kind), `${e.name}: kind ${e.kind}`);
    assert.ok(ACCESS.includes(e.access), `${e.name}: access ${e.access}`);
    assert.ok(e.for && e.license, `${e.name}: for and license`);
    for (const s of e.styles) assert.ok(styles.includes(s), `${e.name}: unknown style ${s}`);
    if (e.kind === 'standout' || e.kind === 'screens') assert.ok(e.styles.length > 0, `${e.name}: needs a style`);
  }
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
