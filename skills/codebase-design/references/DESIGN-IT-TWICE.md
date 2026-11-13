# Design It Twice

When the user wants to explore alternative interfaces for a chosen deepening candidate, use this parallel subagent pattern. Based on "Design It Twice" (Ousterhout): your first idea is unlikely to be the best. Uses the vocabulary in `SKILL.md`: **module**, **interface**, **seam**, **adapter**, **leverage**.

## 1. Frame the problem space

Before spawning subagents, write a user-facing explanation of the problem space for the chosen candidate:

- The constraints any new interface would need to satisfy
- The dependencies it would rely on, and which category they fall into (`DEEPENING.md`)
- A rough illustrative code sketch to ground the constraints, not a proposal, just a way to make the constraints concrete

Show this to the user, then go straight to step 2. The user reads and thinks while the subagents work in parallel.

## 2. Spawn subagents

Spawn 3 or more subagents in parallel, each with a fresh context. Each must produce a **radically different** interface for the deepened module.

Give each a separate technical brief (file paths, coupling details, dependency category, what sits behind the seam), independent of the user-facing explanation in step 1, plus the vocabulary of `SKILL.md` and of `GLOSSARY.md`, so each names things consistently with the architecture language and the project's domain language. Give each a different design constraint:

- Agent 1: "Minimize the interface: aim for 1–3 entry points max. Maximise leverage per entry point."
- Agent 2: "Maximise flexibility: support many use cases and extension."
- Agent 3: "Optimise for the most common caller: make the default case trivial."
- Agent 4 (if applicable): "Design around ports & adapters for cross-seam dependencies."

Can't spawn subagents (you are one, or the tool is missing)? Write the designs yourself, one constraint at a time, finishing each before starting the next.

Each design outputs:

1. Interface (types, methods, params, plus invariants, ordering, error modes)
2. Usage example showing how callers use it
3. What the implementation hides behind the seam
4. Dependency strategy and adapters
5. Trade-offs: where leverage is high, where it's thin

## 3. Present and compare

Present designs one at a time so the user can absorb each, then compare them in prose by **depth** (leverage at the interface), **locality** (where change concentrates), and **seam placement**.

Then give your own recommendation: which design is strongest and why. If elements from different designs would combine well, propose a hybrid. Be opinionated: the user wants a strong read, not a menu.
