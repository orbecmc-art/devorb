# Parallel tasks

Everything in SKILL.md holds: a fresh implementer and a review per task, the
fix loop, the ledger, the final review. This file changes only how many
implementers run at once and where their commits land.

## When

Only for tasks the plan itself marks as independent of each other, in words:
"Tasks 3, 4 and 5 are independent", or a task that says it may run alongside
another. Interfaces blocks that happen not to overlap are not a mark. Tasks the
plan doesn't mark run sequentially, in plan order, even if they look
independent to you; if you think a plan would gain from it, say so in one line
and run it sequentially.

Independent means the tasks share no file and consume nothing from each
other. Before relying on the mark, check it in the pre-flight table: two
"independent" tasks that touch the same file get a ruling to run them in
sequence.

Parallel tasks need a worktree each, which needs the user's consent. Ask at
setup, in the same question as the worktree for the run, naming the tasks that
would run together. Declined: run them in sequence.

## The integration branch

The branch your setup put you on is the integration branch. Every task merges
into it, the final review reads it, and `devorb:finishing` receives it. Never
the main branch, without consent.

Keep one workspace and one ledger, in your own working tree. Run every script
with `-C <your working tree>` (`sdd-workspace`, `task-brief` and
`review-package` accept it), so briefs, reports, review packages and the ledger
stay together, whichever worktree a task commits in. Branches and commits are
shared by every worktree of the repository, so SHAs from a task's worktree work
in your scripts.

## The frontier

The frontier is every task whose dependencies (the tasks it consumes from) are
complete and merged. Dispatch one implementer per frontier task in the same
message, so they run concurrently, each with `prompts/implementer.md` and
these additions:

- Its own worktree on its own branch, cut from the integration tip T. Record
  `Task <N>: dispatched (base <T7>, branch <name>, worktree <path>)`.
- "First confirm your worktree's HEAD is <T>. If it isn't, run
  `git reset --hard <T>` only when `git status --porcelain` and
  `git log <T>..HEAD` both print nothing; otherwise report NEEDS_CONTEXT.
  Don't merge or rebase anything else."
- Work from the task's worktree; the brief and report paths are absolute, in
  your workspace.

When implementers finish, review each task exactly as in SKILL.md, with BASE =
T and HEAD = the task branch's head. Its fix loop runs in its own worktree.
After each merge, refresh the frontier and dispatch what it unblocked.

## Merging a reviewed task

In your working tree, on the integration branch:
`git merge --no-ff <task branch>`. Merges into this branch are part of the
run; merging the integration branch anywhere else is `devorb:finishing`'s.

- **Clean merge:** run the project's test command, output to a file in the
  workspace, and read its tail. Green: append
  `Task <N>: complete (commits <T7>..<head7>, merged <merge7>, review clean)`.
  Red: the tasks weren't independent. Dispatch one fix implementer on the
  integration branch with the failing output (it uses `devorb:debugging`),
  then a scoped re-review of its fix, as one fix-loop round.
- **A user-interface task with `Mirror: not run`:** merge it the same way and
  append `Task <N>: not ready: no screenshot (<why>)` in place of the
  `complete` line, as section 5 of `SKILL.md` says.
- **Conflict:** `git merge --abort`. Resume that task's implementer: merge the
  integration tip into its branch, resolve, re-run its tests, append a fix
  report. Re-review with `review-package` over `<integration tip>..<task head>`,
  the task's net change against what it now lands on, naming the conflicted
  files as the findings. Then merge. Write a ruling naming the tasks that
  were not independent and the files they shared.

A merged task's worktree comes out as in `references/worktree.md`, cleanly and
never forced. Keep its branch until `devorb:finishing`.

## Finish

When every task is merged, the final review runs on the integration branch as
in `references/final-review.md`, with MERGE_BASE = the commit the integration
branch started from. No pull request is opened or marked ready here.
