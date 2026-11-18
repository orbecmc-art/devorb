---
name: design-system
description: Use when a UI needs a design system, colour or type tokens, when a spec's `## Direção visual` needs values, or when a shadcn/ui or Tailwind theme is set up
---

# Design system

This is the one skill that picks values: colour, type scale and rhythm, spacing, radius, border and the look of each state. It turns the direction contract into tokens in the project's own style layer, writes `DESIGN.md` at the root and builds a specimen the owner can approve. Accessibility is decided here too, as tokens, so the build cannot drift below it.

## 1. Read before writing

Read, in this order: the spec's `## Direção visual`, `DESIGN.md`, every place the project already declares values (CSS custom properties, `@theme`, `tailwind.config.*`, theme files, `components.json`), the main components, and `package.json` with its lockfile for the installed Tailwind major.

- **The project has values already:** read them, keep their names and format, and add only what the task needs, in the same style. Never rename a token or move it to another file.
- **`DESIGN.md` exists:** it is the reference. Do not edit or overwrite it unless the user asked. New tokens follow its names and scales; list in your final message what it would need to cover them.
- **Nothing exists:** build the system below from the contract.

For an app screen, read `references/native.md`.

Colours come from the direction: each one traces to something in the world the contract names, or to a colour the spec or the client's material fixes. Never seed from a framework default, a generator's palette or the colours a model reaches for by habit. If the contract is missing, say so and build only what the spec fixes.

## 2. Two layers, few tokens

- **Primitives** hold raw values and are named for what they are (`--clay-700`, `--space-4`).
- **Semantic tokens** are named for the job (`--color-primary`, `--color-on-primary`, `--color-border`) and point at primitives. Components use only semantic tokens.
- A new token needs at least three places doing the same job. Fewer: reuse a token that exists. Two values that match by accident but serve different jobs stay separate tokens.
- Colour roles come in pairs, a surface and the ink that sits on it. Read `references/color-roles.md` before naming any colour token.

What else the system sets:

- **Type:** families come from the contract; this skill sets sizes, weights, leading and tracking. Body size follows the mode: dense on Operate, generous on Read and Persuade. There is no single minimum. Large display sizes get negative tracking, and leading tightens as size grows: each step of the scale fixes size, weight, leading and tracking at once. Build the scale fluid with `scripts/fluid-scale.mjs` and take the values, pairs and finish (accent, text tones, lines, halo) from `references/typography.md` and `references/color-finish.md`.
- **Spacing and radius:** one scale each. On Operate screens, text in a list row keeps at least 8 px from the row's edge, rows' texts sit 16 px apart, and text after a list starts 12 px below it. Scales, section padding and radius by category are in `references/space-radius.md`.
- **Borders and states:** a control's border keeps the same width in every state; focus is drawn as a ring outside it, never by thickening the border. Disabled is shown through at least three cues together (fill, text colour, cursor or icon, `aria-disabled`), never by opacity or colour alone. Each component's states (hover, active, focus, disabled, error, selected where used) get their own tokens.
- **Translucent surfaces,** if the contract wants any, have an opaque fallback under `prefers-reduced-transparency: reduce` and `prefers-contrast: more`.
- **Motion values** are `devorb:motion`'s. Store them as tokens only if that skill decided them.

## 3. Accessibility is part of the tokens

- Every text pair reaches 4.5:1; large text, icons, field edges and the focus ring reach 3:1 against what is next to them.
- Compute every pair, in every theme, with the script in `references/contrast.md`, and print the results. Never estimate a ratio by eye. A failing pair changes the ink or the surface lightness, not the brand hue.
- Focus has its own token (`--focus-ring` or the project's name for it), used by every interactive element through `:focus-visible`.
- Record each pair and its ratio in `DESIGN.md`.

## 4. Dark theme

When the project has or the contract asks for a dark theme, the brand hues stay and everything else is derived again: surfaces, text, borders, muted tones and the focus ring. Inverting the light theme is not a dark theme. Run the contrast check again on every pair in the dark theme.

## 5. Write the tokens where the project keeps them

- **Tailwind v4** (`@import "tailwindcss"`): tokens go in `@theme` in the main stylesheet, with the dark theme under a selector or media query in the same file. Never add a `tailwind.config` file.
- **Tailwind v3:** tokens go in `theme.extend` of the existing `tailwind.config.*`, pointing at CSS custom properties.
- **No Tailwind:** CSS custom properties on `:root`, the dark theme in its own scope.
- **shadcn/ui as foundation (owner's rule):** its default theme has become a recognisable AI look, so it never ships. Replace the values of its theme variables (`--background`, `--primary`, `--ring` and the rest, light and dark) with this project's tokens. Keep the variable names so the components keep working. No default value may survive.

A value lives in one place. Components read tokens (`var()` or the utilities the tokens generate), never literals.

## 6. `DESIGN.md`

When none exists, write `DESIGN.md` at the root in the open format: tokens in YAML frontmatter, prose after. Read `references/design-md.md` before writing it. It holds the contrast table, the state tokens and a section of known gaps.

## 7. Specimen

Build one page the owner can open to approve the system: every colour role with its pair and ratio, both themes, the type scale, spacing and radius, and each component in every state. It uses only `var()` and the project's token utilities, never a literal value, so it shows what the code really holds. Serve it the way the project serves pages (a route, a story, or an HTML file that links the built stylesheet), and say where it is.

## 8. Hand off

Your final message names: the files where the tokens live, whether `DESIGN.md` was written or left untouched (with what it would need), the contrast results for every pair in each theme, and any value you could not trace to the contract.

`devorb:planning` and `devorb:implementing` cite tokens by name; no task writes a raw colour or size. `devorb:ui-review` later measures the build against these tokens and `DESIGN.md`.

## Connects to

- **Receives:** the spec with `## Direção visual` from `devorb:visual-direction`, or a request to set up or extend a project's tokens or theme.
- **Uses:** `references/color-roles.md`, `references/contrast.md` (its script, run on every pair), `references/typography.md`, `references/color-finish.md` and `references/space-radius.md` with `scripts/fluid-scale.mjs`, `references/design-md.md` and, for an app, `references/native.md`.
- **Hands off to:** `devorb:planning` and `devorb:implementing`, which cite the tokens; `devorb:ui-review`, which measures the build against them.
