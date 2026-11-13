import { test } from 'node:test';
import assert from 'node:assert/strict';
import { chmodSync, mkdirSync, mkdtempSync, readFileSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { evalOutside, gradeRegex, parseGrader, parseYaml, score } from '../tools/eval-outside.mjs';

const CASE = `schema_version: "1.0"
name: demo-click
description: >-
  um app
  pequeno
runs: 2
context:
  scaffold_script: scaffold.sh
execution:
  prompt: >-
    confere a tela
    antes de eu avisar

    o cliente
  max_turns: 30
  allowed_tools: [Read, Bash, Skill]
`;

test('parseYaml reads the case shape our suites use', () => {
  const c = parseYaml(CASE);
  assert.equal(c.name, 'demo-click');
  assert.equal(c.runs, 2);
  assert.equal(c.description, 'um app pequeno');
  assert.equal(c.context.scaffold_script, 'scaffold.sh');
  assert.equal(c.execution.prompt, 'confere a tela antes de eu avisar\no cliente');
  assert.equal(c.execution.max_turns, 30);
  assert.deepEqual(c.execution.allowed_tools, ['Read', 'Bash', 'Skill']);
  assert.throws(() => parseYaml('- a list item\n'), /unsupported YAML/);
});

test('parseGrader keeps single-quoted patterns and nested targets', () => {
  const g = parseGrader("---\ntype: regex\ntarget:\n  source: file\n  path: out.txt\npattern: 'it''s (ok|fine)'\nmatch: not_contains\nweight: 2\n---\nrubric\n", 'g1');
  assert.deepEqual({ ...g }, { name: 'g1', weight: 2, type: 'regex', target: { source: 'file', path: 'out.txt' }, pattern: "it's (ok|fine)", match: 'not_contains', body: 'rubric' });
});

test('gradeRegex and score', () => {
  const dir = mkdtempSync(join(tmpdir(), 'eo-'));
  writeFileSync(join(dir, 'a.txt'), 'all good');
  const run = { cwd: dir, trace: '"name":"Bash"', lastMessage: 'pronto' };
  assert.equal(gradeRegex({ target: 'trace', pattern: '"name":"Bash"' }, run).passed, true);
  assert.equal(gradeRegex({ target: 'last_message', pattern: 'falh', match: 'not_contains' }, run).passed, true);
  assert.equal(gradeRegex({ target: { source: 'file', path: 'a.txt' }, pattern: 'GOOD', flags: 'i' }, run).passed, true);
  assert.equal(gradeRegex({ target: { source: 'file', path: 'gone.txt' }, pattern: 'x', match: 'not_contains' }, run).passed, false);
  assert.deepEqual(score([{ weight: 3, passed: true }, { weight: 1, passed: false }]), { score: 0.75, passed: false });
});

test('evalOutside runs scaffold, agent and graders, and writes the summary shape', async () => {
  const root = mkdtempSync(join(tmpdir(), 'eo-'));
  const arm = join(root, 'devorb@abc');
  const kase = join(arm, 'evals-outside', 'demo-click');
  mkdirSync(join(kase, 'graders'), { recursive: true });
  mkdirSync(join(arm, '.claude-plugin'));
  writeFileSync(join(arm, '.claude-plugin', 'plugin.json'), '{"name":"devorb"}\n');
  writeFileSync(join(kase, 'case.yaml'), CASE);
  writeFileSync(join(kase, 'scaffold.sh'), 'echo seeded > seed.txt\n');
  writeFileSync(join(kase, 'graders', 'clicked.md'), "---\ntype: regex\ntarget: trace\npattern: 'click\\('\n---\n");
  writeFileSync(join(kase, 'graders', 'seed.md'), "---\ntype: regex\ntarget:\n  source: file\n  path: seed.txt\npattern: seeded\n---\n");
  writeFileSync(join(kase, 'graders', 'honest.md'), '---\ntype: llm\nfocus: last_message\nweight: 2\n---\nAponta a falha.\n');
  // Fake claude: the agent prints a stream-json trace; the judge (stdin prompt) votes PASS.
  const fake = join(root, 'claude');
  writeFileSync(fake, `#!/bin/sh
echo "$@" >> "${join(root, 'args.log')}"
case "$*" in
  *stream-json*) [ "$(cat seed.txt)" = seeded ] || exit 9
    echo '{"type":"assistant","message":{"content":[{"type":"tool_use","name":"Bash","input":{"command":"page.click(save)"}}]}}'
    echo '{"type":"result","subtype":"success","result":"o botão salvar falha com 404","total_cost_usd":0.5,"num_turns":4}' ;;
  *) cat > /dev/null; echo '{"result":"PASS ok","total_cost_usd":0.01}' ;;
esac
`);
  chmodSync(fake, 0o755);
  const jsonPath = join(arm, 'eval-result.json');
  const out = await evalOutside({ claude: fake, armDir: arm, pattern: /^demo-/, evalDir: 'evals-outside', runs: 2, model: 'm', jsonPath, concurrency: 2 });
  const c = out.cases[0];
  assert.equal(c.name, 'demo-click');
  assert.equal(c.arms.with.length, 2);
  assert.deepEqual(c.aggregates, { score: 1, passRate: 1 });
  assert.equal(c.arms.with[0].error, null);
  assert.ok(Math.abs(out.costUsd - 2 * (0.5 + 3 * 0.01)) < 1e-9);
  assert.deepEqual(JSON.parse(readFileSync(jsonPath, 'utf8')).cases[0].aggregates, c.aggregates);
  const args = readFileSync(join(root, 'args.log'), 'utf8');
  assert.match(args, /--restricted/);
  assert.match(args, /--plugin-dir/);
  assert.match(args, /--tools Read,Bash,Skill/);
  assert.match(readFileSync(`${jsonPath}.traces/demo-click-0.jsonl`, 'utf8'), /page\.click/);
});
