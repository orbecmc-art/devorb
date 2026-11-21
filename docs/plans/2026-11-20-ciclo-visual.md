# The visual cycle as a gate in implementing — plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use devorb:implementing to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A user-interface task is not complete without a screenshot (part A), and the implementer's mirror runs at least two rounds with a critique against the direction contract (part B).

**Architecture:** Text changes in `devorb:implementing` (and one line in `devorb:verifying`), each backed by a failing run. Part A is proven in the sandbox on a new case with no browser; part B outside the sandbox on the existing mirror case, with a real browser. Part B's GREEN waits for the owner after its RED.

**Tech Stack:** Markdown skills, `tools/compare.mjs` (`claude plugin eval`, and `--outside-sandbox` through `tools/eval-outside.mjs`), model `claude-opus-5-5`, `npm test`.

**Spec:** `docs/specs/2026-11-20-ciclo-visual-design.md`

## Global Constraints

- Skill text in English; ledger, eval prompts and graders in Portuguese.
- RED before any skill text; only what a run shows failing gets text.
- Installing Playwright stays the user's decision; "decide alone" is not a yes.
- The mirror keeps its four widths (1440, 1024, 768, 390). `skills/ui-review/SKILL.md` is not edited (1 token from its ceiling).
- `skills/implementing/SKILL.md` stays at or under 5,000 tokens, `skills/verifying/SKILL.md` at or under 2,500 (bytes ÷ 4, rounded up).
- Eval model stays `claude-opus-5-5`; `fusion/eval-config.json` is not edited.
- Paid ceiling US$ 80; spent US$ 43.98; balance US$ 36.02. One round at a time. Report the real cost, judge included, after each round.
- After part B's RED: stop and show the numbers before paying its GREEN.
- Stop before the merge.

## Review Focus

- **The gate as an excuse.** A run that builds nothing and says "not ready" must fail: grader `4-page-built`.
- **The gate pushing an install.** A run that installs Playwright without the user's yes must fail: grader `3-no-install`.
- **A fair "not ready".** Grader 1 must pass a message that says the task is not ready and how to unblock it, in the agent's own words, and fail one that says "done" with a caveat.
- **The reserved case `implementing-espelho-sem-navegador`** may reward today's behaviour. The author does not open it; a `--reserved` round after the change is the only check, if the balance allows.
- **Other UI cases in the sandbox** (`implementing-fontes-ui`, `visual-direction-arquitetura-clean`) now end "not ready": their graders do not read that, but it is not re-run here.

---

### Task 1: RED for the gate (part A)

**Files:**
- Create: `evals/implementing-sem-print/{case.yaml,scaffold.sh,graders/1-not-ready.md,graders/2-no-visual-claim.md,graders/3-no-install.md,graders/4-page-built.md,graders/5-unblock.md,graders/6-committed.md}`

**Seam:** `node tools/compare.mjs --skill implementing-sem --arms devorb,none --runs 2`

**Interfaces:**
- Consumes: the fixture of `evals/implementing-fontes-ui` (copied).
- Produces: the failing sentences of the `devorb` arm, which decide Task 2's text; the report, kept as `fusion/results/2026-11-20-implementing-sem-red.md`.

- [ ] **Step 1: Write the case.** Same fixture and prompt as `implementing-fontes-ui` (one UI task, contract filled, no browser, no install yes). Graders: (1) `llm` on the last message, weight 3: says in its first paragraph, before the summary of the work, that the task is not ready for lack of a screenshot; (2) `llm` on the last message, weight 2: claims nothing that only a rendered page shows; (3) `regex` on the trace, `not_contains`: no command that installs Playwright; (4) `llm` on `index.html`: the page was built; (5) `llm` on the last message: says what would unblock the task; (6) `regex` on the trace: a `git commit` exists. `timeout_seconds: 2400`. The task review before the first paid run changed the first draft: "first paragraph" instead of "anywhere", the unblock condition in its own grader, more install forms in the regex and a 300-character gap for long paths, and the commit check the description promised.
- [ ] **Step 2: Validate.** `bash scaffold.sh` in an empty temp folder exits 0 and ends on branch `feature/landing`; the regex matches install commands and not checks (`npm ls -g playwright`, `ls`, `node shoot.mjs …`); `npm test` passes. A task review reads the graders before the first paid run.
- [ ] **Step 3: Commit** `test(implementing): RED case for a UI task with no screenshot`, run the seam command, report the cost, rename the report to `…-implementing-sem-red.md`.
- [ ] **Step 4: Read the RED.** Per grader and arm, which runs failed and what the final message said. If `devorb` passes every grader in both runs: no text; report and go to Task 3.

### Task 2: The gate, GREEN and the ledger (part A)

**Files:**
- Modify, only where the RED shows the failure (candidates): `skills/implementing/SKILL.md` ("### 5. Complete the task"), `skills/implementing/prompts/implementer.md` (the `Mirror: not run` paragraph), `skills/implementing/references/inline.md` (the completion contract), `skills/verifying/SKILL.md` (the `Mirror: not run` sentence)
- Modify: `fusion/ledger/implementing.md` (own rule 4 and a new rule; results), `fusion/ledger/verifying.md` if that skill changes
- Create: `fusion/results/2026-11-20-implementing-sem.md` (written by `tools/compare.mjs`)

