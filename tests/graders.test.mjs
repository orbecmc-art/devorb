import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, readdirSync, existsSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

// `focus: files` / `target: files` hands the llm judge only the paths created
// during the run, never contents, and leaves out pre-existing files.
const onlyNames = /\b(só|apenas) (os )?nomes dos arquivos\b|\bonly (the )?file names\b/i;

function graders() {
  const out = [];
  const walk = (dir) => {
    for (const e of readdirSync(dir, { withFileTypes: true })) {
      const p = join(dir, e.name);
      if (e.isDirectory()) walk(p);
      else if (e.name.endsWith('.md') && /[/\\]graders$/.test(dir)) out.push(p);
    }
  };
  for (const suite of ['evals', 'evals-reserved']) {
    const dir = new URL(`../${suite}`, import.meta.url);
    if (existsSync(dir)) walk(fileURLToPath(dir));
  }
  return out;
}

test('graders exist in the suites', () => {
  assert.ok(graders().length > 0);
});

test('no llm grader judges contents through focus: files or target: files', () => {
  const bad = [];
  for (const p of graders()) {
    const [, fm = '', body = ''] = readFileSync(p, 'utf8').match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?([\s\S]*)$/) ?? [];
    if (!/^type:\s*['"]?llm['"]?\s*$/m.test(fm)) continue;
    if (/^(focus|target):\s*['"]?files['"]?\s*$/m.test(fm) && !onlyNames.test(body)) bad.push(p);
  }
  assert.deepEqual(bad, []);
});
