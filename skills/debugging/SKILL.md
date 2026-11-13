---
name: debugging
description: Use when encountering any bug, test failure, build failure, flaky behavior, performance regression or unexpected result, before proposing a fix
---

# Debugging

Find the root cause with evidence, then fix it where it lives. Symptom fixes are failure. Violating the letter of this process is violating its spirit.

```
NO THEORY WITHOUT A RED LOOP.
NO FIX WITHOUT A ROOT CAUSE.
```

These gates hold hardest when the fix looks obvious, time is short, someone senior names the cause, or the user asks for the fastest way.

**Redact** every secret in commands, outputs and artifacts you show: write `<REDACTED>`, build loops against env vars, and compare secrets by name, presence or hash, never by value. If the redacted output is not enough, ask the user.

## 1. Build a red loop

**Orient, in minutes.** Read the whole error and stack trace. Check recent changes: git log and diff, dependencies. List what differs between where it fails and where it works: deployed version, config, env vars, infrastructure, service versions. Each difference is a lead for the loop, not a cause to fix. On a live service, read logs and save state before any restart. Read `GLOSSARY.md` and ADRs in the area if they exist. This aims the loop; theories wait for phase 3.

**Many components and unclear which layer breaks** (CI → build → signing, API → service → database): log what enters and leaves each boundary, run once, and aim the loop at the layer that fails.

**The loop is the skill.** With a _tight_ signal that goes _red_ on this bug, everything after it is mechanical. Spend disproportionate effort here. Ways to build one, roughly in order:

1. Failing test at whatever seam reaches the bug
2. curl/HTTP script against a dev server
3. CLI run with a fixture, diffed against a known-good snapshot
4. Headless browser script asserting on DOM, console or network
5. Replay of a captured request, payload or event log
6. Throwaway harness: minimal subset of the system, mocked dependencies
7. Property or fuzz loop for "sometimes wrong output"
8. Bisection: `git bisect run`, or `references/find-polluter.sh` for a test that pollutes others
9. Differential loop: old vs new version or config, diffing outputs
10. Human in the loop, as a last resort: an edited copy of `scripts/hitl-loop.template.sh`

**Tighten it.** Faster: narrow the scope, cache setup. Sharper: assert the exact symptom, not "didn't crash". Deterministic: pin time, seed randomness, isolate the filesystem, force the slow branch, wait on conditions instead of sleeps (`references/condition-based-waiting.md`). For non-deterministic bugs, raise the reproduction rate: loop the trigger 100×, parallelise, narrow timing windows, and add stress only in a local or test environment.

**No loop possible?** Say so, list what you tried, and ask for environment access, a redacted artifact (HAR, log dump, core dump, recording), or permission for temporary production instrumentation.

**Done when** you can name one command you have already run (show it and its output) that is:

- [ ] **Red:** drives the real code path and asserts the user's exact symptom
- [ ] **Deterministic:** same verdict every run (flaky bugs: a pinned, high rate)
- [ ] **Fast:** seconds, not minutes
- [ ] **Unattended:** a human only through the HITL script

## 2. Minimise

Run the loop. Confirm it shows the failure the user described, not a nearby one, and capture the exact symptom. Then cut inputs, callers, config, data and steps one at a time, re-running after each cut.

**Done when** removing any remaining element turns the loop green.

## 3. Hypothesise

Gather evidence first:

- **Working example:** find similar code that works, read any reference implementation completely, and list every difference, however small.
- **Trace:** follow the bad value backward through its callers to where it originates (`references/root-cause-tracing.md`).
- **Silent no-op** (a control does nothing and nothing errors): `references/silent-no-op.md`.

Write 3–5 ranked hypotheses, since a single one anchors on the first plausible idea. Each states its prediction: "If X is the cause, changing Y makes the bug disappear, changing Z makes it worse." A hypothesis with no prediction gets sharpened or discarded.

Show the ranked list to the user before testing; they often re-rank it instantly. If they are away, proceed with your ranking.

**Done when** the list is shown and each entry has a prediction.

