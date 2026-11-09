import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { checkSkills } from '../tools/check-skills.mjs';

const registry = JSON.parse(readFileSync(new URL('../fusion/skills.json', import.meta.url), 'utf8'));

test('the real tree passes', () => {
  assert.deepEqual(checkSkills('.', registry), []);
});
