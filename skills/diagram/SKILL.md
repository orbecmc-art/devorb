---
name: diagram
description: Use when the user asks for a diagram, flowchart, sequence or architecture picture, or a visual of a flow
argument-hint: "What should the diagram show, and where does it go?"
---

# Diagram

The user names a subject and, often, a destination. Make one diagram a reader understands faster than the prose it replaces, or decide that it should not exist. Work through the six steps in order; each one can end the job early.

## 1. Should it be drawn?

A diagram earns its place only when the reader needs to see shape: order, branching, flow between parts, containment, change over time. Before anything else, ask whether a table or a sentence would answer the same question.

- Items that each carry the same attributes (plans and what each includes, features by tier, options by cost) are a table. Write the table.
- A before and after that only changes values is a table with two columns.
- One box, or a straight run of two or three steps, is a sentence.

When the answer is a table or a sentence, deliver that instead, say in one line why it beats a diagram, and stop. Create no diagram file. The user can still insist; then draw.

## 2. Mermaid or SVG

Where the diagram lives decides the format.

| Lives in | Format | Why |
|---|---|---|
| A Markdown file that changes with the code: README, `docs/`, ADR, spec, pull request | Mermaid in a fenced ` ```mermaid ` block | Diffs as text and renders on GitHub, so it stays current |
| A published piece: site page, post, slide, a path ending in `.svg` | Hand-written SVG | Full control of layout, labels and accessibility |

A path the user gives settles it: `.md` means Mermaid, `.svg` or `.html` means SVG. With no path, a diagram for the repository's own docs is Mermaid, anything going public is SVG. Never trace Mermaid's automatic layout into a published SVG; place the nodes yourself.

## 3. Type

Pick the type from the question the reader asks, using `references/types.md` (about twelve types, each with its Mermaid keyword and its own limits). If two types fit, take the one whose main axis carries the meaning, time, flow or hierarchy, and drop the other. A type outside that file is out of scope: use the nearest one or a table.

Before drawing, announce the plan in a single line: the type, the format and path, and what the budget cuts. Do not wait for an answer unless the subject itself is unclear; list any assumption next to the result.

## 4. Budget

- **At most 9 nodes and 12 connectors.** The type's own limit in `references/types.md` can only be lower.
- One or two focal elements get the accent color; everything else stays neutral.
- Over budget: merge nodes that never appear apart, delete connectors the layout already implies, then split into an overview plus one detail diagram. Never shrink text to fit.
- Remove test before finishing: could a node, a connector or a label go without the reader losing anything? Then it goes.

Colors come from the project's `DESIGN.md` tokens when it exists. Labels, title and description use the language of the page they sit on.

## 5. Connectors (SVG)

Full rules and markup are in `references/connectors.md`. The short form:

- Orthogonal only: a straight line when both ends line up on x or y, otherwise right-angle elbows with a small rounded corner. No diagonals.
- A connector leaves and enters a box at right angles to that edge, away from the corners. Several connectors on one edge are spread apart, one point each.
- Every label has an opaque mask behind it, filled with the background color, with a visible gap of 6 to 10 px from its stroke, beside a vertical segment rather than on it. At most 14 characters.
- No two connectors share or overlap a stroke, and none passes behind a box it does not connect.
- Draw connectors first and boxes after, so lines run under the nodes.

In Mermaid, keep node text to a few words and move detail onto the edge labels; the renderer owns the routing.

## 6. Accessibility and output

Start every SVG from `references/template.svg`, which already meets these points.

- Put `role="img"` on the `<svg>`, plus `aria-labelledby` naming the ids of its `<title>` and `<desc>`.
- Inside `<svg>`, `<title>` comes first, ahead of `<defs>`. It names the subject in 60 characters or fewer.
- `<desc>` says in one sentence what the diagram means, not where the boxes are.
- The ids carry the file's slug (`login-flow-title`), never bare `title`, so two diagrams on one page do not collide.
- Meaning never rests on color alone: a label, a dash pattern or a shape carries it too.
- Everything sits inside the `viewBox`.

When the SVG is placed inline in a page, give it a `min-width` equal to the viewBox width and wrap it in its own scroll container, so a phone scrolls the diagram and not the page:

```html
<div style="overflow-x: auto">
  <svg viewBox="0 0 520 240" style="min-width: 520px; width: 100%" ...>
</div>
```

In Mermaid, add `accTitle:` and `accDescr:` lines with the same content.

Animate only when the user asks. The static file must already show the whole diagram, with every node and label visible without script; motion only reveals it in order, and a user who set `prefers-reduced-motion: reduce` gets the complete static frame with no playback.

## Finish

Check the file parses (`xmllint --noout <file>` when present) and that `role="img"` and `<title` are in it. Reply with the path, the type, and anything the budget cut or the plan assumed.

## Connects to

- **Receives:** the user asking for a diagram, flowchart or visual of a flow, with a subject and often a destination.
- **Uses:** `DESIGN.md` tokens written by `devorb:design-system`, when they exist; `references/types.md`, `references/connectors.md`, `references/template.svg`.
- **Hands off to:** the user. An SVG that ships inside a page is checked with the rest of the page by `devorb:ui-review`.
