# Section patterns

Twelve ways to build a section after the first screen, taken from our study of real landing pages in November 2026. A typical page uses 4 to 10 sections with one idea each. Each item in the contract's `Sections:` line cites one of these ids, or `custom` with a line on what the section does.

- **A menu, not a mould.** Pick by what the visitor needs at that point and by the material the page has. Leave out a pattern the page has no material for. Never repeat one layout in every section (`floor.md`, Reflexes).
- **Measures are ranges.** `devorb:design-system` picks the values inside them, using its `references/typography.md`, `color-finish.md` and `space-radius.md`. The contract cites the id and never the numbers.
- **The Floor holds.** Every pattern respects `floor.md`. Where a reference page did something the Floor forbids, such as one word set apart, spaced-out capitals or chains of dots, the pattern below gives the version that respects the Floor.
- **Reflexes need a reason.** A halo, a monospace label or a section number enters only with this page's reason written in the contract's `Floor:` line.
- **Only given numbers.** A number, logo or quote comes only from what the client gave. A pattern built on proof the page lacks does not go in.

### `section:live-ui-bento` — Bento of live interface tiles
When: the product has several capabilities, each one visible as a small real piece of interface or a real readout.
Sketch: 5 to 9 tiles of mixed spans. Each tile holds a short title and one live piece of the product, built in HTML with data from the spec. No icon stands in for the product.
Measures: tile radius 4 to 8px on devtools, 12 to 16px on consumer products. A 1px line at 6 to 10% ink, and no shadow (`color-finish.md`). Gaps 16 to 24px. Density lives inside the tiles.
Mobile: one column, or a horizontal carousel that clips at the screen edge.

### `section:proof-grid` — Proof grid
When: the client gave real proof: customer logos with permission, numbers and named quotes.
Sketch: a grid of about 4 by 3 cells divided by hairlines. Logos, numbers and short quotes are mixed in the cells, each with its source. With too little proof for a grid, use a single named quote, or nothing.
Measures: hairline cell dividers, 1px at 6 to 10% ink. Numbers 32 to 48px. Logos one tone, at about 0.6 opacity.
Mobile: two columns, the quotes at full width.

### `section:stat-cards-mono` — Stat cards
When: the client gave three to six numbers worth showing, each with its unit and meaning.
Sketch: a row of three cards, or a grid of 3 by 2. Each card holds a short label, the number with a small unit, and one line of caption. A monospace number is fine when it is a measurement. A monospace label needs this page's reason in `Floor:`. Labels stay in sentence case at normal tracking, and a coloured dot appears only when it reports a real state.
Measures: number 48 to 64px, unit at about a third of that size. Card radius and line as in `live-ui-bento`.
Mobile: one or two columns.

### `section:alternating-rows-fading-ui` — Feature rows with fading interface
When: two to four capabilities, each needing a sentence of explanation and a real view of the product.
Sketch: each row has its heading and text, then a real capture or HTML view of the product that fades into the ground at its bottom edge. Vary the layout between rows, for example heading left with text right and the interface below at full width. Do not swap image and text sides more than twice (`floor.md`, Reflexes).
Measures: h2 at steps 4 to 5 of the fluid scale in `typography.md`. The fade covers the last 20 to 30% of the view's height. Rows are 96 to 160px apart (`space-radius.md`).
Mobile: text above the view. The view is cropped to the part that matters.

### `section:numbered-steps` — Numbered steps
When: using the product follows a real order of three to five steps.
Sketch: a list of steps, each with a number, a short title and one sentence. Beside the list, one sticky real view changes with the active step, or each step opens like an accordion. The numbers are allowed because the visitor follows the sequence. They are plain digits in the text face, not codes.
Measures: step titles 20 to 24px. The sticky view uses the card radius and line. The space between steps is 32 to 48px.
Mobile: the steps stack, and each step's view sits under it or drops out.

