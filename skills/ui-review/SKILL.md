---
name: ui-review
description: Use when a built page, screen or component must be checked against its design contract, DESIGN.md, accessibility or mobile web, or someone asks to review an interface
---

# UI review

`devorb:browser-testing` answers whether the screen works. This skill answers whether it came out as agreed: it measures the build against what was declared and reports. Taste is judged only through the written rubric (§6); it creates no value rule and writes no fix.

```
THE RENDER JUDGES, THE CODE LOCATES. UNMEASURED IS NOT PASSED.
```

## 1. Gather what was declared

Read, in this order: `DESIGN.md` at the project root, the contract (`## Direção visual` in the spec), `references/floor.md` of `devorb:visual-direction`, and the references of `devorb:design-system` and `devorb:motion` when those skills are installed. These, plus WCAG 2.2 (`references/a11y.md`) and the mobile web floor (`references/mobile-web.md`), are the only rules. A value nobody declared is never a finding. For an app screen, read `references/native.md`.

Whatever `DESIGN.md` or the contract authorizes is not a finding: that check is clear, with no finding and no recommendation.

## 2. Name the mode of each section

Before any check, write the mode of each surface or section (Persuade, Operate, Read, Experience), from the contract or, without one, from what the visitor does there. Several checks depend on it: Inter passes on a panel, and on a landing page whose contract never chose it, it is a spent look. In Operate, navigation hidden behind a menu button at 1280 px or wider is a finding.

## 3. Functional before visual

Take the `devorb:browser-testing` run for this screen; if none exists, do it first with that skill's server lifecycle and script (its `references/playwright.md`). A failed action, a console error or an unreachable control is reported first, as P0 or P1, before any visual finding.

Render at 1280 x 800, at 375 x 812 with touch, and at 1920 when the floor's container rule applies.

**No browser available:** the report's first line says "only code". Every check that needs the render ends as not checked, and code findings are marked inferred. A URL that was given but not measured never passes.

## 4. Measure computed against declared

In the rendered page, never in the source:

