import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { staggerOf, summarize } from '../tools/motion-study.mjs';

test('staggerOf is the median gap between the sorted unique delays', () => {
  assert.equal(staggerOf([0, 40, 80, 120]), 40);
  assert.equal(staggerOf([0, 0]), null);
  assert.equal(staggerOf([0, 30, 90]), 45);
});

test('summarize gives the median duration and the most common easing first', () => {
  const sample = (duration, easing) => ({ source: 'scroll', kind: 'transition', property: 'opacity', duration, delay: 0, easing, target: 'div' });
  const s = summarize([sample(400, 'linear'), sample(150, 'ease-out'), sample(250, 'ease-out')]);
  assert.equal(s.count, 3);
  assert.deepEqual(s.duration, { min: 150, median: 250, max: 400 });
  assert.deepEqual(s.easings[0], ['ease-out', 2]);
  assert.equal(s.staggerMs, null);
});

test('hoverTargets skips a cross-origin sheet and an invalid selector', () => {
  const crossOrigin = {
    get cssRules() {
      throw Object.assign(new Error('Cannot access rules'), { name: 'SecurityError' });
    }
  };
  const btn = { getBoundingClientRect: () => ({ left: 100, top: 200, width: 80, height: 40 }) };
  const document = {
    styleSheets: [crossOrigin, { cssRules: [{ selectorText: '.btn:hover' }] }, { cssRules: [{ selectorText: '::-moz-x:hover' }] }],
    querySelectorAll: (sel) => {
      if (sel === '.btn') return [btn];
      throw Object.assign(new Error(`'${sel}' is not a valid selector`), { name: 'SyntaxError' });
    }
  };
  const window = { scrollX: 0, scrollY: 0 };
  vm.runInNewContext(readFileSync(new URL('../tools/motion-in-page.js', import.meta.url), 'utf8'), { window, document });
  assert.deepEqual(JSON.parse(JSON.stringify(window.__devorbHoverTargets())), [{ x: 140, y: 220 }]);
});
