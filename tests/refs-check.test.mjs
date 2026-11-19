import { test } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, mkdirSync, writeFileSync, readFileSync, existsSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { parseUrls, judgeSite, report } from '../tools/refs-check.mjs';

const ROOT = fileURLToPath(new URL('..', import.meta.url));
const TOOL = join(ROOT, 'tools', 'refs-check.mjs');

test('parseUrls reads slug, url and mode, defaulting to persuade and skipping comments', () => {
  assert.deepEqual(parseUrls('# refs\n\na https://a/\nb https://b/ experience\n'), [
    { slug: 'a', url: 'https://a/', mode: 'persuade' },
    { slug: 'b', url: 'https://b/', mode: 'experience' }
  ]);
});
test('parseUrls throws on an unknown mode with the line number', () => {
  assert.throws(() => parseUrls('a https://a/\nb https://b/ loud'), /line 2: unknown mode loud/);
});
test('parseUrls throws on a duplicate slug with the line number', () => {
  assert.throws(() => parseUrls('a https://a/\n# x\na https://b/'), /line 3: duplicate slug a/);
});
test('parseUrls throws on a line with no url', () => {
  assert.throws(() => parseUrls('a https://a/\nlonely'), /line 2: missing url/);
});
test("the repo's urls.txt holds the 23 references with their modes", () => {
  const refs = parseUrls(readFileSync(join(ROOT, 'docs/specs/2026-11-18-referencias/urls.txt'), 'utf8'));
  assert.equal(refs.length, 23);
  const experience = refs.filter((r) => r.mode === 'experience').map((r) => r.slug).sort();
  assert.deepEqual(experience, ['onlines', 'shopify-editions']);
  assert.ok(refs.every((r) => r.mode === 'experience' || r.mode === 'persuade'));
});

// a shoot output folder: <dir>/<w>/metrics.json and checks.json
const site = (perWidth) => {
  const dir = mkdtempSync(join(tmpdir(), 'devorb-refs-'));
  for (const [w, { sections, checks, shotErrors = [] }] of Object.entries(perWidth)) {
    mkdirSync(join(dir, w));
    writeFileSync(join(dir, w, 'metrics.json'), JSON.stringify({ sections, shotErrors }));
    writeFileSync(join(dir, w, 'checks.json'), JSON.stringify(checks));
  }
  return dir;
};
const sec = (hiddenContent = 0, hidden = false) => ({ hidden, hiddenContent });
const ok = { id: 'heading-ratio', status: 'PASS', detail: '' };
const good = { sections: [sec(), sec()], checks: [ok, { id: 'measure', status: 'WARN', detail: '' }] };

test('judgeSite passes a site with 2 sections, no hidden content and only WARNs, even on exit 2', () => {
  const dir = site({ 1440: good, 390: { ...good, shotErrors: [{ shot: 'section-1', error: 'skipped: empty' }] } });
  assert.deepEqual(judgeSite({ dir, widths: [1440, 390], exit: 2 }), {
    status: 'PASS', reasons: [], warns: ['measure at 1440', 'measure at 390'], shotErrors: ['390/section-1: skipped: empty']
  });
});
test('judgeSite fails a floor FAIL by id and width', () => {
  const dir = site({ 1440: { ...good, checks: [{ id: 'body-size', status: 'FAIL', detail: '' }] } });
  assert.deepEqual(judgeSite({ dir, widths: [1440], exit: 2 }).reasons, ['FAIL body-size at 1440']);
});
test('judgeSite fails hidden content and too few visible sections', () => {
  const dir = site({ 390: { sections: [sec(3), sec(0, true)], checks: [ok] } });
  const r = judgeSite({ dir, widths: [390], exit: 0 });
  assert.equal(r.status, 'FAIL');
  assert.deepEqual(r.reasons, ['1 sections at 390', 'hidden content 3 at 390']);
});
test('judgeSite gives timeout on a null exit and the last stderr line on a crash', () => {
  const dir = site({ 1440: good });
  assert.deepEqual(judgeSite({ dir, widths: [1440], exit: null }).reasons, ['timeout']);
  assert.deepEqual(judgeSite({ dir, widths: [1440], exit: 1, stderr: 'at x\nTypeError: boom\n' }).reasons, ['run failed (exit 1): TypeError: boom']);
});
test("judgeSite names the error line, not Node's version trailer, on a crash", () => {
  const dir = site({ 1440: good });
  const stderr = 'file:///x/shoot.mjs:9\nTypeError: boom\n    at main (file:///x/shoot.mjs:9:3)\n\nNode.js v22.11.0\n';
  assert.deepEqual(judgeSite({ dir, widths: [1440], exit: 1, stderr }).reasons, ['run failed (exit 1): TypeError: boom']);
  assert.deepEqual(judgeSite({ dir, widths: [1440], exit: 1, stderr: 'killed\n' }).reasons, ['run failed (exit 1): killed']);
});
test('judgeSite reports a missing width folder', () => {
  const dir = site({ 1440: good });
  assert.deepEqual(judgeSite({ dir, widths: [1440, 390], exit: 0 }).reasons, ['no metrics at 390']);
});

test('judgeSite reads a broken metrics.json or a missing checks.json as no metrics', () => {
  const dir = site({ 1440: good, 390: good });
  writeFileSync(join(dir, '1440', 'metrics.json'), '{"sections": [');
  rmSync(join(dir, '390', 'checks.json'));
  assert.deepEqual(judgeSite({ dir, widths: [1440, 390], exit: 0 }).reasons, ['no metrics at 1440', 'no metrics at 390']);
});

test('report lists each site and ends with the pass count', () => {
  const text = report([
    { slug: 'a', mode: 'persuade', status: 'PASS', reasons: [], warns: ['measure at 1440'], shotErrors: [] },
    { slug: 'b', mode: 'experience', status: 'FAIL', reasons: ['timeout', 'no metrics at 390'], warns: [], shotErrors: ['390/full: boom'] }
  ]);
  assert.equal(text, [
    '- a (persuade): PASS',
    '  WARN: measure at 1440',
    '- b (experience): FAIL — timeout; no metrics at 390',
    '  shotErrors: 390/full: boom',
    'refs-check: 1/2 PASS'
  ].join('\n'));
});

test('the CLI refuses an --out inside the repo', () => {
  const out = join(ROOT, `refs-out-${process.pid}`);
  const r = spawnSync(process.execPath, [TOOL, '--out', out, '--only', '__none__'], { encoding: 'utf8', timeout: 10000 });
  assert.equal(r.status, 1);
  assert.match(r.stdout + r.stderr, /OUT INSIDE REPO/);
  assert.equal(existsSync(out), false);
});
test('the CLI exits 1 when --only selects no reference, before shooting anything', () => {
  const out = join(mkdtempSync(join(tmpdir(), 'devorb-refs-')), 'out');
  const r = spawnSync(process.execPath, [TOOL, '--out', out, '--only', '__none__'], { encoding: 'utf8', timeout: 10000 });
  assert.equal(r.status, 1);
  assert.match(r.stderr, /no reference selected/);
  assert.equal(existsSync(out), false);
});
