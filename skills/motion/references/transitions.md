# CSS transitions that are easy to get wrong

Read for accordions, tab indicators, chevrons, entry from `display: none`, and page transitions in CSS. Durations and curves come from `SKILL.md` step 5 or the project's tokens.

## Accordion and disclosure

- Animate a grid track, not a guessed `max-height`: the panel is a grid whose `grid-template-rows` goes from `0fr` to `1fr`, and its only child has `overflow: hidden` and `min-height: 0`.
- Padding goes on the inner child, never on the panel itself; padding on the collapsed track leaves a strip that never closes.
- Opening and closing use the same timing: it is one reversible motion.
- In Motion, height to `auto` inside `AnimatePresence` also works, for small content only.

## Chevron and icon swaps

Rotate or flip the chevron with `transform` instead of morphing its path; path interpolation in CSS works in Chromium only. Two icons in one slot crossfade with a small scale, sharing one timing.

## Tab indicator

Place the indicator at its first position (on first paint and on resize) with the transition switched off, then turn the transition back on. Otherwise it slides in from the left edge at zero width on load. Between tabs, move it with `transform` (and `width` only if tabs differ in width and the row is short). In Motion, a shared `layoutId`.

## Distance and blur

- Small travel reads as polish; large travel reads as a fling. More than about 40px is for drawers and full panels.
- Blur belongs to a swap or a slide, a few pixels at most, and settles to zero. A simple fade, or a colour or theme change, gets no blur.
- An exit can drop or shorten the travel and blur its entrance had.

## Entry from `display: none`

```css
.panel {
  transition: opacity 200ms var(--ease-out), transform 200ms var(--ease-out),
              display 200ms allow-discrete, overlay 200ms allow-discrete;
  @starting-style { opacity: 0; transform: translateY(4px) scale(0.95); }
}
.panel:not([open]) { opacity: 0; transform: translateY(4px) scale(0.95); display: none; }
```

`@starting-style` gives the first frame without a `mounted` flag in JavaScript. Without `allow-discrete`, `display` flips at once and the exit never shows. It works with `[popover]` and `<dialog>`. Older browsers simply show the element without motion, which is acceptable.

## View Transitions

- `document.startViewTransition()` for same-document swaps; `@view-transition { navigation: auto; }` on both pages for cross-document ones.
- They ignore `prefers-reduced-motion` unless you say so: under `reduce`, set the `::view-transition-*` animations to a short fade, or skip `startViewTransition`.
- Inside an app, a route change is frequent: give it no animation. Keep View Transitions for marketing pages and for a shared element that shows where content came from.

## Hover in, hover out

Hover-in is quick. Hover-out may settle a little slower, but is never delayed: leaving must feel instant. A close or dismiss is never delayed either.
