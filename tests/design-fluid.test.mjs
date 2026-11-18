import { test } from 'node:test';
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { fluidScale } from '../skills/design-system/scripts/fluid-scale.mjs';

const CLI = fileURLToPath(new URL('../skills/design-system/scripts/fluid-scale.mjs', import.meta.url));
const base = { minWidth: 360, maxWidth: 1440, minBase: 15, maxBase: 16, minRatio: 1.25, maxRatio: 1.333 };
const cli = (...args) => spawnSync(process.execPath, [CLI, ...args], { encoding: 'utf8' });

test('step 0 and step 1 clamp between 360 and 1440', () => {
  const [s0, s1] = fluidScale({ ...base, steps: [0, 1] });
  assert.equal(s0.step, 0);
  assert.equal(s0.clamp, 'clamp(0.9375rem, 0.9167rem + 0.0926vw, 1rem)');
  assert.equal(s1.clamp, 'clamp(1.1719rem, 1.1182rem + 0.2387vw, 1.333rem)');
});

test('step 6 lands inside the 56 to 96px display title', () => {
  const [s6] = fluidScale({ ...base, steps: [6] });
  assert.ok(Math.abs(s6.minPx - 57.22) < 0.01, s6.minPx);
  assert.ok(Math.abs(s6.maxPx - 89.76) < 0.01, s6.maxPx);
});

test('a shrinking step keeps the smaller size first and the sign on the slope', () => {
  const [s] = fluidScale({ minWidth: 360, maxWidth: 1440, minBase: 16, maxBase: 15, minRatio: 1.2, maxRatio: 1.2, steps: [0] });
  assert.equal(s.clamp, 'clamp(0.9375rem, 1.0208rem + -0.0926vw, 1rem)');
});

test('the CLI prints one custom property per step', () => {
  const r = cli('--min-width', '360', '--max-width', '1440', '--min-base', '15', '--max-base', '16', '--min-ratio', '1.25', '--max-ratio', '1.333', '--steps', '-1..0');
  assert.equal(r.status, 0, r.stderr);
  const lines = r.stdout.trim().split('\n');
  assert.equal(lines.length, 2);
  assert.ok(lines[0].startsWith('--step--1: clamp('), lines[0]);
  assert.equal(lines[1], '--step-0: clamp(0.9375rem, 0.9167rem + 0.0926vw, 1rem);');
});

test('the CLI exits 1 with the usage when an argument is missing or invalid', () => {
  const missing = cli('--min-width', '360', '--min-base', '15', '--max-base', '16', '--min-ratio', '1.25', '--max-ratio', '1.333', '--steps', '0..1');
  assert.equal(missing.status, 1);
  assert.match(missing.stderr, /usage/);
  const invalid = cli('--min-width', '360', '--max-width', 'wide', '--min-base', '15', '--max-base', '16', '--min-ratio', '1.25', '--max-ratio', '1.333', '--steps', '0..1');
  assert.equal(invalid.status, 1);
});
