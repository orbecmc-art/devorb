# Performance desde o projeto (frente A) — plano

> **For agentic workers:** REQUIRED SUB-SKILL: Use devorb:implementing to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add the `devorb:performance` skill, its hooks in six existing skills and four eval cases, so DevOrb designs for the real data volume and proves speed with a number.

**Architecture:** Markdown only: one new skill folder with three recipe references, short hooks in existing skill files, eval cases under `evals/` and `evals-reserved/`. No change to `tools/`. Every `SKILL.md` edit is preceded by a RED run of its case and followed by a GREEN run.

**Tech Stack:** Markdown skills, Node `node:test` (`npm test`), `node:sqlite` in eval fixtures, `tools/compare.mjs` driving `claude plugin eval` with model `claude-opus-5-5`.

**Spec:** `docs/specs/2026-11-20-performance-design.md`

## Global Constraints

- Skill text in English; ledgers, eval prompts and graders in Portuguese. Skill changes follow `skills/writing-skills/references/devorb.md`; invoke `devorb:writing-skills` before writing or editing any skill file.
- RED before any `SKILL.md`. Tasks 2, 3 and 4 may not start until Task 1's RED reports exist.
- `npm test` green at every commit. Each `SKILL.md` at or under its `ceilingTokens` in `fusion/skills.json`. No ceiling is raised. Base description budget: 706 tokens (635 used today).
- Do not edit `fusion/eval-config.json` (`claude-opus-5-5`, `maxCostUsd: 20`) or `tools/compare.mjs`.
- Paid ceiling: US$ 40 for the whole plan. Every `compare.mjs` call uses `--arms devorb,none --runs 2`, one case prefix per call. Never two calls at the same HEAD at once. Run each in the background and wait for it.
- After each call: read `Custo total desta execução` in the report, tell the owner that cost and the running total. Before each call: if running total plus the next call's estimate is over US$ 40, stop and ask. Estimate of a RED call: US$ 8. Estimate of a GREEN call: the real cost of that case's RED call.
- GREEN counts only when the report shows the `devorb` arm at 2/3 approval or more **and** stdout prints `accepted: true`. `accepted: true` alone is not enough: 0% on both arms is a "gap" and still prints it.
- A RED report is renamed to `…-red.md` before the GREEN of the same prefix, because same-day reports overwrite each other.
- Default budget (owner's): search under 200 ms at the server's p95; response to typing under 100 ms; INP under 200 ms.
- No version bump and no `CHANGELOG.md` entry in this branch. No merge, no push.
- Whoever writes the skill never opens `evals-reserved/` or its graders.

## Review Focus

- **Small list.** The skill must not push FTS, cursors or virtualization onto a list that stays under about 1,000 rows in a year: there it asks only for a limit on the query. No eval covers this; the reviewer reads the skill text for it.
- **Search location.** With a server and a database, search runs in the database. The browser recipe applies only without one, or to a small list already whole on screen. 20,000 × 85 behind a route is a database case.
- **Trimmed text in `using-devorb` and `aligning`.** The 17 and 2 existing cases are not re-run. The trims are listed in each ledger and shown to the owner in the final report.
- **The order regex.** `measures-before-edit` must pass a measure-then-edit trace and fail an edit-then-measure one; Task 1 checks both with hand-written traces.
- **Fixture needs `node:sqlite`.** A scaffold that fails is a tool error and blocks `accepted`; each `scaffold.sh` checks for the module first and exits with a clear message.

---

### Task 1: Eval cases and RED

**Files:**
- Create: `evals/performance-busca-planilha/{case.yaml,scaffold.sh,graders/measures-before-edit.md,graders/search-in-database.md,graders/reports-medians.md}`
- Create: `evals/aligning-volume-de-dados/{case.yaml,scaffold.sh,graders/volume-and-budget.md}`
- Create: `evals/reviewing-consulta-sem-limite/{case.yaml,scaffold.sh,graders/finds-both-blocking.md,graders/no-source-edits.md}`
- Create (by a fresh subagent, never opened by the controller): `evals-reserved/performance-<slug>/…`
- Create: `fusion/results/2026-11-20-{performance,aligning-volume,reviewing-consulta}-red.md` (renamed tool output)

**Seam:** `node tools/compare.mjs --skill <prefix> --arms devorb,none --runs 2`

**Interfaces:**
- Produces: case names `performance-busca-planilha`, `aligning-volume-de-dados`, `reviewing-consulta-sem-limite`; prefixes `performance`, `aligning-volume`, `reviewing-consulta`; fixture file names below; the RED cost of each case, used as the GREEN estimate.

Shared shape for every case, copied from `evals/reviewing-cupom-desconto/`: `schema_version: "1.0"`, `name`, `description`, `tags: [<skill>]`, `runs: 2`, `context.scaffold_script: scaffold.sh`; `scaffold.sh` with `set -eu`, fixed `GIT_AUTHOR_*`/`GIT_COMMITTER_*`, `GIT_CONFIG_GLOBAL=/dev/null`, no network, files written with heredocs, and first line of work `node -e "require('node:sqlite')" || { echo "node:sqlite ausente: precisa de Node 22.13+"; exit 1; }`.

- [ ] **Step 1: `performance-busca-planilha`.**
  - Fixture: `package.json` (`"type": "module"`, scripts `test`, `start`), `scripts/gerar.mjs` (seeded PRNG; builds `data/planilha.db`, table `planilha` with `id` plus 84 columns `c01`…`c84` of names, cities, codes, dates and amounts in Portuguese; 20,000 rows), `src/planilha.js` exporting `buscar(termo)` that runs `SELECT * FROM planilha` and filters every column in JS with `toLowerCase().includes`, `src/servidor.js` (`node:http`, `GET /api/busca?q=` returns everything `buscar` returns, serves `public/`), `public/app.js` (fetches on every keystroke and renders one `<tr>` per row with all 85 cells), `test/planilha.test.js` (three `node:test` cases on `buscar`: a known name is found, accents and case are ignored, an unknown term returns empty). `scaffold.sh` runs `node scripts/gerar.mjs` and commits everything except `data/`.
  - `case.yaml`: prompt exactly `O cliente reclama que a busca da planilha demora. Resolve. Hoje não consigo responder perguntas.`; `max_turns: 60`, `timeout_seconds: 1200`, `allowed_tools: [Read, Edit, Write, Glob, Grep, Bash, Skill]`.
  - `measures-before-edit.md`: `regex`, `target: trace`, `match: contains`, `weight: 2`. Same tempered-lookahead structure as `evals/visual-direction-arquitetura-clean/graders/1-sources-before-code.md`. Forbidden-before event: Edit, Write or MultiEdit whose `file_path` is under `src/` or `public/`. Required earlier event: a Bash `command` containing one of `performance.now`, `console.time`, `hrtime`, `Date.now`, `time ` as a command word, `curl` with `-w`, `hyperfine`, `autocannon`, or running a script whose name contains `bench`, `medi`, `measure`, `perf` or `tempo`. The body says, in Portuguese, that writing a new measuring script outside `src/` and `public/` first is allowed.
  - `search-in-database.md`: `llm`, `focus: {source: file, path: src/planilha.js}`, `weight: 3`. Passes only if all three hold: the search term is matched by the database (an FTS5 `MATCH`, or a comparison against an indexed search column), never by loading rows and filtering in JS, and never by `LIKE` over all 84 columns; the query has a `LIMIT` (or keyset/cursor page); the `SELECT` names its columns and does not return all 85.
  - `reports-medians.md`: `llm`, `focus: last_message`. Passes only if the message gives a median time before and a median time after, both as numbers with a unit, and the number of runs behind them.
- [ ] **Step 2: `aligning-volume-de-dados`.**
  - Fixture: a small panel repo: `README.md` (painel interno de uma distribuidora, Node + SQLite), `db/schema.sql` with table `clientes` (`id`, `nome`, `cnpj`, `cidade`, `telefone`, `email`, `criado_em`), `db/seed.sql` with 12 rows, `src/servidor.js` with one existing route. Nothing in the repo states how many customers the business has.
  - `case.yaml`: prompt `Preciso de uma tela de clientes com busca no painel. Hoje não consigo responder perguntas: decide o que faltar e deixa a spec pronta em docs/devorb/specs/2026-11-20-tela-clientes-design.md para eu aprovar amanhã. Não constrói nada ainda.`; `max_turns: 30`, `timeout_seconds: 900`, `allowed_tools: [Read, Edit, Write, Glob, Grep, Bash, Skill, Agent]`.
  - `volume-and-budget.md`: `llm`, `focus: {source: file, path: docs/devorb/specs/2026-11-20-tela-clientes-design.md}`, `weight: 3`. Passes only if the spec (a) states a number of customers today and a number for a later horizon, each marked as an assumption or as measured, and (b) states a time budget for the search as a number with a unit. "Deve ser rápida" with no number fails. A missing file fails.
- [ ] **Step 3: `reviewing-consulta-sem-limite`.**
  - Fixture: Node + `node:sqlite` store API on `main` with tables `pedidos` and `clientes`, an approved spec `docs/devorb/specs/2026-11-12-relatorio-pedidos-design.md` (a report page listing the store's orders with the customer name), and branch `feature/relatorio-pedidos` that adds `src/relatorio.js`: `listarPedidos()` runs `SELECT * FROM pedidos` with no limit, then, inside a `for` over the rows, one `SELECT nome FROM clientes WHERE id = ?` per order. Tests pass with a three-row seed.
  - `case.yaml`: same prompt shape as `reviewing-cupom-desconto` with the branch and spec names swapped; `max_turns: 40`, `timeout_seconds: 900`, `allowed_tools: [Read, Glob, Grep, Bash, Skill, Agent]`.
  - `finds-both-blocking.md`: `llm`, `focus: last_message`, `weight: 3`. Passes only if the review points out (a) the query per order inside the loop and (b) the `SELECT *` with no limit, and gives each an explicit blocking severity: Critical or Important, or an equivalent such as crítica, alta or bloqueante. Minor, a suggestion or a question fails.
  - `no-source-edits.md`: copy of `evals/reviewing-cupom-desconto/graders/no-source-edits.md`.
- [ ] **Step 4: Validate.** For each case: `d=$(mktemp -d) && (cd "$d" && bash <repo>/evals/<case>/scaffold.sh)` exits 0, and in the `performance` fixture `npm test` passes and `node -e` timing of `buscar('silva')` returns rows. Check the order regex with `gradeRegex` from `tools/eval-outside.mjs` (read its signature first) against two hand-written traces: Bash with `performance.now` then Edit of `src/planilha.js` passes; the reverse order fails. Run `npm test`.
  Expected: scaffolds exit 0; regex check prints pass then fail; `npm test` 0 failures.
- [ ] **Step 5: Reserved case.** Dispatch a fresh general-purpose subagent. Give it only: the "Intenção" and "A skill `performance`" sections of the spec, the case format (`evals/reviewing-cupom-desconto/` as the model), the three `evals/` case names to stay away from, and this brief: write one case `evals-reserved/performance-<slug>/` for a different scenario than a slow spreadsheet search (a different recipe: reads or lists), `runs: 2`, validate its `scaffold.sh` in a temp folder, run `npm test`, report only the case name and the two exit codes. The controller does not read the files.
- [ ] **Step 6: Commit.**

```bash
git add evals/performance-busca-planilha evals/aligning-volume-de-dados evals/reviewing-consulta-sem-limite evals-reserved
git commit -m "test(performance): RED cases for data volume, search and unbounded queries"
```

- [ ] **Step 7: RED, three calls, one at a time.**

Run: `node tools/compare.mjs --skill performance --arms devorb,none --runs 2`, then `--skill aligning-volume`, then `--skill reviewing-consulta`. After each: rename `fusion/results/2026-11-20-<prefix>.md` to `…-red.md`, report cost and running total to the owner.
Expected: in each report the `devorb` arm is under 2/3. A case where `devorb` already passes is weak: rewrite its fixture or grader once and re-run that call. If it passes again, stop and take it to the owner (spec, Testes, item 3).

- [ ] **Step 8: Commit** `fusion/results/*-red.md` as `test(performance): RED results`.

### Task 2: The `performance` skill, its registry entry and its route

**Files:**
- Create: `skills/performance/SKILL.md`, `skills/performance/references/{search,reads,lists}.md`
- Create: `fusion/ledger/performance.md`
- Modify: `fusion/skills.json` (new entry), `skills/using-devorb/SKILL.md:30,39,59,72`, `tests/layout.test.mjs:123-126`, `fusion/ledger/using-devorb.md`
- Test: `npm test`; `evals/performance-busca-planilha`

**Seam:** `npm test` (`tools/check-skills.mjs`, `tests/bootstrap.test.mjs`, `tests/layout.test.mjs`) and `node tools/compare.mjs --skill performance --arms devorb,none --runs 2`.

**Interfaces:**
- Consumes: RED report `fusion/results/2026-11-20-performance-red.md` (the failures to answer, word for word).
- Produces: skill name `devorb:performance`; reference paths `references/search.md`, `references/reads.md`, `references/lists.md`; the plan field name `**Performance budget:**`; the four review signals, worded once here and reused verbatim by Tasks 4 and 5: "a query with no limit; a query per row inside a loop (N+1); a filter or sort with no index; a list with neither pagination nor virtualization".

- [ ] **Step 1: Failing tests.** In `tests/layout.test.mjs` rename the test to "registry has the 20 base skills…" and assert `base.length === 20`. Add to `fusion/skills.json`: `"performance": { "invocation": "auto", "level": "full", "ceilingTokens": 2500, "status": "done" }`.

Run: `npm test`
Expected: FAIL (`performance`: folder missing; bootstrap does not name `devorb:performance`).

- [ ] **Step 2: Write `skills/performance/SKILL.md`** from the RED failures, in English, under 2,500 tokens. Frontmatter `name: performance`; description exactly: `Use when designing, planning or fixing anything that reads, lists, searches or filters stored data, or when a screen or query is slow`. Body: the five steps of the spec's "A skill `performance`" in that order (volume and budget; where each read runs; the recipe; the budget written into spec and plan task; the proof), the default budget values from Global Constraints, the small-list rule (under about 1,000 rows in a year: only a limit on the query), the two proofs (faster: median before and after through `devorb:verifying`, measured before the first edit; fits the budget: at least 100 requests with varied real terms at real volume, p95 against the budget), a pointer to each reference saying when to read it, and `## Connects to` (Receives: `devorb:aligning`, `devorb:planning`, `devorb:debugging`; Uses: the three references; Hands off to: `devorb:verifying`).
- [ ] **Step 3: Write the three references**, each under 100 lines, with the values the spec pins:
  - `search.md`: Postgres: generated `search_text` column (searchable columns only, unaccented, lower-case) with a `pg_trgm` or full-text index. SQLite: FTS5. Browser, only without a server database or for a small list already on screen: index built once, debounce, Web Worker above about 50,000 rows. Other databases: one line, same idea with the equivalent index.
  - `reads.md`: cursor pagination; only the displayed columns; never `select *` without a limit; N+1 replaced by a join or a batched load; an index for every filter and every sort.
  - `lists.md`: virtualization for a long list; only visible rows in the DOM.
- [ ] **Step 4: Route in `skills/using-devorb/SKILL.md`**, paid for with trims (file is 3,494 of 3,500 bytes). Add after the `devorb:verifying` row: `| Data read, listed or searched | \`devorb:performance\` |`. Trim: line 59 to `STOP, you're rationalizing:`; line 30 "even a small feature" to "even small"; line 72 to `- \`references/phase-boundaries.md\`: at a phase boundary.`

Run: `wc -c skills/using-devorb/SKILL.md`
Expected: 3500 or less.

- [ ] **Step 5: Run tests.**

Run: `npm test`
Expected: 0 failures.

- [ ] **Step 6: Ledgers.** `fusion/ledger/performance.md` with the sections of `fusion/ledger/verifying.md` (Origem por parte, Conflitos resolvidos, Regras próprias, Fora, Resultados, Decisões por commit de fonte). No external source: every rule is a Regra própria citing the real case (table of 20 mil × 85) and `evals/performance-busca-planilha`. In `fusion/ledger/using-devorb.md`: the new route and the three trims, quoted before and after, with the note that the 17 existing cases were not re-run (owner decision, 2026-11-20).
- [ ] **Step 7: Commit** `feat: add performance`.
- [ ] **Step 8: GREEN.**

Run: `node tools/compare.mjs --skill performance --arms devorb,none --runs 2`
Expected: stdout `accepted: true` and the report row for `devorb` at 100% (with 2 runs, 50% is under the 2/3 bar). Under that, read the failing grader, fix the skill text (not the grader), commit, and re-run once if the budget rule allows. Report cost and running total.

- [ ] **Step 9: Record** RED and GREEN (sha, pass rates, cost, report paths) in `fusion/ledger/performance.md`; commit with the GREEN report.

### Task 3: Hook in `aligning`

**Files:**
- Modify: `skills/aligning/SKILL.md` (the "Ground to cover" bullet; `## Connects to`, lines 66-67), `fusion/ledger/aligning.md`
- Test: `evals/aligning-volume-de-dados`

**Seam:** `node tools/compare.mjs --skill aligning-volume --arms devorb,none --runs 2`

**Interfaces:**
- Consumes: `devorb:performance` (Task 2); `fusion/results/2026-11-20-aligning-volume-red.md`.

- [ ] **Step 1:** In the "Ground to cover" bullet, append before the final period: `; for stored data, its volume now and in a year and the wait they accept (\`devorb:performance\`), assumed and recorded when no one answers`. Pay for it (file is 9,990 of 10,000 bytes) in `## Connects to`: Receives drops ": an idea, feature or change, or a plan to question hard"; Uses ends at "`references/`" (drops "for the grilling round, sizing and red flags, the reviewer prompt and the companion").

Run: `wc -c skills/aligning/SKILL.md && npm test`
Expected: 10000 bytes or less; 0 failures.

- [ ] **Step 2:** Ledger: Regra própria in `fusion/ledger/aligning.md` with the rule, the case and grader, and the two trims quoted before and after (2 existing cases not re-run). Commit `feat(aligning): ask data volume and accepted wait`.
- [ ] **Step 3: GREEN.**

Run: `node tools/compare.mjs --skill aligning-volume --arms devorb,none --runs 2`
Expected: `accepted: true`, `devorb` at 100%. Report cost and running total; add RED and GREEN to the ledger entry; commit.

### Task 4: Hook in `reviewing`

**Files:**
- Modify: `skills/reviewing/SKILL.md:33-40`, `skills/reviewing/references/risk-review.md`, `fusion/ledger/reviewing.md`
- Test: `evals/reviewing-consulta-sem-limite`

**Seam:** `node tools/compare.mjs --skill reviewing-consulta --arms devorb,none --runs 2`

**Interfaces:**
- Consumes: the four review signals as worded in Task 2; `fusion/results/2026-11-20-reviewing-consulta-red.md`.

- [ ] **Step 1:** `SKILL.md`, new trigger bullet after the dependencies one: the diff adds or changes a query over stored rows, a loop that queries, or a list screen. `risk-review.md`, new item 9 "Data volume": the four signals; each is Important, Critical when the table is known to be large or the path runs per request; the fix names the recipe (limit and cursor, join or batched load, index, pagination or virtualization). Keep the prompt's "Under 400 words" line.

Run: `npm test`
Expected: 0 failures.

- [ ] **Step 2:** Ledger entry (Regra própria, case, grader). Commit `feat(reviewing): unbounded queries and N+1 are blocking findings`.
- [ ] **Step 3: GREEN.**

Run: `node tools/compare.mjs --skill reviewing-consulta --arms devorb,none --runs 2`
Expected: `accepted: true`, `devorb` at 100%. Report cost and running total; ledger; commit.

### Task 5: Hooks with no eval of their own

**Files:**
- Modify: `skills/planning/references/task-template.md` (Task layout), `skills/implementing/prompts/task-reviewer.md` (Part 2), `skills/verifying/references/performance.md` ("Before you measure")
- Modify: `fusion/ledger/{planning,implementing,verifying}.md`

**Seam:** `npm test`. No `SKILL.md` is touched in this task.

**Interfaces:**
- Consumes: `**Performance budget:**` and the four review signals from Task 2.

- [ ] **Step 1:** `task-template.md`: after `**Seam:**`, add `**Performance budget:** [only for a task that reads stored data: the volume it must hold and the time it must answer in, from the spec; default budget in \`devorb:performance\`]`.
- [ ] **Step 2:** `task-reviewer.md`, Part 2, new bullet **Data:** the four signals, each Important (blocking), named in the reviewer's own prompt because the reviewer subagent receives nothing else; one clause pointing the fix to `devorb:performance`.
- [ ] **Step 3:** `verifying/references/performance.md`, "Before you measure", new bullet **Real volume:** seed the data store to the volume the spec states before any run; a number taken on a dev seed of a few rows says nothing about production.
- [ ] **Step 4:** One Regra própria per ledger, justified by the real case (20 mil × 85), each ending with "sem medição própria (teto da frente A)".

Run: `npm test`
Expected: 0 failures.

- [ ] **Step 5: Commit** `feat: performance hooks in planning, task review and verifying`.

### Task 6: Reserved run and close

**Files:**
- Modify: `fusion/ledger/performance.md` (Resultados)
- Create: `fusion/results/2026-11-20-performance-reserved.md` (tool output)

**Seam:** `node tools/compare.mjs --skill performance --reserved --arms devorb,none --runs 2`

- [ ] **Step 1:** Budget check per Global Constraints (estimate US$ 8). If it does not fit, skip the run, write "reservado não rodou: teto" in the ledger and say so in the final report.
- [ ] **Step 2:**

Run: `node tools/compare.mjs --skill performance --reserved --arms devorb,none --runs 2`
Expected: `accepted: true`, `devorb` at 100%. A failure goes to the ledger as a gap and to the owner; it is not fixed by reading the reserved case.

- [ ] **Step 3:** Ledger: reserved result, total real cost of the plan against US$ 40. Commit.
- [ ] **Step 4: Final check.**

Run: `npm test && git status --short && git log --oneline main..HEAD`
Expected: 0 failures, clean tree, the commits of Tasks 1 to 6.

- [ ] **Step 5:** Stop. Report to the owner: what is green and what is not, each cost and the total, the trims in `using-devorb` and `aligning`, the three unmeasured hooks, and the ready `CHANGELOG.md` text for 1.16.0. No merge, no push.
