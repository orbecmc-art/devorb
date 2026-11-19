# Colour roles

Read before naming any colour token. This file gives roles, never colours: the values come from the world in the direction contract.

## Sixteen roles, in pairs (eighteen with a complement)

A surface is never defined alone. Each surface role has an ink role that sits on it, and the pair is checked as a pair.

| Surface | Ink on it | Job | Minimum |
|---|---|---|---|
| `background` | `foreground` | the page itself and its running text | 4.5:1 |
| `card` | `card-foreground` | raised or grouped areas: panels, cards, popovers | 4.5:1 |
| `primary` | `on-primary` | the main action and the current selection | 4.5:1 |
| `secondary` | `on-secondary` | the second-rank action, quiet fills | 4.5:1 |
| `accent` | `on-accent` | the one spot the direction wants noticed: a highlight, a hovered row | 4.5:1 |
| `complement` | `on-complement` | Persuade with a complementary pair only: the second colour, owning its own sections or bands (`color-finish.md`) | 4.5:1 |
| `muted` | `muted-foreground` | low-emphasis areas and their helper text, captions, placeholders | 4.5:1 |
| `destructive` | `on-destructive` | delete, errors that block | 4.5:1 |

Two roles have no ink, and are checked against the surfaces they sit on:

| Role | Job | Minimum |
|---|---|---|
| `border` | edges that identify a control (an input, a checkbox); a purely decorative divider is exempt | 3:1 against the surface beside it |
| `ring` | the focus indicator, behind the focus token | 3:1 against every surface it can land on |

`muted-foreground` is also checked on `background` and on `card`, since helper text sits there too. `primary` used as text (a link) is checked on `background`.

## Names

Use the names the project already has. With shadcn/ui, the inks are named `*-foreground` (`--primary-foreground`), and its theme adds a few more (`--popover`, `--input`, chart and sidebar colours): give every one a value from this system. In a new project without a convention, the table's names are fine.

## Beyond the sixteen

Status roles (success, warning, info), chart series and brand extras enter only when the interface uses them, with the same three-uses rule as any token. Each one that holds text or sits under text comes as a pair.

## Light and dark

Both themes have all the roles. Going to dark:

- The brand hues stay recognisably the same; lightness and chroma may move so the pairs still pass.
- Surfaces are derived again, not inverted: the page is the darkest layer and raised areas get lighter, so depth still reads.
- Inks, borders, muted tones and the ring are recomputed for the new surfaces.
- Every pair is checked again with `contrast.md`.

## Where the values come from

Start from the world named in `## Direção visual`: the materials, printed matter and places it lists. Pick the brand hue and the neutral family from there, then derive every role. Write in the contract's terms why each primitive was chosen ("the clay of the shop's tiles"), so a reviewer can trace it. A colour fixed by the spec or the client's material wins over the world.

Do not start from a framework's default scale, a generator's palette, a list of ready-made schemes or a famous brand's file. Those reproduce the look the project is trying to avoid.
