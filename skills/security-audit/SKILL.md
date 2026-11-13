---
name: security-audit
description: Audit a whole project, a commit range or a pull request for security holes, check each finding apart, and report without fixing anything
argument-hint: "What to audit: the project, a commit range (a1b2c3..HEAD) or a pull request number"
disable-model-invocation: true
---

# Security Audit

Find the holes that an outsider or a less privileged user could really use, prove each one from the code, and hand the user a report. The audit reads and reports: it changes no file, commits nothing and posts nothing. Fixes come afterwards, through the skills named at the end, for the findings the user picks.

## Ground rules

- **No live targets.** Never send traffic to a deployed site, API, database or third-party service, except read-only package registry lookups, and never touch production data or accounts. Install nothing; spend no paid quota.
- **Run nothing by default.** Read the code; run nothing from the project by default. A local check runs only after the user approves the exact command, from a temporary copy with every `.env*` file removed, under `env -i` with made-up values, against a process started there, stopping at the first sign of the effect. Never for a pull request's code. Without approval, the check goes under Needs checking.
- **Secrets stay unseen.** Never print, echo, copy or try out a value that may be a secret: not in a command, not in tool output, not in the report. Search so that only file names, line numbers, counts or variable names come back (step 2). Never call a service with a found key to see whether it still works. The report gives file, line and variable name, then `[redacted]`.
- **Facts outside the repo stay open.** Proxy, firewall, cloud, host and provider settings decide real outcomes. When a verdict hangs on one the repo doesn't show, don't assume it either way: the lead goes under Needs checking.
- **GitHub stays as it is.** If `gh` is already signed in, open Dependabot, code scanning and secret scanning alerts may be read as leads, only with `gh api --method GET`. For secret scanning, the value must never reach the output: always add `--jq '.[] | {number, secret_type, state}'`. If the token can't see them, that is a coverage gap; never ask for or switch to a wider token. Never dismiss, close or reopen an alert unless the user asks for exactly that.

## 1. Pin the scope

The argument names it. With none, ask once: the whole project, a commit range or a pull request.

- **Project:** everything tracked at `HEAD`. Note the commit and whether the tree has uncommitted changes.
- **Commit range** `A..B`: list the changed files first with `git diff --name-only A..B` and run step 2's secret-name check on that list. A flagged file gets only step 2's commands. Read the hunks of the others one file at a time, `git diff A..B -- <file>`, plus every route, function and check the changed lines call or are called from.
- **Pull request:** `gh pr view <n> --json baseRefName,headRefOid` and `gh pr diff <n> --name-only`, then the same check. Fetch the head without running it (`git fetch origin pull/<n>/head`) and read unflagged files with `git diff origin/<base>...FETCH_HEAD -- <file>`.

What lies outside the scope is reported as out of scope, never as covered. A range or a pull request is a partial audit and the report says so.

## 2. Map the surface

Before hunting, list:

- **Entry points:** routes, server actions, webhooks, CLI arguments, queue consumers, uploads, scheduled jobs.
- **Who may call each one:** anyone, a signed-in user, an admin, another service; and the line where that is enforced.
- **Sensitive sinks:** queries, shell and process calls, file paths, outgoing requests, HTML rendering, redirects, deserialization, model prompts and tools.
- **Secrets:** where they load from and whether a file holding one is tracked, now or in history. Use only commands that can't show a value:
  ```bash
  git ls-files | grep -iE '(^|/)\.env|secret|credential|\.pem$|\.key$|id_rsa'  # tracked, by name
  git log --all --oneline -- <file>                    # commits touching it, never -p
  grep -cE '^[A-Za-z_][A-Za-z0-9_]*=.+' <file>         # how many assigned values
  grep -oE '^[A-Za-z_][A-Za-z0-9_]*=' <file>           # variable names only
  grep -nE '<pattern>' <file> | cut -d: -f1            # line numbers only
  ```
  With the Grep tool, search secret patterns in `files_with_matches` or `count` mode, never `content`. Never open such a file with Read, `cat`, `git show`, `git diff` or `git log -p`. In a source file that matches, read only the lines around the matched line numbers, never the matched lines themselves.
- **Supply chain:** manifests, lockfiles, CI workflows, Dockerfiles, deploy scripts.

