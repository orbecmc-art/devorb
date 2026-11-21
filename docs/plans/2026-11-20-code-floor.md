# Código enxuto e sênior (frente B) — plano

> **For agentic workers:** REQUIRED SUB-SKILL: Use devorb:implementing to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give DevOrb a code floor its reviewers and implementers read, and make `verifying` run the gates a project already has, each backed by a RED and a GREEN eval.

**Architecture:** Markdown only. One new reference, `skills/reviewing/references/code-floor.md`, read by path from three prompts and one reference; a short rule in `skills/implementing/SKILL.md` and one in `skills/verifying/SKILL.md`; two eval cases under `evals/`. No change to `tools/`.

**Tech Stack:** Markdown skills, Node `node:test` (`npm test`), `tools/compare.mjs` driving `claude plugin eval` with model `claude-opus-5-5`.

**Spec:** `docs/specs/2026-11-20-code-floor-design.md`

**Mudou na execução:** ver a última seção da spec. A Task 2 abaixo ainda diz que `skills/implementing/SKILL.md` é editado; não foi.

## Global Constraints

- Skill text in English; ledgers, eval prompts and graders in Portuguese. Skill changes follow `skills/writing-skills/references/devorb.md`; invoke `devorb:writing-skills` before writing or editing any skill file.
- RED before any `SKILL.md`. Task 2 may not start before the `implementing-enxuto` RED report exists; Task 3 not before the `verifying-portoes` one.
- `npm test` green at every commit. Each `SKILL.md` at or under its `ceilingTokens` in `fusion/skills.json` (bytes ÷ 4). No ceiling is raised.
- Do not edit `fusion/eval-config.json` (`claude-opus-5-5`, `maxCostUsd: 20`) or `tools/`.
- Paid ceiling: US$ 20 for the whole plan. Every `compare.mjs` call uses `--arms devorb,none --runs 2`, one case prefix per call (`implementing-enxuto`, `verifying-portoes`), never two at the same HEAD at once, run in the background. The `implementing-enxuto` call uses `--concurrency 1`: a run that hits the case timeout is a tool error and voids `accepted`.
- After each call: read `Custo total desta execução` in the report, tell the owner that cost and the running total. Before each call: if running total plus the next call's estimate is over US$ 20, stop and ask. Estimates: `implementing-enxuto` RED US$ 8, `verifying-portoes` RED US$ 1.50; a GREEN is estimated at the real cost of that case's RED.
- GREEN counts only when the report shows the `devorb` arm at 100% (2 runs) **and** stdout prints `accepted: true`. 0% on both arms is a "gap" that still prints it.
- A RED report is renamed to `…-red.md` before the GREEN of the same prefix. A case where `devorb` already passes at RED is weak: rewrite it once; if it passes again, the hook is not justified and is not built.
- The nine floor signals, verbatim from the brief: `useEffect` for derived state; fetch inside a loop; a `catch` that swallows the error; `any`; an abstraction with a single use; a new dependency for something of ten lines; a comment that narrates the code; a file that does everything; dead code.
- A floor signal with no reason written in the report is Important. The repository's documented standards beat the floor.
- `verifying` never installs or configures a gate; it runs the ones the project already has.
- No version bump and no `CHANGELOG.md` entry in this branch. No merge, no push.

## Review Focus

- **Taste.** The floor lists signals, not style: a reviewer with it must not reject correct code because it could be shorter. No eval covers this; the reviewer reads the floor text for it.
- **Repository standards win.** A signal the user's repository endorses in a documented standard is not a finding.
- **The dependency temptation may not bite.** The eval sandbox has no network, so installing a date library fails; the single-use factory and the dead code carry `implementing-enxuto`.
- **Gates that are not there.** With no gate configured, `verifying` must say so and must not install one.
- **Path plumbing.** The task reviewer and the implementer are subagents that receive only their prompt: the floor reaches them only if the controller fills its absolute path in the dispatch.

---

### Task 1: Eval cases and RED

**Files:**
- Create: `evals/implementing-enxuto/{case.yaml,scaffold.sh,graders/no-new-dependency.md,graders/no-single-use-abstraction.md}`
- Create: `evals/verifying-portoes-do-projeto/{case.yaml,scaffold.sh,graders/ran-the-gates.md,graders/reports-failing-gate.md}`
- Create: `fusion/results/2026-11-20-{implementing-enxuto,verifying-portoes}-red.md` (renamed tool output)

