---
name: retro
description: Retrospective on a coding session that proposes changes to the agent's environment
disable-model-invocation: true
---

# Retro

Look back at a session and propose changes to the agent's **environment**, so the next run goes better: the files it reads, the checks that run, the instructions it carries, its tools and what it can see. The code the session wrote is not the subject. A bug in it becomes a finding only when the environment could have caught it or pointed the agent away from it.

## Steps

1. **Read the primary source.** Use the session the user names; with none named, the current one. A past session's log is on this machine, under `~/.claude/projects/<project folder>/<session id>.jsonl`: read the log, not a summary of it. Quote no secret the log contains.
2. **Read the repo's guardrails** before proposing any: the check commands (`package.json` scripts or the build tool's `lint`, `check`, `test`), the pre-commit hooks, the CI workflows, `CLAUDE.md` or `AGENTS.md` in the repo and in the user's global scope, and the standards files `devorb:reviewing` reads.
3. **Find candidates** in the categories below. Each one cites the moment in the log that shows it: the turn, the command, the error.
4. **Present them to the user, most severe first,** and stop. Each candidate: what happened, the category, the concrete fix (the rule, the check, the pointer) and where it goes. Apply only what the user picks.

## Categories

- **Navigation:** the agent took long to find a file or fact, or missed a hidden dependency between files. Fix: a navigation pointer where the agent looks first.
- **Automated checks:** the agent made a mistake a lint, type check, test or file-layout check would have caught. A check that exists but is unwired or silently broken is the finding, not a new one. A repo with no guardrail at all (no pre-commit hook and no CI job running its lint, typecheck or tests) is a finding by itself.
- **Coding standards:** review let a mistake through, or a rule is missing, wrong or unclear. Classify the rule first (below).
- **Steering files:** `CLAUDE.md` or `AGENTS.md` is large, in the repo or global. Instructions there that are really standards or checks move out.
- **Tool economy:** a tool call, CLI or MCP server cost far more tokens or time than the answer was worth. Fix: a narrower command, a flag, a cheaper tool.
- **No-ops:** an instruction in a steering file that changed nothing the agent did. Fix: delete it.
- **Information access:** a fact the agent needed was out of reach: dev server logs, a read-only view of a third-party service, a doc. Fix: give the access, read-only where possible.

## Mechanical or judgment

- **Mechanical** (a fixed syntactic pattern, a banned API, an import shape, where a file must live): becomes an **automatic check**. A custom rule in the repo's linter, a pre-commit hook or a CI job, whichever the repo's language and existing guardrails make cheapest. Prefer building the check to writing the rule down.
- **Judgment** (consistency across files, matching the surrounding style, anything no check could replace): becomes a **standard**, written in the repo's standards file (`CONTRIBUTING.md` or a coding-standards file), which `devorb:reviewing` reads.
- **The fix is a skill,** or a line in `CLAUDE.md` or `AGENTS.md`: write it with `devorb:writing-skills`, failing scenario first.

## Where each fix belongs

Work runs in two stages. Implementation carries the most context pressure: it explores, writes code and debugs. Review carries the least: it gets a diff. So standards are enforced at review, not loaded into implementation.

- **`CLAUDE.md` / `AGENTS.md`:** loaded into every agent in the repo. Use sparingly, mostly for navigation pointers to other files.
- **Standards file:** read at review. Past about 1,000 lines, split it and leave pointers to the parts.
- **Docs:** reference files that other files point to. Look for an existing doc before writing a new one.
- **Skills:** for reference whose description should sit in context, or for a command the user types.

## Connects to

- **Receives:** the user's call, optionally with the session or log to look at; `devorb:using-devorb` suggests it in the session it looks back on, before clearing.
- **Uses:** the session log; the repo's check commands, hooks, CI and steering files; `devorb:writing-skills` when the fix is a skill or a steering-file line.
- **Hands off to:** the user, with candidates ranked by severity. Accepted standards go to the file `devorb:reviewing` reads; accepted checks land like any code change; accepted skill changes go through `devorb:writing-skills`.
