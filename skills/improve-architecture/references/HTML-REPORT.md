# HTML report format

The architecture review is one self-contained HTML file in the OS temp directory. Tailwind and Mermaid come from CDNs. Mermaid handles graph-shaped diagrams reliably; hand-built divs and inline SVG handle the more editorial visuals (mass diagrams, cross-sections). Mix the two: leaning on Mermaid for everything looks generic.

## Scaffold

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Architecture review for {{repo name}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral" });
    </script>
    <style>
      /* small custom layer for what Tailwind doesn't cover cleanly:
         dashed seam lines, leak arrows, the deep-module fill */
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

Names from the code (files, functions) go into the page as text: escape `<`, `>` and `&`.

## Header

Repo name, date, the scope (the direction the user gave, or the hot spots found and the stretch of history read), and a compact legend: solid box = module, dashed line = seam, red arrow = leakage, thick dark box = deep module. No introduction paragraph: straight into the candidates.

## Candidate card

The diagrams carry the weight. Prose is sparse, plain, and uses the `devorb:codebase-design` terms without ceremony.

Each candidate is one `<article>`:

- **Title:** short, names the deepening ("Collapse the Order intake pipeline").
- **Badge row:** recommendation strength (`Strong` = emerald, `Worth exploring` = amber, `Speculative` = slate), plus a tag for the dependency category (`in-process`, `local-substitutable`, `ports & adapters`, `mock`; see `devorb:codebase-design`).
- **Files:** monospaced list, `font-mono text-sm`.
- **Before / after diagram:** the centrepiece, two columns side by side. Patterns below.
- **Problem:** one sentence. What hurts.
- **Solution:** one sentence. What changes.
- **Wins:** bullets of six words or fewer: "Tests hit one interface", "Pricing logic stops leaking", "Delete 4 shallow wrappers".
- **ADR callout** (if any): one line in an amber-tinted box.

No paragraphs of explanation. If the diagram needs a paragraph to be understood, redraw the diagram.

## Diagram patterns

Pick the pattern that fits the candidate, and mix them: variety is part of the point.

**Mermaid graph** (the workhorse for dependencies and call flow): a `flowchart` when the point is "X calls Y calls Z, and look at the mess." Wrap it in a Tailwind card so it doesn't feel parachuted in, and use `classDef` to colour leakage edges red and the deep module dark. Sequence diagrams suit "before: 6 round-trips; after: 1."

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.leak.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

**Hand-built boxes and arrows** (when Mermaid's layout fights you): modules as bordered `<div>`s, arrows as inline SVG `<line>` or `<path>` positioned absolutely over a relative container. Use it when the "after" should read as one thick-bordered deep module with greyed-out internals, which Mermaid won't render with the right weight.

**Cross-section** (layered shallowness): horizontal bands (`h-12 border-l-4`) for the layers a call passes through. Before: six thin layers each doing nothing. After: one thick band labelled with the consolidated responsibility.

**Mass diagram** (interface as wide as the implementation): two rectangles per module, one for the interface surface, one for the implementation. Before: nearly the same height (shallow). After: short interface, tall implementation (deep).

**Call-graph collapse:** before, a tree of calls as nested boxes; after, the same tree collapsed into one box, the now-internal calls faded inside it.

## Style

- Editorial, not corporate dashboard. Generous whitespace. Serif headings optional (`font-serif` works with stone and slate).
- Colour sparingly: one accent (emerald or indigo), red for leakage, amber for warnings.
- Diagrams about 320px tall, so before and after sit side by side without scrolling.
- `text-xs uppercase tracking-wider` for module labels inside diagrams, so they read as schematic, not as UI.
- The only scripts are the Tailwind CDN and the Mermaid import. Otherwise static: no app code, no interactivity beyond Mermaid's rendering.

## Top recommendation

One larger card: the candidate's name, one sentence on why, and an anchor link to its card.

## Wording

Plain and concise, with the architectural nouns and verbs straight from `devorb:codebase-design`. Concision is no excuse to drift.

**Use exactly:** module, interface, implementation, depth, deep, shallow, seam, adapter, leverage, locality.

**Never substitute:** component, service, unit (for module); API, signature (for interface); boundary (for seam); layer, wrapper (for module, when you mean module).

**Phrasings that fit:**

- "Order intake module is shallow: interface nearly matches the implementation."
- "Pricing leaks across the seam."
- "Deepen: one interface, one place to test."
- "Two adapters justify the seam: HTTP in prod, in-memory in tests."

**Wins** name the gain in glossary terms: "locality: bugs concentrate in one module", "leverage: one interface, N call sites", "interface shrinks; implementation absorbs the wrappers". Never "easier to maintain" or "cleaner code": those terms aren't in the glossary and don't earn their place.

No hedging, no throat-clearing. If a sentence could be a bullet, make it a bullet; if a bullet could be cut, cut it. If a term isn't in the `devorb:codebase-design` glossary, find one that is before inventing a new one.
