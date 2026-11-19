# Par complementar e fontes antes do design — plano

> **For agentic workers:** REQUIRED SUB-SKILL: Use devorb:implementing to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn two owner preferences (a complementary colour pair split by section; read `ui-sources.json` before any design is executed) into DevOrb skill rules, with RED and GREEN evals.

**Architecture:** Skill text and reference edits, one unit test on `accentHues`, three eval changes. No new code path in `rules.mjs`.

**Tech Stack:** Markdown skills, Node 22 `node:test`, `tools/compare.mjs` (`claude plugin eval`).

**Spec:** `docs/specs/2026-11-18-regras-cor-referencias-design.md`

## Global Constraints

- Skill text in English; ledgers, eval prompts and graders in Portuguese.
- RED eval runs before any `SKILL.md` edit (`skills/writing-skills/references/devorb.md`).
- `npm test` green; each `SKILL.md` at or under its `ceilingTokens` in `fusion/skills.json` (`ui-review`: 2,496 of 2,500 today).
- Complementary = hue distance 150° to 210°. The pair is the Persuade default; Operate and Read keep one accent or none; a colour fixed by the spec or `DESIGN.md` wins.
- Paid budget: US$ 50 total. Never two `tools/compare.mjs` at the same HEAD at once. Report the real cost after each run.
- Do not change Phase 2 behaviour beyond what the two rules need.

## Review Focus

- Wine band (~355°) next to orange (~25°) splits into three hues in `accent-count`: a known limit, written in the ledger, not fixed.
- The no-person path of `guide.md` §2 must still read `ui-sources.json` and open the style's gallery: regression `visual-direction-arquitetura-clean` graders 1–3.
- The implementer subagent's own reads are not in the parent trace: the `implementing-fontes-ui` regex accepts a Read of `ui-sources.json` or an `Agent` dispatch whose input names `ui-sources.json`, before the first UI write.
- A pair inside one block (orange word in a navy button) is still a tell: the critique text says so.

---

### Task 1: RED evals

**Files:**
- Create: `evals/visual-direction-receitas-landing/graders/color-pair.md`
- Modify: `evals/visual-direction-receitas-landing/graders/finish.md` (drop condition 1 "Um destaque"; keep border and shadow conditions), `evals/visual-direction-receitas-landing/case.yaml` (description: "um par complementar dividido por seção" instead of "um só destaque")
- Create: `evals/ui-review-par-complementar/{case.yaml,scaffold.sh,graders/pair-not-flagged.md}`
- Create: `evals/implementing-fontes-ui/{case.yaml,scaffold.sh,graders/sources-before-ui.md}`

**Seam:** `node tools/compare.mjs --skill <case prefix> --arms ... --runs 2`

- [ ] `color-pair.md`: `llm` on `styles.css`. Passes only if exactly two saturated accent hues 150°–210° apart (status colours and focus ring excluded), each used in its own sections (one in some sections or bands, the other in others), and no single block mixes both as highlights.
- [ ] `ui-review-par-complementar`: static Persuade landing (`index.html`, `styles.css`, spec with `## Direção visual` naming the pair by section, `DESIGN.md` with `--accent` navy and `--complement` orange tokens, no sentence authorising "two accents"); one planted real defect (a body text pair below 4.5:1). Prompt: review the interface, no answers today. Grader `pair-not-flagged.md` (`llm`, `last_message`): the contrast defect is reported with P0–P3, and no finding, P1 or score gap blames the navy/orange pair as too many accents or highlights.
- [ ] `implementing-fontes-ui`: repo with approved spec (contract filled), `DESIGN.md`, and a one-task plan that builds `index.html` + `styles.css`. Prompt: execute the plan, no answers today. Grader `sources-before-ui.md`: `regex` on trace, same lookahead structure as `evals/visual-direction-arquitetura-clean/graders/1-sources-before-code.md`, target writes `\.(?:html|css|tsx)`, and the accepted earlier event also includes `"name":"(?:Agent|Task)"` whose input contains `ui-sources\.json`.
- [ ] Validate each `scaffold.sh` in a temp folder (`bash scaffold.sh` exits 0, files present). `npm test` green.
- [ ] RED, one at a time: `node tools/compare.mjs --skill visual-direction-receitas --arms devorb,none --runs 2`, then `--skill ui-review-par --arms devorb,none --runs 2`, then `--skill implementing-fontes --arms devorb,none --runs 2`. `arquitetura-clean` RED comes from Phase 2's result file (0.36). At least one arm fails each case; report cost.
- [ ] Commit `test(design): RED for the complementary pair and sources-first rules`.

### Task 2: Rule 1, complementary pair

**Files:**
- Modify: `skills/design-system/references/color-finish.md` ("One accent" section), `skills/design-system/references/color-roles.md` (add `complement` row), `skills/visual-direction/references/floor.md` (Accents line), `skills/visual-direction/references/hero-patterns.md:14` (halo hue), `skills/visual-direction/references/persuade.md` and `contract.md` (contract line says which sections each colour owns), `skills/ui-review/references/critique.md` (color-contrast 10 and tell 3)
- Test: `tests/design-rules.test.mjs`

**Seam:** `checkFloor` / `accentHues` in `skills/ui-review/scripts/rules.mjs`.

**Interfaces:** Produces the term "complementary pair" and role name `complement` used by Task 3's text.

- [ ] Test `accent-count passes a complementary pair split by band`: navy `rgb(15, 42, 92)`, `rgb(30, 58, 138)`, orange `rgb(249, 115, 22)`, `rgb(245, 158, 11)`, dark warm band `rgb(60, 20, 14)` → `accentHues(...).length === 2` and `accent-count` PASS; adding `rgb(22, 163, 74)` → WARN. Passes on current code (guard, not RED).
- [ ] Edit the references. `npm test` green. Commit `feat(design): complementary pair split by section`.

### Task 3: Rule 2, sources before any design

**Files:**
- Modify: `skills/visual-direction/SKILL.md` §4 (hard gate: before any UI file is written or restyled; also with nobody to answer), `skills/visual-direction/references/guide.md` §2 (no-person path still reads sources and opens the style's `byStyle` gallery), `skills/implementing/SKILL.md:79` (UI dispatch names the absolute path of `ui-sources.json` and the contract's `Sources:` line), `skills/implementing/prompts/implementer.md` Mirror block (read the sources before the first UI file; report consulted and skipped), `skills/ui-review/SKILL.md` §6 step 4 (critic also gets the contract's `Sources:`; trim words to stay ≤ 2,500), `skills/ui-review/references/critique.md` (`reference-fidelity` or `finish` gap notes when the build ignored the chosen sources)

**Seam:** eval traces; `npm test` (`check-skills`) for ceilings.

- [ ] Edit; `npm test` green; print each touched `SKILL.md` token count vs ceiling.
- [ ] Commit `feat(design): read the owner's sources before any design is executed`.

### Task 4: GREEN, ledgers

**Files:** `fusion/ledger/{visual-direction,design-system,ui-review,implementing}.md`, `fusion/results/*`.

- [ ] GREEN, one at a time, `--arms devorb,none --runs 2`: `visual-direction-receitas`, `visual-direction-arquitetura`, `ui-review-par`, `implementing-fontes`. Expect devorb passing the new graders and `arquitetura-clean` graders 1–3 back. Report cost after each; stop at US$ 50.
- [ ] Ledgers: own rules with their case, the wine-band limit, costs. Commit `test(design): GREEN for the two owner rules`.
