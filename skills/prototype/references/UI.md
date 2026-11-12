# UI prototype

**Several radically different UI variants** on one route, switched from a floating bottom bar. The user flips between them in the browser, picks one (or takes bits from each), and the rest is thrown away.

If the question is about logic or state rather than looks, use `LOGIC.md`.

## When this is the right shape

- "What should this page look like?"
- "I want to see a few options for this dashboard before committing."
- "Try a different layout for the settings screen."
- Any time the user would otherwise spend a day choosing between three vague mockups in their head.

## Two sub-shapes: strongly prefer A

A variant is much easier to judge when it sits against the rest of the app: real header, real sidebar, real data, real density. A throwaway route on its own is a vacuum where every variant looks fine.

**A: adjustment to an existing page (default).** The route exists. Variants render **on the same route**, gated by a `?variant=` search param. Data fetching, params and auth stay; only the rendering swaps. Something with no page yet that would naturally live inside one (a new dashboard section, a new card on the settings screen, a new step in a flow) is still A: mount the variants inside the host page.

**B: a new page (last resort).** Only when the thing has no existing page to live in (a new top-level surface, a flow that can't be embedded anywhere sensible). Create a **throwaway route** following the project's routing convention, with `prototype` in the path or file name, and the same `?variant=` pattern. Before choosing B, check again: is there really no page to embed it in? An empty route hides design problems a populated one would expose.

The floating bar is the same in both.

## 1. State the question and pick N

Default to **3 variants**, at most 5: past that they stop being radically different and become noise.

Write the plan in one line, in a top-of-file comment where the prototype lives:

> "Three variants of the settings page, switchable via `?variant=`, on the existing `/settings` route."

## 2. Generate radically different variants

Hold each variant to:

- The page's purpose and the data it has.
- The project's component library and styling system (Tailwind, shadcn, MUI, plain CSS, whatever it uses).
- A clear exported name: `VariantA`, `VariantB`, `VariantC`.

Variants must be **structurally different**: different layout, information hierarchy, primary affordance; not just different colours. Three slightly tweaked card grids is wallpaper, not a prototype. If two drafts come out too similar, redo one with an explicit constraint ("no card grid").

## 3. Wire them together

One switcher on the route:

```tsx
// pseudo-code, adapt to the project's framework
const variant = searchParams.get('variant') ?? 'A';
return (
  <>
    {variant === 'A' && <VariantA {...data} />}
    {variant === 'B' && <VariantB {...data} />}
    {variant === 'C' && <VariantC {...data} />}
    <PrototypeSwitcher variants={['A', 'B', 'C']} current={variant} />
  </>
);
```

In A, keep the existing data fetching above the switcher; only the rendered subtree changes. In B, the throwaway route mounts the same switcher.

## 4. Build the floating switcher

A small fixed bar at the bottom centre, with three pieces:

- **Left arrow:** previous variant (wraps around).
- **Label:** the current key and, if the variant exports one, its name: `B (Sidebar layout)`.
- **Right arrow:** next variant (wraps around).

Behaviour:

- An arrow updates the URL search param through the framework's router (`router.replace` in Next, `navigate` in React Router), so the variant is shareable and survives a reload.
- `←` and `→` also cycle, except when an `<input>`, `<textarea>` or `[contenteditable]` has focus.
- Visibly not part of the design being judged: a high-contrast pill with a subtle shadow.
- Hidden in production builds: gate it on `process.env.NODE_ENV !== 'production'` or the project's equivalent, so a stray merge can't ship it to users.

One shared component, wherever the project keeps shared UI.

## 5. Hand it over

Give the URL and the `?variant=` keys, plus the one command that starts the app. The useful feedback is usually "the header from B with the sidebar from C": that is the design they actually want.

## 6. Capture and clean up

Once a variant wins, capture as `SKILL.md` describes: the answer (which variant, and why) goes into the spec, and the full set of variants plus the switcher goes to the `prototype/<name>` branch. Then take them all out of the main working tree: variants and a switcher left in the main branch rot fast and confuse the next reader. The winner reaches the real page or route only through `devorb:planning`, rewritten properly.

## Anti-patterns

- **Variants that differ only in colour or copy.** That's a tweak. Real variants disagree about structure.
- **Sharing too much between variants.** A shared `<Header>` is fine; a shared `<Layout>` defeats the point. Each variant is free to throw out the layout.
- **Wiring variants to real mutations.** Read-only is fine. A variant that must mutate points at a stub: the question is what it should look like, not whether the backend works.
- **Promoting the prototype straight to production.** It was written without tests or error handling. Rewrite it properly when it goes in.