### `section:two-tone-statement` — Two-tone statement
When: the page needs one plain claim stated big, between two denser sections.
Sketch: one paragraph of two or three sentences in large type. The first sentence is in full ink and the rest in the 0.6 tone. Reference pages highlight single keywords in chips or colour. The Floor version changes tone only by whole sentence (`floor.md`, Type).
Measures: 32 to 44px, weight 400 to 500, measure up to about 20 words a line. The tones come from the opacity ladder in `color-finish.md`.
Mobile: 24 to 32px, same split.

### `section:mono-spec-table` — Spec table
When: the product has real specifications, limits or plan facts that a buyer compares row by row.
Sketch: rows of key and value divided by hairlines. Keys sit on the left in the text face. Values are right-aligned, in monospace when they are measurements. Reference pages set the keys in spaced capitals. The Floor version uses sentence case at normal tracking.
Measures: rows 44 to 56px tall. Hairlines at 6 to 10% ink. Values in tabular figures.
Mobile: keep the two columns. A long value wraps under its key.

### `section:configurator-pricing` — Pricing as a configurator
When: the price depends on a quantity the client priced, such as seats, storage or usage. With one or two flat prices, use a plain plan comparison in the same section instead.
Sketch: one or two controls (a slider, a stepper, toggles) compute the price from the client's own rates. A sticky summary shows the total and the action. A struck-through price appears only when the client gave both prices. The action goes to the real signup, and nothing pretends to send.
Measures: controls at least 44px tall. The summary card uses the card radius and line. The total sits at steps 4 to 5 of the fluid scale.
Mobile: the summary follows the controls, or becomes a bar fixed to the bottom of the screen with the total and the action.

### `section:hairline-faq` — Hairline FAQ
When: the visitor has real doubts the spec can answer, such as price, limits, data or cancellation.
Sketch: 4 to 12 questions in rows divided by hairlines. Each row opens with `details` and `summary`. The heading sits on the left and the questions on the right, in a column of about 600px, or in one column. Answers state only facts the client gave.
Measures: rows 56 to 72px tall when closed. Hairlines at 6 to 10% ink. Body text in the answers.
Mobile: one column. The whole row is the touch target.

### `section:dark-contrast-band` — Contrast band
When: a long page needs one change of rhythm, usually around its strongest proof or its key capability.
Sketch: one section in the inverted ground: dark on a light page, or light on a dark page. Use it once per page.
Measures: the same padding as the other sections (`space-radius.md`). The text tones are flattened and checked again on the band's own surface (`color-finish.md`, `contrast.md`).
Mobile: the same band at full width.

### `section:closing-cta-echo` — Closing action that echoes the hero
When: every Persuade page. It is the last section before the footer.
Sketch: a short title and the hero's primary action with exactly the same words, plus at most one caption with a fact the client gave. No mailing-list form, unless subscribing is the page's job.
Measures: title at steps 5 to 6 of the fluid scale. Padding at the top of the section range.
Mobile: the action at full width.

### `section:giant-wordmark-footer` — Footer with a giant wordmark
When: the brand name is short and the direction wants a strong ending.
Sketch: a plain footer with links in columns, then the product name set huge and cut by the bottom edge or the right edge. The giant name is decoration (`aria-hidden`), in a low tone. The real name stays as text in the footer.
Measures: the word spans about the container width. Tone at 0.2 of the ink, or a tint of the ground.
Mobile: the word scales to the screen width and stays cut.

## Mobile recomposition

On phones, recompose the page instead of stacking it:

- The first screen aligns left, including a hero that is centred on desktop.
- The primary action takes the full width of the container.
- The secondary visual drops out or becomes a horizontal carousel. Only the visual that proves the promise stays.
- The h1 sits between 32 and 64px. A fluid title step in `typography.md` lands there when its `clamp()` minimum falls in that range (`space-radius.md`, Mobile title).
- Grids drop to one or two columns. Hairlines and radii stay the same.