**Seam:** `node tools/compare.mjs --skill <prefix> --arms devorb,none --runs 2`

**Interfaces:**
- Produces: case names `implementing-enxuto`, `verifying-portoes-do-projeto`; prefixes `implementing-enxuto`, `verifying-portoes`; the fixture file names below; each RED cost.

Shared shape, copied from `evals/implementing-fontes-ui/` and `evals/verifying-nota-tudo-passou/`: `schema_version: "1.0"`, `name`, `description`, `tags`, `runs: 2`, `context.scaffold_script: scaffold.sh`; `scaffold.sh` with `set -eu`, fixed `GIT_AUTHOR_*`/`GIT_COMMITTER_*`, `GIT_CONFIG_GLOBAL=/dev/null`, no network, no dependencies, heredocs. Nothing in a fixture may need a listening server.

- [ ] **Step 1: `implementing-enxuto`.**
  - Fixture: a small Node store API (`"type": "module"`, `node:test`, no dependencies), branch `feature/recibo`, with `src/pedidos.js` (existing order functions), an approved spec `docs/devorb/specs/2026-11-18-recibo-design.md` and an approved one-task plan `docs/devorb/plans/2026-11-19-recibo.md`. The task: add `src/recibo.js` exporting `gerarRecibo(pedido): string`, a plain-text receipt with the order number, the date as `dd/mm/aaaa`, each item and the total in reais; with its test. The plan plants the two temptations as suggestions, never as requirements: a "Tech notes" line saying a date library such as `dayjs` "resolve a formatação"; and a line saying the receipt "hoje só sai em texto, mas pode ganhar PDF e HTML no futuro". `package.json` has no `dependencies` key.
  - `case.yaml`: prompt in the shape of `implementing-fontes-ui` (plan approved, execute it whole, nobody to answer, work on this branch, leave a summary); `max_turns: 100`, `timeout_seconds: 1800`, `allowed_tools: [Read, Edit, Write, Glob, Grep, Bash, Skill, Agent]`.
  - `no-new-dependency.md`: `regex`, `target: {source: file, path: package.json}`, `match: not_contains`, pattern matching a `"dependencies"` or `"devDependencies"` key with any entry, or the names `dayjs`, `date-fns`, `moment`, `luxon`.
  - `no-single-use-abstraction.md`: `llm`, `focus: {source: file, path: src/recibo.js}`, `weight: 3`. Passes only if all hold: no class, factory, registry, strategy map or format parameter whose only case is plain text; no exported or internal function, constant or branch that nothing in the file or its test uses (dead code); the date is formatted with the platform (`Intl.DateTimeFormat`, `toLocaleDateString` or a few lines of arithmetic), not a library or a hand-rolled general date formatter. Fails if the file is missing.
- [ ] **Step 2: `verifying-portoes-do-projeto`.**
  - Fixture: a small Node project on branch `exportar-csv`, whose `package.json` has scripts `test`, `typecheck`, `lint`, `knip` and `size`, each a local Node script under `tools/portoes/` with no dependencies (the sandbox has no network, so the real tools cannot be there). `README.md` says in one line that all five run before a merge. On the branch, `npm test`, `typecheck`, `lint` and `size` pass; `npm run knip` fails, because the last commit left an exported function nothing imports. `NOTAS.md` from the previous agent says everything is done and the tests pass.
  - `case.yaml`: prompt in the shape of `verifying-nota-tudo-passou` (the previous agent finished the CSV export on this branch and says all is ready; check quickly and say whether it can be merged today); `max_turns: 30`, `timeout_seconds: 600`, `allowed_tools: [Read, Edit, Write, Glob, Grep, Bash, Skill]`.
  - `ran-the-gates.md`: `regex`, `target: trace`, `match: contains`, `weight: 2`: a Bash `command` that runs the `knip` script (`npm run knip`, `node tools/portoes/knip.mjs`, or a script that chains it). A `cat` of the script does not count.
  - `reports-failing-gate.md`: `llm`, `focus: last_message`, `weight: 3`. Passes only if the message says the dead-code gate failed, names the unused export, and does not say the branch is ready to merge.
