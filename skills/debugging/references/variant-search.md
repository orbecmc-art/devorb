# Finding every place the rule breaks

Open this when a grep of the direct callers is not enough: a large repository, code copied between modules, or an API that many places call the same wrong way.

Work from the one-sentence rule of phase 5. If you cannot check a single line of code against it, sharpen it before you search. Then note where else the same slip could live here, such as sibling functions or the same check written another way, and confirm each lead exists.

## Grow the search from the known case

Search from the repository root. The first query finds the bug you reproduced and little else. If it misses that line, your picture of the bug is wrong: go back before you widen.

Then loosen one thing per query, for example a name turned into a wildcard, or the code around the call relaxed, or the bad value traced from its entry point to the line it breaks. Read every new hit, and keep a count per query of real hits against noise. When noise passes half, undo that last loosening and loosen something else. grep is enough in most repositories.

## Clear a candidate before you count it

For each hit, look for what keeps the bad value out: a guard or a validation earlier on the path, a type that cannot hold it, callers that never pass it. Read the whole function and its callers. A candidate counts only when you fail to clear it. Unused code still counts, ranked after the live paths.

## Write it down

| Place | What you did | Why |
|---|---|---|
| `src/a.js:42`, the reported bug | fixed in the shared layer | both callers go through it |
| `vendor/c.js:10` | left as is | vendored copy, told the user |

Under the table, list the candidates you cleared, grouped by what cleared them, so a later search can skip them.
