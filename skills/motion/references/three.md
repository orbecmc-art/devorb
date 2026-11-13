# Three.js and React Three Fiber

Read when a page asks for 3D.

## When 3D is worth it

- Only when the object is the point of an immersive brief: a product to turn around, a scene the visitor explores.
- Tilting a card, a parallax layer or a perspective flip is CSS `transform` (`perspective`, `rotateX`), not WebGL.
- 2D particles or generative lines: a Canvas 2D loop is lighter.

## Setup

- Pin the exact `three` version (and `@react-three/fiber`, `@react-three/drei`). Fiber's major version follows React's: read the React version in `package.json` first.
- Import the scene with a dynamic import (`import()`, `next/dynamic` with `ssr: false`), so it is a separate chunk loaded after the first paint.
- `WebGLRenderer` stays the default. Choose `WebGPURenderer` only for TSL materials or compute, and `await renderer.init()` before the first frame.
- Clamp the pixel ratio to 2: `renderer.setPixelRatio(Math.min(devicePixelRatio, 2))`, or `dpr={[1, 2]}` on the Fiber `<Canvas>`.
- In Fiber, wrap loaded content in `<Suspense>` and keep the `<Canvas>` parent small, since its re-renders reach the scene.

## Rendering

- Static or mostly still scenes render on demand: `frameloop="demand"` and `invalidate()` in Fiber, or render only on change in vanilla.
- Inside `useFrame` or the loop: no `setState`, no new vectors or objects per frame. Reuse them.
- Many identical meshes are instanced. Compress models (Draco) and textures (KTX2).
- Stop the loop when the canvas is off screen or the tab is hidden.

## Cleanup

On unmount call `dispose()` on geometries, materials, textures and the renderer, cancel the animation frame and disconnect observers. Fiber disposes what it created; dispose by hand anything created outside it.

## Fallback

A static poster image of the scene, in the same box, shows:

- while the chunk and models load;
- under `prefers-reduced-motion: reduce` (keep the poster, or render one still frame with no camera motion or autorotation);
- when WebGL is not available (check before mounting) or the context is lost.

Content and calls to action never depend on the canvas.

## Check

Load it on a mid-range phone, with reduced motion on, and with WebGL disabled: the page stays usable in all three, and leaving the page frees the GPU memory.