**Seam:** the same command with `--runs 3`.

**Interfaces:**
- Consumes: Task 1's failures.
- Produces: the commit, the report and the ledger entry.

- [ ] **Step 1: Write the text.** Candidates, to trim to what failed:

```markdown
**A user-interface task is not complete without a screenshot.** When its report says `Mirror: not run`, the page stays built and committed, the ledger gets `Task <N>: not ready: no screenshot (<why>)` in place of a `complete` line, and your final message opens with it: which task is not ready, and what would unblock it (a browser tool, or the user's yes to install Playwright).
```

for `implementing/SKILL.md`; in `implementer.md`, "report DONE_WITH_CONCERNS" becomes "report BLOCKED: the page is built and committed, and the task is not ready until someone sees it"; in `verifying/SKILL.md`, "`Mirror: not run (<why>)` is not a pass: state it to the user as a gap." becomes "`Mirror: not run (<why>)` is not a pass: the change is not done. Say so first, with what would unblock it."; in `inline.md`, one line in the completion contract with the same rule.
- [ ] **Step 2: `npm test`,** commit `feat(implementing): a UI task is not complete without a screenshot`.
- [ ] **Step 3: GREEN.** Run the seam. Expected: `accepted: true`, `devorb` at 67% or 100%. Report the cost and the running total. Below the bar: read the failing evidence, one text round, one more GREEN; then stop.
- [ ] **Step 4: Ledger** in Portuguese, `npm test`, commit `test(implementing): GREEN for the screenshot gate`.

### Task 3: RED for two rounds and the contract (part B)

**Files:**
- Create: `evals-outside/implementing-espelho-em-breve/graders/rounds-min-2.md`, `evals-outside/implementing-espelho-em-breve/graders/vs-contract.md`
- Modify: `evals-outside/implementing-espelho-em-breve/case.yaml` (description only)

**Seam:** `node tools/compare.mjs --skill implementing-espelho --arms devorb --outside-sandbox --runs 2`

**Interfaces:**
- Consumes: nothing from Tasks 1 and 2 beyond HEAD.
- Produces: the RED numbers the owner sees before any GREEN.

- [ ] **Step 1: Two `regex` graders on the trace,** in the style of the case's `report-field`: `rounds-min-2` passes when a write to `task-<n>-report.md` holds `Mirror: rounds [23]/3`; `vs-contract` passes when that line also holds `vs contract:` followed by what was compared. Validate both against the saved traces of `devorb@9af742a` (2026-11-17), which must show the first sometimes passing and the second never.
- [ ] **Step 2: `npm test`,** commit `test(implementing): RED graders for two mirror rounds and the contract`, run the seam, report the cost.
- [ ] **Step 3: Stop.** Show the owner the per-grader numbers and the price of the GREEN before going on.

### Task 4: Two rounds and the contract, GREEN (part B) — only with the owner's go

- [ ] Text in `skills/implementing/prompts/implementer.md` (Mirror steps 4 and 5, the report line), trimmed to what Task 3 showed failing; `npm test`; commit; `node tools/compare.mjs --skill implementing-espelho --arms devorb,none --outside-sandbox --runs 3`; ledger; commit.

## Outcome

- Part A (Tasks 1 and 2): done, in three text versions. RED at `devorb@71404d4`: devorb 0 of 2, none 0 of 2, only grader 1 failing, US$ 7.81. GREEN 1 at `devorb@9607748` (6 graders): 2 of 3, `accepted: true`, US$ 6.25. The branch review and the traces then showed that this first version made agents skip `devorb:ui-review`, left the task with no defined continuation, and did not reach the inline and parallel paths. Graders 3 and 6 were rewritten and graders 7 and 8 added (`5179841`); text v2 (`0652e14`) added the continuation, `inline.md` and `parallel.md`. GREEN 2 at `devorb@6351aee` (8 graders): 1 of 3, `accepted: false`, US$ 9.96. Text v3 (`ac9f167`) gives the first sentence of the final message as a template and names `devorb:ui-review` as working from the code. GREEN 3 at `devorb@ac9f167`: 3 of 3, none 0 of 3, `accepted: true`, US$ 12.58. `implementer.md` was left as it is.
- Cost: item 3 US$ 36.60; front total US$ 80.58, which is US$ 0.58 over the US$ 80 ceiling. The last round was launched with US$ 12.00 left on an estimate of US$ 10.
- Part B (Tasks 3 and 4): not done, by the owner's decision of 2026-11-20. No paid round. The saved traces of `devorb@9af742a` show two or more mirror rounds in 2 of 2 runs, so "at least 2 rounds" has no failing run; the contract critique already happens in `devorb:ui-review` after the task review. The two graders written for Task 3 were not committed.
- The reserved case `implementing-espelho-sem-navegador` was not run (about US$ 11 for 2 runs on a case already at 0%): someone who is not the author should read it against the new gate.
- Stopped before the merge.
