---
name: using-devorb
description: Use when starting any conversation
---

<SUBAGENT-STOP>
If dispatched as a subagent for a specific task, ignore this skill.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
If there is even a 1% chance a skill applies to your task, you MUST invoke it. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

## The Rule

**Invoke relevant or requested skills BEFORE any response or action**, including clarifying questions, exploring code or checking files. If one turns out wrong, drop it. Otherwise announce "Using [skill] to [purpose]" and follow it exactly, with a todo per checklist item.

Before plan mode, invoke `devorb:aligning` if not aligned yet.

## Precedence

1. User and project instructions (CLAUDE.md, AGENTS.md, direct requests).
2. The DevOrb flow.
3. The specific skill.

Skip a step only when level 1 explicitly says so. Domain skills run after the process skill that sets the approach.

## Routing

New work enters through `devorb:aligning`. A bug enters through `devorb:debugging`. The flow runs aligning → planning → implementing → verifying → reviewing → finishing. Invoke these by name even if your skill list omits them, and read a skill before describing or skipping it.

| When | Skill |
|---|---|
| New idea or change: settle it, spec in `docs/devorb/specs/` | `devorb:aligning` |
| Spec ready: plan in `docs/devorb/plans/` | `devorb:planning` |
| Plan ready: build it | `devorb:implementing` |
| While building: test first | `devorb:tdd` |
| Anything fails or surprises you | `devorb:debugging` |
| Before claiming it works | `devorb:verifying` |
| Changed a web UI | `devorb:browser-testing` |
| Asking for or receiving a review | `devorb:reviewing` |
| Integrating the branch | `devorb:finishing` |
| Domain terms and decisions: `GLOSSARY.md`, `docs/adr/` | `devorb:domain-modeling` |
| Shape of a module or interface | `devorb:codebase-design` |
| Creating or editing a skill | `devorb:writing-skills` |

Manual skills run only when the user calls them; suggest, never start: `devorb:evolving`, `devorb:improve-architecture`, `devorb:prototype`, `devorb:handoff`, `devorb:retro`.

## Red Flags

These thoughts mean STOP, you're rationalizing:

| Thought | Reality |
|---|---|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | The skill check comes BEFORE clarifying questions. |
| "Let me explore or check files first" | Skills tell you HOW to explore. Check first. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read the current one. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "It's urgent" or "tests later" | That's when the flow helps most. Code change: check `devorb:tdd` first. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "I know what that means" | Knowing the concept is not using the skill. |

## References

They sit in this skill's folder: invoke `devorb:using-devorb` for its path.

- `references/legacy-names.md`: for instructions citing skills of plugins DevOrb replaced.
- `references/phase-boundaries.md`: at a phase boundary, to choose how to go on.
- `references/claude-code-tools.md`: Claude Code notes.

## Connects to

- **Receives:** every session start, from the hook.
- **Uses:** the references above.
- **Hands off to:** `devorb:aligning` for new work, `devorb:debugging` for a bug, or the table's skill.
