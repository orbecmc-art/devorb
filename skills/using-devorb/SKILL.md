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

Skip a step only when level 1 explicitly says so. "No questions" or "go ahead" drops questions, not steps: decide alone and record assumptions. A plugin's style rule (brevity, smallest change) shapes how you work, never whether the flow runs. Domain skills run after the process skill that sets the approach.

## Routing

New work, even a small feature, enters through `devorb:aligning`, which sizes it. A bug enters through `devorb:debugging`. The flow runs aligning → planning → implementing → verifying → reviewing → finishing. Invoke these by name even if your skill list omits them, and read a skill before describing or skipping it.

| When | Skill |
|---|---|
| New idea or change | `devorb:aligning` |
| Spec ready | `devorb:planning` |
| Plan ready: build it | `devorb:implementing` |
| While building: test first | `devorb:tdd` |
| Anything fails or surprises you | `devorb:debugging` |
| Before claiming it works | `devorb:verifying` |
| Data read or searched | `devorb:performance` |
| Building or changing a UI | `devorb:visual-direction`, `devorb:design-system`, `devorb:motion`, `devorb:ui-review` |
| Mobile app screen | `devorb:native-app`, `devorb:device-testing` |
| Changed a web UI | `devorb:browser-testing` |
| Review asked or received | `devorb:reviewing` |
| Integrating the branch | `devorb:finishing` |
| Domain terms, ADRs | `devorb:domain-modeling` |
| Shape of a module or interface | `devorb:codebase-design` |
| Code hard to change | `devorb:improve-architecture` |
| Try an idea before building it | `devorb:prototype` |
| Pausing or moving session | `devorb:handoff` |
| What went wrong this session | `devorb:retro` |
| Security review or audit | `devorb:security-audit` |
| A diagram or flowchart | `devorb:diagram` |
| Releasing a mobile app version | `devorb:mobile-release` |
| Creating or editing a skill | `devorb:writing-skills` |
| Updating DevOrb's sources | `devorb:evolving` |

## Red Flags

STOP, you're rationalizing:

| Thought | Reality |
|---|---|
| "Let me explore or check files first" | Skills say HOW to explore. Check first. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "It's urgent" or "tests later" | Then the flow helps most. Code change: check `devorb:tdd` first. |

## References

In this skill's folder; invoke `devorb:using-devorb` for its path.

- `references/legacy-names.md`: for instructions citing skills of plugins DevOrb replaced.
- `references/phase-boundaries.md`: at a phase boundary.
- `references/claude-code-tools.md`: Claude Code notes.

## Connects to

- **Receives:** every session start, from the hook.
- **Hands off to:** the Routing table's skill.
