# Measuring a performance claim

Use this before saying a change is faster, slower, lighter or "no slowdown", and when picking between variants by a number.

## Before you measure

- **Baseline first.** Measure the current code before changing it. Without a baseline there is nothing to compare.
- **Write the claim down first:** what you measure, in which unit, and which way you expect it to move. Read the benchmark code to see where the clock starts and stops, so setup or teardown does not slip into the number.
- **Match both sides.** Old and new get the same input and data volume, the same compiler or bundler settings, the same library versions, and a cache in the same state (both warm or both cold). Timing a release build against a dev build measures the build settings, and says nothing about your change.
- **One idea per variant.** A variant that changes three things at once can't tell you which one helped.
- **Tests first.** Every variant runs the test suite before it is timed. A red variant is out, whatever its number.

## While you measure

- **Alternate.** Do 5 alternating runs per side (old, new, old, new...). Noise that grows during a session, such as a JIT warming up, a disk cache filling or a background job, then hits both sides alike.
- **Count bad runs.** Any run that errored or returned a wrong answer is reported, not dropped. An error page comes back quickly and can pass for a speed-up.
- **Prove the measured work happened.** A fire-and-forget call returns before its work finishes, and a compiler may drop a computed value that nothing uses. Either one makes the new side look fast. Check an output of the work on every run, such as a row count or a checksum.
- **Check the gain against its ceiling.** A step that took 200 ms of a 1 s run can give back 200 ms and no more. If the new side gained more than that, look for something else that changed between the sides before believing the number.

## Report

Say first whether the new version is faster, slower, the same within the spread, or whether the data cannot tell.

- Give the median for each side, the spread (lowest to highest), the number of runs, the bad-run count and the exact commands.
- If the gap between medians is inside the spread, the verdict is "no difference", even when one median is lower.
- If any check above failed (sides not matched, bad runs not counted, no proof the work happened), the data cannot tell. Name the check.
- Don't call the winner optimal; it is the best of the ones you tried.
- When you timed one function on its own, give its share of the whole wait: 5 ms saved in a 2 s page load is 0.25% of it.
