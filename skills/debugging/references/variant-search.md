# Searching for variants

Use this when the broken rule could be violated in more places than a quick grep of callers shows: a large codebase, copied code, or a misused API.

## Name the rule first

Write the rule as a sentence a search can check: what must always hold, and what reaches the code without it. "Only the owner of a record may edit it." "Every handle opened on this path is closed on the error path too." A vague rule gives a vague search.

Before searching, list where variants tend to hide, and grep to confirm each lead exists in this codebase:

- Identifiers with the same job: sibling methods, other stores, other flags.
- The same mistake written differently: a negated check, a default that succeeds when no branch matched, the wrong boolean operator.
- Boundary values: a comparison where both sides can be missing, an empty string against null, zero, an empty list.
- Functions whose name or doc promises one thing while the return value means another.

## Widen one step at a time

Search from the repository root, not only the module where the bug showed up.

1. **Exact:** a search that matches only the known case. If it matches nothing, your picture of the bug is wrong; fix that before going on.
2. **Names:** replace the specific identifiers with wildcards.
3. **Structure:** loosen the surrounding code shape.
4. **Data flow:** follow the value from where it enters to where it does harm.

Change one element per step, then read every new hit. Write down per step how many hits were real and how many were noise. When more than half are noise, undo that step and try a different one instead of widening further.

## Decide each candidate

Before counting a candidate, try to prove it safe: read the whole function and its callers for a guard that runs first, a validation on the way in, a type that cannot hold the bad value, or callers that never pass it. It is a variant only when that proof fails. Code with no caller today still counts, at lower priority.

## Record

| Variant | Location | Status | Reason |
|---|---|---|---|
| The reported bug | `src/x.js:42` | fixed | Fixed in the shared layer |
| Same rule, other caller | `src/y.js:10` | not fixed | Out of scope, reported to the user |

Also note the candidates you ruled out, grouped by what made them safe, so a later search can skip them.
