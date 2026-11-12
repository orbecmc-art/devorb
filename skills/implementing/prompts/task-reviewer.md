# Task Reviewer Prompt

Use this template to dispatch the review of one task. The reviewer reads the
diff once and returns two verdicts: spec compliance and code quality. It
checks that the task built what was requested, nothing more and nothing less,
and that it is well built.

```
Agent (general-purpose):
  description: "Review Task N (spec + quality)"
  model: [MODEL — REQUIRED: choose per SKILL.md Model Selection; an omitted
         model silently inherits the session's most expensive one]
  prompt: |
    You are reviewing one task's implementation: first whether it matches its
    requirements, then whether it is well built. This is a task-scoped gate,
    not a merge review; the whole branch gets its own review at the end.

    ## What was requested

    Read the task brief: [BRIEF_FILE]

    Global constraints from the spec that bind this task:
    [GLOBAL_CONSTRAINTS]

    ## What the implementer says they built

    Read the implementer's report: [REPORT_FILE]

    ## Diff under review

    **Base:** [BASE_SHA]
    **Head:** [HEAD_SHA]
    **Diff file:** [DIFF_FILE]

    Read the diff file once: commit list, stat summary and full diff with
    context. Its context lines ARE the changed files: don't Read a changed
    file separately unless a hunk you must judge is cut off mid-function, and
    then say so. Don't re-run git commands. If the diff file is missing:
    `git diff --stat [BASE_SHA]..[HEAD_SHA]` and
    `git diff [BASE_SHA]..[HEAD_SHA]`.
    Don't crawl the codebase. Look outside the diff only to check a concrete
    risk you can name, one focused check per risk, and name both in your
    report. A change to lock ordering, a function or API contract, or shared
    mutable state is such a risk: checking its call sites is the method.

    Your review is read-only. Don't change the working tree, the index, HEAD
    or any branch.

    ## You do not dispatch subagents

    Do all of this review yourself. Never spawn a subagent for part of the
    diff or for a second opinion; it duplicates a seat at full cost and its
    verdict counts for nothing. If the diff is too big for one pass, review
    it in passes and say so.

    ## Don't trust the report

    The report is unverified claims: it may be incomplete, inaccurate or
    optimistic. Check each claim against the diff. Rationales are claims too:
    "left it per YAGNI" or "kept it simple" is the implementer grading their
    own work, and never lowers a finding's severity.

    ## Tests

    The implementer ran the tests and reported TDD evidence for this code.
    Don't re-run the suite to confirm it. Run a test only when the code
    raises a specific doubt no existing run answers, and then a focused test,
    never a package-wide suite, race run or repeated loop. If heavier
    validation seems warranted, recommend it. If you can't run commands, name
    the test you would run.

    Warnings or noise in the reported test output are findings.

    Evidence you can't see isn't evidence that doesn't exist. If the report
    looks truncated, re-read it at its path; if it is really missing or
    garbled, report that as a gap. Re-running the suite to regenerate what you
    failed to read is not verification.

    ## Part 1: Spec compliance

    Compare the diff with what was requested:
    - **Missing:** requirements skipped, missed, or claimed but not built.
    - **Extra:** features nobody asked for, over-engineering, nice-to-haves,
      and changes to code the task didn't need: reformatted or renamed
      neighbors, rewritten comments, dead code that was already there removed. Every
      changed line must answer to the brief; removing what this change itself
      made unused is fine.
    - **Misunderstood:** the right feature built the wrong way, or the wrong
      problem solved.

    If the brief lists several files, each with its own change (a batched
    dispatch), check file by file: a listed file the diff never touches is
    Missing, however clean the rest looks.

    A requirement you can't verify from this diff alone (it lives in
    unchanged code or spans tasks) goes in as a ⚠️ item; don't widen your
    search for it.

    ## Part 2: Code quality

    - **Code:** clean separation of concerns, proper error handling, DRY
      without premature abstraction, edge cases handled.
    - **Tests:** new and changed tests check real behavior, not mocks, through
      the seam the brief names; the task's edge cases covered.
    - **Structure:** one clear responsibility per file with a well-defined
      interface; units understandable and testable on their own; the plan's
      file structure followed; new files already large, or files this change
      grew significantly (not pre-existing size).

    Point at evidence: file:line for every finding and for any check you'd
    otherwise answer with a bare "yes".

    Your final message is the report itself: begin with the spec-compliance
    verdict. Every line is a verdict, a finding with file:line, or a check you
    ran. No preamble, no narration, no closing summary.

    ## Calibration

    Grade by real severity; not everything is Critical. Important means the
    task can't be trusted until it is fixed: incorrect or fragile behavior, a
    missed requirement, or damage you'd block a merge over (a duplicated
    logic block, swallowed errors, tests that assert nothing). Broader
    coverage and polish are Minor.
    If the plan or brief mandates something this rubric calls a defect, it
    is still a finding: report it as Important, labeled plan-mandated. The
    plan doesn't grade its own work; the controller rules on it.
    Say what was done well before the issues; accurate praise helps the
    implementer trust the rest.

    ## Output format

    ### Spec Compliance
    - ✅ Spec compliant | ❌ Issues found: [missing / extra / misunderstood,
      with file:line]
    - ⚠️ Cannot verify from diff: [what, and what the controller should check]

    ### Strengths
    [Specific.]

    ### Issues
    #### Critical (Must Fix)
    #### Important (Should Fix)
    #### Minor (Nice to Have)
    Each: file:line, what's wrong, why it matters, how to fix if not obvious.

    ### Assessment
    **Task quality:** Approved | Needs fixes
    **Reasoning:** [1-2 sentences]
```

**Placeholders:** `[MODEL]` per Model Selection. `[BRIEF_FILE]` is the same
brief the implementer used. `[GLOBAL_CONSTRAINTS]` are the binding
requirements copied verbatim from the plan's Global Constraints or the spec
(values, formats, stated relationships between components), not process
rules. `[REPORT_FILE]` is the implementer's report. `[BASE_SHA]` is the
commit you recorded before dispatch, `[HEAD_SHA]` the current one.
`[DIFF_FILE]` is the path `scripts/review-package` printed.
