# Typography recipe

Numbers measured on 21 reference landings in November 2026. They fill what the contract leaves open. **The direction fixes what the spec fixes:** a size, weight, family or ratio named in the spec, the contract or an existing `DESIGN.md` wins over this file.

## Fluid scale

Each step is one `clamp()` that grows from the smallest screen (360px) to the widest (1440px). Generate it, never write the numbers by hand:

```bash
node <this skill>/scripts/fluid-scale.mjs --min-width 360 --max-width 1440 \
  --min-base <body px at 360> --max-base <body px at 1440> \
  --min-ratio <r> --max-ratio <r> --steps -1..6
```

Ratio by mode:

| Mode | Ratio at 360 to ratio at 1440 |
|---|---|
| Persuade | 1.25 to 1.333 |
| Read | 1.2 to 1.2 |
| Operate | 1.125 to 1.2 (1.125 when dense) |

Example, Persuade with a 15 to 16px body:

```
--step--1: clamp(0.75rem, 0.7499rem + 0.0003vw, 0.7502rem);
--step-0: clamp(0.9375rem, 0.9167rem + 0.0926vw, 1rem);
--step-1: clamp(1.1719rem, 1.1182rem + 0.2387vw, 1.333rem);
--step-2: clamp(1.4648rem, 1.3608rem + 0.4623vw, 1.7769rem);
--step-3: clamp(1.8311rem, 1.6519rem + 0.7964vw, 2.3686rem);
--step-4: clamp(2.2888rem, 1.9993rem + 1.2867vw, 3.1573rem);
--step-5: clamp(2.861rem, 2.4118rem + 1.9966vw, 4.2087rem);
--step-6: clamp(3.5763rem, 2.8983rem + 3.0133vw, 5.6102rem);
```

Step −1 is for captions and labels, never body. Step 0 is the body (15 to 16px), step 1 the lead (about 19 to 21px), step 6 the title (about 57 to 90px). Rename the steps to the project's token names; keep the values.

## Values per role (Persuade landings)

- **Title:** 56 to 96px at 1440, weight 400 to 500. Tracking between -0.02em and -0.05em, tighter as the size grows (about -0.02em near 56px, -0.04em to -0.05em from 72px). Heavy display type at zero tracking is what `ui-review`'s `display-weight` check warns about.
- **Body:** 14 to 16px. Devtools and dense product pages sit at the low end; finance and hospitality at 16. Never below 13px.
- **Lead:** 18 to 22px, the paragraph under the title.
- **Title over body:** the scale above lands near 5.6 at 1440. The floor is 2.5 on Persuade and the target is 4.0.
- **Two-tone title:** a grey sentence and a dark sentence at the same size and weight. The tone changes by whole sentence or line, never on one word (`floor.md`, Type). Check the grey against the surface with `references/contrast.md`, at the large-text threshold.

## Families

One to three. A common product pair is a grotesque for everything plus a monospace for numbers, measurements, code, hashes and timestamps. Monospace on plain labels is a reflex in `floor.md`. Keep it only when the page has its own reason, such as labels that are real identifiers in a devtools product, and write that reason in the contract's `Floor:` line. Labels stay in sentence case at normal tracking.

## Free pairs by category

Each face was checked on 2026-11-18: the Google Fonts specimen page exists, the license is OFL, and the weights listed load from the Google Fonts API.

| Category | Display and text | Numbers, code, or second voice | Weights used |
|---|---|---|---|
| Product and devtools | Geist | Geist Mono | 400, 500 |
| Product and devtools | Inter | JetBrains Mono | 400, 500 |
| Editorial | Newsreader (titles) | Inter (text and UI) | 400, 500 |
| Consumer | Bricolage Grotesque (titles) | DM Sans (text and UI) | 400, 500 |
| Luxury and restaurant | Cormorant Garamond (titles) | Manrope (text and UI) | 400, 500 |
| Fintech | IBM Plex Sans | IBM Plex Mono | 400, 500 |

A family the contract names wins over this table. Faces not in it are fine once you have checked them the same way.
