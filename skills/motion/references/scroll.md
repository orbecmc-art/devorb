# Scroll

Read for scroll reveals, scroll-linked progress, pinned or scrubbed scenes and horizontal rails. A landing page gets one authored moment; a pinned or scrubbed sequence of acts needs a brief that asks for an immersive page. Without that brief, build the one moment and stop.

## Content first

- The page is complete and readable with no JavaScript and under reduced motion. Motion is added on top of the final state.
- The hero is visible at load. Nothing in the first screen waits for a scroll.
- A reveal starts from an `IntersectionObserver` at about 30% visibility, fires once, and never uses a raw `scroll` listener.
- CSS scroll timelines (`animation-timeline: view()` or `scroll()`) go inside `@supports (animation-timeline: view())`, outside of which the content simply shows, and `animation-fill-mode: both`.
- Repeated fade-ups on every section are decoration: they keep content from people who scroll fast. Cut them.

## Pacing an immersive page

- Before choosing devices, write the feeling the visitor should have at each act. If two neighbouring acts give the same feeling, cut one.
- One peak per page, given the largest scroll span. Several peaks flatten each other. The ending settles; administrative parts (specs, FAQ) stay short and plain.
- At most two scrubbed acts per page.

## Scrubbed video

- Map the clip over the full time the stage is on screen (from entering the viewport to leaving it), not only the pinned travel; otherwise it sits frozen while sliding in and out.
- Scroll writes a target time; one `requestAnimationFrame` loop moves the playhead a fraction of the way each frame. Writing `currentTime` straight from wheel events stutters. Under reduced motion, no smoothing.
- Encode for seeking: frequent keyframes (short GOP), no audio track, a separate mobile encode in the right orientation, `muted playsinline`, and a poster image under it.
- iOS paints nothing on a muted video that was never played: prime it with `play()` then `pause()`, and retry on the first touch end. Test on a real iPhone; headless browsers do not reproduce this.
- Under reduced motion, clips are not fetched: the poster holds and the copy still appears.

## Pinned sections

- Animate the content inside the pinned frame, not the frame. Pinned stages use `100svh` on mobile so the address bar does not make them jump.
- Tab through: focus order follows the visual order, and a focused element inside a pinned act is scrolled to where it is visible.

## Horizontal rail

- Measure the real overflow (`scrollWidth - clientWidth`) and travel exactly that; never assume it.
- The rail's movement is navigation, not decoration. Under reduced motion it becomes a native `overflow-x: auto` region with scroll snapping, so every item stays reachable.

## Counters

Only real numbers, given by the project. They run once, when about half visible, with a strong ease-out over a little more than a second, inside the same fade as their block.

## Cost

One frame loop for the whole page, lazy-loaded heavy scenes, observers and loops removed on unmount, no full-screen `backdrop-filter` while scrolling. See `performance.md`.
