# Motion for React

Read when the project uses Motion (`motion`) or the older `framer-motion`, or when a Radix or Base UI component needs an exit animation.

## Package and imports

- New code imports from `motion/react`. A project that already has `framer-motion` keeps it, with the same API; never install both.
- In Next.js App Router, every file that imports hooks, `AnimatePresence` or `MotionConfig` starts with `"use client"`. A server component can render `motion` elements from `motion/react-client` only.
- `x`, `y`, `scale` and `rotate` are accelerated from version 14.2 of the package; on older versions, animate a full `transform` string when the page is busy.

## Reduced motion, once

Put one `<MotionConfig reducedMotion="user">` at the app root. For users who asked for less motion it skips movement and layout changes but still plays fades and colour changes. For custom values, `useReducedMotion()` (for example a drawer that only fades).

## `AnimatePresence`

- It stays mounted; the condition goes inside it: `<AnimatePresence>{open && <Panel key="panel" />}</AnimatePresence>`.
- Every direct child has an `exit` and a `key` that never changes and is not shared. Without either, the exit silently never runs.
- `mode="popLayout"` removes the departing child from flow immediately, letting neighbours slide into its space (the parent needs a non-static `position`). Use `mode="wait"` only when two dense views would overlap badly inside one changing container; never on route changes inside an app, which get no animation.
- `initial` matches what the server rendered. Content the user must see is never hidden behind a conditional `initial`.

## Layout

- `layout` on an element that resizes or moves when React re-renders.
- One element moving between two places (a tab indicator) shares a `layoutId`. When the component can appear twice on a page, make it unique with `useId()`.
- `Reorder` only answers to the pointer: add a keyboard way to move items (arrow keys, or move-up and move-down buttons).

## Radix and Base UI exits

The component normally unmounts itself before an exit can play. To animate it out:

1. Lift its open state into `useState` (`open` and `onOpenChange`).
2. Render it inside `AnimatePresence` under that condition.
3. Keep it mounted for the exit: `forceMount` on the Radix part that accepts it (never on a DOM element), or `keepMounted` on the Base UI `Portal`.
4. Attach motion through `asChild` (Radix) or the `render` prop (Base UI) with a `motion` element, animating at least one of `opacity`, `transform`, `filter` or `clip-path`.

## Motion values

Never read a motion value during render; read it in effects and callbacks. Chain `useMotionValue`, `useTransform` and `useSpring` instead of imperative updates. Subscribe with `value.on("change", fn)`.

## Springs

`{ type: "spring", bounce: 0, visualDuration: 0.3 }` is the default shape. Raise `bounce` only for a release after a drag. Serious products (finance, health, admin) get no overshoot anywhere.
