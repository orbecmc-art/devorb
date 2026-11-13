# Worst-case data pass

Sample data flatters a screen: short names, counts above one, no field left blank. This pass swaps in the hardest data real use would bring and reports what breaks. It runs in the browser session only; the project's files stay as they were.

## 1. Map the rendered values

List every value the screen shows that comes from data, with where it comes from and its limit:

| Value | Source | Limit | Optional |
|---|---|---|---|
| member name | `member.name` | 120 (`schema.ts:22`) | no |
| e-mail | `member.email` | unbounded | no |
| member count | `team.members.length` | none | no |

Counts inside headings, status badges, relative dates, data-driven button text, avatars and each list's length are values too. Find limits in validation schemas, migrations, API types and `maxlength`. Where nothing caps a value, write "unbounded"; that gap is a P3 finding. A form cap shorter than the column behind it is noted.

The pass is done when every rendered value has a row with a source and a limit or "unbounded".

## 2. Build plausible worst cases

Each value is either something seen in real use or the exact maximum the schema allows. A value no one would ever type is easy to dismiss and weakens the whole report.

- Long but real: a double-barrelled surname with a particle, a company e-mail on a long subdomain, a street address with a complement, a product name with its variant.
- Short: a two-letter first name, a one-character field, a missing optional field.
- Numbers: 0, 1, a count in the thousands, a price with cents, a negative balance.
- Text the screen did not plan for: accents and cedilla (the sites are in Portuguese), an emoji, a non-Latin name.
- Lists: **empty**, exactly **one** item (every count at 1, for plurals), and **huge** (the realistic maximum, past a thousand rows when nothing paginates).

Put a different worst case in each of the visible rows.

## 3. Enter through the data boundary

The worst case comes in where the real data does, never by editing the component's markup or styles:

- Data from an API: intercept the request in the browser run (`page.route`) and answer with the worst-case body.
- A fixture or mock file: load a copy from a scratch folder outside the project through the same route.
- A static page with text in the markup: replace the text of the data nodes in the browser session only.

## 4. Look at it

At the container's real width, at 320 px, at the widest layout, and with the root font size at 200 %. In dark mode when the product has one.

| What shows | Usual cause | Where to look |
|---|---|---|
| "1 members", "0 member" | plural written by hand | the string building the label; `Intl.PluralRules` or one string per count |
| A round avatar or icon comes out oval | a box meant to keep its size gives way inside a flex row | `flex-shrink` on the avatar |
| Text spills past its container | a flex or grid child left at `min-width: auto` | `min-width: 0`, `minmax(0, 1fr)` |
| An e-mail, link or code crosses the edge | the string has no place to break | `overflow-wrap` on that element |
| A heading breaks in the middle of a word with room to spare | `word-break: break-all` | `overflow-wrap` on the heading |
| The row's last control disappears or is clipped | the text before it grew and nothing stopped it | `min-width: 0` on the middle, `flex-shrink: 0` on the action |
| A status badge splits over two lines | the badge may shrink | `white-space: nowrap` on the badge |
| Text ends in an ellipsis and the rest is nowhere | truncation with no way to reveal it | a `title`, a disclosure or a detail view |
| Accents cut off at the top of a line | `overflow: hidden` on a box with tight `line-height` | the text box's height and overflow |
| Initials wrong or a broken glyph in the avatar | initials cut by character position, not by letter | the initials function |
| A lone dash or an empty line where a field was missing | a stand-in printed for an absent value | the optional field's render |
| `NaN`, `undefined`, or 1284 with no thousands separator | the raw value reached the screen | `Intl.NumberFormat` with the page's locale |
| Columns of figures do not line up | digits of unequal width | `font-variant-numeric` |
| The long list scrolls in jerks | all rows drawn at once | pagination or virtualization |

`overflow-wrap`: data that must stay whole and has no spaces (e-mails, URLs, codes) takes `anywhere`; headings take `break-word`, which breaks a word only when it cannot fit any other way. A heading on `anywhere`, or data on `break-word` that still overflows, is a finding.

Never cut a figure, price or date short; people compare them.

## 5. Report

Each break is a finding in the main report with the value that caused it, what happened, the cause and `file:line`. Where more than one answer is right (wrap or truncate a field, what an empty role shows, paginate or virtualize), say so in one line: the decision is the user's. List the worst cases the screen already handles, so the pass is visibly real.
