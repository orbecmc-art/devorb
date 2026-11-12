---
name: writing-skills
description: Use when creating, editing or testing a skill, or writing CLAUDE.md, AGENTS.md or any other instructions an agent follows
---

# Writing Skills

A skill is a document an agent follows. Writing one is test-driven development applied to documents: watch an agent fail without it, write the least text that fixes that failure, watch the agent pass with it, then tighten. The cycle is the one in `devorb:tdd`; this skill adapts it. Everything here also applies to `CLAUDE.md`, `AGENTS.md`, a prompt template, or any file an agent reaches through a pointer.

```
NO SKILL WITHOUT A FAILING TEST FIRST.
```

This covers new skills and edits to existing ones. Text you wrote in this change before its baseline run is a guess about what agents need: delete it and start from RED. An existing skill stays; revert only your untested edit. If the user tells you directly to skip testing, that is their call: follow it, and report the skill as untested.

Working in this repository's own skills, with `fusion/skills.json` at the root? Read `references/devorb.md` first: it names the eval cases, comparison tool, size limits and ledger that replace the generic steps below.

## When a skill earns its place

Write a skill for a technique that was not obvious, that you will reach for again across tasks or projects, and that other agents would get wrong without it. Route everything else where it lives best:

- **A one-off solution:** nowhere. Solve it.
- **A project convention:** one line in the project's `CLAUDE.md` or `AGENTS.md`.
- **A mechanical rule** that a regex, linter, type check or test can enforce: make it that check. Documents carry judgment calls.
- **Something the model already does well:** nothing. A skill that changes no behavior is pure load.

## The cycle

### 1. RED: watch an agent fail without the skill

Write a scenario that tempts the failure: a realistic task, in a repository with concrete paths and files, phrased the way a user would ask. For a discipline skill, combine three or more pressures (time, sunk cost, authority, exhaustion) and force a concrete choice. Run it with a fresh subagent that has never seen your draft, without the skill. Run a few times; single samples lie.

Record, word for word: what the agent chose, the rationalizations it gave, and which pressure broke it. The step is done when you can quote the failure. If the agent already does the right thing, there is nothing to fix: stop, and write no skill. `references/testing.md` has scenario formats, pressure types, tests by skill type and wording micro-tests.

### 2. Match the form to the failure

Classify what you saw before you write a word. The form that fixes one failure type backfires on another.

| Observed failure | Form that fixes it |
|---|---|
| Knows the rule, skips it under pressure | Bright-line rule, rationalization table, red flags: read `references/bulletproofing.md` |
| Complies, but the output has the wrong shape (bloated, buried verdict, restated spec) | A positive recipe: what the output is, its parts, in order |
| Leaves out an element of something it already produces | A required slot in the template it fills in |
| Behavior should depend on a condition | A conditional keyed to something observable ("if the spec exists, cite it") |

Write in the positive by default: state the target behavior, so the unwanted one is never spoken. A prohibition drags the forbidden behavior into context; under a competing goal, agents negotiate with "don't X", and in wording tests the prohibition produced more of the unwanted output than no guidance at all. Use a prohibition only for a discipline failure you observed or a hard guardrail you cannot phrase positively, and pair it with the positive target. Whatever the form:

- **Express each exception as its own conditional** on an observable predicate. A nuance clause ("unless it matters") reopens the negotiation.
- **Restructure so a rule cannot reach what must stay exempt.** "This limit doesn't apply to code blocks" still suppresses code blocks.

### 3. GREEN: write the least skill that fixes the observed failure

Address the failures you recorded, in the agent's own words where it rationalized. Content for hypothetical cases waits for a scenario that shows it is needed. Run the same scenarios with the skill loaded: the agent now complies. Still failing? The skill is unclear or incomplete; revise and run again.

### 4. REFACTOR: close loopholes, then prune

A new rationalization in the runs gets an explicit counter, then a re-run, until the scenario passes under full pressure. Then prune (below), and run once more: pruning is an edit too.

Take each skill through its whole cycle before starting the next one.

## Writing the document

**Where it lives.** A project skill is `.claude/skills/<name>/SKILL.md`, with its supporting files beside it (`references/`, `scripts/`); a personal one goes in `~/.claude/skills/`. A plugin keeps its skills in its own `skills/` folder.

**Frontmatter.** `name` is letters, digits and hyphens, named for what you do (`condition-based-waiting`, `writing-skills`). An automatic skill has a `description` that starts with "Use when..." and lists only triggering conditions and symptoms, in the third person. It never summarizes the workflow: an agent that reads a workflow summary follows it and skips the body. A manual skill sets `disable-model-invocation: true`, and its description is a one-line summary for the human who types its name. Choosing between them, writing triggers, and splitting a skill: read `references/SKILL-MECHANICS.md`.

