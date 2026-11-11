# Measuring a performance claim

Use this before saying a change is faster, slower, lighter or "no slowdown", and when picking between variants by a number.

## Before you measure

- **Baseline first.** Measure the current code before changing it. Without a baseline there is nothing to compare.
- **Decide the claim up front:** metric, unit and the change you expect. Then open the benchmark and see what its timer covers and what sits outside it.
- **Same conditions on both sides:** input, data size, build mode and flags, dependency versions, cache state. If one side runs a debug build or a cold cache, the number measures that difference instead of your change.
- **One idea per variant.** A variant that changes three things at once can't tell you which one helped.
- **Tests first.** Every variant runs the test suite before it is timed. A red variant is out, whatever its number.

## While you measure

- **Interleave.** Run old, new, old, new, at least 5 times each, so whatever drifts during the session (warm-up, caching, other load) lands on both sides.
- **Count bad runs.** Any run that errored or returned a wrong answer is reported, not dropped. An error page comes back quickly and can pass for a speed-up.
- **Make sure the timed code ran.** A promise nobody awaits or a result nobody reads can be skipped or optimized away, and skipped work is very fast. Log or assert something the work produces.
- **Sanity-check the size of the gain.** Removing a step that took a fifth of the time can shorten the run by a fifth at most. A bigger gain usually means you timed a cache hit or skipped work.

## Report

Start with one word for the verdict: **faster**, **slower**, **no difference** or **inconclusive**.

- Give the median for each side, the spread (lowest to highest), the number of runs, the bad-run count and the exact commands.
- If the gap between medians is inside the spread, the verdict is "no difference", even when one median is lower.
- The verdict is inconclusive if any check above failed: different conditions, uncounted bad runs, or no sign the work ran. Name the one that failed.
- Don't call the winner optimal; it is the best of the ones you tried.
- For a micro-benchmark, also say how much of the user's wait that code accounts for.
