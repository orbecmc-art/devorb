# Bulletproofing against rationalization

For one failure type only: the agent knows the rule and skips it under pressure (a discipline failure seen in the baseline). For output with the wrong shape, or a missing element, these tools backfire; use a recipe, a required slot or a conditional instead (`SKILL.md`, "Match the form to the failure").

## Close each loophole by name

A bare rule leaves room to negotiate. Name the workarounds the baseline agent used:

```markdown
Wrote code before the test? Delete it. Start over.

- Don't keep it as a reference.
- Don't adapt it while writing the test.
- Don't look at it.
- Delete means delete.
```

Each line answers a rationalization you recorded. A generic counter ("don't cheat") binds nothing; a specific one ("don't keep it as a reference") does.

## Cut off "spirit, not letter" early

Put the foundational principle near the top, before the rules:

```markdown
Violating the letter of these rules is violating their spirit.
```

One line closes the whole class of "I'm following the spirit" arguments.

## Rationalization table

Every excuse from the baseline and refactor runs goes in, in the agent's own words, with the answer:

```markdown
| Thought | Reality |
|---|---|
| "Too simple to test" | Simple code breaks. The test takes 30 seconds. |
| "I'll test after" | A test written after passes at once, which proves nothing. |
```

Rows come from runs, not from imagination. A row nobody produced is a no-op.

## Red flags

A short list the agent can check itself against, ending with the action each one triggers:

```markdown
These thoughts mean: stop, delete the code, start over from the test.
- "I already tested it by hand"
- "This case is different because..."
```

## Description symptoms

Add the moment just before the violation to the description's triggers ("before writing implementation code", "including urgent requests"), so the skill loads while the temptation is live.

## Language that holds under pressure

Language models answer to the same persuasion principles people do: in one study of 28,000 conversations (Meincke et al., 2025), applying them roughly doubled compliance (33% to 72%). Use them to make a rule hold, never to manipulate.

| Principle | In a skill | Use for |
|---|---|---|
| Authority | Imperatives and bright lines: "Always", "No exceptions" | Discipline and safety rules |
| Commitment | Announce the skill in use; force an explicit choice; track checklist items as todos | Multi-step processes, accountability |
| Scarcity | Time-bound steps: "before proceeding", "immediately after X" | Steps agents defer |
| Social proof | Norms and failure modes: "Checklists without tracking get skipped. Every time." | Universal practices |
| Unity | Shared goals: "we both want this to work" | Collaborative workflows |

By skill type: discipline skills combine authority, commitment and social proof; technique skills use moderate authority and unity; reference skills use clarity alone. Leave out liking (it breeds sycophancy) and reciprocity. The test for each use: would it serve the user's real interests if they fully understood it?

Bright lines work because they remove the "is this an exception?" decision. "When X, do Y" binds better than "generally do Y".
