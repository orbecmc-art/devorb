---
name: planning
description: Use when you have an approved design doc, spec or requirements for a multi-step change, before touching code
---

# Planning

Write the plan for an engineer who has seen neither this codebase nor the spec. Assume they write idiomatic code in the project's language once they know the exact interface and the exact test, and that they choose well wherever the plan leaves a choice open. What they can't know is what you decided: which files, which names and signatures, which values from the spec, which tests prove each task. Write those down, as small tasks. DRY. YAGNI. TDD. Frequent commits.

**The spec** is the design doc `devorb:aligning` wrote in `docs/devorb/specs/`. Don't write a second one. Requirements handed to you directly (a message, a ticket) serve as the spec when nothing that changes the build is open; when something is, stop and invoke `devorb:aligning` for those points. The same holds for an approved spec with open items.

**Save to** `docs/devorb/plans/YYYY-MM-DD-<topic>.md`, unless the user or the project says otherwise.

## Before any task

- **Scope.** A spec covering several independent subsystems gets one plan per subsystem, each producing working, testable software on its own.
- **The project's words.** Read `GLOSSARY.md` and the ADRs in `docs/adr/` for the area when they exist. Name things the way the glossary does, and don't plan against a recorded decision.
- **Is it already on the base branch?** Fetch the base branch and read its `git log`, from the spec's date (or the request's) on, for the files the plan will touch, and search the commit messages for its main symbols. If part of the work already landed, tell the user before writing tasks, and plan only what's left.
- **Does everything you cite exist?** Each command, flag, script, route or endpoint the plan tells someone to run or call: confirm it in its `--help`, the package scripts, the route table or the registry it comes from. If it isn't there, the plan is wrong until shown otherwise: fix it or tell the user. Never cite it unchecked.

## Files and seams

Map which files get created or changed, and what each one is responsible for, before defining tasks. Decomposition gets locked in here.

- One clear responsibility per file, with clear boundaries and well-defined interfaces. Prefer small focused files. Files that change together live together: split by responsibility, not by technical layer.
- In existing code, follow its patterns. Don't restructure on your own; splitting a file you modify that has grown unwieldy is fair, as a task in the plan.
- **Name the seams.** For each task, name the seam its tests go through: the public interface a caller uses. Prefer existing seams to new ones and the highest seam that reaches the behavior. The fewer seams across the codebase, the better; one is ideal. `devorb:tdd` tests at the seam the plan names without stopping to ask, so the user approves seams when approving the plan. When the shape of an interface is itself in question, use `devorb:codebase-design`.

## Tasks

- **Vertical slices, in order.** Each task cuts a narrow but complete path through every layer it needs (schema, API, UI, tests) and ends in something testable or demoable on its own, small enough for one fresh context. Never one layer per task. Prefactoring that makes the change easy comes first. A task depends only on tasks above it; they run top to bottom.
- **Right size.** A task is the smallest unit with its own test cycle that a fresh reviewer could reject while approving its neighbor. Fold setup, configuration, scaffolding and docs into the task whose deliverable needs them.
- **Wide refactors** (one mechanical change, such as renaming a column or retyping a shared symbol, that breaks callers everywhere at once) can't be sliced vertically. Sequence them expand-contract. Expand: add the new form beside the old, so nothing breaks. Migrate: move callers in batches sized by blast radius (per package, per directory), one task each, green after each because the old form still exists. Contract: remove the old form once no caller remains. If even one batch can't stay green alone, end with an integrate-and-verify task and promise green only there.
- **Steps.** Each is one action with a checkable result: write the failing test, run it and see it fail, write the minimal code, run it and see it pass, commit.

## What a step contains

A step is done when the implementer can write exactly one reasonable thing from it: unambiguous, not complete.

- **Test step:** the test's name and its assertions, as code, with the spec's exact values. Point to a similar test in the codebase when there is one.
- **Code step:** the exact signature (name, parameters, return type), its file, and the values the spec pins. The implementer writes the body. Show one only for an algorithm the signature and tests don't determine, or for exact copy the spec fixes.
- **UI step:** when the work touches the interface, the step names the `DESIGN.md` tokens it uses, by name, never their raw values, and the spec's `## Direção visual` contract. When the contract lists a `Reference pack`, the step names its path. Done is the implementer's `Mirror:` line with no check FAIL, and the `devorb:ui-review` Critique with no score below 8 or its findings handed to the user.
- **Verification step:** the command, and the output that means it passed.
- **Another task's work:** its Interfaces block says what to use. Don't repeat its code.

A plan longer than the code it describes has written the code instead. Lines that decide nothing ("TBD", "handle edge cases", "add appropriate validation", "write tests for the above", a type no task defines) are the opposite failure.

## Changes that are hard to take back

A plan that migrates data, changes a public interface (anything outside this code calls or reads), touches authentication or ships a production release carries a `## Rollout` section with four items: the order in which the pieces go out, how long old and new must keep working side by side, how to get back to a good state (code and data), and what stays changed even after that. Each comes from the spec, the code or the user, never from a guess. An item you can't fill means the plan isn't finished: ask the user, and don't hand it off with the gap.

## The plan document

Read `references/task-template.md` before writing. It has the header (goal, architecture, tech stack, spec path, global constraints, review focus, rollout) and the task layout. Three parts are contracts:

- **`### Task N: <name>`** heads every task, exactly like that, N counting from 1 with no gaps. `devorb:implementing` finds tasks by this header.
- **Interfaces** in every task: what it consumes from earlier tasks and what it produces for later ones, with exact names and types. An implementer sees only their own task; this block is how they learn the names their neighbors use.
- **Global Constraints:** the spec's project-wide requirements, values copied verbatim. Every task inherits them.

## Self-review

With the plan written, reread the spec with fresh eyes and check the plan against it. Run this yourself, not as a subagent. Fix what you find inline and move on.

1. **Coverage:** every spec requirement points to a task. One with no task gets a task.
2. **Step scan:** every step lets the implementer write exactly one reasonable thing. A line that decides nothing is a gap; a body the signature and tests already determine is a transcript. Fix both.
3. **Consistency:** names, signatures and types in later tasks match the earlier ones. `clearLayers()` in Task 3 and `clearFullLayers()` in Task 7 is a bug.
4. **Review Focus:** for each input or failure the spec implies, some task's tests exercise it. The five uncovered ones most likely to bite a user go in Review Focus, each with its test added to the task that owns the code. An empty section means you checked and found none.
5. **Proportion:** a plan several times longer than its spec is a transcript. Replace bodies with signatures, test names and assertions, and keep each step unambiguous.
6. **Reality:** the base-branch and command checks ran, and a hard-to-reverse change has all four Rollout items.

## Hand off

Give the user the plan's path and ask them to review it: does it capture what they want, are the slices the right size, are the seams the right ones? Wait for the answer and fold in their changes. If they already said how to run it (in this session, or with subagents), keep that and pass it on. Then invoke `devorb:implementing`.

## Connects to

- **Receives:** the approved `docs/devorb/specs/YYYY-MM-DD-<topic>-design.md` from `devorb:aligning` (through `devorb:visual-direction` and `devorb:design-system` when the task has an interface), or requirements with nothing open.
- **Uses:** `GLOSSARY.md` and `docs/adr/`, kept by `devorb:domain-modeling`; `devorb:codebase-design` when an interface's shape is in question; the tokens of `DESIGN.md`, by name, when the work touches UI; `references/task-template.md`.
- **Hands off to:** `devorb:implementing`, with the reviewed `docs/devorb/plans/YYYY-MM-DD-<topic>.md`.