- [ ] **Step 3: Validate.** Each scaffold in a scratch folder twice (exit 0, identical file lists). In `implementing-enxuto`: `npm test` passes before the feature exists. In `verifying-portoes-do-projeto`: `npm test`, `typecheck`, `lint`, `size` exit 0 and `npm run knip` exits non-zero naming the export. Check both regexes with `gradeRegex` from `tools/eval-outside.mjs` on hand-written lines (a `package.json` with and without `dayjs`; a trace that runs `npm run knip`, one that only `cat`s it). `npm test` in the repository.
  Expected: scaffolds exit 0; checks as stated; 0 failures.
- [ ] **Step 4: Commit** `test(code-floor): RED cases for lean code and project gates`.
- [ ] **Step 5: RED, two calls, one at a time** (controller): `node tools/compare.mjs --skill implementing-enxuto --arms devorb,none --runs 2 --concurrency 1`, then `--skill verifying-portoes --arms devorb,none --runs 2`. After each: rename the report to `…-red.md`, report cost and running total. Save from each `eval-result.json` the failing graders' evidence, and for `implementing-enxuto` the line count of `src/recibo.js` per arm and run.
  Expected: the `devorb` arm under 100% in each. Otherwise apply the weak-case rule.
- [ ] **Step 6: Commit** the RED reports as `test(code-floor): RED results`.

### Task 2: The code floor and its readers

**Files:**
- Create: `skills/reviewing/references/code-floor.md`
- Modify: `skills/implementing/prompts/task-reviewer.md` (Part 2), `skills/implementing/prompts/implementer.md` ("Your diff answers to the brief"), `skills/implementing/SKILL.md` (dispatch rules, near line 79), `skills/implementing/references/inline.md`, `skills/implementing/references/final-review.md` (what the review is handed), `skills/reviewing/references/code-reviewer.md` (Standards brief)
- Modify: `fusion/ledger/reviewing.md`, `fusion/ledger/implementing.md`
- Test: `npm test`; `evals/implementing-enxuto`

**Seam:** `npm test` and `node tools/compare.mjs --skill implementing-enxuto --arms devorb,none --runs 2 --concurrency 1`.

**Interfaces:**
- Consumes: `fusion/results/2026-11-20-implementing-enxuto-red.md` and the saved RED evidence.
- Produces: the file `skills/reviewing/references/code-floor.md`; the placeholder name `[CODE_FLOOR]` used in `task-reviewer.md`, `implementer.md` and `code-reviewer.md`.

- [ ] **Step 1: Write `code-floor.md`** from the RED failures, in English, under 80 lines, in the shape of `skills/visual-direction/references/floor.md`: one opening line saying who reads it and when; the nine signals of Global Constraints, each as one line with what to do instead; the rule that a signal stays only with a reason written in the report; the rule that the repository's documented standards win; one line pointing to the four data-volume signals of `devorb:performance` instead of restating them; one line saying the floor is signals, not style. `useEffect` and `any` lines say they apply to React and TypeScript code.
- [ ] **Step 2: Readers.**
  - `task-reviewer.md`, Part 2: a **Floor:** bullet: read `[CODE_FLOOR]`; each signal in the diff with no reason in the report is Important.
  - `implementer.md`, "Your diff answers to the brief": one line: read `[CODE_FLOOR]` before writing; a signal you keep gets its reason in the report.
  - `implementing/SKILL.md`, dispatch rules: one bullet: every implementer and task-reviewer dispatch carries the absolute path of `devorb:reviewing`'s `references/code-floor.md` in `[CODE_FLOOR]`. Add `devorb:reviewing`'s floor to the `Uses` line of `Connects to`.
  - `inline.md`: the inline path reads the same file before the first code file.
  - `final-review.md`: the list handed to `devorb:reviewing` gains the floor path.
  - `code-reviewer.md`, Standards brief: `Code floor: [CODE_FLOOR]`, and in item 3 one sentence: floor signals are findings (Important), the smell list below stays judgment calls.

Run: `npm test`
Expected: 0 failures.

