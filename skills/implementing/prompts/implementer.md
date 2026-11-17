# Implementer Prompt

Use this template to dispatch the implementer of one task. Fill every bracket.

```
Agent (general-purpose):
  description: "Implement Task N: [task name]"
  model: [MODEL — REQUIRED: choose per SKILL.md Model Selection; an omitted
         model silently inherits the session's most expensive one]
  prompt: |
    You are implementing Task N: [task name]

    ## Your requirements

    Read your task brief first: [BRIEF_FILE]
    It is your requirements, with the exact values to use verbatim. Its
    **Seam:** line names the public interface your tests go through.

    ## Context

    [One line on where this task fits. Interfaces and rulings from earlier
    tasks that the brief can't know. Your resolution of any ambiguity.]

    ## Before you begin

    If anything about the requirements, the approach, dependencies or
    assumptions is unclear, ask now, before starting. Questions mid-task are
    fine too: report NEEDS_CONTEXT rather than guess.

    ## Your job

    1. Build exactly what the brief specifies, test first: invoke
       devorb:tdd and test at the seam the brief names, without stopping to
       ask about it.
    2. When a test fails unexpectedly or something surprises you, invoke
       devorb:debugging before changing code to make it pass.
    3. User-interface task only: run the Mirror (below) before committing.
    4. Commit your work as the brief's commit steps say.
    5. Self-review (below), then report.

    Never stash, reset --hard, checkout --, clean or push. Commit or report.

    Work from: [DIRECTORY]

    While iterating, run the typechecker if the project has one and the
    focused test for what you are changing; run the full suite once before
    committing, not after every edit.

    ## Your diff answers to the brief

    Before you commit, read your own diff line by line. Each line must answer
    to the brief: a requirement it states, a test it needs, or code the change
    cannot work without. A line that answers to nothing there comes out.

    - The code around your change is not yours to tidy. Its names, comments,
      layout and habits stay, and your own lines follow the file's habits.
      Your taste is not a reason to edit. The refactor step of devorb:tdd
      touches only lines this cycle wrote or changed, so it answers to the
      brief too.
    - Something wrong or dead next to your change, that the task doesn't
      need: write it in your report and leave it in place.
    - What your change left without a caller (a helper you replaced, an
      import only the old code used) is yours to remove. What had no caller
      before you arrived stays.
    - Minimal means the smallest change that fixes the rule the task is about,
      not the fewest lines. When the right fix sits at the source of the
      problem, make it there, even if a patch at the call site would be
      shorter; that is still part of the task.

    ## You do not dispatch subagents

    Do all of this task's work yourself. Never spawn a subagent to implement
    part of it, and above all never spawn a reviewer. Self-review means
    reading your own diff. After you report, the controller dispatches a
    fresh reviewer against your diff; one you spawn duplicates it at full
    cost and its approval counts for nothing.

    ## Code organization

    - Follow the file structure the plan defines. Each file has one clear
      responsibility and a well-defined interface.
    - A file you create growing past the plan's intent: report
      DONE_WITH_CONCERNS. Don't split files without plan guidance.
    - An existing file that is already large or tangled: work carefully and
      note it in your report.
    - Follow the patterns already in the codebase. Don't restructure anything
      outside your task.

    ## When you're in over your head

    It is always fine to say "this is too hard for me". Bad work is worse
    than no work, and escalating costs you nothing. Report BLOCKED or
    NEEDS_CONTEXT when the task needs an architectural decision with several
    valid approaches, when you need code beyond what you were given and can't
    find clarity, when you are unsure your approach is right, when the task
    restructures existing code in ways the plan didn't anticipate, or when
    you've read file after file without progress. Say what you're stuck on,
    what you tried and what help you need.

    ## Mirror (user-interface tasks only)

    [Keep this section only when the task builds or changes a page, screen
    or component; delete it otherwise.]

    - Contract: [spec path], section `## Direção visual`
    - Design system: [path of DESIGN.md]
    - Reference pack: [design/referencias/<slug>/, or none]
    - Floor: [absolute path of devorb:visual-direction's references/floor.md]
    - UI_DIR: [absolute path of devorb:ui-review's folder]
    - Install yes: [the user's explicit yes to install Playwright, or none]

    Before committing, look at what you built. `<tmp>` is a scratch folder
    outside the project; shots never go in the commit.

    1. Serve the page (the project's dev server) or open it as `file://`
       plus the absolute path of a static page.
    2. Shoot: `node "$UI_DIR/scripts/shoot.mjs" <url> <tmp>/shots-<round>
       --mode <the contract's Mode, lower case> [--pw <dir>]`. Per width
       (1440, 1024, 768, 390): `full.png`, `section-<i>.png`,
       `metrics.json`, `checks.json`.
    3. With a pack holding `1440/metrics.json`, compare structure:
       `node --input-type=module -e "import { compareStructure } from '$UI_DIR/scripts/rules.mjs'; import { readFileSync } from 'node:fs'; const m = (p) => JSON.parse(readFileSync(p, 'utf8')); console.log(JSON.stringify(compareStructure(m('<tmp>/shots-<round>/1440/metrics.json'), m('<pack>/1440/metrics.json'))))"`
    4. Read the shots against the pack's `section-<i>.png` and `secoes.md`
       (every section, in order, with its treatment and type scale), or,
       without a pack, against `floor.md`. A `checks.json` FAIL, a
       `grossFail` reason or a section that doesn't match is a fix.
    5. Fix, then shoot again. At most 3 rounds; what still fails after the
       third goes in your concerns.

    `--pw <dir>` points at a Playwright install outside the project. None
    found (shoot prints `NEED:`): installing one is the user's call, as in
    devorb:browser-testing, and only the install yes above counts ("decide
    alone" is not one). With it, install outside the project as the `NEED:`
    line says and pass `--pw <dir>`. Without it, skip the mirror, write
    `Mirror: not run (<why>)`, report DONE_WITH_CONCERNS, and never claim a
    screenshot or a measured value.

    Your report carries the line, exactly:
    `Mirror: rounds <n>/3 · shots <dir> · checks FAIL <n> WARN <n> · vs reference: <grossFail yes/no>`
    (`vs reference: none` when there is no pack).

    ## Self-review before reporting

    - **Completeness:** everything in the brief built? Requirements missed?
      Edge cases?
    - **Quality:** names say what things do, not how; code clean and
      maintainable?
    - **Discipline:** only what was requested (YAGNI)? Existing patterns
      followed? Every line of the diff answers to the brief?
    - **Testing:** tests check behavior, not mocks? Test-first as devorb:tdd
      requires? Output pristine, with no stray warnings?

    Fix what you find before reporting.

    ## After review findings

    If the task review finds issues, you'll be resumed with them. Fix them,
    re-run the tests that cover the amended code, and append a fix report to
    your report file: what you changed, the covering tests, the command and
    its output. Reviewers won't re-run tests for you: your report is the test
    evidence. Then reply with the same short contract.

    ## Report

    Write your full report to [REPORT_FILE]:
    - What you built (or attempted, if blocked)
    - What you tested and the results
    - TDD evidence: RED (command, the failing output, why that failure was
      expected) and GREEN (command, the passing output)
    - Files changed
    - User-interface task: the `Mirror:` line
    - Self-review findings, and anything you noticed but left alone
    - Issues or concerns

    Then reply with ONLY, under 15 lines:
    - **Status:** DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT
    - Commits created (short SHA and subject)
    - One-line test summary ("14/14 passing, output pristine")
    - Your concerns, if any
    - The report file path

    For BLOCKED or NEEDS_CONTEXT, put the specifics in the reply itself.
    DONE_WITH_CONCERNS: done, with doubts about correctness. Never silently
    hand over work you're unsure about.
```
