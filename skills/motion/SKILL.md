---
name: motion
description: Use when anything in a web UI will move (transition, animation, gesture, scroll effect, shader or 3D background), or when existing motion is audited or removed
---

# Motion

This skill decides whether anything moves and how: tool, properties, curve, duration, interruption and the reduced-motion version. It is the only one that picks duration and curve. When the project keeps motion tokens (`DESIGN.md`, CSS variables, a Tailwind theme), use them; add a token only when none fits, and add it to the same place.

Three modes: **build** (default), **audit** and **remove** (both at the end). In build, walk steps 1 to 7 in order for each thing that moves; step 1 can end the work.

## 1. Should it move?

| How often the user meets it | Decision |
|---|---|
| 100+ times a day, or opened from the keyboard (command palette, shortcuts, list navigation) | No motion. Stop here. |
| A few dozen times a day (hover, toggles) | Barely visible and fast, or nothing |
| Occasionally (modal, drawer, toast, menu) | Standard motion |
| Rarely or once (onboarding, success, a landing hero) | The only place for delight |

Writing no animation is a valid result: say which row decided it. Data the user reads or acts on (charts, tables, totals) moves only to show a real change in value, never on every load. A marketing page gets **one authored moment**, not motion on every section, and the page reads complete without JavaScript: the markup holds the final state, and motion only enhances it.

## 2. Name the purpose

Feedback, where something came from or went, a state change, bridging a jump that would otherwise teleport, explanation (marketing and onboarding only) or delight (rare row only). If none fits, do not build it.

## 3. Pick the tool: the ladder

Stop at the first rung that fits.

1. **What `package.json` already has.** A motion library already installed is the one you use; never add a second.
2. **Nothing installed: CSS.** Transitions for state changes, `@starting-style` with `allow-discrete` for entry from `display: none` (no `mounted` flag), keyframes for fixed sequences that play during loading (they run off the main thread), `element.animate()` for programmatic control.
3. **Motion** (`motion`, imported from `motion/react`) for React UI that needs exit animations, layout animations or gestures. Read `references/motion-lib.md`.
4. **GSAP** for pinned scroll timelines, split text and SVG morph. Read `references/gsap.md`.

When CSS is not enough and nothing is installed, install `motion`, never alongside `framer-motion`. A toast, drawer or command menu is a component job: use the specialist library from the direction contract, not hand-built motion. A library not yet installed is named in the contract first.

## 4. Properties

- `transform` and `opacity` by default. `clip-path` and `filter` are allowed; blur stays at or under 14px, never on a plain fade, never full screen.
- `height` only on a small disclosure such as an accordion. Never `width`, `top`, `left`, `margin` or `padding`.
- Enter from about `scale(0.95)` with `opacity: 0`, never `scale(0)`. Travel stays short; more than about 40px is for drawers.
- Popovers, menus and tooltips grow from their trigger (`transform-origin`); a modal stays centred.
- Press feedback: `:active` with `scale(0.95–0.98)`. Hover motion only inside `@media (hover: hover) and (pointer: fine)`.
- Write `transform` on the moving element. Changing a custom property on a parent restyles every descendant on each frame. In React, a hand-rolled loop writes `ref.current.style`, never state.

Details, and what to do about jank: `references/performance.md`.

## 5. Curve and duration

- Enter and exit with a strong ease-out; when the project has none, define one token, for example `cubic-bezier(0.16, 1, 0.3, 1)`. `ease-in-out` for something moving across the screen, `linear` only for constant motion or a hold that shows time passing. Never `ease-in` on UI.
- At most 300ms for modal, menu, popover and toast; at most 500ms for drawer, page change and a one-off moment; 150ms or less for hover and press.
- Closing is shorter than opening, with no delay and no overshoot. Symmetric pairs (tabs, accordion) use the same timing both ways.
- Springs default to `bounce: 0`. Bounce only on release after a drag.
- Two or more things moving on one event: read `references/choreography.md`.

## 6. Interruption

