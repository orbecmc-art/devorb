# Logic prototype

One self-contained HTML file (a **shareable demo**) that lets anyone drive a state model by clicking buttons. Use it when the question is about **business logic, state transitions or data shape**: the kind of thing that looks reasonable on paper and only feels wrong once you push it through real cases.

It is one file with nothing to install, so the user can hand it to a non-developer (a designer, a PM, a domain expert) and let them feel the model for themselves. So it speaks their language, not the code's.

## When this is the right shape

- "I'm not sure this state machine handles the case where X then Y."
- "Does this data model actually let me represent the case where…"
- "I want to feel out what the API should look like before writing it."
- Anything where someone wants to **press buttons and watch state change**.

If the question is "what should this look like," use `UI.md`.

## 1. State the question

Before writing code, write down the state model and the question you're prototyping: one paragraph at the top of the demo, in a visible intro, not just a comment. A prototype that answers the wrong question is pure waste, so make the question explicit and checkable later, whether the user is watching now or comes back to it.

## 2. Isolate the logic in a portable module

Put the logic that answers the question in a single `<script>` block, written as a small pure module that could be lifted into the real codebase later. The page around it is throwaway; this module isn't.

The shape depends on the question:

- **A pure reducer**, `(state, action) => state`: actions are discrete events and state is a single value.
- **A state machine**, with explicit states and transitions: "which actions are even legal right now" is part of the question.
- **A small set of pure functions** over a plain data type: no implicit current state, just transformations.
- **A class or module with a clear method surface**: the logic genuinely owns ongoing internal state.

Pick the shape that fits the question, not the one easiest to wire to a page. Keep it pure: no DOM, no `document`, no button handlers reaching inside. The page calls into it; nothing flows the other way. That is what makes it useful past its own lifetime: once the question is answered, the validated reducer, machine or function set is the starting point for the real module.

Use the names of `GLOSSARY.md` for states and actions, where it has them.

## 3. Build the shareable HTML file

One file of plain HTML, CSS and JS: no framework, no bundler, no server, everything inline, so it opens with a double-click and survives being emailed around.

Write it for a non-developer. Every label is in **domain language**: buttons and state read like the business, not like the reducer. Explain in plain words what is happening.

Top to bottom:

1. **Title and a one-line explanation** of what the demo lets you explore (the question from step 1).
2. **Current state:** the full relevant state as a readable panel (labelled fields, not a raw JSON dump), re-rendered after every click. Where it helps, call out what just changed.
3. **Free-play buttons:** one per action, always available, so anyone can poke the model in any order. Each click dispatches its action and re-renders the state.
4. **Guided walkthroughs:** a set of **scenarios**, one per tab. Each tab holds a short plain-language description (the situation it sets up and what to watch for) and, under it, the ordered **buttons to press**. Each step is a real button: clicking it performs the action and moves to the next step. Starting a walkthrough resets to a known initial state, so it runs the same way every time.

Choose scenarios that show the awkward cases: the happy path, a tricky edge case, and an attempt at something that should be illegal.

Beautiful but restrained: clean typography, generous spacing, one accent colour. No animations or gimmicks competing with the state and the buttons.

## 4. Hand it over

Give the user the file's absolute path, or open it for them. The interesting moments are "wait, that shouldn't be possible" or "huh, I assumed X would be different": those are bugs in the idea, which is the whole point. If they want new actions or a new scenario, add them.

## 5. Capture

Once the question is answered, capture as `SKILL.md` describes: the answer goes into the spec, and the whole file (shell and module) goes to the `prototype/<name>` branch, where it stays trivially re-runnable. The validated module reaches the real code only through `devorb:planning`, with tests.

## Anti-patterns

- **Adding tests.** A prototype that needs tests is no longer a prototype.
- **Wiring it to the real database.** In-memory state, unless the question is about persistence.
- **Generalising.** No "what if we wanted to support X later." It answers one question.
- **Blurring the logic and the page.** If the module references the DOM, `document` or button handlers, it is no longer liftable. Keep the page a thin shell over a pure module.
- **A framework, bundler or server.** A React app or a dev server defeats "shareable".
- **Shipping the HTML shell.** The page is built to be clicked through by hand; the module behind it is the part worth keeping.
