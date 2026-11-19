import { test } from 'node:test';
import assert from 'node:assert/strict';
import { existsSync, readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const REFS = fileURLToPath(new URL('../skills/visual-direction/references/', import.meta.url));
const HEADER = /^### `(hero|section):([a-z0-9-]+)`/gm;
const read = (name) => (existsSync(REFS + name) ? readFileSync(REFS + name, 'utf8') : '');

const HERO_IDS = [
  'centred-product-halo', 'split-header-bleeding-ui', 'copy-left-ui-right-halo', 'object-cut-by-fold',
  'full-photo-display-type', 'type-performs-product', 'tilted-content-wall', 'left-headline-product-video',
  'copy-and-form-card', 'giant-word-on-canvas',
];
const SECTION_IDS = [
  'live-ui-bento', 'proof-grid', 'stat-cards-mono', 'alternating-rows-fading-ui', 'numbered-steps',
  'two-tone-statement', 'mono-spec-table', 'configurator-pricing', 'hairline-faq', 'dark-contrast-band',
  'closing-cta-echo', 'giant-wordmark-footer',
];

const files = [
  { name: 'hero-patterns.md', kind: 'hero', ids: HERO_IDS },
  { name: 'section-patterns.md', kind: 'section', ids: SECTION_IDS },
];

for (const { name, kind, ids } of files) {
  test(`${name} lists the ${ids.length} ${kind} ids once each`, () => {
    const found = [...read(name).matchAll(HEADER)].map((m) => `${m[1]}:${m[2]}`);
    assert.equal(new Set(found).size, found.length, `repeated id in ${found}`);
    assert.deepEqual(found.toSorted(), ids.map((id) => `${kind}:${id}`).toSorted());
  });

  test(`every pattern in ${name} has When, Sketch, Measures and Mobile`, () => {
    // A block runs from its ### header to the next ## or ### heading.
    const blocks = read(name).split(/^(?=#{2,3} )/m).filter((b) => /^### `(hero|section):/.test(b));
    assert.ok(blocks.length > 0, `no pattern blocks in ${name}`);
    for (const block of blocks) {
      for (const label of ['When:', 'Sketch:', 'Measures:', 'Mobile:']) {
        assert.match(block, new RegExp(`^${label}`, 'm'), `${block.split('\n')[0]} misses ${label}`);
      }
    }
  });
}

test('section-patterns.md ends with the mobile recomposition', () => {
  assert.match(read('section-patterns.md'), /^## Mobile recomposition$/m);
});
