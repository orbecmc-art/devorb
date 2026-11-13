---
name: prototype
description: Build a throwaway prototype that answers one design question, either a logic demo or UI variants
disable-model-invocation: true
---

# Prototype

A prototype is **throwaway code that answers one question**. The question decides the shape. If what to build is already settled, this is the wrong skill: the work goes through `devorb:planning`.

## Pick a branch

Find the question being answered, from the user's request and the surrounding code, and ask the user when it isn't clear:

- **"Does this logic or state model feel right?"** Read `references/LOGIC.md`. Build one shareable HTML file (free-play buttons plus tabbed guided walkthroughs) that pushes the state model through the cases hard to reason about on paper, and that a non-developer can drive.
- **"What should this look like?"** Read `references/UI.md`. Build several radically different UI variants on one route, switched by a URL search param and a floating bottom bar. Each variant names the one axis it changes (layout, density, how it is operated); variants that differ only in colour or wording count as one.

The two branches produce very different artifacts, so a wrong pick wastes the whole prototype. Still ambiguous and the user isn't reachable? Take the branch that matches the surrounding code (a backend module: logic; a page or component: UI) and state the assumption at the top of the prototype.

Write the question at the top of the prototype, where the user will see it, before writing any code.

## Rules for both

1. **Throwaway from day one, and marked as such.** Start on a new `prototype/<name>` branch before writing anything, and build and commit there. Uncommitted changes in the tree? Use a git worktree on that branch instead, so the user's files are never touched. When done, return to the original branch. Never clean up with `git checkout`, `git restore` or `git stash` over the user's files. Put the prototype close to where it would be used (next to the module or page it explores), so the context is obvious, and name it so a casual reader sees a prototype, not production: `prototype` in the file or route name. Follow the project's routing convention for a throwaway route; don't invent a new top-level structure.
2. **Trivial to run.** A UI prototype starts with one command from the project's task runner (`pnpm <name>`, `python <path>`, `bun <path>`). A logic demo is one HTML file the user double-clicks. Give the user that command or path; no thinking required to start it.
3. **No persistence by default.** State lives in memory. Persistence is what a prototype might check, never something it depends on. If the question is about a database, use a scratch DB or a local file named so it reads "PROTOTYPE, wipe me", never the project's real database.
4. **Skip the polish.** No tests, no error handling beyond what keeps it running, no abstractions. Calling this skill is the user's permission for `devorb:tdd` to skip tests, and it covers only the prototype. At hand-over, say that it is untested.
5. **Show the state.** After every action (logic) or on every variant switch (UI), print or render the full relevant state so the user sees what changed.
6. **Capture it when done.** The prototype is a primary source: it stays on its `prototype/<name>` branch, committed and never merged, out of the main branch. Write the answer (the question, the verdict and the branch name) in the spec for this work in `docs/devorb/specs/`. No spec yet? Give the user the answer and the branch name; `devorb:aligning` puts them in the spec when it writes it.

## After the answer

Keeping anything is a new request. The verdict goes into the spec, and the real code is built through `devorb:planning`, with tests. The validated logic module enters as existing code under `devorb:tdd`: first tests for its behavior, seeded by the walkthrough scenarios, then the code moves in. The winning variant is rewritten test-first, never promoted as it is. The main branch keeps only the decision.

## Connects to

- **Receives:** a call from the user (`/devorb:prototype`) with a design question that talking won't settle, often raised while `devorb:aligning` shapes the spec.
- **Uses:** `references/LOGIC.md` or `references/UI.md`; the project's task runner, routing and component library.
- **Hands off to:** the spec in `docs/devorb/specs/` (or `devorb:aligning`, when there is none yet) with the verdict and the prototype branch, then `devorb:planning` to build what was decided.
