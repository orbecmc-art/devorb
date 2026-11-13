# `DESIGN.md`

Read before writing `DESIGN.md`. The file sits at the project root and follows the open `DESIGN.md` format (google-labs-code/design.md): machine-readable tokens in YAML frontmatter, then prose that says how to use them. The frontmatter is the source of truth; the prose never states a different value.

If the file already exists, do not edit or replace it unless the user asked. Report what it lacks instead.

## Frontmatter

Only tokens the project really uses. No empty groups, no invented steps.

```yaml
---
name: <project>
description: <one line on what the interface is for>
colors:
  primary: "<value>"      # the role's value; the Colors section names its primitive
  on-primary: "<value>"
typography:
  display:
    fontFamily: "<family>, <fallback>"
    fontSize: "<size>"
    fontWeight: <weight>
    lineHeight: <ratio>
    letterSpacing: "<negative for large sizes>"
  body: { ... }
rounded:
  sm: "<size>"
spacing:
  "4": "<size>"
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    rounded: "{rounded.sm}"
  button-primary-hover:
    backgroundColor: "{colors.primary-hover}"
  button-primary-disabled:
    backgroundColor: "{colors.muted}"
    textColor: "{colors.muted-foreground}"
---
```

- References use `{group.key}`, and only components use them: one colour may not point at another. So `colors` holds each semantic role with its value, and the `## Colors` section says which primitive (`--clay-700`) it comes from.
- Keep the colour notation the project already uses (hex or `oklch()`); one notation, one place.
- Group and key names follow the project: never rename to fit an example.
- Each state is its own key next to its component (`button-primary-hover`, `input-error`, `tab-selected`), not a nested object.
- Values the format has no field for (shadows, focus ring width and offset, motion) go in the prose section they belong to, with the token name the code uses.

## Body

Sections in this order; leave out any the project has nothing for.

1. `## Overview`: the world from the direction contract in two or three sentences, and the mode of each surface.
2. `## Colors`: each role pair, its primitive, where it is used and why, and the contrast table copied from the script output, light and dark.
3. `## Typography`: families and their roles, the scale, leading and tracking per step. If a family is proprietary or unconfirmed, a short note names the free face that stands in for it and what changes.
4. `## Layout`: container, grid, the spacing scale and density per mode.
5. `## Elevation & Depth`: shadows or tonal layers, and the opaque fallback of any translucent surface.
6. `## Shapes`: radius and border widths.
7. `## Components`: each component and every state it has, by token name, including the focus token.
8. `## Do's and Don'ts`: rules this project has confirmed, not general advice.
9. `## Known gaps`: what is pending and why (a face not yet confirmed, a colour waiting for the client's material, a state not yet designed).

## Reference files of real brands

Collections of brand `DESIGN.md` files (such as getdesign.md in the owner's source list) are for seeing how the file is organised. Never copy a brand's colours, fonts or signature into a client's system.
