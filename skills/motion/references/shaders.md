# Shaders

Read when a page asks for an animated shader or gradient background, usually through `@paper-design/shaders-react` (React) or `@paper-design/shaders` (vanilla).

## When

- Texture behind marketing content (a hero, a section band, text masked over it) when a CSS gradient or a still image cannot give the effect.
- Never on an Operate screen and never behind data the user reads or acts on.
- One shader instance per view. Each is a WebGL context, and browsers cap how many can live at once.

## Version

The library ships breaking changes inside `0.0.x`. Pin the exact version in `package.json` (no `^` or `~`). Read the props from the installed package's types; names and colour schemes change between versions, so props from memory or old examples break.

## Reduced motion

The library does not read `prefers-reduced-motion`. Do it yourself:

```jsx
const reduce = useReducedMotion(); // or matchMedia('(prefers-reduced-motion: reduce)')
<MeshGradient speed={reduce ? 0 : 0.3} /* ... */ />
```

With `speed` at 0 it renders one still frame.

## No WebGL2

Without WebGL2 the shader throws, and nothing catches it. So:

- The wrapper element always has a CSS background close to the shader's colours. It shows while the bundle loads, when WebGL2 is missing and if the shader fails.
- Detect support before mounting (`document.createElement('canvas').getContext('webgl2')`) and skip the shader when it is null, or wrap it in an error boundary.
- Text over the shader is legible over the CSS fallback too.

## Cost

- In full-screen use, lower `minPixelRatio` so a high-density phone does not render at full device resolution.
- Load the shader lazily (dynamic import) after the first paint, so it never delays the largest content.
- Pause or unmount it when off screen.

## Check

Load the page with WebGL disabled and with reduced motion on: both show the CSS background and readable content, with no error in the console.
