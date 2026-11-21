# Inline execution

Execute the plan yourself, task by task, in this session: no implementer and no
reviewer per task, one fresh-context review of the whole branch at the end.
Use it when the user chose it, or when you have no subagent tool.

**Why it still holds up.** Subagent execution pays for a fresh implementer and
reviewer on every task. Inline pays for one context plus one final reviewer,
and keeps what the per-task seats bought by other means: the brief is the spec,
the ledger is your memory, `devorb:tdd` is the per-task gate, and the final
reviewer is the second pair of eyes.

A fully specified plan makes inline execution transcription plus testing: it
runs well on a mid-tier session model, and the most capable model earns its
cost only in the final review. Tell the user so when they choose inline.
Suggest subagents instead when they want a review on every task, or when the
plan is long enough that its last tasks would run on a compacted context.

Everything in SKILL.md before "The task loop" still holds: keep going, rulings
not stalls, the four stops, setup, the workspace and ledger (the same
directory and format, so a plan can change executors mid-flight), the
pre-flight scan. Two changes to setup:

- **Load `devorb:tdd` now, before Task 1.** It governs every step of every
  task, even in a plan whose steps already say "write the failing test first".
- **Your diff answers to the brief.** The rule in
  `prompts/implementer.md` ("Your diff answers to the brief") binds you
  as it binds a subagent: read it once now. Its `[CODE_FLOOR]` is
  `devorb:reviewing`'s `references/code-floor.md`: read it before the first
  code file, and write the reason for a signal you keep where it says.

## The task loop

Everything you print stays in your context. Send long test output to a file in
the workspace and read its tail; read a brief, not the whole plan. Every tool
call is a turn that re-reads your context, so bookkeeping rides with work: a
ledger line in the same call as the commit, never in a call of its own.

### 1. Take the task

Run this skill's `bash scripts/task-start PLAN_FILE N` by its absolute path, from
your working tree. It prints the brief path and BASE in one call. Read the
brief for every task, including ones you remember: what you remember is a
summary; the brief has the exact values, signatures and tests. Mark the todo
in progress.

### 2. Work the steps

Follow the plan's steps in their RED-GREEN order under `devorb:tdd`. A test
step's code is written first and run first; watching it fail is a step, and a
test that passes before the code exists is a finding about the test.

Each step that runs a command has an `Expected:` line. Run it, read the output,
compare:

- **Matches:** next step.
- **The code is wrong:** use `devorb:debugging`. Find the cause; never patch
  the symptom until the output matches.
- **The plan is wrong** (a step that contradicts itself, an interface from an
  earlier task that doesn't match, a command that can't work): rule on the
  smallest change that satisfies the spec,
  `Task <N>: Ruling: <finding> — <what you decided and why> — <cost if wrong>`,
  and continue.
  Later tasks read the ruling from the ledger. A step that contradicts the
  spec on what gets built is the fourth stop.

A task that builds or changes a user interface runs the Mirror section of
`prompts/implementer.md` before its commit, and its ledger line carries the
`Mirror:` line. Before the first UI file, read the sources the contract's
`Sources:` line names, then the foundation and specialists for the
components, in `devorb:visual-direction`'s `references/ui-sources.json`;
record `Sources:` beside `Mirror:` in the ledger.

Commit as the plan's commit steps say. Several commits per task are fine; the
range starts at BASE, never `HEAD~1`.

### 3. The completion contract

Before a task's ledger line, all of this is true, with evidence from this
session, not inferred from the diff looking right:

- Every test the brief names exists, ran in this task, and you read the output.
- The final test run for the task passed: `task-done` is that run.
- Every `Expected:` line was compared with real output.
- Every deviation from the brief has a `Ruling:` line.

`devorb:verifying` governs the claim. Anything missing: the task isn't done.

### 4. Complete the task

Run this skill's `bash scripts/task-done PLAN_FILE N BASE -- <test command>` by its
absolute path, from your working tree, with the test command the brief names
for the whole task. It runs the tests, keeps the full output in the workspace,
prints the tail and, only if they pass, appends
`Task <N>: complete (commits <base7>..<head7>, tests: <command> → <result>)`.
A failing run records nothing. When it records, mark the todo complete and take
the next task.

A user-interface task whose ledger line says `Mirror: not run` is not done: run
no `task-done` for it and write `Task <N>: not ready: no screenshot (<why>)`
instead, as section 5 of `SKILL.md` says.

## Final review

First run the full suite fresh through `devorb:verifying` and keep the command
and the counts. Then run `bash scripts/review-package PLAN_FILE MERGE_BASE HEAD`
by its absolute path (MERGE_BASE: the commit the branch started from, e.g.
`git merge-base main HEAD`).

- **With a subagent tool:** invoke `devorb:reviewing` for the branch on the
  most capable model, with what `references/final-review.md` lists: package,
  plan and spec paths, Review Focus verbatim, the ledger's `Ruling:`,
  `parked` and `minor (deferred)` lines, and the suite command and counts.
  This is the one fresh context the run buys; never skip it or replace it with
  your own read.
- **Without one:** do the `devorb:reviewing` review yourself against the
  package, as a separate pass after the last task's ledger line. Write
  `Final review: self-review (no subagent tool)` to the ledger and say so in
  your final message: an author's self-review is weaker, and the user decides
  whether it is enough before merge.

Set the USER DECIDES items apart first, as `Final: user decides: <item,
verbatim>`: a loosened test, gate or acceptance line is the user's call, never
fixed or ruled on here. Sort the rest before acting; the labels are advice and
the gate is yours.
Re-grade by effect first: what a reasonable person using this software gets if
it ships. A reviewer who marked something Minor because the spec was silent
graded the spec. Every item the reviewer declined to judge is a ruling you make
and write down.

- **Critical and Important:** fix them yourself, in ONE pass. Each fix gets a
  test that reproduces the finding, seen failing, then passing, then the whole
  suite: `Final: fixed <finding> — <test name> RED→GREEN, suite <N>/<N>`. No
  re-review: the covering tests answer "addressed" and the suite answers
  "broke nothing".
- **A finding you decide not to fix:** `Final: Ruling: <finding> — <why the
  code stands> — <cost if wrong>`.
- **Minor:** `Final: minor (deferred): <one-liner>`, never fixed in this pass:
  each one is a test, a fix and a suite run nobody asked for.

There is no second pass. Then finish as in `references/final-review.md`: fresh
evidence through `devorb:verifying`, the "Rulings I made", "Deferred minors"
and "User decides" lists, the workspace deleted, `devorb:finishing`.

## Rationalizations

| Excuse | Reality |
|---|---|
| "I remember what Task N says" | You remember a summary. Read the brief. |
| "The plan's code is right, skip watching the test fail" | A test you never saw fail proves nothing. |
| "I'll run the full suite at the end instead of per step" | Per-step runs show which step broke it. |
| "The plan is wrong here, I'll just do the right thing" | Do it and write the ruling. Unwritten deviation is a decision made in secret. |
| "I'll write the ledger lines after a few tasks" | Compaction doesn't wait. One line per task, with the commit. |
| "I read my own diff; the final reviewer is redundant" | Same author, same blind spots. |
| "I'll fix the minors too while I'm in there" | Write them down. The user decides. |
