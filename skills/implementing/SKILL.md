---
name: implementing
description: Use when you have a written implementation plan to execute task by task, with subagents or inline in this session
---

# Implementing

Execute the plan by dispatching a fresh implementer subagent per task, a task review (spec compliance and code quality) after each, and one review of the whole branch at the end. By default, tasks run one at a time, in plan order.

**Why subagents:** each one gets exactly the context you build for it, never your session's history, so it stays on its task and your own context stays free for coordination.

**Which way to run it:**

- **Default, this file:** sequential, one fresh implementer and one review per task.
- **Inline, in this session:** the user chose it, or you have no subagent tool. Read `references/inline.md` and follow it instead of the task loop below. Never fabricate a dispatch.
- **Parallel:** only for tasks the plan itself marks as independent of each other. Read `references/parallel.md`. Your own reading that two tasks look independent is not enough.

**Narration:** at most one short line between tool calls. The ledger and the tool results carry the record.

**Keep going.** Don't pause between tasks to check in, and don't post progress summaries. The user asked for the plan to be executed; "should I continue?" spends their time.

**Rulings, not stalls.** Conflicts, ambiguities, plan defects, a cap you would have asked to exceed: decide them. Where the plan is silent, ambiguous or inconsistent with itself, the spec is the binding authority, the plan is its argument, and your judgment settles what neither answers. Record every decision in the ledger as `Ruling: <what you decided> — <why> — <what it costs if wrong>`, and keep going. A wrong ruling costs rework the user can see and undo; a run parked on a question costs their whole day.

**Four things stop you, and only these.** For each, stop and ask:

1. An irreversible or destructive operation.
2. A security-sensitive action.
3. A side effect outside this worktree that norms say you ask about first: a merge into a shared branch, a push, a publish.
4. A plan so broken that every path forward is a guess. A plan that contradicts its spec on what gets built is one: a task that builds what the spec rules out, a different value, a spec requirement no task covers. The user approved both, so which one they meant is their decision, not your ruling.

## Setup

**Where you work.** Never start on the main or master branch without the user's explicit consent. If you are not already in a linked worktree, ask once before creating one ("Set up an isolated worktree? It protects your current branch."), unless the user or the project already said what they prefer. If the plan marks tasks as independent, ask in the same question whether they may run in parallel, a worktree each (`references/parallel.md`). Read `references/worktree.md` for detection, creation and the baseline test run. Declined: work in place, on a branch that isn't main without consent, and run `git status --porcelain` first: if it prints anything, the tree holds the user's uncommitted work, so ask before starting.

**Workspace and ledger.** Conversation memory does not survive compaction. Controllers that lost their place have re-dispatched entire completed task sequences, the most expensive failure seen. Track progress in a ledger file, not only in todos.

- Each plan owns a workspace. Run this skill's `bash scripts/sdd-workspace PLAN_FILE` by its absolute path, from the working tree you execute in. It prints the plan's git-ignored directory, `<repo-root>/.devorb/sdd/<plan-basename>/`: ledger, briefs, reports, review packages. Another plan's directory is never yours to read or write.
- If `<workspace>/progress.md` exists and its first line names your plan file, tasks with a `Task <N>: complete` line are done: don't re-dispatch them, resume at the first task without one. A task whose last line is a fix round is mid-loop: resume at the next round. A ledger naming another plan, or a stray one at `.devorb/sdd/progress.md`, is someone else's: leave it and start yours.
- A new ledger starts with `# SDD ledger — plan: <plan file path>`.
- After compaction, trust the ledger and `git log` over your own memory: the commits it names exist even when you don't remember making them. `git clean -fdx` destroys the workspace; recover from `git log`.

**Read the plan once.** Note its Global Constraints and Review Focus, and make a todo per task. Read the spec the plan names: it is the authority. No reachable spec: write a ledger note that rulings made without one are provisional.

**Pre-flight.** Before dispatching Task 1, read `references/preflight.md` and run its scan. Its table and rulings go in the ledger.

## Model Selection

Use the least powerful model that can do each role well. **Always name the model when dispatching**: an omitted model inherits your session's, often the most expensive, and silently defeats this section.

| Role | Model |
|---|---|
| Implementer whose task text holds the complete code (transcription plus tests), or a single-file mechanical fix | Cheapest |
| Implementer working from prose, 1-2 files, clear spec | Mid tier |
| Multi-file integration, pattern matching, debugging | Standard |
| Design judgment or broad codebase understanding | Most capable |
| Task reviewer | Scaled to the diff's size, complexity and risk; mid tier at least |
| Scoped re-review of a small fix | Cheap to mid |
| Fix rounds 4-5 | One tier above the implementer that got stuck |
| Final whole-branch review | Most capable |

**Turn count beats token price.** Cost scales with how many turns a subagent takes, and the cheapest models often take 2-3 times the turns on multi-step work. That is why prose tasks and reviewers start at mid tier.

## The task loop

Everything you paste into a dispatch, and everything a subagent prints back, stays in your context and is re-read every turn. Hand artifacts over as files.

**Small same-shape work.** When the plan lists several small edits of the same kind (the same one-line fix, constant or field across files), send one dispatch listing every file and its change, and review the diff as one unit. Keep one dispatch per task for work that needs its own judgment, tests or review.

**Waiting.** Never poll with short timeouts, and never sit in one silent open-ended wait. While you have local work (ledger, packaging a review, reading a report), do it. When idle, wait in stretches of five to ten minutes; between them, post one status line and check your live subagents for any that finished without reporting.

### 1. Dispatch the implementer

