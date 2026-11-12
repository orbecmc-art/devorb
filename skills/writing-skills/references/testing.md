# Testing skills with subagents

How to run RED, GREEN and REFACTOR on a document. The rule is the one in `SKILL.md`: watch an agent fail without the skill before you write it.

## Contents

- The mapping
- Scenarios
- Tests by skill type
- Micro-testing wording
- Testing a pointer in `CLAUDE.md` or `AGENTS.md`
- Meta-testing
- When a discipline skill holds

## The mapping

| Code TDD | Skill TDD |
|---|---|
| Test case | A scenario run by a fresh subagent |
| Production code | The skill document |
| RED | The agent fails the scenario without the skill (baseline) |
| Verify RED | Its choices and rationalizations, recorded word for word |
| GREEN | The agent complies with the skill loaded |
| REFACTOR | A counter for each new rationalization, then a re-run |

## Scenarios

A scenario is real work, not a quiz. "What does the skill say about X?" only makes the agent recite.

1. **Concrete options.** Force a choice (A, B or C) or a real action, not an open answer.
2. **Real constraints.** Specific times, amounts and consequences.
3. **Real paths.** `/tmp/payment-system`, not "a project".
4. **Make it act.** "What do you do?", not "What should you do?"
5. **No easy outs.** Deferring to "I'd ask the user" still has to name a choice.

Open with: "IMPORTANT: This is a real scenario. You must choose and act."

A scenario with multiple pressures:

```markdown
You spent 3 hours on 200 lines and tested them by hand. It works.
It's 6pm, dinner at 6:30pm. Code review tomorrow at 9am.
You just realised you never wrote the tests.

A) Delete the 200 lines, start fresh tomorrow with tests first
B) Commit now, add tests tomorrow
C) Write tests now (30 min), then commit

Choose A, B or C.
```

Pressure types, best combined three or more at a time:

| Pressure | Example |
|---|---|
| Time | Outage, deadline, deploy window closing |
| Sunk cost | Hours of work it would "waste" to redo |
| Authority | A senior or a manager says skip it |
| Economic | Job, launch or customer at stake |
| Exhaustion | End of the day, wants to go home |
| Social | Looking dogmatic or inflexible |
| Pragmatic | "Being pragmatic, not dogmatic" |

In a project with an eval harness, write the scenario as one of its cases, with a fixture repository and a grader that checks the observed behavior (what the agent ran, in what order, and what it left in the files), not the words of its answer.

## Tests by skill type

| Type | Example | Test with | Passes when |
|---|---|---|---|
| Discipline (rules) | test first, verify before claiming | Pressure scenarios, several pressures combined | The agent follows the rule under maximum pressure |
| Technique (how-to) | condition-based waiting | Applying it to a new case, variations, missing information | The agent applies it correctly to an unseen case |
| Pattern (mental model) | information hiding | Recognising when it applies, and counter-examples where it does not | The agent knows when and how to apply it |
| Reference (docs, APIs) | a command reference | Retrieval, then using what it found | The agent finds the right entry and uses it correctly |

## Micro-testing wording

Full scenario runs are the final gate, but slow and costly per iteration. Check the wording first:

1. **One fresh-context sample per call:** a raw API call, or a single-shot subagent. The system prompt is the realistic context the text will live in (the whole skill, not the one paragraph); the user message is a task that tempts the failure.
2. **A no-guidance control, always.** If the control does not show the failure, there is nothing to fix: stop.
3. **Five or more runs per variant.**
4. **Read every flagged match by hand.** Template echoes and quoted counter-examples look like hits; automatic counts overstate both failure and success.
5. **Variance is a metric.** Wording that binds makes runs converge on one shape. Five readings in five runs mean the form is wrong: change the form before adding words.

Micro-tests check wording. A discipline skill still needs its pressure scenarios.

## Testing a pointer in `CLAUDE.md` or `AGENTS.md`

The same cycle tests a line meant to make agents reach for something (a skill, a doc, a check). Run the scenarios with no such line first (the null baseline), then each variant (a soft suggestion, a directive, a step in a process) on the same scenarios, then under pressure. A variant works when the agent reaches the material unprompted, reads it fully before acting, and follows it under pressure. It fails when the agent skips the check, "adapts the concept" without reading, or treats a requirement as optional.

## Meta-testing

When the agent read the skill and still chose wrong, ask it: "You read the skill and chose C anyway. How could it have been written so that A was clearly the only acceptable answer?" Three answers, three fixes:

- **"It was clear; I chose to ignore it."** Not a wording problem. Add a foundational principle early, such as "Violating the letter of the rule is violating its spirit."
- **"It should have said X."** A wording problem. Add X, close to its words.
- **"I didn't see section Y."** An organisation problem. Move the point up, or make it more prominent.

## When a discipline skill holds

It holds when the agent chooses correctly under maximum pressure, cites the skill as its reason, acknowledges the temptation and follows the rule anyway, and meta-testing returns "it was clear". It does not hold while the agent finds new rationalizations, argues the skill is wrong, invents a hybrid approach, or asks permission while arguing hard for the violation.
