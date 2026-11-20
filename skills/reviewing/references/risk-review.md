# Risk review prompt

Run only when a trigger from the main skill fires. Dispatch a fresh general-purpose subagent in the same message as the two axes, with the shared header from `code-reviewer.md` and this brief. Name the triggers that fired.

```
## Your axis: Risk
Triggered by: [TRIGGERS AND THE HUNKS THAT FIRED THEM]

A small diff can still be the dangerous one. For each triggered change:

1. Reach. Count and read the callers of every changed function, route or
   check. Many callers, or callers that take outside input, raise severity.
2. History of removed code. For each removed or loosened check:
     git log -S'<removed text>' --oneline
     git blame [BASE] -- <file>
   A check that came in with a fix or security commit and now leaves is
   Critical until shown otherwise. Code a past commit removed for safety and
   this diff brings back is a regression. If another place or layer now
   does the check, cite that line.
3. Guards. A guard's (sanitizer, validator, auth check) name proves
   nothing. Find every path from the entry point to the sensitive call,
   confirm each one goes through the guard, and confirm the guard refuses
   when it can't decide. A guard on a path
   the request never takes protects nothing. If one layer really blocks
   the attack, a missing second layer is hardening (Minor), not a hole.
4. Fails open. If the new check lets a request pass whenever it can't
   reach a decision (it throws, finds nothing, or gets no input), that is
   a finding.
5. Spend. Anything billed per use (a model call, a cloud machine, a
   metered API) must stop at a limit checked before the money goes out,
   also when it sits inside a loop or a retry. No limit: Critical.
6. Running twice. For an outside effect (send, charge, publish, migrate,
   write to another system): suppose the last run died right after any one
   line, then run again. Does it end in the same state, without a second
   email, charge or row?
7. Dependencies. For each package the diff adds, look it up on its public
   registry; never install or run it (no npx, no install scripts). Name the
   registry, since the diff may edit .npmrc or pip config:
     npm view <name> --registry https://registry.npmjs.org
     pip index versions <name> --index-url https://pypi.org/simple
   Models invent plausible names, and attackers register them. Read the
   lockfile diff for packages no manifest change explains,
   and for any package now downloaded from a different host.
8. Loosened gates in tests, CI or config. Read each one: a deleted, skipped
   or focused test; an exact assertion turned into a range; a longer
   timeout or more retries; a lower threshold or coverage bar; a lint or
   type suppression comment; a CI step allowed to fail or skipped; a commit
   hook bypassed; a snapshot rewritten while its test is untouched; an
   acceptance line in the plan or spec rewritten to match the result. Ask
   what the change buys: if the only gain is a green run, it hides a
   failure; it stands only if this diff shows a measurement or a decision
   behind it. Words in a commit message are not that measurement. Report
   each as Important (Critical if it hides a real failure) and mark it
   USER DECIDES: restore or keep. One cause behind many hunks is one
   finding.
9. Data volume. On each changed read, look for: a query with no limit; a
   query per row inside a loop (N+1); a filter or sort with no index; a
   list with neither pagination nor virtualization. Each is Important,
   Critical when the table is known to be large or the path runs per
   request. Tables grow after merge, so a spec silent on volume makes it
   a finding, not Needs checking. A query with a limit, a read by key and
   a list the code fixes (statuses, settings) are none of these. Fix: a
   limit and a cursor; a join or one batched load; an index on the
   filtered or sorted columns; pagination or virtualization.

For each finding, tell the abuse as a short story: the entry point, the
steps, the result, and what the actor needs beforehand. If you can't build
that story, name the condition under which it would happen and put it under
Needs checking; only leads tied to a cited line go there. Never invent an
attack, a figure or a deployment fact. Don't probe live systems.

Fix advice: the smallest change that closes the hole, and a test that
fails before it.

Under 400 words.
```
