---
name: ui-review
description: Use when a built page, screen or component must be checked against its design contract, DESIGN.md, accessibility or mobile web, or someone asks to review an interface
---

# UI review

`devorb:browser-testing` answers whether the screen works. This skill answers whether it came out as agreed: it measures the build against what was declared and reports. It decides no taste and no value, and writes no fix.

```
THE RENDER JUDGES, THE CODE LOCATES. UNMEASURED IS NOT PASSED.
```

## 1. Gather what was declared

Read, in this order: `DESIGN.md` at the project root, the contract (`## Direção visual` in the spec), `references/floor.md` of `devorb:visual-direction`, and the references of `devorb:design-system` and `devorb:motion` when those skills are installed. These, plus WCAG 2.2 (`references/a11y.md`) and the mobile web floor (`references/mobile-web.md`), are the only rules. A value nobody declared is never a finding.

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

## 6. Severity

- **P0:** the task cannot be finished, data is lost, the state shown is false, or a path is closed to keyboard or screen-reader users.
- **P1:** a WCAG 2.2 A or AA failure, or a contract or floor line visibly broken.
- **P2:** a deviation with a workaround: token drift, a one-off, a minor floor slip.
- **P3:** polish and recommendations, only those worth someone's time.

Targets: under 24 x 24 CSS px with no WCAG exception is P1; under 44 px on touch is a P3 recommendation. Inputs on mobile render at 16 px or more; below that is a finding. No grade, score or total anywhere: only P0 to P3.

## 7. Report and stop

```
Measured: <URL or files>, <viewports>, <engine>  |  or: only code, no browser
Modes: <section: mode>
Findings, P0 first:
  [P1] <what> at <selector>, <file:line>. Declared: <value and where>. Measured: <value and how>. Class: <one of four>. Rule: <DESIGN.md line, contract line, floor item or WCAG criterion>.
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
| "This deviation is ugly" | Ugly is not a rule. Without a declared value it is not a finding. |
| "I'll just fix this one" | Report and stop. |
| "Not applicable, so it passed" | It never ran. |

## Connects to

- **Receives:** from `devorb:verifying`, after `devorb:browser-testing`, a built screen with a UI; or a request to review an interface.
- **Uses:** `DESIGN.md`, the spec's contract, `devorb:visual-direction`'s `references/floor.md`, the references of `devorb:design-system` and `devorb:motion`, the rendering of `devorb:browser-testing`; `references/a11y.md`, `references/mobile-web.md`, `references/worst-case.md`.
- **Hands off to:** the caller with the report; `devorb:debugging` when the task includes fixing.
