---
name: codebase-design
description: Use when deciding a module's interface or where a seam goes, judging whether a module is shallow, or making code testable through its interface
---

# Codebase Design

Design **deep modules**: a lot of behaviour behind a small interface, placed at a clean seam, testable through that interface. The aim is leverage for callers, locality for maintainers, and testability for everyone. This is a vocabulary and a set of principles to consult while designing, not a session to run.

## Glossary

Use these terms exactly: don't substitute "component," "service," "API," or "boundary." Consistent language is the whole point. Domain names come from `GLOSSARY.md` (`devorb:domain-modeling`); architecture names come from here.

**Module**: anything with an interface and an implementation. Deliberately scale-agnostic: a function, class, package, or tier-spanning slice. _Avoid_: unit, component, service.

**Interface**: everything a caller must know to use the module correctly: the type signature, but also invariants, ordering constraints, error modes, required configuration, and performance characteristics. _Avoid_: API, signature (too narrow, they refer only to the type-level surface).

**Implementation**: what's inside a module, its body of code. Distinct from **Adapter**: a thing can be a small adapter with a large implementation (a Postgres repo) or a large adapter with a small implementation (an in-memory fake). Say "adapter" when the seam is the topic; "implementation" otherwise.

**Depth**: leverage at the interface. The amount of behaviour a caller (or test) can exercise per unit of interface they have to learn. A module is **deep** when a large amount of behaviour sits behind a small interface, **shallow** when the interface is nearly as complex as the implementation.

**Seam** _(Michael Feathers)_: a place where you can alter behaviour without editing in that place; the *location* at which a module's interface lives. Where to put the seam is its own design decision, distinct from what goes behind it. _Avoid_: boundary.

**Adapter**: a concrete thing that satisfies an interface at a seam. Describes *role* (what slot it fills), not substance (what's inside).

**Leverage**: what callers get from depth. More capability per unit of interface they learn. One implementation pays back across N call sites and M tests.

**Locality**: what maintainers get from depth. Change, bugs, knowledge, and verification concentrate in one place rather than spreading across callers. Fix once, fixed everywhere.

A **Module** has exactly one **Interface**. **Depth** is measured against that interface. A **Seam** is where the interface lives. An **Adapter** sits at a seam and satisfies the interface. **Depth** produces **Leverage** for callers and **Locality** for maintainers.

## Principles

- **Depth is a property of the interface, not the implementation.** A deep module can be internally composed of small, mockable, swappable parts; they just aren't part of the interface. A module can have **internal seams** (private to its implementation, used by its own tests) as well as the **external seam** at its interface.
- **The deletion test.** Imagine deleting the module. If complexity vanishes, it was a pass-through. If complexity reappears across N callers, it was earning its keep.
- **The interface is the test surface.** Callers and tests cross the same seam. If you want to test *past* the interface, the module is probably the wrong shape.
- **One adapter means a hypothetical seam. Two adapters means a real one.** Don't introduce a seam unless something actually varies across it.

When shaping an interface, ask: can I reduce the number of methods, simplify the parameters, hide more complexity inside?

## Designing for testability

1. **Accept dependencies, don't create them.** `processOrder(order, paymentGateway)`, not a `processOrder(order)` that calls `new StripeGateway()` inside.
2. **Return results, don't produce side effects.** `calculateDiscount(cart): Discount`, not an `applyDiscount(cart): void` that mutates `cart.total`.
3. **Small surface area.** Fewer methods, fewer tests needed. Fewer params, simpler test setup.

## Rejected framings

- **Depth as ratio of implementation-lines to interface-lines** (Ousterhout): rewards padding the implementation. We use depth-as-leverage instead.
- **"Interface" as the TypeScript `interface` keyword or a class's public methods**: too narrow: interface here includes every fact a caller must know.
- **"Boundary"**: overloaded with DDD's bounded context. Say **seam** or **interface**.

## Deciding

Give one recommendation, not a menu: where the seam goes, what the interface exposes, and the evidence (the deletion test, how many adapters are real, which callers and tests cross it). Name each rejected option in one line.

A seam the plan from `devorb:planning` already names stands. Moving it is a plan change: say so, never move it silently. With the user present, the recommendation waits for their yes. Working without the user (as a subagent, or told to go ahead without questions)? Keep any seam the plan names; decide the rest, and report each choice as one for the user to confirm.

## Going deeper

- **Deepening a cluster given its dependencies:** `references/DEEPENING.md`: dependency categories, seam discipline, and replace-don't-layer testing.
- **Exploring alternative interfaces**, when the user asks for options or `devorb:improve-architecture` hands over a candidate: `references/DESIGN-IT-TWICE.md`.

## Connects to

- **Receives:** an interface or seam in question from `devorb:tdd` or `devorb:planning` (which names the seams of each task), and a chosen deepening candidate from `devorb:improve-architecture`.
- **Uses:** `GLOSSARY.md` from `devorb:domain-modeling` for domain names; the code, to count callers and adapters.
- **Hands off to:** the caller, with the seam, the interface and the reason in this vocabulary, ready to go into the plan or the test.
