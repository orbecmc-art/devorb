# Performance

Read when picking a property beyond `transform` and `opacity`, when something stutters, when many elements move, or when you write a frame loop.

## The budget

A 60Hz screen gives each frame about 16.7ms; a 120Hz phone gives about 8ms. Design for the smaller number and judge on a mid-range phone, never on the development laptop.

## Which properties

| Cost | Properties | Use |
|---|---|---|
| Cheapest (compositor) | `transform`, `opacity`; in current engines also `filter`, `clip-path` | Default |
| Repaint each frame | `box-shadow`, `border-radius`, `color` | Short, small elements only |
| Layout, paint and composite | `width`, `height`, `top`, `left`, `margin`, `padding`, `border-width` | Avoid |

Swaps: grow with `scale()` instead of size; move with `translate()` (a percentage is a fraction of the element's own box) instead of `top`, `left` or `margin`; fade with `opacity` instead of toggling `display` or `visibility`; animate `filter: drop-shadow()` instead of `box-shadow`. A layout property also pushes its neighbours every frame: a sidebar animating `margin` re-lays out the whole page.

## Where it runs

- CSS transitions, keyframes and `element.animate()` can run off the main thread, so they stay smooth while the page fetches, hydrates or navigates.
- A `requestAnimationFrame` loop always runs on the main thread and drops frames when it is busy. Use CSS or WAAPI for motion that plays during loading or route changes.
- In Motion, `transform`, `opacity`, `filter` and `clip-path` can be accelerated. `onUpdate`, layout animations, SVG and values set every frame fall back to the main thread.

## Frame loops

Inside anything that runs every frame (`requestAnimationFrame`, `useFrame`, pointer and scroll handlers, `useTransform` callbacks):

- No `setState`. Write `ref.current.style` or set a motion value.
- No new objects or arrays per frame. Reuse and mutate.
- One loop per page, not one per element. No raw scroll listeners: use the library's scroll progress, an `IntersectionObserver` or `animation-timeline`.
- Stop the loop when the element leaves the screen, when the tab is hidden, and on unmount.

## Traps that still use `transform`

- **A custom property set on a parent** that children read in `transform`: every change restyles every descendant. It gets worse as content grows. Set `transform` on the element.
- **Blur:** expensive, worst in Safari. Keep it small and off large surfaces.
- **Many nodes at once:** a hundred cards entering together is a hundred layers. Animate the few that matter.

## `will-change`

Browsers already promote elements that animate `transform` or `opacity`. Add `will-change` only after you see a one-pixel shift at the start or end, or measured dropped frames, on the moving element only, and remove it when the motion ends. Layers take GPU memory.

## Diagnose in this order

1. Which properties animate? Layout ones first, then shadow and radius.
2. Does the stutter coincide with loading or navigation? Move to CSS or WAAPI.
3. Does React re-render each frame?
4. Does it slow down as the list or page gets longer? Look for an inherited variable or too many moving nodes.
5. Only then `will-change`.

Confirm with a recording (the browser's performance panel), not by feel, and say which findings need a real device.
