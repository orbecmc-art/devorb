# Connectors

Rules for connectors in a hand-written SVG. A reader follows a diagram by tracing lines; every rule here keeps each line traceable from one end to the other. Mermaid routes its own edges, so only the label length applies there.

## Routing

1. **Orthogonal only.** When both ends line up on x or on y, draw one straight segment. Otherwise route with horizontal and vertical segments joined by a rounded corner of radius 8 (6 when space is tight). A diagonal between two boxes is always wrong.
2. **Square to the box.** A connector arrives at a box square to that side, 8 px or more away from any corner. A horizontal segment never leaves from the upper or lower side of a box: it would hug the border and seem to sprout from the corner.
3. **One point per connector.** Spread N connectors on one side evenly: the k-th sits `k / (N + 1)` of the way along it, 12 px or more from its neighbours. Two connectors never share a point.
4. **No shared strokes.** Two connectors never overlap or stack. Parallel runs keep at least 12 px apart along their whole length. Where two must cross once, add a small hop on one of them. Needing more than that means the layout or the budget is wrong.
5. **No passing behind a box.** A connector does not run behind a box that is not one of its ends; route around it. Only when a box that spans the figure (a shared layer, a bus) leaves no other path, draw that connector dashed, put its label near the visible end, and end the arrowhead only at the real target.

## Meaning in the stroke

| Stroke | Use |
|---|---|
| Solid, neutral | The normal connection |
| Solid, accent | The one path the diagram is about, at most two connectors |
| Dashed `5,4` | Optional, async, reply or return |

A dash pattern or a label always repeats what the color says, so the diagram reads in grayscale.

## Labels

- 14 characters at most. Name the action or the data (`POST /login`, `token`, `yes`), not a sentence.
- Every label sits on an opaque rectangle filled with the background color, so the line does not show through the text.
- Between that rectangle and the stroke, leave a visible gap of 6 to 10 px. A label that covers its own connector hides the thing it describes.
- On a horizontal segment, center the label above the line. On a vertical segment, put it to one side with the same gap. Never rotate text along a line.
- Size the rectangle from the text: about 0.6 em per character in the label font, plus 4 px of padding on each side.

## Drawing order

1. Background and containers (boundaries, lanes).
2. Connectors, then their label masks and label text.
3. Boxes and their text.

Because boxes paint last, a label mask that pokes into a box drawn after it gets cut and the text breaks against the border. Place each label beside a stretch of its line that crosses empty canvas, clear of every box. A small badge drawn entirely inside a box is fine.

## Markup

An elbow from the right edge of one box down to the left edge of another, with its label beside the vertical segment:

```svg
<path d="M200 68 H252 A8 8 0 0 1 260 76 V164 A8 8 0 0 0 268 172 H320"
      fill="none" stroke="#6b6f7b" stroke-width="1.5" marker-end="url(#slug-arrow)"/>
<rect x="268" y="112" width="72" height="16" rx="2" fill="#f7f6f2"/>
<text x="304" y="123.5" font-size="9" text-anchor="middle" fill="#6b6f7b">CREDENTIALS</text>
```

The mask starts 8 px right of the stroke at x 260 and ends above the lower box, which begins at y 144.

The arrowhead is a marker in `<defs>`, with an id that carries the file's slug:

```svg
<marker id="slug-arrow" markerWidth="8" markerHeight="6" refX="8" refY="3" orient="auto">
  <path d="M0 0 L8 3 L0 6 Z" fill="#6b6f7b"/>
</marker>
```
