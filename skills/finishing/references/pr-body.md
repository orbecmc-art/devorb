# Pull request body

Use this only when the repository has no pull request template. A template
wins: fill its sections with the same evidence.

No preamble, brief prose, and the user's domain words from `GLOSSARY.md`.

```markdown
## Summary

<diagram, diff sketch or tree>

## Evidence

- **Before:** <screenshot, output or failing test run>
  **After:** <screenshot, output or passing test run>

## Merge danger

**Door:** <one-way or two-way>

<optional: why>

**Blast radius:** <one word>

<optional: what a merge could affect>
```

## Summary

Pick the smallest view that makes the main point clear. Usually one, sometimes
two, rarely more.

- **Logic or an algorithm:** pseudocode.
- **Runtime control flow:** a call tree.
- **UI structure:** a component tree, with the state and module boundaries
  that matter.
- **File responsibilities or a broad refactor:** a shallow file tree with a
  comment per entry.
- **Interaction or data flow between parts:** a Mermaid sequence diagram.
- **What changes inside a shape that already exists:** a `diff` block in that
  shape, `+` and `-` on the lines of the tree, call stack or flow:

```diff
 submitForm
   createSession
     persistPrompt
+    expandSkillMention
     launchAgent
```

- **Mostly new code, or a target shape to copy:** the whole block.

Put each view next to the sentence it supports. Keep only the calls, files,
props and states the reader needs to judge the change.

## Evidence

Show that the change works, before and after. A screenshot is the strongest
evidence when the change is visual and the environment can take one. Next
best is execution: the test that failed before and passes now (as pseudocode
if it is long), or the command output. Use the suite run from
`devorb:verifying`, with its counts.

## Merge danger

- **Door:** two-way when the change can be walked back cheaply, one-way when
  it destroys data or locks in a decision that is hard to reverse (a
  migration, a published API, a sent message).
- **Blast radius:** who and what the change could affect if it is wrong:
  consumers of an interface, layout, mobile, other services.
- Add what `devorb:finishing` found before the menu: base commits the branch
  depends on, docs that still describe the old behavior, and each USER
  DECIDES item with the user's answer.
