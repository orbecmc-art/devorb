---
name: improve-architecture
description: Scan the codebase for deepening opportunities, show them in a visual HTML report, then question the one the user picks
disable-model-invocation: true
---

# Improve Architecture

Find architectural friction and propose **deepening opportunities**: refactors that turn shallow modules into deep ones, for testability and for an agent finding its way around the code. This skill is a survey: it changes no code. The refactor the user picks is built later through the normal flow.

Two sources shape every suggestion:

- **Architecture words** from `devorb:codebase-design`: **module**, **interface**, **implementation**, **depth**, **seam**, **adapter**, **leverage**, **locality**, and its principles (the deletion test, the interface is the test surface, one adapter means a hypothetical seam and two mean a real one). Use these terms exactly; never drift into "component," "service," "API" or "boundary."
- **Domain words** from `GLOSSARY.md`, which give good seams their names, and decisions in `docs/adr/`, which this skill does not re-litigate (`devorb:domain-modeling` keeps both).

## 1. Explore

**Scope before you scan.** A deepening pays off by making future changes easier, so weight the parts that change. Decide where to look before you look:

- The user named a direction (a module, a subsystem, a pain point, or a spec with "how can we make this change easy?"): take it and skip the rest of this list.
- Otherwise find the hot spots in the commit history: the files and areas that keep coming up. For example, `git log --since="6 months ago" --name-only --format= -- . ':!*.lock' ':!package-lock.json' ':!pnpm-lock.yaml' | grep . | sort | uniq -c | sort -rn | head -30`, leaving out lockfiles and generated files (builds, snapshots, migrations output), plus `git log --oneline` over the same stretch to see what the changes were about. Let those paths pull your attention first. No clear hot spot (changes scattered, or little history): widen the net, and say so in the report.

Read `GLOSSARY.md` and the ADRs for the area first, if they exist.

Then dispatch a fresh subagent to walk the code in that scope, with the scope, the vocabulary above and the questions below. No subagent tool: walk it yourself. Explore organically, not by rigid heuristics, and note where you feel friction:

- Where does understanding one concept mean bouncing between many small modules?
- Where are modules **shallow**, with an interface nearly as complex as the implementation?
- Where were pure functions extracted just for testability, while the real bugs hide in how they are called (no **locality**)?
- Where do tightly coupled modules leak across their seams?
- Which parts are untested, or hard to test through their current interface?

Apply the **deletion test** to every suspect: would deleting it concentrate complexity, or just move it? Only "concentrates" earns a candidate.

## 2. Present the candidates as an HTML report

Write one self-contained HTML file to the OS temp directory, so nothing lands in the repo: `$TMPDIR`, falling back to `/tmp` (`%TEMP%` on Windows), at `<tmpdir>/architecture-review-<timestamp>.html`, fresh each run. Open it for the user (`open` on macOS, `xdg-open` on Linux, `start` on Windows) and give the absolute path. The file is the deliverable, even when another instruction asks for brevity or the smallest output: a summary in chat never replaces it.

Each candidate gets a card with:

- **Files:** the modules involved.
- **Problem:** why the current architecture causes friction.
- **Solution:** in plain words, what would change.
- **Benefits:** in terms of locality and leverage, and how tests would improve.
- **Before / after diagram:** side by side, showing the shallowness and the deepening.
- **Recommendation strength:** `Strong`, `Worth exploring` or `Speculative`, as a badge.

End with a **Top recommendation**: which candidate to tackle first, and why.

Domain names come from `GLOSSARY.md`: if it defines "Order," write "the Order intake module," not "the FooBarHandler" or "the Order service."

**ADR conflicts:** surface a candidate that contradicts an ADR only when the friction is real enough to reopen it, and mark it in the card ("contradicts ADR-0007, but worth reopening because…"). Don't list every refactor an ADR forbids.

Scaffold, diagram patterns, style and wording: `references/HTML-REPORT.md`. Read it before writing the report.

**No interfaces yet.** The report names the deepening, never the new interface. After the file is written, ask the user: "Which of these would you like to explore?" and stop until they answer.

## 3. Question the chosen candidate

Once the user picks one, invoke `devorb:aligning` to question it with them: constraints, dependencies, the shape of the deepened module, what sits behind the seam, which tests survive. The refactor goes through the normal flow from there: a spec, then `devorb:planning`.

Keep the domain model current as decisions settle, with `devorb:domain-modeling`:

- **Naming the deepened module after a concept not in `GLOSSARY.md`?** Add the term.
- **Sharpening a fuzzy term?** Update `GLOSSARY.md` right there.
- **User rejects the candidate with a load-bearing reason?** Offer an ADR: "Want me to record this as an ADR so future architecture reviews don't suggest it again?" Only when a future reviewer would need the reason; skip passing ones ("not worth it right now") and self-evident ones.
- **Want to compare alternative interfaces for the deepened module?** Use `devorb:codebase-design` and its design-it-twice pattern.

## Connects to

- **Receives:** a call from the user (`/devorb:improve-architecture`), optionally with a direction: a module, a pain point or a spec.
- **Uses:** `devorb:codebase-design` for the vocabulary and the deletion test; `GLOSSARY.md` and `docs/adr/` through `devorb:domain-modeling`; `git log` for hot spots; a fresh subagent to explore; `references/HTML-REPORT.md`.
- **Hands off to:** `devorb:aligning`, with the chosen candidate; `devorb:codebase-design` when the user wants to compare interfaces for it.
