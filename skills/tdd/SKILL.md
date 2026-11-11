---
name: tdd
description: Use when implementing any feature, bugfix or behavior change, before writing implementation code
---

# Test-Driven Development

Write the test first. Watch it fail. Write the least code that makes it pass. If you didn't watch the test fail, you don't know whether it tests the right thing. Violating the letter of these rules is violating their spirit.

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST.
```

Wrote production code before its test? Delete it and start over from the test. Don't keep it as a reference, don't adapt it while writing the test, don't look at it. Delete means delete.

**Always:** new features, bug fixes, refactoring, behavior changes. **Exceptions, only with the user's permission:** throwaway prototypes, generated code, configuration files.

**Urgency is not permission.** "It's urgent" or "add the test later if there's time" does not waive the test: say in one line that you're writing it first, and do. Only an explicit user decision to skip tests for this change waives it; then report the change as untested.

**Existing code without tests** is not deleted. Before changing it, add tests for the behavior you will touch. They pass at once, so break the code briefly to watch each one fail, then restore it and diff against the original.

## Where tests go

**Seams come from the plan.** Test at the highest seam the plan names for this task: the public interface a caller uses, never internals. Don't stop to confirm it during implementation. No plan, or no seam named? Take the highest public interface that reaches the behavior, name it in one line, and go on. If the named seam can't reach the behavior, use the nearest public seam below it and say so in your report. When the shape of the interface itself is in question, use `devorb:codebase-design`.

Name tests in the project's domain language: read `GLOSSARY.md` and the ADRs in the area if they exist.

## The cycle

Work in **vertical slices**: one test, one minimal implementation, repeat. Each test is a tracer bullet that answers what the last cycle taught you. Never write all the tests first and then all the code: bulk tests check imagined behavior and fix the test structure before you understand the code.

### 1. RED: one failing test

One behavior, and a name that says what should happen ("and" in the name: split it). Real code; mocks only at system boundaries. Before writing the body, name the production change that would make it fail. Derive the expected value by hand (a literal, a worked example, the spec), never with the code under test or its helpers. Read `references/writing-good-tests.md` whenever you write or change a test, a mock or a test helper.

### 2. Verify RED: watch it fail

Mandatory. Run the test and read the output. Confirm that:

- it fails, rather than erroring;
- the failure message is the one you expected;
- it fails because the behavior is missing, not because of a typo or a bad import.

Passes at once? It tests existing behavior: fix the test. Errors? Fix the error and re-run until it fails for the right reason.

### 3. GREEN: the least code that passes

The simplest code that passes this test. No feature the test doesn't demand, no option for a later test, no refactoring of other code.

### 4. Verify GREEN: watch it pass

Mandatory. Run the test, then the project's whole suite (`npm test`, `pytest`, `cargo test`, whatever the repo uses), even when the task names one file. Confirm the new test passes, the others still pass, and the output has no errors or warnings.

Test fails? Fix the code, not the test. Another test fails? Fix it now. A failure you didn't cause still goes in your report, by name.

### 5. REFACTOR: only what this cycle touched

After green only. Remove duplication, improve names, extract helpers, in the code and tests this cycle wrote or changed. Stay green after each step and add no behavior. Cleanup beyond that is a note for `devorb:reviewing`, not work for this cycle.

Then the next failing test for the next behavior.

## Tests that prove nothing

- **Tautological:** the expected value is computed the way the code computes it (`expect(add(a, b)).toBe(a + b)`, the same builder on both sides, a constant compared with itself). It passes by construction and can never disagree with the code.
- **Implementation-coupled:** it mocks your own modules, tests private methods, or checks through a side channel, such as querying the database instead of reading back through the interface. The tell: it breaks on a refactor that kept the behavior.
- **Testing the mock:** the assertion passes when the mock is there and fails when it isn't, so it says nothing about the code.
- **Horizontal slices:** all the tests first, then all the code.

**Algebraic shape** (encode and decode, a normaliser, a parser, a comparator, a numeric rule, an invariant over state): read `references/property-based.md`. If the project has no property-testing library, adding one is the user's decision; keep going with example tests meanwhile.

## When stuck

| Problem | Do |
|---|---|
| Don't know how to test it | Write the call you wish existed, then the assertion. |
| The test is too complicated | So is the design. Simplify the interface. |
| Must mock everything | The code is too coupled. Inject the dependency. |
| Setup is huge | Extract helpers. Still huge? Simplify the design. |

## Stop signs

Each of these means: delete the code written before its test, and start over from RED.

| Thought | Reality |
|---|---|
| "It's urgent, I'll test after if there's time" | There is no time after, and a test written after passes at once, which proves nothing. RED takes minutes. |
| "Too simple to test" | Simple code breaks. The test takes 30 seconds. |
| "Tests after reach the same goal" | Tests after answer "what does this do?"; tests first answer "what should it do?". Tests after check only the cases you remembered. |
| "I already tested it by hand" | No record, no re-run, and edge cases slip under pressure. |
| "Deleting hours of work is wasteful" | Sunk cost. Keeping code you can't trust is the waste. |
| "I'll keep it as a reference" | You'll adapt it. That's testing after. |
| "I need to explore first" | Fine. Throw the exploration away, then start with RED. |
| "This is hard to test" | Hard to test means hard to use. Listen to the test. |
| "The test passed right away" | It tests existing behavior, or nothing. |
| "This case is different" / "spirit, not ritual" | That is the rationalisation this skill exists to stop. |

## Before calling a slice done

- [ ] Every new behavior has a test at the agreed seam
- [ ] You watched each test fail, for the expected reason, before writing its code
- [ ] You wrote the least code that passes each test
- [ ] The whole suite passes, with clean output
- [ ] Mocks only at system boundaries; expected values derived by hand
- [ ] Edge cases and error paths are covered
- [ ] Each realistic mutation (wrong constant or branch, missing side effect, empty return) fails at least one test

Can't tick every box? You skipped TDD: start over.

## Connects to

- **Receives:** a slice to build from `devorb:implementing`, with its seam from the `devorb:planning` plan, or a minimised repro from `devorb:debugging`, which becomes the RED test. Never fix a bug without one.
- **Uses:** `devorb:codebase-design` when the seam's shape is in question.
- **Hands off to:** the caller, with each slice green; `devorb:verifying` before claiming the work is done; wider cleanup to `devorb:reviewing`.
