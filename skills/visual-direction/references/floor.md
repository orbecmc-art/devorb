# Floor

Read before the first line of UI code. Two tiers:

- **Floor:** holds on every page, in every mode, whatever the direction. Never waived.
- **Reflexes:** defaults a model falls into. One may be kept only with a reason that comes from this page, written in the contract's Floor line. "It looks good" is not a reason.

Above the floor the page belongs to the direction. Building it, no need to recite this list.

## Floor

**Structure**
- Colours and font families are referenced through tokens only (CSS custom properties or the project's theme); a raw value appears only where the tokens are declared.
- `overflow-x: clip` on both `html` and `body`; never `hidden` there, and no `100vw` widths.
- Grid tracks that hold images use `minmax(0, 1fr)`; large headings can break long words (`overflow-wrap: break-word; min-width: 0`).
- The content container has a maximum width and stays centred, so a 1920 px screen adds empty margin, never longer lines or extra columns.
- On Persuade, the headline, the one sentence and the primary action are all visible at 1280 x 800 without scrolling.

**Document and access**
- `lang` matches the content (`pt-BR` for Brazilian Portuguese), a `<title>` and a meta description in the page's own words, heading levels that step one at a time.
- A "skip to content" link is the first focusable element and targets `<main>`.
- Focus rings (`:focus-visible`) appear at once, with no transition, on everything reachable by Tab. Every animation has a `prefers-reduced-motion: reduce` fallback, and the content shows with scripts off.
- The image that is the largest thing in the first screen is not `loading="lazy"`.

**Honesty**
- No invented number, testimonial, client logo, rating or count. What the client must prove and has not is marked as missing in the handoff, never filled.
- No `href="#"` and no made-up route. A form with no endpoint never shows success.
- No drawn browser or OS window, and no image URL written from memory.
- No status the page cannot back: an "online" or "all systems operational" badge, a live dot, a version or build string, a "last synced" time with nothing measuring it.

**Type**
- No single word set apart inside a heading (italic, colour, weight or highlight on one word).
- Small text (nav, tags, column heads, captions, labels) is the text face slightly smaller, in sentence case, at normal letter-spacing; never spaced-out capitals.
- Metadata is separated by line breaks or columns, not chains of middle dots ("A · B · C"). Links and buttons end with their words, no arrow appended. A coloured dot appears only when it reports a real state.

## Reflexes

Keep one only with this page's reason, recorded.

- A short label above a section heading. It survives only when it carries a fact, a destination or an identifier (`references/copy.md`).
- Three or more equal cards of icon, title and two lines as the page's structure; any card inside a card.
- Section numbers or codes ("01", "SEC-02") on content that is not a sequence anyone navigates by.
- A strip of city, clock or weather; a "since" year the client did not give.
- Glow, blurred colour blobs, gradient fills on text, glass panels used as decoration.
- A mailing-list close on a page whose job is not subscribing.
- One layout repeated in every section (centred heading over a grid, or image and text swapping sides more than twice).
- Monospace on labels and small text that are not code or measurements.

## Spent looks

These come out of models whatever the subject. Each is fine when the brief asks for it; reached for on a free brief, it means nothing was decided. Compare the plan with this table:

| Look | Ground | Display face | Accent | Giveaway |
|---|---|---|---|---|
| Warm paper | off-white, OKLCH lightness 90% or more, hue 55 to 105 | high-contrast serif | clay or rust, hue 15 to 55 | italic flourishes |
| Dark neon | lightness 15% or less | heavy sans | one, chroma 0.2 or more | glow around it |
| Newsprint | light | italic serif | none or one | hairlines everywhere, square corners, tiny mono caps tracked 0.08em or more |
| Card kit | white or pale grey | any | any | equal boxes, one radius at every level, the same shadow (black near 10% opacity, 10 px blur or more) under each, gradient wash behind |
| Product default | near-white | tight grotesque, heavy | a framework's stock blue or violet | 1 px border under a soft shadow |

If the plan matches a row the brief never asked for, change it and record what changed. Try another accent before touching the ground or the display face.