- Record BASE (`git rev-parse HEAD`) first.
- Run this skill's `bash scripts/task-brief PLAN_FILE N` by its absolute path, from your working tree. It writes the task's full text, including its Files, Seam and Interfaces, to a file and prints the path. The report file sits beside it: `task-N-brief.md` gives `task-N-report.md`.
- Use `prompts/implementer.md`. The dispatch holds: one line on where the task fits; the brief path, as "read this first: it is your requirements, with the exact values to use verbatim"; interfaces and rulings from earlier tasks the brief can't know; your resolution of any ambiguity you noticed; the report path and contract. Exact values appear only in the brief. Never make a subagent read the whole plan.
- A dispatch describes one task, not the session's history. Never paste summaries of earlier tasks: one real dispatch reached 42k characters, 99% of them pasted history. If an earlier task parked a finding in this area, point to that ledger line.
- The template carries two contracts: the implementer never dispatches subagents (a reviewer it spawns duplicates yours at full cost), and every line it changes must answer to the brief.
- Record the implementer's agent identity: fix rounds 1-3 resume it.
- One implementer at a time, outside `references/parallel.md`. Parallel implementers on shared code conflict.

### 2. Handle the report

- **DONE:** review it.
- **DONE_WITH_CONCERNS:** read the concerns. About correctness or scope: settle them before review. Observations ("this file is getting large"): note them and review.
- **NEEDS_CONTEXT:** give the missing context and re-dispatch.
- **BLOCKED:** a context problem gets more context and the same model; a reasoning problem gets a more capable model; a task too large gets split; a wrong plan gets a ruling in the ledger, carried in the re-dispatch. Never retry the same model with nothing changed.

Questions from the implementer, before or during the work, get complete answers.

### 3. Review the task

- Run this skill's `bash scripts/review-package PLAN_FILE BASE HEAD` by its absolute path, from your working tree. It writes the commit list, stat and full diff with context to one file and prints the path; the package never enters your context. BASE is what you recorded, never `HEAD~1`, which drops all but the last commit. Without bash: write `git log --oneline`, `git diff --stat` and `git diff -U10` for the range to one uniquely named file. Never dispatch a reviewer without a diff file.
- Dispatch `prompts/task-reviewer.md` with the brief, the report, the package, and the Global Constraints that bind the task, copied verbatim: exact values, formats, stated relationships ("same layout as X"). The template already carries the process rules.
- Don't pre-judge findings. If your prompt says "do not flag", "at most Minor" or "the plan chose", you are sparing yourself a loop: delete it, and adjudicate in the loop. Don't ask for tests the implementer already ran, or add open-ended directives ("check all uses") without a task-specific reason.
- Never skip the review, and never accept one missing either verdict. The implementer's self-review never replaces it.
- **"Cannot verify from diff" items:** resolve each one yourself before completing the task; you hold the plan and the cross-task context. A real gap counts as a failed spec review.

### 4. The fix loop

It runs on spec ❌, any Critical or Important finding, or a cannot-verify item you confirmed as a gap. Read `references/fix-loop.md` before every round, even if you read it earlier: it holds the cap, the breaker and the ledger lines, and your memory of it does not survive compaction. Never fix findings yourself in the controller: it fills your context and skips review.

### 5. Complete the task

When the review is clean, or every open finding is parked with a ruling at the cap, append in the same message as your other bookkeeping:

- `Task <N>: complete (commits <base7>..<head7>, review clean)`
- `Task <N>: complete (commits <base7>..<head7>, <K> parked)` after a tripped breaker

Mark the todo complete and take the next task. Never move on with an open Critical or Important finding that is neither fixed nor parked at the cap.

## Final review and finish

When every task is complete, read `references/final-review.md` and follow it: one whole-branch review through `devorb:reviewing`, one fix wave, fresh evidence through `devorb:verifying`, then the hand-off.

Your final message has three lists, each exhaustive. **"Rulings I made":** every ledger line containing `Ruling:`, in the order you made them, each with what it costs if wrong. **"Deferred minors":** every deferred minor. **"User decides":** every USER DECIDES item from `devorb:reviewing` (a loosened test, gate or acceptance line), verbatim, never fixed and never ruled on. They are the only place the decisions you took, and the ones left for the user, reach them.

Delivery ends at `devorb:finishing`, which presents the options. Never merge outside the integration branch, push, open a pull request or mark one ready on your own.

## Rationalizations

| Excuse | Reality |
|---|---|
| "Close enough on spec compliance" | Spec gaps mean not done. Fix, or reach the cap and adjudicate. |
| "I'll fix it myself, dispatching is overhead" | Controller fixes fill your context and skip review. Resume the implementer. |
| "One more round will converge" | Past the cap the failure is structural. Adjudicate and route. |
| "This finding is obviously wrong" | You adjudicate only at the cap, and every ruling is a ledger line. Silent discards are forbidden. |
| "The fix was small, skip the re-review" | Unreviewed fixes are how regressions land. |
| "While it's in there, tidy the neighbors" | The diff answers to the brief. Neighbors' problems go in the report. |
| "Ledger bookkeeping is overhead" | The ledger is what survives compaction. |
| "The implementer spawned its own reviewer: extra assurance" | A duplicate seat on the same diff. Flag it as a defect. |
| "The plan says X, the spec says Y; I'll go with the spec" | On what gets built, that is the user's call. Stop and ask. |

## Connects to

- **Receives:** the reviewed `docs/devorb/plans/YYYY-MM-DD-<topic>.md` from `devorb:planning`, and the spec it names.
- **Uses:** `devorb:tdd` in every task, at the seam the plan names; `devorb:debugging` when something fails or surprises; `devorb:verifying` before any completion claim; `devorb:reviewing` for the whole-branch review; `scripts/`, `prompts/` and `references/` in this folder.
- **Hands off to:** `devorb:finishing`, with the branch and the three lists: "Rulings I made", "Deferred minors" and "User decides".
