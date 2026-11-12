---
name: domain-modeling
description: Use when a request uses a vague or overloaded domain term, or a hard-to-reverse decision is settled; records them in GLOSSARY.md and docs/adr/
---

# Domain Modeling

Build and sharpen the project's domain model while the work is designed: challenge terms, probe them with edge-case scenarios, and write each term and decision down the moment it settles. Only reading `GLOSSARY.md` to name things is not this skill; any skill does that. This one is for changing the model.

## Where the files live

One context, as in most repos: `GLOSSARY.md` at the root and decisions in `docs/adr/`. A `GLOSSARY-MAP.md` at the root means several contexts, each with its own `GLOSSARY.md` and its own `docs/adr/` for decisions local to it; the root `docs/adr/` keeps system-wide decisions. Work in the context the topic belongs to. Unclear which one? Ask.

Create files only when you have something to write in them: `GLOSSARY.md` when the first term is resolved, `docs/adr/` when the first ADR is needed. Missing files are not a problem to report, and empty ones are never created up front.

## While the work is discussed

- **Challenge against the glossary.** A term used differently from `GLOSSARY.md`: say so at once. "The glossary defines *cancellation* as X, but you seem to mean Y. Which is it?"
- **Sharpen fuzzy words.** A vague or overloaded term: propose one precise term. "*Account*: the Customer or the User? Those are different things."
- **Probe with scenarios.** When the relationships between concepts come up, invent concrete edge cases that force the boundary between them into the open.
- **Check the code.** When the user says how something works, see whether the code agrees, and surface a contradiction: "The code cancels whole Orders, but you said partial cancellation is possible. Which is right?" The code shows how the system behaves today, not what the business requires.

## Resolving a term

A term is resolved when the user picks its meaning, or when the request, the code and the glossary all point to the same one. Otherwise ask the user, one question at a time, with the meaning you recommend. Working without the user (as a subagent, or told to go ahead without questions)? Take the meaning the code supports, write it, and name it in your report as a choice for the user to confirm.

Write each resolved term to `GLOSSARY.md` right then, in the format of `references/GLOSSARY-FORMAT.md`. Don't save terms up for later. From then on, use the term in code, tests and messages, and list the words it replaces under _Avoid_.

The glossary holds definitions and nothing else. No implementation detail (tables, classes, endpoints, libraries), no requirements, no to-dos: it is not a spec or a scratch pad. Requirements go in the spec `devorb:aligning` writes, and implementation choices in the plan or an ADR.

## Recording a decision

Offer an ADR only when all three are true:

1. **Hard to reverse:** changing your mind later has a real cost.
2. **Surprising without context:** a future reader will wonder why it was done this way.
3. **A real trade-off:** there were genuine alternatives, and one was picked for specific reasons.

Any one missing: no ADR. When the user accepts, write it in the format of `references/ADR-FORMAT.md`. A decision that contradicts an existing ADR: say so instead of overriding it silently. If the user reopens it, a new ADR supersedes the old one.

## Connects to

- **Receives:** terms and decisions from `devorb:aligning` as the design is discussed; a concept with no glossary term from any skill that names things, such as `devorb:improve-architecture` naming a module.
- **Uses:** the code, to check what the user says.
- **Hands off to:** the caller, with `GLOSSARY.md` and `docs/adr/` current. `devorb:planning`, `devorb:tdd` and `devorb:debugging` read them to name things in the project's language.
