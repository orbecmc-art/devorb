# Contrast

Every ratio in the system is computed, never estimated. The ratio is (L1 + 0.05) / (L2 + 0.05), where L1 is the relative luminance of the lighter colour and L2 that of the darker one (WCAG 2).

## Thresholds

- Running text on its surface: at least 4.5:1.
- Large text (as WCAG defines it), icons that carry meaning, the edge of a control and the focus ring against what is next to it: at least 3:1.
- A disabled control is exempt, but it still has to read as disabled (see the three cues in `SKILL.md`).

## The script

No dependencies. Save it outside the project (or run it from a temporary file) and pass pairs as `ink/surface`. It reads `#rgb`, `#rrggbb` and `oklch(L C H)`, with L as a number or a percentage. Convert any other notation first, or resolve it from a token you already have in one of these forms.

```js
// node contrast.mjs '#1c1917/#faf7f2' 'oklch(0.98 0.01 80)/oklch(0.45 0.1 30)'
const lin = (c) => (c <= 0.04045 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4);
const clamp = (x) => Math.min(1, Math.max(0, x));
function rgbLinear(color) {
  const s = color.trim().toLowerCase();
  let m = s.match(/^#([0-9a-f]{3}|[0-9a-f]{6})$/);
  if (m) {
    const h = m[1].length === 3 ? [...m[1]].map((d) => d + d).join('') : m[1];
    return [0, 2, 4].map((i) => lin(parseInt(h.slice(i, i + 2), 16) / 255));
  }
  m = s.match(/^oklch\(\s*([\d.]+)(%?)\s+([\d.]+)\s+([\d.]+)(?:deg)?\s*\)$/);
  if (m) {
    const L = m[2] ? m[1] / 100 : +m[1], C = +m[3], h = (m[4] * Math.PI) / 180;
    const a = C * Math.cos(h), b = C * Math.sin(h);
    const l = (L + 0.3963377774 * a + 0.2158037573 * b) ** 3;
    const k = (L - 0.1055613458 * a - 0.0638541728 * b) ** 3;
    const q = (L - 0.0894841775 * a - 1.291485548 * b) ** 3;
    // shortcut: out-of-gamut values are clipped, not gamut-mapped; check such a pair in the browser
    return [
      4.0767416621 * l - 3.3077115913 * k + 0.2309699292 * q,
      -1.2684380046 * l + 2.6097574011 * k - 0.3413193965 * q,
      -0.0041960863 * l - 0.7034186147 * k + 1.707614701 * q,
    ].map(clamp);
  }
  throw new Error(`unsupported colour: ${color} (use #rgb, #rrggbb or oklch(L C H))`);
}
const luminance = (c) => { const [r, g, b] = rgbLinear(c); return 0.2126 * r + 0.7152 * g + 0.0722 * b; };
const ratio = (a, b) => { const [x, y] = [luminance(a), luminance(b)].sort((p, q) => q - p); return (x + 0.05) / (y + 0.05); };
for (const pair of process.argv.slice(2)) {
  const [fg, bg] = pair.split('/');
  const r = ratio(fg, bg);
  console.log(`${pair}  ${r.toFixed(2)}:1  text ${r >= 4.5 ? 'ok' : 'FAIL'}  large/UI ${r >= 3 ? 'ok' : 'FAIL'}`);
}
```

Known answers, to trust it before use:

```
$ node contrast.mjs '#000/#fff' '#767676/#fff' '#777/#fff'
#000/#fff  21.00:1  text ok  large/UI ok
#767676/#fff  4.54:1  text ok  large/UI ok
#777/#fff  4.48:1  text FAIL  large/UI ok
```

## How to run it

1. List every pair from `color-roles.md` that the system defines, plus `border` and `ring` against each surface they touch.
2. Run all of them for the light theme in one command, then all of them again for the dark theme.
3. Read the threshold that applies to each pair (text or large/UI), not just the first `ok`.
4. A failing pair: move the lightness of the ink or the surface until it passes, keep the hue, and run it again.
5. Copy the final output, per theme, into `DESIGN.md` and into your final message.
