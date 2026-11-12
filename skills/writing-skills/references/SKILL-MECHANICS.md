# Skill mechanics

What changes when the document is a skill: frontmatter, the invocation choice, triggers, naming and splitting. Everything else about writing it is in `SKILL.md`.

## Frontmatter

- `name`: up to 64 characters, letters, digits and hyphens. Name it for the action or the core insight, verb-first or as a gerund: `condition-based-waiting` over `async-test-helpers`, `root-cause-tracing` over `debugging-techniques`.
- `description`: up to 1,024 characters; aim for one or two lines. Third person, since it is injected into the system prompt.
- `disable-model-invocation: true` only for a manual skill.

The full field list is in the Agent Skills overview: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview

## Invocation: two choices, two costs

Every always-loaded line spends **context load**: tokens and attention on every turn, whether or not it fires. Every skill the human must remember spends **cognitive load**: the human is the index. Choose which one to pay.

- **Automatic (model-invoked).** Keeps a `description`, so the agent can fire it on its own and other skills can reach it. The human can still type its name. The description is a permanent context pointer: pay context load for discoverability. Mechanics: no `disable-model-invocation`, and a description that starts with "Use when..." and lists the triggers.
- **Manual (user-invoked).** Only a human typing its name runs it, and no other skill can reach it. Zero context load, paid for in cognitive load. Mechanics: `disable-model-invocation: true`, and a description that is a one-line summary for the human, with no trigger list.

Make a skill automatic only when the agent must reach it on its own, or another skill must. A skill that only ever fires by hand is manual.

An automatic skill whose content is all reference can be the single home for reference several skills share. Reference that two manual skills both need lives in neither, since the model cannot invoke them: put it in a plain file outside the skill system that both point to.

## Writing triggers for an automatic skill

The description answers one question: should the agent read this skill right now?

- **Triggers only.** Conditions, situations and symptoms that signal the skill applies. A description that summarizes the workflow ("dispatches a subagent per task with review between tasks") becomes a shortcut: the agent follows the summary and skips the body. In one test, that summary made agents do one review where the body required two.
- **The problem, not one symptom of one technology.** "Use when tests have race conditions, timing dependencies, or pass and fail inconsistently", not "Use when tests use setTimeout". Name the technology only when the skill is specific to it ("Use when using React Router and handling authentication redirects").
- **Words the agent will meet:** error messages, symptoms ("flaky", "hanging"), tool and file names. Put them early.
- **One trigger per branch.** Synonyms that rename one case are the same branch written twice: keep one. Cut identity the body already carries.
- **For a discipline skill, include the moment just before the violation:** "before writing implementation code", "including urgent requests".

Good:

```yaml
description: Use when implementing any feature or bugfix, before writing implementation code
description: Use when tests have race conditions, timing dependencies, or pass and fail inconsistently
```

Weak: "For async testing" (no trigger), "I can help you with async tests" (first person), "Use for TDD: write test first, watch it fail, write minimal code" (workflow summary).

## Splitting

Split only when the cut earns the load it costs.

- **By sequence:** split off a run of steps when the steps after it tempt the agent to rush the one in front. This only works across a real context boundary, such as a hand-off or a subagent dispatch; an inline call leaves the later steps in view.
- **By invocation:** split off a new automatic skill when it has its own leading word that should trigger it (one you actually use in prompts), or another skill must reach it. The new description is permanent context load, so that independent reach has to be worth it.

## Router skills

When manual skills multiply past what the human can remember, one manual **router skill** can name the others and when to reach for each. The human remembers one skill instead of many. It can only suggest them: the model cannot invoke them, so only the human can run them.

## Size

Load the body only with what every use needs. Keep `SKILL.md` well under 500 lines, and move heavy reference (API docs, long syntax, worked examples) to `references/`. Measure with `wc -c` or `wc -w` after each edit; a project may set its own ceilings.
