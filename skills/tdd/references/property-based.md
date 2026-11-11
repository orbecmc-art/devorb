# Property-Based Tests

**Read this when:** the code under test follows a general rule that should hold for every valid input, not just for the cases you can list by hand.

First decide whether such a rule exists. Most code has none; then write example tests and say in one line that no general rule applies. When the rule does exist, you state it once and a library supplies the inputs, hundreds per run. On a failure, the library shrinks the input to the smallest one that still breaks the rule. An example test covers only the input you chose.

## Does the code have the shape?

Each question below that gets a "yes" hands you a rule to assert.

- **Is it an object you call in sequences?** Run random sequences of calls against it and against a tiny in-memory model of what it should hold; after every step the two agree. Session stores, undo stacks, inventories, rate limiters.
- **Is there a version you already trust?** For every input, the code under test and the trusted version return the same answer. A plain loop beside the SQL query that replaces it, a memoised function beside its uncached twin, the legacy endpoint beside the new one.
- **Is there an operation that undoes it?** Then going there and back returns the input: `decode(encode(x))` equals `x`. Base64, a CSV export read back by the importer, an amount in cents printed as text and parsed again.
- **Is there something it must keep?** Measure it before and after; it doesn't move. Splitting a bill keeps the total, paging through results returns every row exactly once, a sort keeps the same items.
- **Does running it twice change anything?** Code that tidies something must leave tidy input alone: `normalise(normalise(x))` equals `normalise(x)`. Phone-number normalisers, slug generators, upserts, "mark as read".
- **Does a known change to the input move the output in a known direction?** Adding an item never lowers the cart total; raising the minimum rating never adds results; a later deadline never makes a task more urgent.
- **Should order, grouping or a neutral value not matter?** Swapping the arguments, regrouping them, or adding the empty value leaves the result alone. Merging config maps, adding money, the union of tag sets, counters synced between devices.
- **Is checking an answer much cheaper than producing it?** Check the answer and skip the steps: a solved sudoku obeys the grid rules, a generated timetable books no room twice, the change handed back adds up to the amount owed.

## How much a rule proves

Run each candidate rule against a deliberately broken version of the code, such as one that returns its input unchanged or returns an empty value. If the broken version still satisfies the rule, the rule proves little. Ranked from the rule that rejects the most wrong versions to the one that rejects the fewest:

- **The output is pinned:** a round trip, agreement with a trusted version, or a check that decides the answer completely (for a sort: in order, and the same items). Hardly any wrong version survives.
- **It settles:** a second pass changes nothing. A version that settles on the wrong value survives.
- **Something is kept:** a count, a total or the set of items is unchanged. A wrong order, or a wrong value with the right total, survives.
- **The form is right:** type, length or range. Any wrong value of the right form survives.
- **It runs:** no crash and no undocumented exception. Almost every broken version survives.

Start at the top and take the first rule the code supports. If only "it runs" is left, a property test seldom earns its place, and never earns a new dependency: write example tests and say so.

## Green, yet empty

**Tautological:** the expected value is computed the way the code computes it (`expect(add(a, b)).toBe(a + b)`, the same builder on both sides). It passes by construction and can never disagree with the code. Assert a law, a round trip or an independently written reference instead. One exception: running the code twice on one input and comparing the results is a real check when its output may vary, as with a generated ID or work split across threads.

**Vacuous:** the run is green because almost nothing was checked. Read its statistics first: how many cases ran and how many were thrown away. A rule guarded by an `if` that the data seldom enters, or a filter that rejects most inputs (or all of them, when two conditions clash), checks next to nothing. Build valid inputs in the generator rather than filtering afterwards.

## In the TDD cycle

A property is a test like any other: write it, run it, watch it fail, then write the code. The generator usually finds a failing input before the behavior exists; read it and confirm it fails because the behavior is missing.

Inputs that broke similar code before (empty, zero, the type's limits) go in as fixed examples next to the property; a random generator may never reach them.

A failing input is not yet a bug. Look up what the code promises for it: types, docs, spec, existing tests. The promise excludes it? Narrow the generator. The promise covers it? Fix the code. The promise is silent? Supporting that input is the user's choice, so ask. If the user is away or this runs as a subagent, keep example tests for the promised inputs and name the open input in your report.

## When the rule has no seam

Sometimes the rule is real but no test can reach it: a total computed inside a handler that also writes the HTTP response, a slug built and saved in the same call, a timestamp rounded inside the logger. Pulling the pure part into its own function gives the rule a seam. That is a design change, so it follows the seams in the plan. If the plan didn't foresee it, name the rule the extraction would expose and let the user choose. If the user is away or this runs as a subagent, keep example tests and put that rule in your report. Never restructure code only to check that it runs.

## Libraries

No property-testing library in the project? The rule still works over a hand-written table of inputs; you lose generation and shrinking, not the rule. Installing a library is the user's decision: ask once, naming the exact rule it would let you check, and keep to example tests until they agree. If the project already has one, use it, and don't add a second.
