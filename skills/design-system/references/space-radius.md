# Space and radius recipe

Numbers measured on 21 reference landings in November 2026. They fill what the contract leaves open. **The direction fixes what the spec fixes:** a spacing, radius or layout named in the spec, the contract or an existing `DESIGN.md` wins over this file.

## Space

- **Base:** 4px, with 8px steps for most gaps inside components. Density belongs inside cards; the space between sections stays wide.
- **Large scale** for sections and big gaps: 64, 80, 128, 160, 200 and 256px.
- **Section padding:** 96 to 160px of vertical space per section at 1440. Hospitality and editorial pages may go wider.
- **Fluid section padding:** generate it with the same script as the type scale, using one step and a ratio of 1. Example, 64px at 360 to 128px at 1440:

```bash
node <this skill>/scripts/fluid-scale.mjs --min-width 360 --max-width 1440 \
  --min-base 64 --max-base 128 --min-ratio 1 --max-ratio 1 --steps 0..0
--step-0: clamp(4rem, 2.6667rem + 5.9259vw, 8rem);
```

  Rename the output to the project's token (for example `--space-section`).

## Radius

| Where | Radius |
|---|---|
| Product and devtools: cards, buttons, inputs | 4 to 8px |
| Consumer products: cards | 12 to 16px |
| A whole section drawn as a rounded panel | 24px |
| Pill (fully round) | buttons and chips only |
| Luxury and restaurant pages that use square corners | 0 |

## Mobile title

On a phone the h1 sits between 32 and 64px. A fluid title step from `references/typography.md` already lands there when its value at 360 falls in that range: check the first number of its `clamp()` (in rem, × 16).