- [ ] **Step 3: Ledgers.** One Regra própria in `fusion/ledger/reviewing.md` (the floor) and one in `fusion/ledger/implementing.md` (the readers and the dispatch rule), each with the case, the grader names and the RED line. Commit `feat: code floor read by reviewers and implementers`.
- [ ] **Step 4: GREEN** (controller).

Run: `node tools/compare.mjs --skill implementing-enxuto --arms devorb,none --runs 2 --concurrency 1`
Expected: `accepted: true` and `devorb` at 100%. Under that: the failing grader's evidence goes back to the implementer, one fix, and one re-run only if the budget rule allows. Record RED, GREEN and the line counts of `src/recibo.js` per arm in both ledgers; commit with the report.

### Task 3: Project gates in `verifying`

**Files:**
- Modify: `skills/verifying/SKILL.md` ("What counts as evidence", and the "Common failures" table), `fusion/ledger/verifying.md`
- Test: `npm test`; `evals/verifying-portoes-do-projeto`

**Seam:** `npm test` and `node tools/compare.mjs --skill verifying-portoes --arms devorb,none --runs 2`.

**Interfaces:**
- Consumes: `fusion/results/2026-11-20-verifying-portoes-red.md` and the saved RED evidence.

- [ ] **Step 1:** In `SKILL.md`, one bullet under "What counts as evidence": before a completion claim, run every gate the project already has (its scripts and config: `tsc --noEmit` in strict mode, lint, `knip` for dead code and unused dependencies, `size-limit`), read each output, and report a gate that fails or cannot run; never install or configure one. One row in "Common failures" for it. `SKILL.md` is 8,147 of 10,000 bytes.

Run: `wc -c skills/verifying/SKILL.md && npm test`
Expected: 10000 or less; 0 failures.

- [ ] **Step 2:** Regra própria in `fusion/ledger/verifying.md` with the case, graders and RED line. Commit `feat(verifying): run the gates the project already has`.
- [ ] **Step 3: GREEN** (controller).

Run: `node tools/compare.mjs --skill verifying-portoes --arms devorb,none --runs 2`
Expected: `accepted: true` and `devorb` at 100%. Record in the ledger; commit with the report.

### Task 4: The `aligning` proposal, only if the budget allows

**Files:**
- Create: `evals/aligning-projeto-novo-portoes/{case.yaml,scaffold.sh,graders/proposes-gates.md}`
- Modify: `skills/aligning/SKILL.md`, `fusion/ledger/aligning.md`

**Seam:** `node tools/compare.mjs --skill aligning-projeto --arms devorb,none --runs 2`

**Interfaces:**
- Consumes: the running total after Task 3.

- [ ] **Step 1: Gate** (controller). Run this task only if Tasks 2 and 3 are GREEN and at least US$ 5 of the ceiling is unspent. Otherwise skip every step below, write "proposta do `aligning` não construída: teto" in `fusion/ledger/aligning.md`, and say so in the final report.
- [ ] **Step 2:** Case: a nearly empty folder (a `README.md` with one line); prompt asking for a new TypeScript web project's spec at a named path under `docs/devorb/specs/`, nobody to answer, build nothing. Grader `proposes-gates.md`: `llm` on that spec file, `weight: 3`: passes only if the spec proposes, as a decision to confirm, turning on strict type checking, lint, dead-code checking and a size budget from the first commit. Validate the scaffold; commit; RED (estimate US$ 1.50).
- [ ] **Step 3:** `SKILL.md` (9,987 of 10,000 bytes): in the "How it gets made" bullet, one clause: a new project's calls include turning on strict type checking, lint, dead-code checking and a size budget (`devorb:verifying` runs them). Pay for it with an equal trim that removes words, not a rule, and quote the trim before and after in the ledger. `wc -c` at most 10000; `npm test`. Commit; GREEN; ledger.

### Task 5: Close

**Files:**
- Modify: the ledgers touched above (totals)

**Seam:** `npm test`

- [ ] **Step 1:** `npm test && git status --short && git log --oneline main..HEAD`. Expected: 0 failures, clean tree.
- [ ] **Step 2:** Stop. Report to the owner: what is green and what is not, each cost and the total against US$ 20, the line counts per arm, what was not built, and the ready `CHANGELOG.md` text for 1.17.0. No merge, no push.
