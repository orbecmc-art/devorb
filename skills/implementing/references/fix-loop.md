# The fix loop

The task review reported spec ❌, a Critical or Important finding, or a
cannot-verify item you confirmed as a real gap; or, on a user-interface
task, the `devorb:ui-review` Critique has a `[P1]` from a score below 8.

**Critique findings** go to the builder as Important findings, with the
critic's gap lines verbatim. After each fix, run `devorb:ui-review` again: a
fresh shoot and a fresh Critique. Three Critique rounds at most, the first
included; the findings still open after the third are stated plainly to the
user, never parked in silence.

## Before the loop

Two kinds of finding leave at once:

- **Minor findings** go to the ledger as you go:
  `Task <N>: minor (deferred): <one-liner>`. The final review sees that list
  and decides which must be fixed before merge. Minors never enter the loop.
- **A finding labeled plan-mandated,** or any finding that conflicts with
  what the plan's text requires, is yours to rule on: weigh it against the
  plan text, decide with the spec as the binding authority, and write the
  ruling to the ledger before acting. Don't dismiss it because the plan
  mandates it, and don't dispatch a fix that contradicts the plan without a
  ruling. If the conflict is the plan against the spec on what gets built,
  it is the fourth stop: ask the user.

Everything else enters the loop. A round is one fix dispatch plus one scoped
re-review. Five rounds at most per task.

## Rounds

**Rounds 1-3: resume the original implementer** with the open findings,
verbatim. Its context is intact: the task, the code, its own choices. If you
can't message a live subagent, dispatch a fresh implementer with the brief
path, the report path and the findings; the report file is the memory either
way.

**Rounds 4-5: a fresh implementer on a more capable model** (Model
Selection), with the brief path, the report path, the open findings, and:
"A prior implementer attempted this task [N] times; you own it now. Read the
report file for what was tried." A loop that survives three resumes usually
means the implementer can't see its own problem.

**Every round:** the implementer fixes, re-runs the tests covering the
amended code, appends a fix report to the same report file and replies with
the short contract. Name the covering test files in your fix message; a
one-line fix doesn't need the whole suite. Before the re-review, confirm the
fix report holds the covering tests, the command and the output.

**The re-review is scoped.** Run `bash scripts/review-package PLAN_FILE FIX_BASE HEAD`
by its absolute path, from your working tree, where FIX_BASE is the head the
previous review saw. Dispatch `prompts/re-reviewer.md` with the findings, the
brief, the report and the printed path. New Critical or Important breakage in
the fix diff joins the open findings. Out-of-scope observations go to the
ledger as deferred minors; they never extend the loop.

**After each round,** append:
`Task <N>: fix round <R>/5 (<X> addressed, <Y> open — <finding one-liners>; commits <a7>..<b7>)`

Never fix findings yourself in the controller.

## The breaker

When round 5's re-review still leaves findings open, stop dispatching and
adjudicate each one yourself; you hold the plan and the cross-task context:

- **The reviewer is wrong, or the point is contestable:** park it,
  `Task <N>: parked — <finding> — Ruling: <why the code stands> — <cost if wrong>`.
  The final
  review sees both sides.
- **Real, but nothing downstream builds on it:** park it the same way, with a
  ruling that says it is real and deferred.
- **Real and load-bearing** (a later task builds on it, or it shows a plan
  defect): rule on the smallest change that unblocks the dependent work,
  `Task <N>: Ruling: <finding> — <what you decided and why> — <cost if wrong>`,
  and carry it
  into the next task's dispatch. Parking a structural failure silently lets
  every dependent task build on it. Stop only if the defect leaves every path
  forward a guess.

Adjudicate only at the cap; earlier, it is pre-judging under another name.
Every adjudication is a ledger line. A silent discard is forbidden.
