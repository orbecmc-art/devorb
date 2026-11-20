# Lists: what the screen draws

Read this when a screen draws more rows at once than fit in view.

## Page first

A page of 50 rows from the server needs no virtualization. Paginate the read (`reads.md`) and draw the page. Virtualize when the user must scroll one long list without page breaks: a spreadsheet-like grid, an infinite feed, a log.

## Virtualization

Only the visible rows are in the DOM, plus a few above and below.

- Use the virtualizer the project already has (the data grid's own, TanStack Virtual, react-window).
- The scroll container keeps the full height: a spacer sized to row count × row height, with the visible rows positioned inside it. Fixed row height is the cheap case; variable height needs measuring.
- Cells count, not rows: 85 columns × 30 visible rows is 2,550 cells. A wide table draws its list columns (`SKILL.md`), not every column.
- Long data arrives in pages as the user scrolls (the cursor of `reads.md`), never all at once.
- Row keys are the row ids, so a scrolled row is reused and not rebuilt.

## What virtualization takes away

- The browser's find (Ctrl+F) sees only the rows in the DOM: the screen needs its own search.
- A screen reader needs the real size: `aria-rowcount` on the table, `aria-rowindex` on each row.

## Check

- The number of row elements in the DOM stays flat while scrolling to the end.
- INP is a browser measure: take it in a real browser, on the list filled to the real volume.
