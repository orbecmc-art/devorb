# Property-Based Tests

**Read this when:** the code under test follows a general rule that should hold for every valid input, not just for the cases you can list by hand.

An example test pins one input you picked. A property test states a rule, lets a generator throw many inputs at it, and when one breaks the rule, cuts that input down to the smallest version that still fails. It pays off only when the code really follows such a rule. Most code doesn't, and then example tests are the right tool; reporting that is a good result, not a failure.

## Does the code have the shape?

Ask these questions about the code. Each "yes" gives you a rule to assert.

- **Is there an operation that undoes it?** Then going there and back returns the input: `parse(format(x))` equals `x`. Serialisers, codecs, unit conversions, encryption.
- **Is there a version you already trust?** A naive, older or slower implementation must give the same answer as the code under test for every input. Optimisations, rewrites, caches, ports.
- **Is checking an answer much cheaper than producing it?** Then check the answer instead of the steps: the factors multiply back to the number, the route starts and ends where asked, the schedule breaks no constraint.
- **Does running it twice change anything?** For anything that cleans up, the second pass must leave the result alone: `clean(clean(x))` equals `clean(x)`. Formatters, normalisers, deduplication, migrations.
- **Is there something it must keep?** A count, a total, the set of items, a balance: equal before and after. Transfers between accounts, reshaping data, filters that only reorder.
- **Does a known change to the input move the output in a known direction?** A larger cart never lowers the discount rate; adding a matching record never shrinks the result. Pricing, scoring, ranking, limits.
- **Should order, grouping or a neutral value not matter?** Swapping the arguments, regrouping them, or combining with the empty value leaves the result the same. Merges, sums, set operations, replicated state.
- **Is it an object you call in sequences?** After any sequence of calls, it agrees with a tiny in-memory model of what it should hold. Caches, queues, repositories, carts.

## Choose the strongest rule the code supports

A rule is only as strong as the wrong implementations it rejects. Try each candidate against an obviously broken version, such as one that returns its input untouched or an empty value. If the rule still holds, it is weak.

From weakest to strongest:

1. **It runs.** No crash and no exception outside the documented ones. Nearly every broken version also runs.
2. **The output has the right form.** Type, length or range are right. A wrong value of the right form still passes.
3. **Something is kept.** A count, total or membership survives. The wrong order, or a wrong value with the right total, still passes.
4. **It settles.** A second pass changes nothing. A version that settles on the wrong value still passes.
5. **The output is pinned.** A round trip, agreement with a trusted version, or a check that fully decides the answer (ordered and holding the same items, for a sort). Very little survives.

Aim for the top. Level 1 alone is seldom worth a property test, and never worth a new dependency. Look once more for a stronger rule; if there is none, write example tests and say so.

## When a passing property means nothing

**Tautology: the test restates the code.** `expect(applyTax(p)).toBe(p * 1.2)` when `applyTax` multiplies by 1.2, or an expected value built by the same helper the code uses. A bug that both sides share can never fail it. Use a rule that limits the output without computing it the same way: a law, a round trip, a reference written differently. Calling the function twice on one input and comparing is the exception: for code that may not be deterministic, such as output built from an unordered map or code that reads the time, that comparison is a real check.

**Vacuity: the test never reaches the interesting inputs.** If the test discards every generated input that doesn't meet a precondition, and most don't, the run is green on the few that are left. Two preconditions that can't both hold leave nothing at all to check, and the run still reports success. Have the generator build only valid inputs instead of filtering afterwards, and read the library's statistics for how many cases ran and how many were thrown away. A rule guarded by an `if` that generated data rarely enters has the same flaw.

## In the TDD cycle

A property is a test like any other: write it, run it, watch it fail, then write the code. The generator usually finds a failing input before the behavior exists; read it and confirm it fails because the behavior is missing.

Keep the inputs you already know are risky (empty, zero, the limits of the type) as fixed examples beside the property, so every run covers them and not only the lucky ones.

Before changing code to satisfy a failing input, check that the code promises to handle it: the types, the docs, the spec, the existing tests. Outside that promise, narrow the generator. Where the promise says nothing about that input, ask the user: it is a decision, not a bug.

## When the shape is buried

The rule can be real yet out of reach of any test: a price calculated inside a function that also writes to the database, a message built and sent in the same call, a list sorted in place. Pulling the pure part out gives the rule a seam. That is a design change, so it follows the seams in the plan. If the plan didn't foresee it, tell the user which rule it would make testable and let them choose. Don't restructure code only to reach level 1.

## The library is the user's call

Already a property-testing library in the project? Write the property with it, and don't bring in a second one. If none is installed, don't install one. Ask the user once, and make the question concrete: show the exact rule it would let you check. Until they agree, keep to example tests. Without a library, the same rule can still run over a hand-written table of inputs: you lose the search and the shrinking, not the rule.
