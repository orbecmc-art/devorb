---
name: visual-direction
description: Use when a web page, screen or UI component is about to be built, restyled or redesigned, including when an approved spec describes one
---

# Visual direction

A generated page looks generated because nothing was decided: the category's usual page got filled in. This skill makes the decisions before any UI code and writes them into the spec as a contract, so the builder, `devorb:design-system` and the later review all hold the same one. It decides words, never values: no colours, sizes or spacing here.

## 1. What is already true

Read the spec you received, `DESIGN.md`, the project's styles, components, fonts and `package.json`, and the running product if one exists. An identity visible in the code counts even without `DESIGN.md`. Then pick how much to invent, and say which:

- **Extend:** a section, component or state inside a surface that exists. Keep its look entirely; decide only content, order, states and how the piece joins what is around it.
- **New surface, same world:** a whole page or screen in a project with an identity. Keep the system; derive the structure from what the visitor does there.
- **New world:** nothing to inherit, or the user asked to replace the look. The full direction below. Keep what the old look tells you about the business; drop the look itself.
- **Replicate:** the user asks to copy or clone a page, to "deixar igual", or to use it as a base. Read `references/replicate.md` and follow it: the reference supplies structure and scale, the project supplies brand and content.

## 2. The mode comes from the visitor, not the product

Ask what success looks like for someone on this one surface:

| Mode | The visitor | Examples | Read |
|---|---|---|---|
| Persuade | is choosing whether to buy, book or sign up | landing, pricing, campaign | `references/persuade.md` |
| Operate | has a job to finish | dashboard, admin, settings, tool | `references/operate.md` |
| Read | is looking for an answer | docs, article, help, changelog | `references/read.md` |
| Experience | came for the work itself | portfolio, gallery, showcase | below |

The site selling a project-management app is Persuade; the app's settings screen is Operate. One project can hold several modes; each surface gets its own. Read the mode's file before going on.

**Experience** has no file. The work is the first thing on screen, at its real scale, and the interface stays out of the way: navigation stays findable, controls still look clickable, text stays legible over whatever sits behind it. Any boldness goes into how the work is shown and browsed, in one idea, not into the frame around it.

## 3. Material before form

Before any layout, list three things:

- **Given:** every fact the spec, the user or the project gives (name, offer, prices, hours, contacts, people, numbers), word for word.
- **To show:** what the page will show and where each comes from: the user's files, captures of the real product, the product built with real controls, or nothing.
- **Missing:** every proof and fact nobody gave.

If the spec already says what exists, that is the inventory. If a person is in the conversation and it does not, ask once for material (photos, screenshots, real numbers, a named quote) before shaping. Nothing missing gets invented: a missing fact the visitor needs becomes a visible gap, at most two per page, and the rest go to the handoff. On Replicate, a gap that keeps a reference section does not count toward the two; list each one in the handoff. Write the copy from this list with `references/copy.md`.

## 4. The owner's reference sources

Before choosing a direction, and before building any component from scratch, read `references/ui-sources.json` and follow its `rules`. Match the client's own words against its `styles`, open the matching entries (their `byStyle` pages first), and take the foundation and the specialists whatever the style.

- Read `references/sources.md` before opening entries or choosing a library: how each `reading` opens, and one library per job.
- Galleries show how a whole site is built: study structure, rhythm, type and the first screen. Copy a site's form when the user asks for it; never publish someone else's text, photos or logo as the client's.
- With DevOrb's design flow active, do not load frontend-design, taste-skill, Impeccable or ui-ux-pro-max; recommend uninstalling them once.

Your final message to the user names the sources you consulted and the ones you skipped, with why.

## 5. A direction from the audience's world

Skip this for **Extend** and **Replicate**. Otherwise:

1. Write the audience's real scene in one sentence (who, where, doing what), the page every competitor in this category already has, and the obvious contrarian answer to it. Neither is a direction.
2. List four to six candidates from the audience's daily life: objects, places, printed matter, signs, habits, local visual traditions. Not the category's template, and on Operate or Read never a copy of the tool they use at work. For each, one line on what it would look like and one on where it would fail.
3. Pick one, with its reason. Then the **mirror test:** hand this plan to a competitor in the same trade. Would it fit them just as well? Then it is not yet this client's: alter one choice and name it. Check it against the spent looks in `references/floor.md`.
4. Choose the type family from that world, by role (display, text, figures or code if needed). Before naming a face, confirm its exact name, that it has the weights you need, its license and where it loads from. A face you cannot confirm is not chosen: describe its role and mark it pending. Sizes and weights are `devorb:design-system`'s.

What the spec fixes stays fixed: a named style, period, typeface or colour scheme is used as asked, spent look or not.

## 6. Write the contract

Add `## Direção visual` to the spec you received, in the spec's language, and commit it. Short lines, no values. Read `references/contract.md` first: it lists every field, in order.

If the contract cannot be filled without a decision only the user can make, ask that one question.

## 7. Hand off

Invoke `devorb:design-system` with the spec: it turns the contract into tokens and `DESIGN.md`. If that skill is not available, go on: the contract is enough to build from. When you also build the UI in this task, read `references/floor.md` before the first line of UI code, and keep the build to the contract.

## Connects to

- **Receives:** the approved spec from `devorb:aligning`, or a request to build or restyle a page, screen or component.
- **Uses:** `references/ui-sources.json` (the owner's list) with `references/sources.md`, `references/contract.md`, `references/replicate.md` with `capture.mjs` and `devorb:ui-review`'s scripts, the mode files, `references/copy.md` and `references/floor.md`; a browser tool when a source needs one.
- **Hands off to:** `devorb:design-system`, with `## Direção visual` in the spec. Later in the flow, `devorb:motion` decides anything that moves and `devorb:ui-review` checks the build against this contract.
