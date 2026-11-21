# Action-result notice is the toast job — plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use devorb:implementing to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `devorb:visual-direction` classify a notice that reports the result of an action as the toast job, so the list's specialist (Sonner) is used instead of a hand-built notice, and close the eval gap `visual-direction-arquitetura-clean` (graders 4 and 6).

**Architecture:** One sentence of rule text in a `visual-direction` reference file, proven first on a cheap cut of the real eval case and then on one full `tools/compare.mjs` round. The ledger gets the corrected diagnosis, the owner's rule and the costs. No code, no eval file and no `SKILL.md` changes in Tasks 1 and 2; the second round (Tasks 3 and 4) changes one grader and two `SKILL.md`.

**Tech Stack:** Markdown skills, `tools/compare.mjs` (`claude plugin eval`, model `claude-opus-5-5` from `fusion/eval-config.json`), Node 22 `node:test` through `npm test`.

**Spec:** `docs/specs/2026-11-20-aviso-de-acao-toast-design.md`

## Global Constraints

- Skill text in English; ledger in Portuguese.
- RED before any skill text. It exists: 9 full runs fail graders 4 and 6, and 3 of 3 capped runs at `devorb@d7dc0a1` write a contract with no specialist (quotes in the spec).
- The eval case keeps its fixture and prompt. Of its graders only `6-newsletter-toast` changes, in Task 3, by the owner's decision of 2026-11-20.
- The eval model stays `claude-opus-5-5`. `fusion/eval-config.json` is not edited.
- Done means the `devorb` arm approves 2 of 3 runs or more on `visual-direction-arquitetura-clean`. `accepted: true` alone is not enough: a 0% versus 0% gap also prints it.
- Paid ceiling US$ 50. Spent before this plan: US$ 9.48, judge cost included. One full GREEN round fits, not two. That was the first estimate only: the first round cost US$ 8.66, and the owner approved a second. Report the real cost after every paid run.
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

---

## Second round (owner's decision, 2026-11-20)

Task 2 ended at its Step 3: 1 of 3 approved at `devorb@31f827d`, US$ 8.66, paid total US$ 21.54. The owner approved three adjustments and one more full round. The spec's section "Segunda rodada" has the reasons; the RED for each is a run of that round, quoted in `fusion/ledger/visual-direction.md`.

### Task 3: Three adjustments

**Files:**
- Modify: `skills/visual-direction/references/sources.md:14`
- Modify: `skills/implementing/SKILL.md:118`
- Modify: `skills/verifying/SKILL.md` (section "Hand-off")
- Modify: `evals/visual-direction-arquitetura-clean/graders/6-newsletter-toast.md` (condition 2 only)

**Seam:** the six graders of `visual-direction-arquitetura-clean` in a full run; for the grader edit, a judge reading the new grader text against two kept files.

**Interfaces:**
- Consumes: nothing from earlier tasks beyond the files as they are at `65f3c82`.
- Produces: the commit whose short sha names the `devorb@<sha>` arm Task 4 runs.

- [ ] **Step 1: `sources.md`.** Replace the bullet that starts "Name each job by what happens on screen" with:

```markdown
- Name each job by what happens on screen, whatever word the spec uses. A notice that reports the result of an action (saved, subscribed, sent, failed on the server) is the toast job: it uses the list's specialist and is never a status line built into the form or the page. A field's validation error stays at the field.
```

- [ ] **Step 2: `implementing/SKILL.md`.** In the paragraph that starts "Your final message has three lists, each exhaustive.", add this sentence at the end of the paragraph:

```markdown
When the plan built or changed a user interface, the message also names the sources: the entries the spec's `Sources:` line lists as consulted and as skipped, by name.
```

- [ ] **Step 3: `verifying/SKILL.md`.** In the section "## Hand-off", add this sentence at the end of its paragraph:

```markdown
For a built or changed interface, the report also names the sources: the entries the spec's `Sources:` line lists as consulted and as skipped, by name.
```

- [ ] **Step 4: Grader 6.** In `6-newsletter-toast.md`, replace the whole item that starts "2. **Sucesso só com resposta de verdade.**" with:

```markdown
2. **Sucesso só com resposta de verdade.** O formulário envia o e-mail para `/api/newsletter` com `POST`, por `fetch` no próprio arquivo ou por uma função importada que ele chama com `await` (por exemplo `await subscribe(email)`, de `@/lib/newsletter`), e só mostra o aviso de sucesso depois de a resposta, ou o resultado dessa função, indicar sucesso. A função importada não aparece neste arquivo: aceite a chamada. Falha se mostra sucesso sem chamar a rota nem uma função de envio, ou antes de ter a resposta.
```

Nothing else in the grader changes: the frontmatter, the context paragraph, condition 1 and the last paragraph stay.

- [ ] **Step 5: `npm test`.** Expected: all tests pass. It also checks each `SKILL.md` against its token ceiling (`implementing` 5,000, `verifying` 2,500).

- [ ] **Step 6: Commit.** `fix(design): toast rule names where the notice does not go; final message names the sources; grader 6 accepts a helper`.

### Task 4: Second full round and the ledger

**Files:**
- Modify: `fusion/ledger/visual-direction.md` (results block of 2026-11-20; rule 6), `fusion/ledger/implementing.md` and `fusion/ledger/verifying.md` (the sources sentence, as an own rule with its case)
- Rewrite: `fusion/results/2026-11-20-visual-direction-arquitetura.md` (written by `tools/compare.mjs`); keep the first round's report as `fusion/results/2026-11-20-visual-direction-arquitetura-primeira-rodada.md`

**Seam:** the same command as Task 2, through the `--keep-temp` wrapper.

**Interfaces:**
- Consumes: Task 3's commit.
- Produces: the report, the per-grader results and the ledger entries.

- [ ] **Step 1: Judge check of the new grader 6,** before paying: a judge given the new grader text and the kept `components/newsletter-form.tsx` of round 1 run 2 (Sonner toast after `await subscribe(email)`) answers PASS; given the kept file of run 3 (hand-built `role="status"` line) it answers FAIL.

- [ ] **Step 2: Rename the first round's report** to `…-arquitetura-primeira-rodada.md`, then run `node tools/compare.mjs --skill visual-direction-arquitetura --arms devorb,none --runs 3`. Expected: `accepted: true` and the `devorb` row at 67% or 100%. Report the cost and the running total.

- [ ] **Step 3: Check the kept build of each run** as in Task 2 Step 2.

- [ ] **Step 4: Ledgers,** in Portuguese: both rounds, each grader per run, the costs, what closed and what stayed open. Below the bar again: write the evidence and stop; no third full round without the owner.

- [ ] **Step 5: `npm test`,** then commit `test(visual-direction): second full round for the toast rule`.

## Outcome

Owner's decision, 2026-11-20: item 1 is accepted as it stands, with grader 6 loosened and `accepted: false`. It is an acceptance, not a GREEN by the house rule.

Round 2 at `devorb@2502b5c` approved 2 of 3 (67%) and `compare.mjs` printed `accepted: false`, because one run hit the case's 1200 s timeout. Paid total: US$ 37.67 of 50. Open items are in `fusion/ledger/visual-direction.md`. Stopped before the merge.