The questions for each boundary are in `references/checklist.md`; patterns for JS/TS, shell, CI and Docker in `references/ecosystems.md`.

## 3. Hunt

Walk each boundary with the checklist. A candidate names six things: who acts and why they shouldn't be able to, what they send, the control that should stop it, the line where that control fails, what they reach, and the result. Short of one, it isn't a candidate yet.

Not findings:

- a skipped best practice with no path to harm;
- a missing second layer when the first one really blocks the attack: list it as hardening;
- a user who can only affect their own data;
- a guard credited for its name. `sanitize()`, `isAdmin` or `validate()` prove nothing until you have read them, seen every path to the sink run through them, and seen them refuse when they can't decide.

A lead the repo can't settle keeps its trace and goes under Needs checking, with no severity: the missing fact, and the check, local or done by the owner on their system, that would settle it.

## 4. Verify each candidate apart

Each candidate goes to a new general-purpose subagent whose only job is to knock it down. Send them all in one message. Each gets the evidence, not your reasoning: the claim in one line, entry and sink as `file:line`, the steps between, the output of any local check, and the scope. Never your confidence, the other candidates or a secret value. Brief:

```
Try to disprove this security finding. Read-only; no network beyond this machine.
Reread every cited line yourself. Look for anything on the path that stops it:
validation, auth middleware, ownership check, parameterized query, framework
escaping, configuration. A guard counts only if every path runs through it and
it refuses when unsure. Confirm the actor really lacks the access they gain.
Never print or open a file that may hold a secret; check one only with
`git ls-files`, `git log --oneline` and variable names.
Answer with one of:
- CONFIRMED: the path and the result hold; proposed severity and the damage shown.
- NEEDS CHECKING: the fact outside the repo that decides it, and how to check it.
- REJECTED: the line or control that refutes it, in one sentence.
```

Without the subagent tool, verify each candidate in its own pass that starts from that evidence alone, and the report says verification ran in the same session.

Only a confirmed finding gets a severity, set by the damage the evidence shows, never by how alarming it sounds:

- **Critical:** someone with no account runs code, or reads or changes all data or any account.
- **High:** a user gets past a control meant for them: another user's data, an admin action, a login without the right credential.
- **Medium:** a real crossing with narrow reach or unusual conditions.
- **Low:** a minor leak of non-secret detail, or an effect that costs great effort for little gain.

Every finding here is Critical in `devorb:reviewing` terms: a security hole, whatever its level on this scale.

A secret in a tracked file or in history goes to a verifier like any candidate, and it confirms with only `git ls-files`, `git log --oneline` and variable names. Rate it by what the code does with it, read at its call sites.

## 5. Report, then stop

In the user's language:

1. **Scope:** what was audited, at which commit, uncommitted changes, what stayed out, and how verification ran.
2. **Findings,** worst first: title, severity, `file:line`, who acts and how, the result, and the smallest fix where the decision is made. Secrets as `[redacted]`.
3. **Needs checking,** no severity: the lead, its trace, the missing fact, the check that settles it.
4. **Hardening:** notes that are not findings.
5. **Rejected:** one line each, so the next audit doesn't raise them again.
6. **Coverage:** for each boundary, with or without findings, the paths read and the checks run; then what was not examined.

Close with the count of findings, or "no sustained finding in scope" when there are none. Never "secure", "safe" or "no vulnerabilities": an audit vouches for what it examined, not for what it missed.

Then stop. Don't start fixing. For each fix the user picks:

- **Leaked secret:** the user revokes or rotates it at the provider first, outside git. Taking it out of the tree comes after, and rewriting history is a separate decision with its own cost. Dismissing or leaving the alert postpones the fix; it doesn't make it.
- **Code finding:** `devorb:debugging` finds the root cause, and `devorb:tdd` writes a regression test that fails before the fix, passes after it, and includes a legitimate request that must still succeed, so that refusing everything can't pass for a fix.

## Connects to

- **Receives:** the user's `/devorb:security-audit` call with a scope; a suggestion from `devorb:reviewing` when a diff review calls for a full audit.
- **Uses:** fresh subagents as verifiers; `references/checklist.md` and `references/ecosystems.md`; read-only `git` and `gh`.
- **Hands off to:** the user, with the report. The fixes they pick go through `devorb:debugging` and `devorb:tdd`.
