---
name: verifying
description: Use when about to claim work is done, fixed, passing or faster, before committing, opening a PR, moving to the next task or relaying another agent's result
---

# Verifying

Evidence before claims, always. Violating the letter of this rule is violating its spirit.

```
NO COMPLETION CLAIM WITHOUT FRESH EVIDENCE.
```

Fresh means you ran the command after your last edit, in this session, and read its output. The rule covers exact words, paraphrases and anything that implies success: "done", "fixed", "works", "Great!", a commit message, a ticked checkbox.

## The gate

Before claiming any status or expressing satisfaction:

1. **Identify** the command that proves the claim.
2. **Run** it in full, fresh. A subset is fine while fixing; the claim needs the full run.
3. **Read** the whole output: exit code, how many tests ran, failures, errors, skips.
4. **Compare.** Output does not confirm the claim: state the real status, with the output. It does: state the claim, with the output.
5. **Only then** make the claim.

Skipping a step is lying, not verifying.

## What counts as evidence

- **A run, not a reading.** Reading the code, or running against a mock or a fake, shows what those touch, not how the real system behaves. Say which one you did; whatever needed the real system stays unverified.
- **Count what ran.** Exit 0 alone proves nothing. A suite that ran zero tests is a failure to report, not a pass, and so is a test pattern that found no file.
- **Green counts only with the gate intact.** Read your own diff to tests, test config and CI before trusting green: nothing deleted, skipped or loosened (a weaker assertion, a longer timeout, more retries, a lower bar) to get there. If something was, restore it or tell the user what and why. `devorb:reviewing` holds the full list.
- **"It was already failing" needs proof:** the same red recorded before your first edit, or reproduced on the base branch (in a separate worktree, `git worktree add`). Without that, the red is yours.
- **Missing pieces block; they don't get faked.** If the run can't reach a database, key or binary it needs, report that with the output. A stand-in that turns the check green hides the failure.

## Common failures

| Claim | Requires | Not sufficient |
|---|---|---|
| Tests pass | Test output: N ran, 0 failures | An earlier run, "should pass", exit 0 with nothing run |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command: exit 0 | Linter passing, logs look good |
| Bug fixed | The original symptom, re-run: gone | Code changed, assumed fixed |
| Regression test works | Red-green cycle seen (below) | Test passes once |
| Agent completed | The diff shows the change, and your own run passes | The agent or a note says "success" |
| Requirements met | Line-by-line checklist against the request or plan | Tests passing |
| UI works | `devorb:browser-testing` on the running app | Unit tests, reading the markup |
| Works when deployed | A check on that environment (below) | Local tests, review, merge |
| Faster | Measured as below | One run, reading the code |

## Regression tests: see the red

Write, run (pass), revert only the fix, run (**must fail**), restore, run (pass). A test you never saw fail may not test the bug.

## Reports from agents and notes

A subagent's summary, an earlier session's handoff, a commit message or a note saying "all tests pass" is a claim, not evidence. Read the diff (`git diff`, `git log`), check it does what the report says, run the checks yourself, and report what you saw. When your run contradicts the report, the run wins: quote the failing test and the counts, and never repeat the report's success.

## Requirements

Re-read the request or plan as it was before your work, not a version you edited to match the result. Make a checklist, check each item, and report each gap.

## Deployed environments

When the request depends on a deployed environment (staging, preview, production, a device or store build), give it its own line, apart from local checks: **verified**, **failed**, **not done** or **not applicable**, with environment, version and evidence. Local tests, review and merge say nothing about the target. Not done? Say what access or step is missing. Production is read only; a check that changes data runs on staging or preview, with the user's explicit permission.

```
Local: npm test, 112 ran, 0 failed; npm run build, exit 0
Deployed (preview, commit 4e1c9a2): failed, POST /orders returns 500 (log line quoted)
```

## Performance claims

"Faster", "lighter", "no slowdown" are claims about numbers. Same input, build and data on both sides. Run each side 5 times, interleaved (old, new, old, new...), and give the median and the spread (lowest to highest). Count the runs that errored or gave a wrong result. If the gap between medians fits inside the spread, the verdict is "no difference". A variant that breaks a test is rejected, whatever its number. Setup and report: `references/performance.md`.

## Stop signs

Catching yourself on the left means run the gate.

| Thought | Reality |
|---|---|
| "Should work now" / "Looks correct" | Run it. |
| "I'm confident" | Confidence is not evidence. |
| "Just this once" / "I'm tired" | No exceptions. |
| "Linter passed" | The linter is not the compiler. |
| "The agent / the note says it passed" | Check the diff and run it yourself. |
| "It was already red" | Show it red before your first edit or on the base branch. |
| "I'll skip that flaky test for now" | A skipped test turns green into noise. Report it. |
| "The mock returns the right thing" | The mock is not the service. |
| "Partial check is enough" | Partial proves nothing. |
| "Different words, so the rule doesn't apply" | Spirit over letter. |

Also stop before committing, pushing, opening a PR, moving to the next task or delegating without the gate.

## Hand-off

Report each claim with its command and the result you saw (counts, exit code), what stays unverified and why, and the deployed line when it applies.

## Connects to

- **Receives:** finished work from `devorb:implementing`, or a fix from `devorb:debugging`.
- **Uses:** `devorb:browser-testing` when the task has a user interface.
- **Hands off to:** `devorb:reviewing`, with the evidence.
