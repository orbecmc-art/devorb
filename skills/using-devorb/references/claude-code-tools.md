# Claude Code Tool Notes

Claude Code is the reference harness: skills speak its vocabulary
(`Agent` for a subagent dispatch, todos, `Skill`). These notes cover the
one place Claude Code can run a plan cheaper than the skills' default
shape. It is opt-in by the user and changes nothing the skills require.

## Cheaper orchestration for implementing

The controller session is the most expensive seat in a `devorb:implementing`
run: it reads every dispatch result and every report, and it usually runs on
the session's most capable model. Claude Code supports nested subagents (three
layers below the main conversation by default;
`CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` adjusts it), so the whole loop can run
one layer down.

When the user asks for it, or has said the session model is too expensive to
spend on coordination, dispatch ONE orchestrator subagent on a mid-tier model
with the plan path and the instruction to use `devorb:implementing` end to end.
The orchestrator dispatches its own implementers and reviewers per that skill's
Model Selection; the workspace and ledger live on disk, so nothing is lost to
the extra layer. Its final message must carry the "Rulings I made" and "User
decides" lists verbatim. Those lists are how the decisions reach the user, and
you relay them, not summarize them.

Do this only for a whole plan. Nesting a single task's dispatch buys nothing
and adds a seat.
