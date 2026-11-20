# Action-result notice is the toast job — plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use devorb:implementing to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `devorb:visual-direction` classify a notice that reports the result of an action as the toast job, so the list's specialist (Sonner) is used instead of a hand-built notice, and close the eval gap `visual-direction-arquitetura-clean` (graders 4 and 6).

**Architecture:** One sentence of rule text in a `visual-direction` reference file, proven first on a cheap cut of the real eval case and then on one full `tools/compare.mjs` round. The ledger gets the corrected diagnosis, the owner's rule and the costs. No code, no eval file and no `SKILL.md` changes.

**Tech Stack:** Markdown skills, `tools/compare.mjs` (`claude plugin eval`, model `claude-opus-5-5` from `fusion/eval-config.json`), Node 22 `node:test` through `npm test`.

**Spec:** `docs/specs/2026-11-20-aviso-de-acao-toast-design.md`

## Global Constraints

- Skill text in English; ledger in Portuguese.
- RED before any skill text. It exists: 9 full runs fail graders 4 and 6, and 3 of 3 capped runs at `devorb@d7dc0a1` write a contract with no specialist (quotes in the spec).
- The eval case stays as it is: no change to its fixture, prompt or graders.
- The eval model stays `claude-opus-5-5`. `fusion/eval-config.json` is not edited.
- Done means the `devorb` arm approves 2 of 3 runs or more on `visual-direction-arquitetura-clean`. `accepted: true` alone is not enough: a 0% versus 0% gap also prints it.
- Paid ceiling US$ 50. Spent before this plan: US$ 9.47. One full GREEN round fits, not two. Report the real cost after every paid run.
- One `tools/compare.mjs` per HEAD at a time.
- A field's validation error stays at the field. A rule that sends it to a toast fails the plan.
- `npm test` green. No version bump and no `CHANGELOG.md` entry: the brief puts both after the owner's merge.
- Stop before the merge.

## Review Focus

- **Toast with no `<Toaster />` mounted.** Grader 6 reads only `components/newsletter-form.tsx`; a `toast()` call with no `<Toaster />` in `app/layout.tsx` shows nothing. Task 2 checks the kept work folder of each passing run for it.
- **Field errors moved to a toast.** Task 1's capped loop reads the contract's `States:` line: the 400 "E-mail inválido." stays at the field.
- **Other `visual-direction` cases** (`receitas-landing`, `guia-leigo`, the reserved `guia-restaurante`): not re-run, the ceiling does not fit them. Said in the final report as not checked.
- **Operate surfaces.** The rule is written for dashboards too, and no eval case exercises it there. Item 2 of front C (`visual-direction-tabela-operacao`) is where that gets a case.
- **The capped loop reads the contract, not the build.** A contract that names Sonner can still end in a hand-built notice; only Task 2 proves the build.

---

### Task 1: The rule, proven on the capped loop

**Files:**
- Modify: `skills/visual-direction/references/sources.md` (section "Choosing libraries, per job")

**Seam:** the `Sources:` and `States:` lines of the `## Direção visual` contract written by the agent in the real eval case, read from the kept trace.

**Interfaces:**
- Consumes: the throwaway harness `capped.mjs` in the session scratchpad. It calls `prepareArm` and `evalArgs` from `tools/compare.mjs`, lowers `max_turns` from 60 to 20 in the arm's copy of the case only, runs `claude plugin eval` with `--keep-temp`, and prints each run's specialist sentence and cost. Usage: `node <scratchpad>/capped.mjs <runs> <max_turns> <label>`. Baseline output is saved as `capped-baseline.json` beside it.
- Produces: the commit whose short sha names the `devorb@<sha>` arm Task 2 runs.

- [ ] **Step 1: RED is on record.** No new test to write. Baseline, 3 of 3: "Especialista: nenhum; o aviso da newsletter fica junto do formulário, em texto com `aria-live`, porque um toast some antes de ser lido e o Sonner não está instalado."

- [ ] **Step 2: Add the rule to `sources.md`.** New bullet right after "Start from what the interface needs done…", with this copy:

```markdown
- Name each job by what happens on screen, whatever word the spec uses. A notice that reports the result of an action (saved, subscribed, sent, failed on the server) is the toast job and uses the list's specialist. A field's validation error stays at the field.
```

- [ ] **Step 3: `npm test`.** Expected: all tests pass.

- [ ] **Step 4: Commit.** `feat(visual-direction): an action-result notice is the toast job`.

- [ ] **Step 5: Capped GREEN.** Run `node <scratchpad>/capped.mjs 3 20 green`. Expected, in 3 of 3 runs: the contract names Sonner as the specialist for the newsletter notice and `sonner` as a new library, and its `States:` line keeps the 400 error at the field. Report the cost.

- [ ] **Step 6: If a run still writes no specialist,** quote its sentence, add the counter for that one rationalization to the same bullet (positive wording, one clause), commit, and repeat Step 5. Two text rounds at most; after the second, stop and report to the owner.

### Task 2: Full GREEN and the ledger

**Files:**
- Modify: `fusion/ledger/visual-direction.md` (own rule 5: the diagnosis; a new owner rule 6; a results block dated 2026-11-20)
- Create: `fusion/results/2026-11-20-visual-direction-arquitetura.md` (written by `tools/compare.mjs`)
- Keep: `fusion/results/2026-11-20-visual-direction-arquitetura-1rodada.md` (the diagnostic round, already on disk)

**Seam:** `node tools/compare.mjs --skill visual-direction-arquitetura --arms devorb,none --runs 3`, run through `runCli` with a `claude` wrapper that appends `--keep-temp`, so each run's work folder stays for the `<Toaster />` check.

**Interfaces:**
- Consumes: Task 1's commit.
- Produces: the report file, the per-grader results in `.arms/devorb@<sha>/eval-result.json`, and the ledger entry.

- [ ] **Step 1: Run the full round.** Expected: `accepted: true`, and in the report `visual-direction-arquitetura-clean | devorb@<sha> | 67%` or `100%`. Report the cost of the round and the running total.

- [ ] **Step 2: Check the build of each passing run.** In its kept folder (`tracePath` in `eval-result.json` gives it): `package.json` declares `sonner`; `components/newsletter-form.tsx` calls `toast` after the response says ok; `<Toaster />` is mounted in `app/layout.tsx` or the page; the invalid e-mail error is shown at the field. Read files only; run no git inside a kept folder.

- [ ] **Step 3: If the round is below 2 of 3,** read which grader failed and why from `eval-result.json` and the kept traces, write that in the ledger as an open gap with the evidence, and stop: a second full round does not fit the ceiling.

- [ ] **Step 4: Ledger.** In rule 5, replace "nenhuma regra faz o Sonner entrar sem rede" with what the traces show (the agent never chose Sonner; it kept the notice in the form). Add rule 6, "Regra do dono: aviso de resultado de ação é trabalho de toast", with the owner's decision of 2026-11-20, the case, the three baseline sentences and the limit (field validation stays at the field). Add the 2026-11-20 results: diagnostic round, capped baseline, capped GREEN, full GREEN, each with its cost, the total, and what was not re-run.

- [ ] **Step 5: `npm test`,** then commit `test(visual-direction): GREEN for the action-result toast rule` with the ledger and both result files.