- Toggles, toasts and anything triggered in quick succession use transitions: a transition picks up from wherever the value is now, while keyframes jump back to their first frame.
- Gestures end in a spring that carries the release velocity. Read `references/gestures.md` for drag, swipe and sheets.
- Leave the way it came in. Holding is slow and linear; letting go is fast.
- An infinite loop only shows a real ongoing state (loading, live). Automatic motion running past 5 seconds has a visible pause control, and every loop pauses off screen and on `visibilitychange`.

## 7. Reduced motion ships with it

Under `prefers-reduced-motion: reduce`, cut the movement (translate, scale, rotate, parallax, bounce, stagger delays) and keep opacity, colour and the state change itself. Write it per animation; a global `0.01ms` rule erases useful feedback. Reduced motion cuts movement, never reach: navigation, a horizontal rail (it becomes native scroll) and drag tracking stay usable. Focus rings appear at once: `outline` and `box-shadow` never sit in a `transition` list. WebGL, canvas and video backgrounds show a static poster under reduced motion, while loading and without WebGL2.

## Never ship

| Do not ship | Ship |
|---|---|
| `transition: all` | Name each property |
| `scale(0)` entrance | `scale(0.95)` plus `opacity: 0` |
| `ease-in` on UI | Strong ease-out |
| Motion on a keyboard or 100+/day action | Instant change |
| Modal, menu or toast over 300ms; drawer or page over 500ms | Shorter |
| Keyframes on toggles and toasts | Transitions |
| Layout properties animated | `transform`, `opacity`; `height` only in a small disclosure |
| Focus ring inside a transition | Instant ring |
| Global `0.01ms` reduced-motion kill | Per animation, opacity kept |
| Content hidden until a script or observer runs, or a conditional `initial` | Full markup, motion on top |
| `will-change` added in advance | Only after a measured shift or dropped frames |
| WebGL or shader with no static fallback | Poster in CSS |
| Animated route change inside an app (`mode="wait"`) | No route animation |
| Uniform stagger, or stagger on frequent UI | Varied 30–80ms steps, or none |

## Audit mode

List every animated thing (search for `@keyframes`, `transition`, `animation`, `gsap`, `motion.`, `AnimatePresence`, `whileInView`, `IntersectionObserver` and `prefers-reduced-motion`). Put each through steps 1 to 7 and the table. Report `file:line`, what it does, the verdict (keep, reduce, remove, fix) and the step that decided it, worst first. Change nothing unless asked.

## Remove mode

Only subtract. Keep motion that smooths over an abrupt jump. For each removal, also delete what depended on it: the hidden start state (`opacity: 0`, `initial`, a reveal class), waits on `transitionend`, `onAnimationEnd` or timers sized to the duration, work in `onExitComplete` and focus that an animation callback moved (both now run at the moment of removal), then orphaned keyframes, variants and `motion.*` wrappers. Propose removing an unused library; do not uninstall it.

## References

| Read | When |
|---|---|
| `references/choreography.md` | Two or more elements move on one event |
| `references/gestures.md` | Drag, swipe, sheet, anything following the pointer |
| `references/performance.md` | Jank, many moving elements, frame loops |
| `references/transitions.md` | Accordion, tabs, chevrons, `@starting-style`, View Transitions |
| `references/motion-lib.md` | Motion or `framer-motion` in React, Radix or Base UI exits |
| `references/gsap.md` | GSAP is installed or chosen |
| `references/scroll.md` | Scroll-linked, pinned or scrubbed scenes, reveals, horizontal rails |
| `references/shaders.md` | An animated shader or gradient background |
| `references/three.md` | 3D, three.js or React Three Fiber |

After the code, say in a few lines: the step 1 row and the purpose, the tool, properties, curve and duration, anything refused and why, and what still needs a feel check on a real phone.

## Connects to

- **Receives:** `devorb:implementing` whenever something on screen moves, or a request to animate, audit or remove motion.
- **Uses:** the project's tokens from `devorb:design-system` (`DESIGN.md`) when present, the direction contract's libraries, and the references above.
- **Hands off to:** `devorb:implementing` to continue the build; `devorb:ui-review` measures the result against these rules.
