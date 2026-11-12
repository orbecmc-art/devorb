# Isolated workspace

Detect isolation first, then use the harness's own worktree tool, then fall
back to git. Never fight the harness.

## 1. Are you already isolated?

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
BRANCH=$(git branch --show-current)
git rev-parse --show-superproject-working-tree 2>/dev/null  # prints a path inside a submodule
```

- `GIT_DIR` differs from `GIT_COMMON`, and you are not in a submodule: you are
  in a linked worktree. Don't create another; go to step 3. On a branch, say
  "Already in an isolated workspace at `<path>` on `<branch>`." On a detached
  HEAD, say so too: a branch will be needed at finish time.
- Otherwise you are in a normal checkout, and a submodule counts as one.

## 2. Create one, with consent

Ask once, unless the user or the project already declared a preference:
"Set up an isolated worktree? It protects your current branch." Declined:
work in place and go to step 3, on a branch that isn't main or master unless
the user agreed to that too.

**Native tool first.** If you have one (a tool like `EnterWorktree`, a
`/worktree` command, a `--worktree` flag, or a dispatch option that gives a
subagent its own worktree), use it. It owns placement, branching and cleanup;
`git worktree add` beside it creates state the harness can't see or manage.

**Git fallback,** only without a native tool:

1. Directory: one the user or project declared; else an existing `.worktrees/`
   (preferred) or `worktrees/`; else `.worktrees/` at the project root.
2. A project-local directory must be ignored:
   `git check-ignore -q .worktrees || git check-ignore -q worktrees`. Not
   ignored: add it to `.gitignore` and commit that first, or the worktree's
   whole tree gets committed into the repository.
3. `git worktree add "$LOCATION/$BRANCH_NAME" -b "$BRANCH_NAME"`, then work
   from that path.

A sandbox that denies `git worktree add`: tell the user, and work in place.

## 3. Set up and check the baseline

Install dependencies the way the project does (`npm install`, `cargo build`,
`pip install -r requirements.txt`, `poetry install`, `go mod download`), then
run the project's test command. A dirty baseline makes every later failure
ambiguous.

- **Passing:** report "Worktree ready at `<path>`, `<N>` tests passing".
- **Failing:** report the failing tests by name and ask whether to proceed or
  investigate. This happens before the run starts, so it is not a mid-run
  stall.

## Cleaning up

A worktree you created and whose work is merged comes out with the native tool
or `git worktree remove <path>`, only when `git -C <path> status --porcelain`
prints nothing. Never `--force`: a dirty worktree holds work.
