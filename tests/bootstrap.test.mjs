import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, readdirSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const registry = JSON.parse(readFileSync(new URL('../fusion/skills.json', import.meta.url), 'utf8'));
const skillPath = (rel) => fileURLToPath(new URL(`../skills/using-devorb/${rel}`, import.meta.url));
const read = (rel) => readFileSync(skillPath(rel), 'utf8');

const REFERENCES = ['claude-code-tools.md', 'legacy-names.md', 'phase-boundaries.md'];

const SUPERPOWERS_NAMES = {
  'using-superpowers': 'using-devorb',
  brainstorming: 'aligning',
  'writing-plans': 'planning',
  'subagent-driven-development': 'implementing',
  'executing-plans': 'implementing',
  'dispatching-parallel-agents': 'implementing',
  'using-git-worktrees': 'implementing',
  'test-driven-development': 'tdd',
  'systematic-debugging': 'debugging',
  'verification-before-completion': 'verifying',
  'requesting-code-review': 'reviewing',
  'receiving-code-review': 'reviewing',
  'finishing-a-development-branch': 'finishing',
  'writing-skills': 'writing-skills',
};

const SLASH_NAMES = {
  'ask-matt': 'using-devorb',
  grilling: 'aligning',
  'grill-me': 'aligning',
  'grill-with-docs': 'aligning',
  'to-spec': 'planning',
  'to-tickets': 'planning',
  implement: 'implementing',
  'implement-spec': 'implementing',
  tdd: 'tdd',
  'diagnosing-bugs': 'debugging',
  'code-review': 'reviewing',
  pr: 'finishing',
  'writing-for-agents': 'writing-skills',
  'domain-modeling': 'domain-modeling',
  'codebase-design': 'codebase-design',
  'improve-codebase-architecture': 'improve-architecture',
  prototype: 'prototype',
  handoff: 'handoff',
  retro: 'retro',
};

const LEFT_OUT = [
  '/triage',
  '/wayfinder',
  '/teach',
  '/to-questionnaire',
  '/wizard',
  '/research',
  '/wait-what',
  'superpowers:diagnosing-superpowers',
  '/setup-matt-pocock-skills',
];

// A design skill joins the bootstrap in the task that finishes it: naming it earlier would send
// agents after a skill that does not exist yet.
const inBootstrap = (s) => s.sector !== 'design' || s.status === 'done';

test('bootstrap names every non-manual skill, design ones once done, and stays small', () => {
  const body = read('SKILL.md');
  for (const [name, s] of Object.entries(registry))
    if (s.invocation !== 'manual' && name !== 'using-devorb' && inBootstrap(s)) assert.ok(body.includes(`devorb:${name}`), name);
  assert.ok(Buffer.byteLength(body) <= 3500);
});

test('a design skill still being planned stays out of the bootstrap', () => {
  const body = read('SKILL.md');
  for (const [name, s] of Object.entries(registry))
    if (!inBootstrap(s)) assert.ok(!body.includes(`devorb:${name}`), name);
});

test('using-devorb is marked done', () => {
  assert.equal(registry['using-devorb'].status, 'done');
});

test('description says only when to use the skill', () => {
  const description = /^description:[ \t]*(.*)$/m.exec(read('SKILL.md'))?.[1] ?? '';
  assert.ok(description.startsWith('Use when'), description);
});

test('bootstrap keeps the skill check, the subagent stop and the red flags', () => {
  const body = read('SKILL.md');
  assert.match(body, /<SUBAGENT-STOP>/);
  assert.match(body, /BEFORE any response or action/);
  assert.match(body, /## Red Flags/);
});

test('precedence runs user and project, then the flow, then the specific skill', () => {
  const body = read('SKILL.md');
  const order = ['User and project instructions', 'The DevOrb flow', 'The specific skill'].map((s) => body.indexOf(s));
  assert.ok(order.every((i) => i >= 0), `missing level: ${order}`);
  assert.deepEqual(order, [...order].sort((a, b) => a - b));
});

test('new work enters through aligning and a bug through debugging', () => {
  const body = read('SKILL.md');
  assert.match(body, /New work enters through `devorb:aligning`/);
  assert.match(body, /A bug enters through `devorb:debugging`/);
});

test('manual skills are named as running only when the user calls them', () => {
  const body = read('SKILL.md');
  assert.match(body, /Manual skills run only when the user calls them/);
  for (const [name, s] of Object.entries(registry))
    if (s.invocation === 'manual' && inBootstrap(s)) assert.ok(body.includes(`devorb:${name}`), name);
});

test('the only references are the three kept files, and the body points to each', () => {
  assert.deepEqual(readdirSync(skillPath('references')).filter((f) => !f.startsWith('.')).sort(), REFERENCES);
  const body = read('SKILL.md');
  for (const file of REFERENCES) assert.ok(body.includes(`references/${file}`), file);
});

test('the skill and its references do not mention where they came from', () => {
  for (const rel of ['SKILL.md', 'references/claude-code-tools.md', 'references/phase-boundaries.md']) {
    assert.doesNotMatch(read(rel), /superpowers|pocock|\bmatt\b|aihero|human partner/i, rel);
  }
});

test('legacy-names maps every name the skill map covers', () => {
  const text = read('references/legacy-names.md');
  for (const [old, name] of Object.entries(SUPERPOWERS_NAMES))
    assert.ok(text.includes(`| \`superpowers:${old}\` | \`devorb:${name}\` |`), old);
  for (const [old, name] of Object.entries(SLASH_NAMES))
    assert.ok(text.includes(`| \`/${old}\` | \`devorb:${name}\` |`), old);
});

test('legacy-names marks the left-out skills as having no equivalent', () => {
  const text = read('references/legacy-names.md');
  for (const old of LEFT_OUT) assert.ok(text.includes(`| \`${old}\` | No equivalent |`), old);
});

test('phase-boundaries keeps the five questions in order, with DevOrb names', () => {
  const text = read('references/phase-boundaries.md');
  const order = ['**1.', '**2.', '**3.', '**4.', '**5.'].map((s) => text.indexOf(s));
  assert.ok(order.every((i) => i >= 0), `missing question: ${order}`);
  assert.deepEqual(order, [...order].sort((a, b) => a - b));
  assert.match(text, /`devorb:handoff`/);
  assert.match(text, /`\/compact`/);
});