- **Values:** `getComputedStyle` on the elements in question (colours, font families, sizes, radii, spacing) against the tokens in `DESIGN.md`. A colour that matches no token is a deviation.
- **Motion:** trigger the state (hover, focus, open), then read `document.getAnimations()` for the real duration, delay and easing; compare with what `devorb:motion` declared. Run again with `reducedMotion: 'reduce'` in the browser context.
- **Focus:** press Tab through the page; at each stop read the outline and box-shadow at once and the `transition-property`. A ring that transitions in is a fade, a finding.
- **Contrast:** compute from the painted colours and write the pair with its ratio.
- **Displayed text:** read the rendered text, `alt`, `aria-label`, `title` and `placeholder`, never class names. Here live the AI tells (the floor's reflexes and spent looks) and broken plurals such as "1 members". A tell passes only when the contract names it in a sentence you quote; an atmosphere word in the contract ("editorial", "premium", "moderno") is no permission.

Then locate each deviation in the code with `file:line`. When the screen shows data (names, counts, lists, dates), also run `references/worst-case.md`.

Classify every deviation:

- **Missing token:** `DESIGN.md` has no value for what this spot needed.
- **One-off:** the right token or shared component exists and was not used here.
- **Conceptual mismatch:** the page is organized differently from what the contract or the sibling screens set (order, grouping, what leads).
- **Local defect:** this spot alone is unfinished or wrong.

## 5. The checks

Run each: every contract line (mode, first screen, sections in order, states, the primary action's wording, type), every floor item, the tokens, motion, `references/a11y.md`, and `references/mobile-web.md` at 375 px. Keyboard: a one-letter shortcut without a modifier must not fire while a field has focus, and the page must not take over the browser's own shortcuts.

Each check ends in exactly one of: **found** (with the finding), **clear**, or **not applicable**. Not applicable means the check did not run: it goes under not checked and never counts as a pass.

## 6. Visual critique

A reviewer who never sees the code scores the look by `references/critique.md`. `UI_DIR` is this skill's folder, under the plugin's base directory; run its scripts by absolute path; `<tmp>` is a scratch folder outside the project. Installing Playwright or downloading a browser is the user's call, as in `devorb:browser-testing`: ask; only their explicit yes counts ("decide alone" is not one). Without it, use a browser tool (`critique.md`, Fallbacks); with none, go code-only. An install outside the project is passed as `--pw <dir>`.

1. **Shoot:** `node "$UI_DIR/scripts/shoot.mjs" <url, or file:// plus the absolute path> <tmp>/shots --mode <the contract's main mode, lower case> [--pw <dir>]`. Per width: `full.png`, `section-<i>.png`, `metrics.json`, `checks.json`.
2. **Floor checks:** each `checks.json` FAIL is a `[P1]` finding, each WARN a `[P2]`, with the check id as the rule.
3. **Reference pack** (the contract's `Reference pack:` or one the user names): without `1440/metrics.json` in it, shoot its URL or `source.html` into `<tmp>/ref` the same way. Then:
   `node --input-type=module -e "import { compareStructure } from '$UI_DIR/scripts/rules.mjs'; import { readFileSync } from 'node:fs'; const m = (p) => JSON.parse(readFileSync(p, 'utf8')); console.log(JSON.stringify(compareStructure(m('<tmp>/shots/1440/metrics.json'), m('<ref 1440>/metrics.json'))))"`
   Each `reasons` item is a `[P1]` Conceptual mismatch; each `deviations` item a `[P2]`.
4. **Fresh critic:** dispatch a new subagent (the Agent tool). Its prompt names, by absolute path, `$UI_DIR/references/critique.md`, the shots, the pack's notes and shots, and `DESIGN.md`, and quotes the contract's `## Direção visual`. Nothing else: no code (except in the no-browser fallback), no word on who built it. Never paste the rubric; if the critic cannot read that path, copy `critique.md` into `<tmp>` and name the copy.
5. **Copy** its block verbatim, in `critique.md`'s line format: never a table, never a summary. Every score below 8 gets its own `[P1]` line (§8), even when a measured finding covers it, unless its gap targets only what `DESIGN.md` or the contract authorizes, or a value nobody declared: then the score line stays and no P1 is added.

No browser or no subagent tool: follow the fallbacks at the end of `critique.md`. Without a browser the report's first line says "only code" and no screenshot or measured value is claimed.

## 7. Severity

- **P0:** the task cannot be finished, data is lost, the state shown is false, or a path is closed to keyboard or screen-reader users.
- **P1:** a WCAG 2.2 A or AA failure, or a contract or floor line visibly broken.
- **P2:** a deviation with a workaround: token drift, a one-off, a minor floor slip.
- **P3:** polish and recommendations, only those worth someone's time.

Targets: under 24 x 24 CSS px with no WCAG exception is P1; under 44 px on touch is a P3 recommendation. Inputs on mobile render at 16 px or more; below that is a finding. No grade outside the Critique block: findings are P0 to P3.

## 8. Report and stop

```
Measured: <URL or files>, <viewports>, <engine>  |  or: only code, no browser
Modes: <section: mode>
Critique (fresh reviewer):   (or the fallback title from critique.md)
  <dimension>: <0-10> — a 10 here: <one line> — gap: <one line>   (9 lines, in critique.md's order)
Findings, P0 first:
  [P1] <what> at <selector>, <file:line>. Declared: <value and where>. Measured: <value and how>. Class: <one of four>. Rule: <DESIGN.md line, contract line, floor item or WCAG criterion>.
  [P1] <dimension> <score>/10 — see finding <n>  |  or: — gap: <gap>. Class: Conceptual mismatch | Local defect. Rule: critique rubric.
Checks: <check>: found | clear | not checked (<why>)
Inventory: colours, radii, font families, durations, easings, each with up to five file:line, no verdict
Not checked: <what, and what would check it: a phone, a login, a browser>
```

Then stop. Change no file: no fix, no fixture in the tree, no formatting. When fixing is part of the task, the findings go to `devorb:debugging`; otherwise the user decides.

## Stop signs

| Thought | Reality |
|---|---|
| "The CSS says 150ms, so the motion is 150ms" | Read `getAnimations()`; overrides and inline styles win. |
| "No browser, but the code looks clean" | The report says "only code" and the render checks stay unchecked. |
| "This deviation is ugly" | Ugly is judged by the rubric, with a fresh reviewer. A value nobody declared is still no token finding. |
| "The critic will understand better with the CSS" | The critic sees shots, pack and contract, never code, except in the no-browser path. |
| "I'll just fix this one" | Report and stop. |
| "Not applicable, so it passed" | It never ran. |

## Connects to

- **Receives:** from `devorb:verifying`, after `devorb:browser-testing` (or `devorb:device-testing` for an app), a built screen with a UI; or a request to review an interface.
- **Uses:** `DESIGN.md`, the spec's contract, `devorb:visual-direction`'s `references/floor.md`, the references of `devorb:design-system` and `devorb:motion`, the rendering of `devorb:browser-testing`; `references/a11y.md`, `references/mobile-web.md`, `references/worst-case.md`, `references/native.md`, `references/critique.md`, `scripts/shoot.mjs`, `scripts/rules.mjs`; a pack from `devorb:visual-direction`.
- **Hands off to:** the caller with the report; `devorb:debugging` when the task includes fixing.
