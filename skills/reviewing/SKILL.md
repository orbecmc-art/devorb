---
name: reviewing
description: Use when finished work needs review before merging or the next task, or when review feedback arrives, before acting on any of it
---

# Reviewing

Two jobs: **asking** for a review, where fresh reviewers judge the diff, and **receiving** one, where every point is checked before anything changes. A reviewer gets precise context and never your session history, so it judges the work, not your reasoning about it.

## Asking for a review

### 1. Pin the range

The fixed point is the merge-base with the base branch. Don't ask for it. The base branch is the one the user or plan named, else the branch `origin/HEAD` points to, else `main` or `master`. A point the user gives ("since `a1b2c3`", a tag) wins.

```bash
BASE=$(git merge-base <base-branch> HEAD)
git log --oneline $BASE..HEAD   # commits under review
git diff --stat $BASE           # commits plus uncommitted edits to tracked files
git status --short              # new files the diff leaves out
```

Stop here if `BASE` doesn't resolve, or if the diff and `git status` are both empty. A bad range should fail now, not inside two reviewers.

### 2. Gather the context

- **Spec:** the plan task and spec in `docs/devorb/plans/` and `docs/devorb/specs/`, an issue the commits cite, or a path the user gave, plus the plan's Review Focus section, verbatim, when given. None found? Ask once where it is. If there is none, the Spec axis is skipped and the report says so.
- **Standards:** every file in the repo that says how code is written: `CLAUDE.md`, `CONTRIBUTING.md`, a coding-standards file, linter config, `docs/adr/`, `GLOSSARY.md`. The reviewer also carries the smell list in `references/code-reviewer.md`. **The repo's documented standards beat that list:** a smell the repo endorses is not a finding, and anything a tool already enforces is skipped.
- **Evidence:** what `devorb:verifying` ran, with counts, so reviewers read results instead of guessing.

### 3. Check for risk triggers

Read the changed paths and the removed lines. A risk review runs too when the diff:

- touches login, sessions, permissions, tokens, cryptography or secrets;
- adds or changes a call that leaves the process: network, shell, payment, a model or other paid API;
- removes or loosens a validation, check, limit or redaction, or adds a check whose error path lets the request through;
- adds an operation that may run twice: send, charge, publish, migrate;
- changes dependencies or a lockfile;
- adds or changes a query over stored rows, a loop that queries, or a list screen: its data-volume defects (item 9 of `references/risk-review.md`) are Important at least, even when the spec is silent on volume;
- changes tests, CI or config in a way that could hide a failure.

No trigger, no risk review. Name the trigger in the report when one fires.

### 4. Dispatch fresh reviewers in parallel

Send all calls in one message, each to a new general-purpose subagent, with the prompts in `references/code-reviewer.md` (Standards and Spec) and `references/risk-review.md` (Risk, only when triggered). Fill in what was built in two lines, the range commands, the spec path or text (with the Review Focus), the standards files and the evidence. A diff package path, when the caller built one, replaces the range commands. Nothing else from this session.

Reviewers are read-only and dispatch no one. Without subagents, run each axis yourself as a separate pass that starts from the diff alone, and say so.

**Standards** asks whether the code is correct and fits this repo: bugs first, then documented standards, then smells. **Spec** asks whether the code does what was asked: a verdict per requirement (implemented, partial, contradicted, beyond spec, absent, undecidable; absent lists what was searched), then what is missing and what was added that nobody asked for. **Risk** follows the triggered change to its callers, history and worst case.

### 5. Report

Keep one heading per axis, `## Standards`, `## Spec`, and `## Risk` when it ran. Don't merge findings across axes or rank one axis against another: a change can follow every rule and build the wrong thing, or build the right thing badly, and merging hides one behind the other. Inside each axis:

- **Critical:** wrong behavior, security hole, data loss, broken build or test.
- **Important:** a requirement missing or wrong on some path, poor error handling, a test gap, a loosened gate.
- **Minor:** style, naming, small cleanup.

Each finding gives `file:line`, what is wrong, why it matters and the fix if it isn't obvious. A lead nobody could settle goes under **Needs checking**, with no severity: the fact that is missing and the check that would settle it. End with one line per axis (count and worst finding) and a verdict: ready, ready with fixes, or not ready.

Then hand Critical and Important findings to the fix loop of `devorb:implementing`, which fixes them and runs its own scoped re-review. Minor findings are listed, not looped. A loosened test, gate or acceptance line is the user's call (restore or keep, with their reason), never the loop's: report USER DECIDES items apart from the fix list; `devorb:implementing` passes them to `devorb:finishing` for the user. If the diff touches a user interface, also send it to `devorb:ui-review` when installed, and leave how it looks to that skill: no reviewer here judges aesthetics. A full security audit is `devorb:security-audit`, run only when the user asks: suggest it, don't start it.

## Receiving a review

Applies to every source: these reviewers, the user, a pull request comment, a tool. Findings from this skill's own reviewers, called from `devorb:implementing`, go to its fix loop; its fixer applies steps 2-4. Otherwise apply them yourself. Details and examples: `references/receiving.md`.

1. **Read all of it first.** If any item is unclear, ask about it before changing anything: items are often linked.
2. **Restate each claim in your own words:** what is wrong, where, what triggers it, what it causes. A claim you can't restate is one you can't accept yet. Writing it out exposes most bad claims.
3. **Check it against the code.** Read the lines, the callers and the checks upstream; run a test when that is cheap. Two traps: crediting a guard you haven't read, and dismissing a real bug because the trigger looks unlikely.
4. **Decide.**
   - Correct: fix it.
   - Wrong for this codebase: push back with the code or test that shows why.
   - Can't verify: say what you'd need and ask.
   - Clashes with an earlier decision of the user: stop and ask them.
   - Asks to build out something nothing calls: grep for callers and propose removing it instead.
5. **Fix in order:** what breaks, leaks or loses data first, then simple fixes, then complex ones. One at a time, each tested.
6. **Reply with substance.** No performative agreement: no "you're absolutely right", "great point" or thanks. State the fix ("Fixed: null check in `cart.ts:42`") or the reasoning. If your pushback was wrong, say so in one line and fix it.

## Connects to

- **Receives:** finished work from `devorb:implementing`, with its plan or spec path, the Review Focus and a diff package, and the evidence from `devorb:verifying`; review feedback from anyone.
- **Uses:** fresh subagents with `references/code-reviewer.md` and `references/risk-review.md`; `references/receiving.md`; `devorb:tdd` and `devorb:verifying` for fixes; `devorb:ui-review` when the diff touches a user interface, which judges how it looks so this skill doesn't.
- **Hands off to:** the fix loop of `devorb:implementing`, with findings by axis and severity and the USER DECIDES items apart; `devorb:finishing` (when invoked on its own) once no Critical or Important finding remains; a suggestion of `devorb:security-audit` when the user wants a full audit.
