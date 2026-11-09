import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, mkdtempSync, mkdirSync, writeFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { checkSkills, approxTokens } from '../tools/check-skills.mjs';

const fx = (n) => fileURLToPath(new URL(`./fixtures/skills/${n}/`, import.meta.url));
const regOf = (n) => JSON.parse(readFileSync(`${fx(n)}registry.json`, 'utf8'));
const errs = (n) => checkSkills(fx(n), regOf(n));

test('approxTokens is UTF-8 bytes / 4 rounded up', () => {
  assert.equal(approxTokens(''), 0);
  assert.equal(approxTokens('abcd'), 1);
  assert.equal(approxTokens('abcde'), 2);
  assert.equal(approxTokens('éé'), 1); // 4 bytes
});

test('valid tree has no errors', () => assert.deepEqual(errs('valid'), []));
test('token ceiling', () => assert.ok(errs('over-ceiling').includes('big: 2600 tokens > 2500')));
test('byte limit', () => assert.ok(errs('huge').includes('huge: SKILL.md >= 20000 bytes')));
test('unknown devorb reference', () => assert.ok(errs('bad-ref').includes('a: devorb:nope not in registry')));
test('legacy name', () => assert.ok(errs('legacy').includes('a: legacy name superpowers:')));
test('legacy name in nested references', () =>
  assert.ok(errs('ref-legacy-elsewhere').includes('a: legacy name .scratch/')));
test('missing Connects to', () => assert.ok(errs('no-connects').includes('a: missing "Connects to" section')));
test('auto description must start with Use when', () =>
  assert.ok(errs('bad-desc').includes('a: automatic skill description must start with "Use when"')));
test('manual skill needs the flag', () =>
  assert.ok(errs('manual-flag').includes('m: manual skill needs disable-model-invocation: true')));
test('manual skill with flag is fine without Use when', () => assert.deepEqual(errs('manual-ok'), []));
test('frontmatter name must match folder', () =>
  assert.ok(errs('name').includes('a: frontmatter name differs from folder')));
test('always-on cost cap', () => assert.ok(errs('always-on').includes('always-on: 800 tokens > 706')));
test('done without folder', () => assert.ok(errs('missing-done').includes('a: status done but folder missing')));
test('planned without folder is fine', () => assert.deepEqual(errs('planned-no-folder'), []));
test('referencing a planned skill is valid', () => assert.deepEqual(errs('planned-ref'), []));
test('folder not in registry', () => assert.ok(errs('unregistered').includes('z: folder not in registry')));
test('legacy-names.md is exempt from the legacy check', () => assert.deepEqual(errs('legacy-allowed'), []));
test('legacy-names.md still has its devorb references checked', () =>
  assert.deepEqual(errs('legacy-bad-ref'), ['a: devorb:ghost not in registry']));
test('missing skills/ folder does not throw', () =>
  assert.deepEqual(checkSkills(fx('nonexistent'), {}), []));
test('both scans walk every file in the skill folder', () =>
  assert.deepEqual(errs('outside-refs').sort(), [
    'a: devorb:ghost not in registry',
    'a: legacy name .superpowers/',
    'a: legacy name superpowers:',
  ]));
test('automatic skill must not set disable-model-invocation', () =>
  assert.deepEqual(errs('auto-flag'), ['a: automatic skill must not set disable-model-invocation']));
test('a stray file in skills/ is not a folder', () => {
  const root = mkdtempSync(join(tmpdir(), 'devorb-'));
  try {
    mkdirSync(join(root, 'skills'));
    writeFileSync(join(root, 'skills', '.DS_Store'), 'x');
    assert.deepEqual(checkSkills(root, {}), []);
  } finally {
    rmSync(root, { recursive: true, force: true });
  }
});
