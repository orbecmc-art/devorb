# Phase boundaries

A **phase** is a chunk of work inside a session: the alignment, the implementation, the verification. The definition is fuzzy on purpose: a phase ends when you think *"ok, we're done with that"*.

The **phase boundary** is the gap between two phases, and it is the only place this decision belongs. Mid-phase there is no decision to make: continue, or split the work that's left into subagents. Compacting mid-phase makes the agent lose the thread.

## The five options

| Option | What it does |
|---|---|
| **Continue** | Stay in the session. No context switch at all. |
| **`/clear`** | Empty the context window and start from nothing. |
| **`devorb:handoff`** | Write a portable markdown file and seed a session anywhere with it. |
| **Subagent** | Send the task to its own context window and get a report back. |
| **`/compact`** | Compress this context and seed a fresh session with the summary. |

`/clear` and `/compact` are the user's to run; `devorb:handoff` runs when the user pauses or moves on. Recommend one and say why.

## The tree

Work top to bottom at the boundary. The first **yes** wins.

**1. Can you continue in this session?** Two things make the answer yes: the next phase needs this phase as a **primary source**, or enough of the window remains for the next phase to fit (the model reasons sharply up to about 150k tokens). `devorb:aligning` → `devorb:planning` is the standard yes: the plan wants the reasoning verbatim, not a summary of it. Continue costs nothing and loses nothing, so rule it out before anything else.

**2. Is the context irrelevant to what comes next?** Is everything in this session (the exploration, the decisions, the dead ends) disposable? If so, **`/clear`**. It is the cheapest move on the board: it takes no time and hands back the whole window. `/clear` also isn't terminal: the old session stays resumable.

The cost of getting this wrong is one-way. Clear a *relevant* context and you lose the **why** behind what you built, and no amount of reading the diff back returns it.

**3. Do you need to hand off?** `devorb:handoff` is narrow. You need it only when you are:

- swapping to a **new harness**,
- moving to a **new directory** or repo,
- sending the work to a **colleague**,
- or forking a side task you found **mid-phase** without derailing what you're doing.

That list is the whole clause. What `devorb:handoff` buys is **portability**: a file that travels. If nothing is travelling, you don't need it.

**4. Can the task be done with the user away?** Is it scoped tightly enough to run with no steering? Then send it to a **subagent** and leave this session untouched. Automated review is the standard case: the agent reads the diff and reports, and the user isn't needed while it does.

**5. Otherwise, `/compact`.** Relevant context, same harness, same directory, and the user needs to stay in the loop: this is where the tree lands, and it lands here often. Pass it an instruction (`/compact we're going to verify this area`) so the summary keeps what the next phase needs.

`/compact` is the **default, not the first reach**. It sits at the bottom because the four questions above it are all cheaper or more precise. The failure mode of starting here is a fresh session that is confidently wrong about a decision the summary flattened.

## Primary and secondary sources

Every move except **Continue** turns a **primary source** into a **secondary source**: the session as it happened, replaced by a summary of it. The trade is always the same shape:

| Source | Information | Noise | Room to move |
|---|---|---|---|
| Primary (Continue) | Full | Lots | Little |
| Secondary (`/compact`, `devorb:handoff`) | Lossy | Less | Lots |

This is why question 1 comes first. Pay the lossiness only when staying costs more than it saves.

## Context hygiene

- Keep `devorb:aligning` and `devorb:planning` in one unbroken context window, so the plan builds on the same thinking.
- If a session nears the 150k tokens before planning ends, don't push on degraded. Run `/compact` at the nearest phase boundary and carry on.
- Suggest `devorb:retro` in the session it looks back on, before clearing. After clearing, the user points it at that session's log.

## These are judgement calls

The questions are not objective: each has taste in it, and the same boundary can go two ways on two days. The value is in asking them **in order**, at the boundary rather than in the middle of the work.
