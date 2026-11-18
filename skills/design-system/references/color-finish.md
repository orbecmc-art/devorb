# Colour and finish recipe

Numbers measured on 21 reference landings in November 2026. They fill what the contract leaves open. **The direction fixes what the spec fixes:** a colour, effect or ban named in the spec, the contract or an existing `DESIGN.md` wins over this file. Colours still come from the direction's world (`SKILL.md` §1); this file sets how many there are and how they are used.

## One accent

- Neutrals carry the page: ground, surfaces, text and lines. Use one accent beyond them, and none is fine too. All 21 references use one accent or none.
- Status colours (success, error, warning) appear only where a real state needs them. They are not a second accent.
- More than 2 saturated hues across text, button fills and section backgrounds is what `ui-review`'s `accent-count` check warns about.

## Text by opacity

Text tones are one ink at a few opacities, not a row of unrelated greys: 1, 0.6, 0.4, and 0.2 for disabled. `references/contrast.md` reads opaque colours only. Flatten each step over its surface first (each channel = ink × a + surface × (1 − a)), then check it.

Example, ink `#ededed` on ground `#0a0a0a`, flattened and run through the contrast script:

```
#ededed/#0a0a0a  16.91:1  text ok  large/UI ok      (1)
#929292/#0a0a0a  6.36:1  text ok  large/UI ok       (0.6)
#656565/#0a0a0a  3.40:1  text FAIL  large/UI ok     (0.4)
#373737/#0a0a0a  1.66:1  text FAIL  large/UI FAIL   (0.2)
```

In this example 0.6 works for secondary text, 0.4 only for large text and icons, and 0.2 only for disabled controls, together with the other cues. Run the ladder again on every surface it sits on, in both themes.

## Lines, not shadows

- Cards, sections and table rows are separated by 1px lines of the ink at 6 to 10% opacity, not by shadows. Such a line measures about 1.1 to 1.3:1, so it may never be the edge of an input or a button. Those edges need 3:1.
- Shadows are for UI that floats over the page only: menus, popovers, dialogs, toasts. A 1px border under a soft shadow on every card is the "Product default" spent look in `floor.md`.
- A visible grid or rail (hairline columns, a construction grid behind the hero) is optional. It is a choice the direction makes, never a default.

## Halo

A blurred glow is a reflex in `floor.md`. Keep it only when it lights a real object the page shows, such as the product UI, a render or a cut-out photo, and write that reason in the contract's `Floor:` line. When kept:

- blur radius above 100px, soft enough that no edge shows;
- always behind the object, never behind text;
- in the accent's hue or a neutral, never a second accent.

A near-black ground with a saturated accent and a glow is the "Dark neon" spent look. Check the plan against that table before adding a halo.
