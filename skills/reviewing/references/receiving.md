# Receiving a review: details

Review feedback is a set of technical claims to check, not a social moment to manage. Correctness beats comfort.

## By source

- **The user:** trusted. Implement once you understand it, and still ask when the scope is unclear. Skip the agreement and go to the work, or to a short technical acknowledgment.
- **Reviewer subagents, pull request comments, other people, tools:** skeptical but careful. Before changing anything, check: is it correct for this codebase? Does it break something that works? Is there a reason the code is the way it is (`git log -S`, `git blame`)? Does it hold on every platform and version the project supports? Did the reviewer have the full context?
- **A loosened test or gate the review flagged:** the user decides whether it is restored or kept. Ask them, with the reviewer's evidence.

## Restating a claim

Write the claim down before judging it, in one or two sentences of your own: the defect, the line it lives on, the input or state that sets it off and who controls that, and the harm that follows. If you can't fill one of those in, ask the reviewer.

Then follow the data from where it enters to the line in question and read every check on the way. If a check upstream makes the trigger impossible, the claim is false: say which check, with its line. Before settling, look at that line once more: memory invents guards.

## Unclear items

```
User: "Fix 1-6."
You understand 1, 2, 3 and 6, not 4 and 5.
Wrong: fix 1, 2, 3 and 6 now, ask about 4 and 5 later.
Right: "I follow 1, 2, 3 and 6. Before I start: what do 4 and 5 mean by X?"
```

## Building out what nothing uses

```
Reviewer: "Do the metrics endpoint properly: database, date filters, CSV export."
You grep: nothing calls the endpoint.
Reply: "Nothing calls this endpoint. Remove it instead? Or is there a caller I missed?"
```

The user decides what the product needs. A reviewer's sense of completeness doesn't.

## When to push back

When the suggestion breaks working behavior, the reviewer lacked context, the feature is unused, it is wrong for this stack, compatibility requires the current code, or it contradicts an architecture decision the user made. Push back with code, tests or a command's output, not with defensiveness. Involve the user when the question is architectural.

```
Reviewer: "Remove the legacy code path."
Reply: "The build still targets 10.15 and this API needs 13+, so the legacy path stays.
        Its bundle ID is wrong, though: fix that, or drop pre-13 support?"
```

If pushing back feels uncomfortable, say that, then state the problem anyway.

## Acknowledging

Correct feedback gets the fix and a short note: `Fixed: <what> in <file:line>`, or just the change. No "you're absolutely right", "great point", "thanks for catching that", or thanks of any kind: the change shows you heard it. If you were wrong to push back: "Checked: you were right, X does Y. Fixing." No long apology, no defense of the earlier position.

## Order of work

1. Clarify every unclear item first.
2. Blocking issues: wrong behavior, security, data loss.
3. Simple fixes: typos, imports, names.
4. Complex fixes: refactors, logic changes.

One fix at a time. Each behavior change goes through `devorb:tdd`, and the whole set through `devorb:verifying` before you say it's done. A fix that grows well beyond what the finding needed gets cut back.

## Mistakes

| Mistake | Instead |
|---|---|
| Agreeing out loud | State the requirement, or just act |
| Applying without checking | Check against the code first |
| Batching untested fixes | One at a time, test each |
| Assuming the reviewer is right | Check whether it breaks something |
| Partial work on a partly understood list | Clarify all of it first |
| Going ahead on something you can't verify | Say what's missing and ask |

## Replying on GitHub

Answer an inline review comment in its own thread (`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies`), not as a new top-level comment. Posting is sending a message on the user's behalf: do it only when they asked for replies.