**Context pointers.** A description, a line in `AGENTS.md` naming a doc, and "read `references/x.md` when..." are all context pointers: text in context that names material outside it and says when to reach it. The wording of the pointer, not the target, decides whether the agent gets there. A must-have target behind a weak pointer is a variance bug: sharpen the pointer's condition first, and inline the material only if sharpening fails. Point to another skill by its full name (`devorb:tdd`) and say whether it is required. Never `@`-link a file: that force-loads it.

**Information hierarchy.** Place each piece by how soon the agent needs it:

1. **In-file steps:** what the agent does, in order.
2. **In-file reference:** rules and facts consulted on demand.
3. **Disclosed reference:** a file in `references/`, loaded only when its pointer fires.

Inline what every branch of the task needs; disclose what only some branches reach. Keep every reference one level deep from `SKILL.md`, and give a reference longer than 100 lines a table of contents. Keep a concept's definition, rules and caveats under one heading. A document too long, even with every line live, is **sprawl**: attention thins, so disclose and split.

**Completion criteria.** End every step on a condition the agent can check ("each modified model accounted for", "you can quote the failure"). A vague bound ("understanding reached") invites premature completion; sharpen the bound before anything else.

**Leading words.** Prefer a compact concept the model already knows (_tracer bullet_, _red_, _tight loop_) to a sentence that gestures at it. Repeated as a word, it anchors the behavior in few tokens. A triad spelled out at three sites is a leading word waiting to be found.

**Freedom.** Match specificity to fragility: exact commands for a fragile, ordered operation; heuristics where several approaches work.

**Examples and files.** One excellent, runnable example from a real scenario, in the most relevant language. Write reusable techniques, not the story of one session. Use a flowchart only for a non-obvious decision or a loop where agents stop too early; lists and tables carry the rest. Invoke bundled scripts through their interpreter (`bash scripts/check.sh`, `node scripts/check.js`), since packagers can strip executable bits. Use forward slashes in paths.

## Pruning

Run this pass on every draft and every edit. Each line must change behavior against the agent's default.

- **No-ops.** A sentence the model already obeys pays load to say nothing: delete the whole sentence. Two readers disagreeing about a no-op settle it by running the scenario, not by debate. A leading word too weak to beat the default (_be thorough_) needs a stronger word (_relentless_).
- **Single source of truth.** Each meaning lives in one place. A duplicate costs tokens, drifts, and inflates the meaning's rank.
- **The environment is a source too.** `package.json` scripts, config files, directory layout and `--help` output are one lookup away; restating them is a cache that goes stale. Write what the agent cannot find by looking: the unwritten convention, the reason behind a choice, the gotcha.
- **Relevance.** A line that never bears on the task, or describes behavior that changed, is sediment. Remove it now; adding feels safe and removing feels risky, and that is how documents rot.
- **Always-loaded text** (descriptions, `CLAUDE.md` lines) costs on every turn: front-load the leading word, one trigger per distinct case, no synonyms that rename one case.

## Skipping the test

Agents skip RED for documents more readily than for code. These thoughts mean: go back to RED.

| Thought | Reality |
|---|---|
| "The skill is obviously clear" | Clear to you is not clear to an agent under pressure. Run it. |
| "It's just a reference" | References have gaps and unreachable sections. Test retrieval. |
| "It's a small edit" | An untested edit is an untested skill. Same cycle. |
| "I'll test if problems show up" | A problem means an agent already failed with it. |
| "Reading it through is enough" | Reading is not using. Run an application scenario. |
| "Batching skills is more efficient" | Each skill gets its own cycle before the next. |

## Before calling a skill done

- [ ] The baseline failure was recorded, word for word, before the skill text existed
- [ ] The form matches the failure type; prohibitions only for observed discipline failures or hard guardrails
- [ ] Frontmatter fits the invocation: "Use when..." triggers, or a one-line summary with `disable-model-invocation: true`
- [ ] The same scenarios pass with the skill, compared with a run without it
- [ ] Every reference is one level deep, behind a pointer that says when to read it
- [ ] The pruning pass ran, and the scenarios still pass after it

## Connects to

- **Receives:** a request to create or change a skill or agent instructions; ideas to merge into a skill from `devorb:evolving`; a judgment rule to turn into a pattern from `devorb:retro`.
- **Uses:** `devorb:tdd` for the cycle this skill adapts; fresh subagents for baseline and green runs.
- **Hands off to:** `devorb:verifying` before claiming the skill works; the caller, with the baseline failure, the passing runs and anything left untested.
