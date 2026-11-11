import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, readdirSync, existsSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

// `focus: files` / `target: files` hands the llm judge only the paths created
// during the run, never contents, and leaves out pre-existing files.
const onlyNames = /\b(só|apenas) (os )?nomes dos arquivos\b|\bonly (the )?file names\b/i;

function judgesContentsByFileList(text) {
  const [, fm = '', body = ''] = text.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?([\s\S]*)$/) ?? [];
  if (!/^type:\s*['"]?llm['"]?\s*(#.*)?$/m.test(fm)) return false;
  return /^(focus|target):\s*['"]?files['"]?\s*(#.*)?$/m.test(fm) && !onlyNames.test(body);
}

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

test('the file-list check catches every spelling of focus or target files', () => {
  const caught = [
    '---\ntype: llm\nfocus: files\n---\nrubric',
    '---\ntype: llm\nfocus: files # x\n---\nrubric',
    '---\ntype: llm # judge\ntarget: "files"\n---\nrubric',
    "---\ntype: 'llm'\ntarget: 'files'   # y\n---\nrubric",
  ];
  const allowed = [
    '---\ntype: llm\nfocus: trace\n---\nrubric',
    '---\ntype: llm\nfocus:\n  source: file\n  path: a.js\n---\nrubric',
    '---\ntype: regex\ntarget: files\n---\n',
    '---\ntype: llm\nfocus: files\n---\nConfere só os nomes dos arquivos criados.',
  ];
  for (const s of caught) assert.equal(judgesContentsByFileList(s), true, s);
  for (const s of allowed) assert.equal(judgesContentsByFileList(s), false, s);
});

test('graders exist in the suites', () => {
  assert.ok(graders().length > 0);
});

test('no llm grader judges contents through focus: files or target: files', () => {
  const bad = graders().filter((p) => judgesContentsByFileList(readFileSync(p, 'utf8')));
  assert.deepEqual(bad, []);
});
