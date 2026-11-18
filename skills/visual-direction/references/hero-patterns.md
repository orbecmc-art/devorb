# Hero patterns

Ten ways to build the first screen, taken from our study of real landing pages in November 2026.

- **A menu, not a mould.** Pick the pattern that fits the page's material and direction. Leave out what the page has no material for, and bend the rest to the direction.
- **Measures are ranges.** `devorb:design-system` picks the values inside them, using its `references/typography.md`, `color-finish.md` and `space-radius.md`. The contract cites the id (`hero:centred-product-halo`) and never the numbers.
- **The Floor holds.** Every pattern respects `floor.md`. Where a reference page did something the Floor forbids, such as one word set apart, spaced-out capitals or chains of dots, the pattern below gives the version that respects the Floor.
- **Reflexes need a reason.** A halo, a monospace label or a section number enters only with this page's reason written in the contract's `Floor:` line.
- **Real product only.** A pattern that shows the product needs the real thing: a capture, or the product built in HTML with real controls and real data from the spec. It is never an icon, and never a drawn browser or OS window.

### `hero:centred-product-halo` — Centred title over the product
When: one calm promise, and a product whose main screen tells the story by itself.
Sketch: a centred title on two lines, a lead under it, one or two actions, and a one-line caption under the actions. Below them sits a wide frame with the real product, on a soft halo that sits behind the frame only. A short line above the title is allowed only when it carries a fact the client gave, such as a release.
Measures: title 72 to 96px at 1440, weight 400 to 500, tracking -0.04em to -0.05em. Lead 18 to 22px. Frame radius as the cards in `space-radius.md`. The halo is blurred past 100px in the one accent hue, and never sits behind text.
Mobile: title and actions left-aligned, actions at full width. The frame is cropped to its most telling part.

### `hero:split-header-bleeding-ui` — Split header, product running off the edge
When: the product's main screen is wide (an editor, a table, a timeline) and the promise fits in one or two lines.
Sketch: one row with the title on the left, about seven of twelve columns, and the lead with the action on the right. Below the row, the product starts inside the grid and runs past the right edge of the screen.
Measures: title 56 to 64px, weight 500, tracking about -0.02em. Between 15% and 30% of the product sits past the edge. The page clips it with `overflow-x: clip` and never scrolls sideways (`floor.md`).
Mobile: stacked in one column. The product still runs off the right edge.

### `hero:copy-left-ui-right-halo` — Copy left, real interface right
When: the product does one concrete job in one view, such as a task list, a conversation or a card.
Sketch: the copy column takes about five of twelve columns: title, lead and action. The real interface takes the other seven. Behind the interface only, there is a halo or a faint construction grid, but not both.
Measures: title 56 to 74px, weight 400 to 500, tracking -0.03em to -0.05em. The halo is 600 to 800px wide and blurred past 100px. A construction grid uses hairlines at 6 to 10% ink (`color-finish.md`).
Mobile: copy first and left-aligned, action at full width. The interface drops out, or follows below the copy.

### `hero:object-cut-by-fold` — One object cut by the fold
When: the product is a physical object, or the page sells a person or character, and a real render or cut-out photo exists. Without one, use another pattern.
Sketch: a short title and one action at the top. The object fills the lower half and is cut by the bottom edge of the first screen, lit from one side. Nothing else is on the screen.
Measures: title 56 to 64px, weight 500. The object takes 50 to 60% of the first screen's height.
Mobile: the object is scaled to the screen's width and still cut by the fold. The title stays above it.

### `hero:full-photo-display-type` — Full photo with display type
When: the visitor buys a place, a meal, a stay or a team, and the client has real photographs.
Sketch: one photograph across the whole screen, darkened so the text reads. The title sits bottom-left in the display face, with one action. An optional small real element floats over the photo, such as the hours the client gave. Reference pages mix a script word into a capital-letter title. The Floor version sets the whole title in one face, in full lines, with no single word set apart. Small labels are in sentence case at normal tracking.
Measures: title 54 to 96px, or up to 140px for a single short line on luxury and restaurant pages. A light serif at 400 to 440, or capitals in a display face. The photo is darkened 30 to 50%, or carries a scrim, until the title passes the large-text contrast check in `contrast.md`. Corners are square on luxury pages (`space-radius.md`).
Mobile: the photo is cropped to its subject. The title stays bottom-left, between 32 and 64px.

### `hero:type-performs-product` — The title performs the product
When: the product's effect can be shown on its own headline. Examples: a blur that clears, a count made of the users' avatars, a selection box around a sentence, objects set between the words.
Sketch: a title on two or three lines, where one whole sentence or line does what the product does. One action and a short caption follow. The effect applies to a whole sentence or line, never to a single word (`floor.md`, Type). The text stays readable with scripts off and with reduced motion.
Measures: title 48 to 80px, weight 400 to 500. Objects set between the words stand at the height of the capitals.
Mobile: the same sentence keeps the effect. The title is left-aligned and smaller.

### `hero:tilted-content-wall` — Title over a tilted wall of content
When: a catalogue product with many real items to show, such as templates, typefaces, listings or courses.
Sketch: the title on the left, over a wall of real item tiles set in perspective. The wall fades into the ground colour near the text, so the title always sits on calm ground.
Measures: title 56 to 80px; a serif title may be italic as a whole. Tile radius 12 to 16px. The fade covers the third of the wall nearest the text.
Mobile: the wall flattens into a strip of two columns under the title, or drops out.

### `hero:left-headline-product-video` — Left title over a product recording
When: the product is best understood in motion, and a real recording of it exists.
Sketch: the title on the left on two lines, a grey lead, and on one row the action plus a secondary link to a real destination. Below, a recording of the product spans the full container width. It plays muted, and shows its poster frame under reduced motion.
Measures: title 54 to 64px, weight 500, tracking about -0.04em. Lead 18px. The video radius matches the cards (`space-radius.md`). The gap to the video is 64 to 80px.
Mobile: stacked. The video is cropped to the region that shows the job.

### `hero:copy-and-form-card` — Copy beside a form card
When: lead generation, where the form is the action and it has a real endpoint. Without an endpoint, use another pattern: a form without one never shows success (`floor.md`).
Sketch: the copy on the left: title, lead, and any proof the client gave. A form card sits on the right. With more than four fields, the form splits into two steps with visible progress. Reference pages paint half the title in a gradient and use very heavy type. The Floor version keeps the title in one colour at a moderate weight.
Measures: title 46 to 64px, weight 500 to 600. Card radius 12 to 16px. Fields 44 to 48px tall.
Mobile: the form follows the copy at full width and keeps every field.

### `hero:giant-word-on-canvas` — One giant word on a canvas of work
When: Experience pages such as a studio or portfolio, where the craft is the product.
Sketch: one word or name set huge, on a faint grid. Real artefacts from the studio's own work sit around it: frames, notes, comments, cursors from their tools. The artefacts are the studio's real work, never drawn windows.
Measures: the word is 160 to 200px at 1440, weight 500 to 700, with negative tracking (`floor.md`, Measured, display weight). The grid cell is about 40px, in hairlines.
Mobile: the word drops to 56 to 64px, and only two or three artefacts remain.
