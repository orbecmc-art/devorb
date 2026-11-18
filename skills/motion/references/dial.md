# The motion dial

The `Motion level` in a page's direction contract (`## Direção visual`) sets how much the page moves. Steps 1 to 7 still apply to every moving thing; the level only sets how far each may go. Without a level, use Equilibrado.

| Level | When | What moves |
|---|---|---|
| Suave | minimal, editorial and system pages | fade plus a 4–12px shift, nothing else |
| Equilibrado (default) | most pages | staggered entrances, live hover, counting numbers, a mockup with slight motion |
| Impacto | asked for, or recommended by the guide and accepted | scroll scenes, an element held while the page scrolls, kinetic type, light, 3D |

## Numbers for every level

- Open in about 250ms, close in about 150ms.
- A stagger step of about 40ms, the whole cascade under 300ms.
- Nothing bounces, and a close never waits.

## Per level, with the measured ranges

These ranges come from our own headless study of five animated reference sites, reading the running animations during load, at each scroll step and on each hover. None of the five sits at Suave; each range below says which level it belongs to.

- **Suave.** No measured range applies: keep the numbers above. Each entrance is opacity plus a 4–12px translate, about 250ms, ease-out, with no scale, rotation, parallax or pinned scene. A cascade, if any, steps about 40ms and ends under 300ms.
- **Equilibrado.** Section entrances measured with a median of 350–500ms, which stays inside the 500ms ceiling for a one-off moment in step 5. Curves were strong ease-outs, from `cubic-bezier(0, 0, 0.58, 1)` to the steeper `cubic-bezier(0.33, 1, 0.68, 1)` and `cubic-bezier(0.19, 1, 0.22, 1)`. Stagger steps measured 40–100ms; use varied 40–80ms steps and keep the cascade under 300ms. Hover measured a median of 150–160ms with `ease`, `ease-out` or `cubic-bezier(0.4, 0, 0.2, 1)`, which matches step 5.
- **Impacto.** Entrances measured with a median of 500–700ms, and scroll entrances up to 1000ms. Moves across the screen used in-out curves such as `cubic-bezier(0.65, 0, 0.35, 1)`, and one site compiled springs to `linear()`. Stagger steps measured 20–100ms. A scene tied to scroll is scrubbed, so its length is scroll distance, not time; read `references/scroll.md`.

The study sees only what `document.getAnimations()` reports. Motion a script writes frame by frame does not show, so a site with few measured animations may still move a lot.

## With a reference

With a reference, its rhythm wins over this table: take its durations, curves and stagger from the capture's `Movimento` line or a look at the live page.

## Always

- `prefers-reduced-motion` is mandatory at every level, as in step 7.
- React Bits and transitions.dev components come only by installing them through their registry into the user's project, in a React stack, and under each one's license. Never copy their code into the page by hand.