## 4. Test one variable at a time

Each probe maps to one prediction. Prefer a debugger or REPL, then targeted logs at the boundaries that separate hypotheses. Tag every log with a unique prefix such as `[DEBUG-a4f2]`. For performance, measure a baseline (profiler, timing harness, query plan), then bisect.

All refuted: form new hypotheses from what you learned. Something you don't understand: say "I don't understand X", then research or ask.

**Done when** one prediction held and you can state why the bug happens.

## 5. Fix at the source

1. **Locate the defect.** State the broken rule in one sentence: what must always be true, and where it is not. Search the whole repository for other callers and paths with the same pattern; in a large or copied codebase, use `references/variant-search.md`. The fix goes in the layer where the defect lives: when two call sites would need the same patch, it belongs one layer down.
2. **Write the regression test first**, at a seam that exercises the real bug pattern. Turn the minimised repro into a test and watch it go red on every run. A test that fails only sometimes proves nothing; wait on conditions, not sleeps (`references/condition-based-waiting.md`). If you forced red by mutating code, diff against a pristine copy to prove the mutation landed. No correct seam? That is a finding: record it, and the phase 1 loop stays as the proof.
3. **Make one fix.** The smallest change that restores the broken rule, which is not the change with the fewest lines. The root cause and its variants, with nothing else bundled. For invalid data crossing layers, see `references/defense-in-depth.md`.
4. **Verify.** The test goes green, the phase 1 loop goes green on the original scenario, and the full suite passes. List every place the rule breaks, what you did there, and why. Tell the user what the fix costs and any cheaper or safer option you rejected.

**The fix failed?** Count your attempts. Under 3: return to phase 3 with what you learned. At 3: stop. Each fix revealing a new problem elsewhere, or demanding a massive refactor, means the architecture is wrong, not the hypothesis. Discuss it with the user before fix #4.

**Truly environmental or external?** Document what you investigated, add handling (retry, timeout, clear error) and logging. Most "no root cause" verdicts are incomplete investigations.

## 6. Clean up

- [ ] Phase 1 loop is green on the original scenario
- [ ] Regression test passes, or the missing seam is documented
- [ ] Every place the rule breaks is listed, with what you did there and why
- [ ] Grep for `[DEBUG-` returns nothing
- [ ] Captured logs, dumps and HAR files that may hold secrets are deleted or redacted
- [ ] Throwaway harnesses deleted or moved to a marked debug location
- [ ] The confirmed hypothesis is stated in the commit or PR message

## Stop signs

Catching yourself on the left means stop and return to phase 1. Containing an outage is allowed; fixing it still needs phase 1.

| Thought | Reality |
|---|---|
| "Quick fix now, investigate later" | The first fix sets the pattern. Guessing is slower than this process. |
| "They asked for the fastest way" | Finding the cause is the fast path, and a source fix is often the same size as the patch. |
| "It's an emergency" | Thrashing costs more than investigating. |
| "Restart it and see" | A restart wipes the state you need. Save logs and state first; a restart after that mitigates, it does not fix. |
| "It's simple, I see the problem" | Seeing the symptom is not understanding the cause. |
| "I'll read the code and work it out" | A theory before a red loop is the exact failure this skill prevents. |
| "Just try X and see" / "several changes at once" | You can't isolate what worked. |
| "I'll patch this caller; the other one wasn't asked for" | Same defect, one layer down. Fix it there or report why not. |
| "I'll add the test after" / "I verified by hand" | Untested fixes don't stick. |
| "The senior engineer says it's X" | Experience raises a hypothesis. Evidence confirms it. |
| "One more attempt" (after 2) | Question the architecture. |

From the user, these mean you assumed instead of verifying: "Is that not happening?", "Will it show us...?", "Stop guessing", "Ultra-think this", "We're stuck?"

## Connects to

- **Receives:** a bug report, failing test or unexpected result, from any stage.
- **Uses:** `devorb:tdd` for the regression test in phase 5.
- **Hands off to:** `devorb:verifying` before claiming the bug is fixed.
