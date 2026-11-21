# Dense tables on Operate screens — plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use devorb:implementing to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Teach `devorb:visual-direction` to decide what a dense table shows and how its user works in it, proven on a new Operate eval case. After the RED only one bullet about the keyboard was written (see "RED result" in Task 2).

**Architecture:** One new section in `skills/visual-direction/references/operate.md`, holding only the topics the RED run shows the agent missing. One new eval case whose agent writes the direction contract and stops, so a run costs about US$ 1. No `SKILL.md` change. After the RED only one bullet about the keyboard was written, not a section (see "RED result" in Task 2).

**Tech Stack:** Markdown skills, `tools/compare.mjs` (`claude plugin eval`, model `claude-opus-5-5`), Node 22 `node:test` through `npm test`.

**Spec:** `docs/specs/2026-11-20-tabela-de-operacao-design.md`

## Global Constraints

- Skill text in English; ledger, eval prompt and graders in Portuguese.
- RED before any skill text: the case runs on the current skill first, and at least one arm fails.
- Only topics with a recorded failure enter the section.
- No `devorb:performance` pointer: that skill is not on this branch and `npm test` rejects an unregistered name.
- No change to `SKILL.md`, `contract.md` or another skill. No version bump, no `CHANGELOG.md` entry.
- Eval model stays `claude-opus-5-5`; `fusion/eval-config.json` is not edited.
- Paid ceiling US$ 50; spent US$ 37.67; balance US$ 12.33. Every round at `--concurrency 1` (the default). Report the real cost, judge included, after each round. One GREEN attempt only.
- Done means `devorb` approves 2 of 3 or more and `tools/compare.mjs` prints `accepted: true`.
- Stop before the merge.

## Review Focus

- **A grader that a correct contract fails.** Each grader has a hard cut (15 columns, a named key, both outcomes of a status change). Task 1's review reads each one for a fair pass path.
- **The `none` arm passing.** If the plain model already passes, the case does not measure the skill: Task 1 Step 4 handles it. Step 4 only covered `devorb` passing everything; `none` tying `devorb` is recorded in the ledger as open.
- **The rule read as layout control.** `operate.md` says the direction does not touch layout, navigation and controls; the new section must read as content decisions for the contract, not as a new widget set.
- **Overlap with front A.** The section says what the user sees; it gives no query, index or virtualization recipe.
- **Other `visual-direction` cases and the reserved one:** not re-run. Said in the final report.

---

### Task 1: The RED case

**Files:**
- Create: `evals/visual-direction-tabela-operacao/{case.yaml,scaffold.sh,graders/1-default-columns.md,graders/2-volume.md,graders/3-table-states.md,graders/4-search.md,graders/5-keyboard.md,graders/6-status-change.md}`

**Seam:** `node tools/compare.mjs --skill visual-direction-tabela --arms devorb,none --runs 2`

**Interfaces:**
- Consumes: nothing.
- Produces: the per-grader failures of the `devorb` arm, which decide the text of Task 2; `fusion/results/2026-11-20-visual-direction-tabela.md`, to be kept as `…-tabela-red.md`.

- [ ] **Step 1: Write the case.** Fixture: Next (App Router), Tailwind 4, shadcn/ui default theme, no `node_modules`; approved spec `docs/devorb/specs/2026-01-01-central-pedidos-design.md` for the orders screen of Central Aurora: 14 attendants, 20,134 orders, 85 fields listed in nine groups (8 + 12 + 9 + 10 + 10 + 10 + 10 + 9 + 7), no `## Direção visual`, no `DESIGN.md`. Prompt: define the direction and write it in the spec, do not build, nobody answers today. `max_turns: 45`, `timeout_seconds: 1200`. Six `llm` graders on the spec file, judging only the direction the agent added, whatever its heading: (1) default columns named, 15 at most, and a named home for the other fields; (2) a mechanism that limits what is loaded or drawn of the 20 thousand orders; (3) loading, the empty of a search or filter with its way out, and error with its way out; (4) search over at least two named fields; (5) at least one concrete key for keyboard work; (6) both outcomes of a status change. Graders 1 to 3 are the owner's; 4 to 6 give a recorded failure to the other topics the owner listed. A task review before the first paid run changed the first draft: the fixture no longer says the API paginates or what it answers, the judge is told which sections were already in the spec, one three-part grader became three, and the limits went from 30 turns and 900 s to 45 and 1200.
- [ ] **Step 2: Validate.** `bash scaffold.sh` in an empty temp folder exits 0, makes two commits, and the spec's field list counts 85. `npm test` passes.
- [ ] **Step 3: Commit** `test(visual-direction): RED case for the dense operation table`, then run the seam command. Report the cost. Rename the report to `fusion/results/2026-11-20-visual-direction-tabela-red.md`.
- [ ] **Step 4: Read the RED.** Per grader and arm, which runs failed and what the contract said. If `devorb` passes every grader in both runs, harden the case once (state why in the ledger) and rerun; if it still passes, stop and report, with no skill text.

