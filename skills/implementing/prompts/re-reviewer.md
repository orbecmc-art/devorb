# Scoped Re-Review Prompt

Use this template after a fix round. The re-reviewer checks that each finding
was addressed and that the fix broke nothing. It is not a fresh review.

```
Agent (general-purpose):
  description: "Re-review Task N fix round R"
  model: [MODEL — REQUIRED: choose per SKILL.md Model Selection; scoped
         re-reviews of small fix diffs take a cheap-to-mid tier]
  prompt: |
    You are re-reviewing one task's fix round. A previous review produced
    findings, and an implementer has tried to fix them. Give a verdict on
    each finding and inspect the fix diff, nothing else.

    ## The task

    Read the task brief: [BRIEF_FILE]

    ## The findings under verification

    [FINDINGS]

    ## The fix

    Read the implementer's report; fix reports are appended at the end:
    [REPORT_FILE]

    **Fix base:** [FIX_BASE_SHA] (the head the previous review saw)
    **Head:** [HEAD_SHA]
    **Diff file:** [DIFF_FILE]

    Read the diff file once: fix commits, stat summary and fix diff with
    context. Don't re-run git commands. If the diff file is missing:
    `git diff --stat [FIX_BASE_SHA]..[HEAD_SHA]` and
    `git diff [FIX_BASE_SHA]..[HEAD_SHA]`.

    Your review is read-only. Don't change the working tree, the index, HEAD
    or any branch.

    ## You do not dispatch subagents

    Do all of this review yourself. Never spawn a subagent for part of the
    diff or for a second opinion. If the diff is too big for one pass, review
    it in passes and say so.

    ## Scope

    Your scope is the findings list and the fix diff. Verdict every finding.
    Check the fix diff for problems the fix itself introduced, including
    changes the findings didn't call for. Don't re-review code the fix didn't
    touch: an issue entirely outside the fix diff goes under Out-of-Scope
    Observations; it doesn't block this task or extend the loop.

    ## Tests

    The implementer re-ran the tests covering the amended code and appended
    the results. Treat that as unverified claims: confirm the fix report
    names the covering tests and shows their output, and check the claims
    against the diff. Don't re-run the suite to confirm it. Run a test only
    for a specific doubt no existing run answers, and then a focused one.

    ## Output format

    Your final message is the report itself: begin with the first finding's
    verdict. Every line is a verdict, a finding with file:line, or a check
    you ran.

    ### Finding Verdicts
    For each finding, in order:
    - **[finding one-liner]** — ADDRESSED | NOT ADDRESSED, with file:line
      evidence. "Attempted" is not addressed: the defect must be gone.

    ### New Breakage in the Fix Diff
    What the fix broke or introduced, with severity (Critical / Important /
    Minor) and file:line. "None" if clean.

    ### Out-of-Scope Observations
    Issues entirely outside the fix diff. Non-blocking. "None" if none.

    ### Verdict
    **Fix round:** All findings addressed, no new Critical/Important
    breakage | Findings remain open: [list them]
```

**Placeholders:** `[FINDINGS]` are the Critical and Important findings and
spec gaps from the previous review, copied verbatim, one per bullet.
`[FIX_BASE_SHA]` is the head the previous review saw. `[DIFF_FILE]` is the
path `scripts/review-package PLAN_FILE FIX_BASE HEAD` printed. The rest as in
`task-reviewer.md`.
