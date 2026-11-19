import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, mkdtempSync, symlinkSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
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

test('summarize drops samples with no duration', () => {
  const sample = (duration) => ({ source: 'hover', kind: 'transition', property: 'color', duration, delay: 0, easing: 'ease', target: 'a' });
  const s = summarize([sample(0), sample(200)]);
  assert.equal(s.count, 1);
  assert.deepEqual(s.duration, { min: 200, median: 200, max: 200 });
});

test('__devorbMotion skips an animation with no effect', () => {
  const effect = { getTiming: () => ({ duration: 200, delay: 0, easing: 'ease-out' }), getKeyframes: () => [], target: { tagName: 'DIV', id: '', classList: ['card'] } };
  const document = { getAnimations: () => [{ effect: null }, { effect, transitionProperty: 'opacity' }] };
  const window = {};
  vm.runInNewContext(readFileSync(new URL('../tools/motion-in-page.js', import.meta.url), 'utf8'), { window, document });
  assert.deepEqual(JSON.parse(JSON.stringify(window.__devorbMotion('load'))), [
    { source: 'load', kind: 'transition', property: 'opacity', duration: 200, delay: 0, easing: 'ease-out', target: 'div.card' }
  ]);
});

const ROOT = fileURLToPath(new URL('..', import.meta.url));
const TOOL = join(ROOT, 'tools', 'motion-study.mjs');
const run = (out) => spawnSync(process.execPath, [TOOL, '--out', out, '--only', '__none__'], { encoding: 'utf8', timeout: 10000 });
test('the CLI refuses an --out that reaches the repo through a symlink', () => {
  const link = join(mkdtempSync(join(tmpdir(), 'devorb-motion-')), 'repo');
  symlinkSync(ROOT, link);
  const r = run(join(link, `motion-out-${process.pid}`));
  assert.equal(r.status, 1);
  assert.match(r.stdout + r.stderr, /OUT INSIDE REPO/);
});
test('the CLI refuses an --out inside the repo spelled in another case on macOS', { skip: process.platform !== 'darwin' }, () => {
  const r = run(join(ROOT.toUpperCase(), `motion-out-${process.pid}`));
  assert.equal(r.status, 1);
  assert.match(r.stdout + r.stderr, /OUT INSIDE REPO/);
});