### Task 2: The section, GREEN and the ledger

**Files:**
- Modify: `skills/visual-direction/references/operate.md` (one bullet in "## The screen"; see the RED result below)
- Modify: `fusion/ledger/visual-direction.md` (own rule 7 with its case; results of 2026-11-20, item 2)
- Create: `fusion/results/2026-11-20-visual-direction-tabela.md` (written by `tools/compare.mjs`)

**Seam:** `node tools/compare.mjs --skill visual-direction-tabela --arms devorb,none --runs 3`

**Interfaces:**
- Consumes: Task 1's failures.
- Produces: the report and the ledger entry.

**RED result (2026-11-20, `devorb@2916598`, 2 runs per arm, US$ 2.56 with the judge).** `devorb`: 1 of 2 approved; graders 1, 2, 3, 4 and 6 passed in both runs, grader 5 (keyboard) failed once: the contract said "Atalho de teclado para voltar ao campo, mostrado ao lado dele" and named no key. `none`: 1 of 2 approved; graders 2 and 3 failed once. So the current skill already decides default columns, the home of the other fields, paging, the table's states, the search fields and both outcomes of a status change. Only the keyboard has a recorded failure. By the spec's anti-goal, Step 1 writes one bullet, in "## The screen", and no new section:

```markdown
- **Keyboard:** someone who works here all day reaches a row, opens it and runs the most frequent action without the mouse. The contract names each key.
```

It goes right after the bullet that starts "**A destructive action**". The candidate section below stays in the plan as what was considered and not written.

- [ ] **Step 1 (superseded by the RED result above): Write the section,** keeping from the candidate below only the bullets whose topic failed in the RED, plus the opening sentence:

```markdown
## Dense tables

A table with more fields than the screen holds is designed from what the user does with a row, not from what the record contains. The contract carries each decision below.

- **Default columns:** name them, in order: the ones the user needs to find a row and decide what to do with it. The first identifies the row and stays in place while the others scroll. Every other field gets a named home: the row's detail (an expanding row or a side panel), a column picker, or a saved view for a job that repeats. No view shows every field at once.
- **Volume:** say how many rows exist and how they reach the screen: pages, or a list that draws only the rows in view.
- **Search and filters:** say which fields the search looks in and which filters exist, from the questions the user asks of this data. Active filters stay visible and each one clears on its own.
- **States of the table:** loading keeps the table's shape, header and skeleton rows; "no rows yet" and "nothing matches this search or filter" are two empties, and the second offers to clear the search or filter; an error keeps the filters and the rows already shown, and offers to try again.
- **Editing in a row:** the row shows the change at once; when the save fails, it goes back to the old value and says so.
- **Keyboard:** a daily user reaches a row, opens it and runs the most frequent action without the mouse. Name the keys.
```

- [ ] **Step 2: `npm test`,** then commit `feat(visual-direction): dense tables on Operate screens` (real commit: `e440b20 feat(visual-direction): the contract names the keys on an Operate screen`).
- [ ] **Step 3: GREEN.** Run the seam command. Expected: `accepted: true`, the `devorb` row at 67% or 100%. Report the cost and the running total. Below the bar or `accepted: false`: read the failing grader's evidence, write it in the ledger and stop; no second attempt.
- [ ] **Step 4: Ledger,** in Portuguese: own rule 7 with the case and the RED sentences, both rounds per grader, the costs, what was not checked.
- [ ] **Step 5: `npm test`,** then commit `test(visual-direction): GREEN for dense tables` (real commit: `65ec2e7 test(visual-direction): GREEN for the keys on an Operate screen`) with the ledger and both result files.

## Outcome

Owner's decision, 2026-11-20: the keyboard bullet and the new case stay as they are.

- RED at `devorb@2916598`: devorb 1 of 2, none 1 of 2, US$ 2.56.
- One bullet written (`e440b20`).
- GREEN at `devorb@e440b20`: devorb 2 of 3, none 2 of 3, `accepted: true`, US$ 3.75.
- Item 2 cost US$ 6.31; front total US$ 43.98 of 50.
- The dense-table section of the brief was not written.
- Open items are in the ledger.
- Stopped before the merge.
