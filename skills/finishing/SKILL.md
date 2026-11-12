---
name: finishing
description: Use when implementation is done and the branch needs integrating (merge, pull request, keep or discard), or when writing a pull request body
---

# Finishing

Prove the branch green, show the user everything they are about to decide, offer the options, and carry out only the one they pick. Integration is the user's decision: never push, merge, open a pull request or mark one ready unless they chose it in this session.

## 1. Green suite first

Run the project's full test suite on the tree you are about to integrate, fresh, as `devorb:verifying` requires. "It passed earlier" proves only the tree it ran on.

Red: report the failing tests by name and the count, and stop. No menu, no merge offered. The failures go through `devorb:debugging`; finishing starts again from this step once the suite is green.

## 2. Where you are

Capture these now, inside the working tree: cleanup needs them after you change directory.

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
WORKTREE_PATH=$(git rev-parse --show-toplevel)
```

| State | Menu | Cleanup |
|---|---|---|
| `GIT_DIR == GIT_COMMON`, normal repo | 3 options | None |
| Linked worktree on a named branch | 3 options | See Cleanup |
| Linked worktree, detached HEAD | 2 options, no merge | Host-managed: leave it |

## 3. Confirm the base branch

The base is the branch this work forked from: named in the plan, the conversation or the branch's upstream. Not known? Ask: "This branch split from `<best guess>`, correct?" Merging into the wrong base is expensive to undo.

## 4. Check what moved on the base

A merge without conflicts only shows that the edited lines don't overlap. Whether the branch is still right on the new base is a separate question.

```bash
git fetch origin <base>            # skip without a remote; use the local base
MB=$(git merge-base origin/<base> HEAD)
git log --oneline $MB..origin/<base>
```

If the base gained commits, list what the branch takes for granted: the signatures of what it calls, the behavior its tests pin down, the problem it solves. Then read each new base commit, message first, and its diff wherever it reaches one of those. The dependency can sit in a file the branch never edited. A base that already solved the same problem its own way counts too. Report each such commit with what it breaks, or say "the base moved N commits; none touch what the branch depends on."

**Rebase**, only when the user asks or the project requires it. If `git log --merges --oneline $MB..HEAD` prints anything, don't: a rebase flattens those merges, and the range-diff can't show what they resolved. Say so and offer a merge instead. Otherwise record `OLD=$(git rev-parse HEAD)` first, then after the rebase run `git range-diff $MB..$OLD origin/<base>..HEAD`. For each patch it marks as changed, write one line naming what made it differ. A change whose cause you can't name means the rebase may have lost work: stop and show the user. Run the suite again on the result.

## 5. Find the docs that aged

From `git diff $MB`, list each name that someone outside the code types or calls and that the branch added, changed, renamed or removed: a command, a flag, an environment variable, a route. Search the old and new names in the README, `docs/`, the changelog, `CLAUDE.md` and help text. Note each place that now describes the old behavior, with `file:line`. Point them out; the user decides whether they are fixed before integrating.

## 6. Show the user what they decide

Before the menu, one short summary:

- the suite command and its counts;
- the base, and what step 4 found;
- the aged docs from step 5;
- every **USER DECIDES** item `devorb:reviewing` reported (a loosened test, gate or acceptance line; `devorb:implementing` passes them as "User decides"), with the reviewer's evidence. Ask restore or keep for each, and record the reason given for a keep. A restore is a fix: make it with `devorb:tdd`, then start again at step 1;
- the "Rulings I made" and "Deferred minors" from `devorb:implementing`, unchanged.

## 7. The menu

Normal repo or named-branch worktree, exactly these:

```
1. Merge into <base> locally
2. Push and open a pull request
3. Keep the branch as it is
```

Detached HEAD: `1. Push as a new branch and open a pull request` and `2. Keep as it is`.

Discarding is not on the menu. It happens only when the user asks for it in so many words. Wait for their answer.

## 8. Carry out the choice

**Merge locally.**

```bash
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"
git checkout <base> && git pull && git merge <branch>
```

Run the suite on the merged result. Red: stop, leave the branch and worktree in place, investigate with `devorb:debugging`; nothing was pushed, so it is recoverable. Green: Cleanup, then `git branch -d <branch>`. Pushing the base is a separate request.

**Pull request.** `git push -u origin <branch>` (detached: `git push origin HEAD:refs/heads/<new-branch>`). Open it against `<base>` with the forge's CLI, as a draft where the forge has drafts, unless the user asked for a ready one: marking it ready is their call. The body follows the repo's template when one exists (`.github/pull_request_template.md`, `.github/PULL_REQUEST_TEMPLATE/`, `docs/`); otherwise `references/pr-body.md`. Report the URL. Keep the worktree: review feedback gets fixed there.

**Keep.** Report "Keeping `<branch>`, worktree at `<path>`."

**Discard, on explicit request only.** Show what goes: the branch, its commits (`git log --oneline $MB..HEAD`), the worktree path. Then ask the user to type `discard`. Nothing else counts, not "yeah, get rid of it". Once typed: `cd "$MAIN_ROOT"`, Cleanup, `git branch -D <branch>`.

## Cleanup

Only after a merge or a confirmed discard. Pull request and keep leave the worktree alone.

- Normal repo: nothing to do.
- `WORKTREE_PATH` under `.worktrees/` or `worktrees/` (the git fallback of `devorb:implementing`): `git worktree remove "$WORKTREE_PATH"`, then `git worktree prune`.
- Anything else belongs to the host: leave it, and use the host's exit tool if it has one.

Removal refused because of modified or untracked files: those files exist nowhere else. Never `--force`. Show `git -C "$WORKTREE_PATH" status --porcelain -uall` and ask: commit them to the branch, move them to the main checkout, or delete them (unrecoverable). Do what they choose, then remove.

## Rationalizations

| Excuse | Reality |
|---|---|
| "They obviously want it merged" | Integration is the user's decision. Show the menu and wait. |
| "No conflicts, so it's safe" | Conflicts measure overlapping lines, not meaning. Read what moved on the base. |
| "The base is obviously main" | Confirm it. A wrong base is expensive to undo. |
| "The push was rejected; force-push fixes it" | The remote moved. Investigate. Force-push only when the user asks for it. |
| "The PR is up, so the worktree is clutter" | Feedback gets fixed there. It stays until the work lands. |
| "That other worktree looks stale too" | Clean only `.worktrees/` or `worktrees/`. The rest is the host's. |

## Connects to

- **Receives:** from `devorb:implementing`, the branch and its three lists: "Rulings I made", "Deferred minors" and "User decides" (the USER DECIDES items of `devorb:reviewing`); or a finished branch from the user directly.
- **Uses:** `devorb:verifying` for the suite; `devorb:debugging` when it is red; `devorb:tdd` for a restore; `references/pr-body.md`.
- **Hands off to:** nobody. This is the end of the flow.
