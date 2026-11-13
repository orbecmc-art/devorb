# Choreography

Read when two or more elements move in response to one event. Good choreography mostly removes moving parts and runs the rest at the same time.

## Roles first

Before any timing, give every element that would move one role:

- **Lead:** what the user has to notice (the new view, the item acted on). It moves first and furthest.
- **Support:** content that follows the lead. Shorter, smaller motion.
- **Decoration:** badges, pills, dividers. Fade only, or nothing.
- **Still:** everything else, including a container whose content already moves.

Two leads means the layout has a hierarchy problem; motion will not fix it. Say so.

## Rules

- **One entrance per container.** If a panel slides in, its items are already inside it. Never animate the panel and then stagger its children.
- **No stagger on frequent or keyboard UI.** Menu rows, dropdown items, command results and tab content appear together, or without motion.
- **Same moment, same start.** Parts of one object (a drawer and its content, a removed chip and the gap closing) start together in one timing family.
- **A leaving element stops taking space at once,** so its neighbours close the gap while it fades. In Motion, `AnimatePresence mode="popLayout"`.
- **Swapping views in one place is a crossfade:** the old one leaves while the new one arrives.
- **Sequence only when order means something:** cause then effect, reading order, or one thing that must land before another appears. Start the second slightly before the first ends.
- **Secondary motion hooks to the event that caused it** (the click, the landing), not to a delay tuned by eye.

## Stagger

- Product UI: 30 to 80ms between items, and the whole group done in about 300ms. In a long list, stagger the first few and bring the rest with the last.
- A landing hero or first-run moment may use 100 to 150ms steps, because it is seen once per visit.
- Never uniform: vary the delay and the distance by importance (the lead travels most, decoration only fades). Gaps that shrink feel organic; even gaps feel robotic.
- Order runs with the reading direction, or outward from the point the user touched.

## Exits

Everything leaves together, faster and simpler than it came in, along the same path it entered. No reverse stagger: the user already decided to leave. Pass the direction to the exit (Motion: give the same `custom` value to `AnimatePresence` and to the leaving child), or it leaves with the old direction.

## Interruption

Trigger it again halfway: click twice, hover out mid-sequence, switch views while one is opening. Each run stops what is in flight before starting; nothing stacks. With `AnimatePresence`, check that fast switching never leaves two children mounted, and give each child a stable unique `key`.

## Reduced motion

Collapse the sequence: no delays, no travel, everything fades in together. When the sequence itself teaches something, cut between its states without tweening.

## Check

Screen-record it and scrub the recording slowly: overlap and waiting in line only look different at low speed. Then picture the fiftieth use today: if you would skip it, cut it.
