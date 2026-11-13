# GSAP

Read when GSAP is installed, or when the ladder in `SKILL.md` chose it: a pinned scroll timeline, split text or an SVG morph. GSAP is not the default for everything; a fade or a modal stays in CSS or Motion.

## ScrollTrigger

- Register it once: `gsap.registerPlugin(ScrollTrigger)`.
- A `scrollTrigger` lives on a timeline or a top-level tween only, never on a tween nested inside a timeline.
- Create triggers in page order, top to bottom. When they are created out of order (async content), give each a `refreshPriority`.
- Call `ScrollTrigger.refresh()` after fonts, images or new content change the layout (`document.fonts.ready`, image `load`). Resize is handled for you.
- Pick `scrub` (progress follows the scroll) or `toggleActions` (play and reverse at the edges), never both on one trigger.
- Animate a child of the pinned element, not the pinned element itself. A fake horizontal scroll uses `ease: "none"` on the horizontal tween.
- `markers` never reach production.
- Kill or revert triggers when their section leaves the page (SPA routes).

## React

- `useGSAP()` from `@gsap/react`, with `scope` set to the component's root ref, so selectors stay inside the component and everything reverts on unmount.
- Without it: `gsap.context(() => { ... }, rootRef)` inside `useEffect`, returning `() => ctx.revert()`.
- Tweens created later, in event handlers, are wrapped in `contextSafe(...)`, or they leak past unmount.
- Target refs, not global selectors.

## Reduced motion and breakpoints

```js
const mm = gsap.matchMedia();
mm.add({ motion: "(prefers-reduced-motion: no-preference)", reduce: "(prefers-reduced-motion: reduce)" }, (ctx) => {
  if (ctx.conditions.reduce) { gsap.set(".hero-line", { opacity: 1, y: 0 }); return; }
  // full timeline here
}, rootRef);
```

Everything created in a handler reverts when its query stops matching. Under `reduce`, content lands in its final state; pinned sections that hold navigation stay reachable.

## Split text

- Split only after the fonts load (`await document.fonts.ready`), or use `autoSplit` with the animation built in `onSplit`, so line breaks match the real font.
- Screen readers read the whole text once: the parent keeps an accessible name (`aria-label`) and the pieces get `aria-hidden="true"`. SplitText's default `aria: "auto"` does this; do not turn it off.
- Split only the level you animate (words, not characters, if only words move), and revert the split on cleanup.
- One split headline per section at most.

## Licence

Every plugin, SplitText and MorphSVG included, is free and ships in the public `gsap` package (`gsap/SplitText`). No private registry, token or membership is needed.
