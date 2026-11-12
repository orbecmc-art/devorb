# Final review and finish

Every task in the plan is complete.

## The whole-branch review

Run `bash scripts/review-package PLAN_FILE MERGE_BASE HEAD` by its absolute
path, from your working tree. MERGE_BASE is the commit the branch started from,
for example `git merge-base main HEAD`. Then invoke `devorb:reviewing` for the
branch, on the most capable available model, and hand it:

- the printed package path, so its reviewers read one file instead of
  re-deriving the diff;
- the plan and spec paths, and the plan's Review Focus section verbatim, if
  it has one: the inputs and failures no task's tests exercise, which the
  review checks one by one;
- a pointer to the ledger's `Ruling:`, `parked` and `minor (deferred)` lines,
  so it can weigh your calls and decide which deferred items must be fixed
  before merge.

This is the review the whole run is built around. Don't skip it, and don't
replace it with your own read of the diff.

## One fix wave

Sort the findings before acting. Severity labels are advice; the gate is
yours. Grade each finding by what a reasonable person using this software gets
if it ships, not by whether the spec names the input that triggers it.

- **Critical and Important:** dispatch ONE fix implementer with the complete
  list, not one fixer per finding. Per-finding fixers each rebuild context and
  re-run suites; one real session's final fix wave cost more than all its
  tasks together. It works like any implementer: `prompts/implementer.md`,
  `devorb:tdd` for each fix, the findings file as its brief.
- Then exactly one scoped re-review of the wave:
  `bash scripts/review-package PLAN_FILE FIX_BASE HEAD` and
  `prompts/re-reviewer.md`.
- **Residual findings:** adjudicate them as in the breaker of
  `references/fix-loop.md`: park with rulings, or rule on the load-bearing
  ones and write what you decided. There is no second wave. Residual
  load-bearing findings reach the user through `devorb:finishing`.
- **Minor:** to the ledger as `Final: minor (deferred): <one-liner>`. Minors
  are not rulings and don't enter the wave.

Only the four stops in SKILL.md stop you here.

## Evidence

Before any claim that the plan is done, follow `devorb:verifying`: run the
project's full suite fresh on the final HEAD, read the output, and report the
command and the counts. A red suite means the work isn't done: route it
through `devorb:debugging` and a fix implementer, not a controller edit.

## Finish

Before you delete anything, collect every ledger line containing `Ruling:`
(pre-flight rulings, parked findings, breaker adjudications, all of them) into
your final message under **"Rulings I made"**, in the order you made them,
each with what it costs if wrong. Put every `minor (deferred)` line under
**"Deferred minors"**. Both lists are exhaustive: if the ledger holds it, the
list holds it. A ruling that dies with the workspace was a decision made in
secret.

When the final review is clean and its fixes are committed, delete this plan's
workspace (`rm -rf <workspace>`, the directory `sdd-workspace` printed, never
its parent). The git history is the record now. Sibling directories belong to
other plans: leave them.

Then invoke `devorb:finishing` with the branch and both lists. It presents the
options. You don't merge, push, open a pull request or mark one ready yourself.
