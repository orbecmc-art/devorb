---
name: handoff
description: Write a handoff file in the system temp folder so a fresh session can pick up this work
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

# Handoff

Compact this session into one markdown file that a fresh agent, in any harness or directory, can read and continue from. If the user passed arguments, they say what the next session is for: shape the file around that. Writing the handoff is the whole job; no other file changes.

## Where it goes

Save it in the OS temp folder (`$TMPDIR`, else `/tmp`; `%TEMP%` on Windows), never in the workspace, as `devorb-handoff-<yyyy-mm-dd>-<topic>.md`. If that name is taken, add a suffix, so earlier handoffs stay intact. Nothing is committed.

## Point, don't copy

Specs (`docs/devorb/specs/`), plans (`docs/devorb/plans/`), ADRs (`docs/adr/`), `GLOSSARY.md`, issues, pull requests, commits and diffs already hold their content. Name them by path, URL or command (`git diff main...HEAD`), with one line on why the next agent should read each. Write out only what lives nowhere else: the decisions and reasons from this conversation, what is still open, what failed.

## Hide secrets

The file leaves the repo and may reach a colleague. Before writing, check the draft for API keys, tokens, passwords, connection strings with credentials and personal data. Write where a secret lives (`STRIPE_KEY` in `.env`), never its value.

## Open items say how they are known

Tag each open item with one word, by what this session did with it:

| Tag | This session | Add after the tag |
|---|---|---|
| `ran` | executed it | the command and its result (`npm test`: 3 failing in `cart.test.ts`) |
| `read` | looked at it, ran nothing | the path, and the line when it helps |
| `assumed` | neither | nothing |

What a subagent's report, an earlier handoff or a commit message claims stays `assumed` until this session runs or reads it.

The file tells whoever resumes to check the `assumed` items first, before building on any of them, then to re-check the `ran` and `read` items whose files changed after the commit the handoff names.

## The file

```markdown
# Handoff: <topic>

From `<repo path>`, branch `<branch>` at `<short sha>`, <date>. Uncommitted: <files, or none>.

## Next session
<What it is for: the user's arguments, else the next step. Two lines at most.>

## Read first
- `<path, URL or command>`: <why>

## Decisions not written elsewhere
- <decision>: <reason>

## Open items
Check the assumed items first.
1. <item>. (ran: `<command>`, <result> | read: `<path>` | assumed)

## Dead ends
- <what was tried>: <why it failed>

## Suggested skills
- `devorb:<skill>`: <when to call it>
```

Leave out a section that would be empty. In **Suggested skills**, name the DevOrb skills the next agent should call; for a manual one (`devorb:prototype`, `devorb:retro`), say the user has to start it.

## Finish

Reply with the file path and a line the user can paste to start the next session: `Read <path> and continue with <next step>.`

## Connects to

- **Receives:** the user's call at a phase boundary, often after `devorb:using-devorb` recommends it for a new harness, a new directory, a colleague or a side task, with an optional focus for the next session.
- **Uses:** git state and the paths of the spec, plan and ADRs; this conversation for decisions, open items and dead ends.
- **Hands off to:** a fresh session, which treats the file as claims to check, as `devorb:verifying` does with any earlier handoff, starting with the assumed items.
