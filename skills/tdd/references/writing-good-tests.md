# Writing Good Tests

**Read this when:** writing or changing tests, adding mocks, or adding cleanup or helper methods for tests.

A test exists to catch a specific break. Two principles govern everything here:

```
1. Every test names the break it catches
2. Every test exercises the real thing, through its public interface
```

Strict TDD produces both naturally: a test written first and watched failing against real code has already proven it can fail, and it earns a mock only when the real dependency proves slow or external.

## Principle 1: Name the break

Before writing the test body, answer: **what production change should make this test fail, and is that change a bug or a decision?** A test earns its place by catching a wrong branch, a missing side effect, a wrong argument, a boundary case or a broken contract. One behavior per test, with one logical assertion; "and" in the name means split it.

**Derive expectations independently.** Use literals and hand-checked fixtures; table-driven tests with literal expected values are the preferred shape. An expectation computed by the code under test, by its helpers, or by the same formula passes no matter what that code does. That is a tautological test.

```typescript
// BAD: the same builder computes both sides, so it is always true
const expected = buildSearchQuery({ tag: 'urgent' });
expect(buildSearchQuery({ tag: 'urgent' })).toBe(expected);

// BAD: the expected value recomputes the sum the way the code does
const items = [{ price: 10 }, { price: 5 }];
expect(calculateTotal(items)).toBe(items.reduce((sum, i) => sum + i.price, 0));

// GOOD: hand-derived literals
expect(buildSearchQuery({ tag: 'urgent' })).toBe('tag:"urgent"');
expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
```

**No change detectors.** If only intentional decisions can fail a test (a constant's value, exact message wording, private structure), it fires on redesign and sleeps through bugs. Test the behavior that depends on the decision: not `expect(MAX_RETRIES).toBe(5)` but "a failing call is retried 5 times and the 6th attempt never happens."

**Behavior, not text.** Asserting that a script, skill or config contains an exact line proves only that the source is the source. Run scripts against controlled inputs and assert outputs, side effects or exit codes. Documents that instruct agents are tested by the consuming agent's behavior (`devorb:writing-skills`); prose for humans earns no test at all.

**Your code, not the framework.** Test the contract your code makes at its boundaries: the route you register, the query you emit, the payload you produce. Upstream mechanics are their maintainers' tests to write (the classic: asserting your router invokes a registered handler). When upstream behavior genuinely surprised you, write one narrow characterization test naming the assumption. The same boundary applies inside your code: constructors, getters, constants and trivial forwarding earn tests only when they validate, normalize, default, derive, enforce or cause side effects. Otherwise assert the first consumer-visible result that depends on them.

### Gate function

```
BEFORE writing the test body:
  Name the production change that would make this test fail.

  Cannot name one            → redesign around an observable behavior
  "The source text changed"  → run the artifact and assert its effects
  Only intentional decisions → change detector; test the behavior
                               that depends on the decision

  Confirm the expected value is derived without the code under test.
  IF it reuses the code's logic or helpers:
    Replace it with a literal or hand-checked fixture
```

## Through the public interface

Tests verify behavior through public interfaces, not implementation details. The code can change entirely; the tests shouldn't. A good test reads like a specification: "user can checkout with valid cart" says exactly what capability exists, and it survives refactors because it doesn't care about internal structure.

```typescript
// GOOD: observable behavior through the interface
test('user can checkout with valid cart', async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe('confirmed');
});

// BAD: bypasses the interface to verify
test('createUser saves to database', async () => {
  await createUser({ name: 'Alice' });
  const row = await db.query('SELECT * FROM users WHERE name = ?', ['Alice']);
  expect(row).toBeDefined();
});

// GOOD: verifies through the interface
test('createUser makes user retrievable', async () => {
  const user = await createUser({ name: 'Alice' });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe('Alice');
});
```

## Principle 2: Exercise the real thing

### Mock at system boundaries only

Mock:

- external APIs (payment, email and the like);
- databases, sometimes: prefer a test database;
- time and randomness;
- the file system, sometimes.

Don't mock your own classes or modules, internal collaborators, or anything else you control.

**The mock earns no assertions.** A mock assertion passes when the mock is present and fails when it is absent: it says nothing about the component. Assert the real component's behavior; if the mock is what you are checking, unmock it or delete the assertion. The question that catches it: "Are we testing the behavior of a mock?"

```typescript
// GOOD: real behavior
expect(screen.getByRole('navigation')).toBeInTheDocument();

// BAD: mock existence
expect(screen.getByTestId('sidebar-mock')).toBeInTheDocument();
```

**Mock at the right level.** Learn every side effect of the real method before replacing it; mock the slow or external operation and keep what the test depends on real. When unsure, run the test against the real implementation first and observe what actually needs to happen.

```typescript
// BAD: the mock swallows the config write that duplicate detection reads
vi.mock('ToolCatalog', () => ({
  discoverAndCacheTools: vi.fn().mockResolvedValue(undefined)
}));

// GOOD: mock only the slow server startup; the config write stays real
vi.mock('MCPServerManager');
```

**Make boundary doubles specific.** When the outgoing call is itself the contract (the charge sent to the payment API, the email handed to the mail service), assert its arguments, count and order: a fake that accepts anything verifies nothing. Give each branch (success, error, malformed) its own fixture or spy, so the wrong branch cannot satisfy the expectation. Inside code you own, assert the outcome instead of the calls.

**Mirror real data completely.** Mock the complete structure as it exists in reality, with all documented fields, not just the ones your test reads. Partial mocks fail silently when downstream code reads an omitted field: the test passes while integration breaks.

**Production classes carry production methods only.** Cleanup that only tests need lives in test utilities, never as a `destroy()` on the production class. Ask: is this method called only from tests? Does this class own this resource's lifecycle? Wrong answers mean it belongs in a test utility.

**Prefer real components over complex mocks.** When mock setup outgrows the test logic, mocks miss methods the real components have, or tests break when the mock changes, switch to an integration test with real components. Ask: "Do we need to be using a mock here?"

### Design boundaries for substitution

At a system boundary, shape the interface so a test can replace it.

**Inject the dependency** instead of creating it inside:

```typescript
// Easy to substitute
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// Hard to substitute
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**Prefer SDK-style interfaces over a generic fetcher.** One function per external operation means each double returns one shape, test setup has no conditional logic, the endpoints a test exercises are visible, and each one is typed.

```typescript
// GOOD: each function is independently replaceable
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// BAD: the double needs conditional logic inside it
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

### Gate function

```
BEFORE adding a mock or test helper:
  Is it a system boundary? If not, use the real thing.

  List the real method's side effects; keep the ones the test
  depends on real, and mock the slow/external level below them.

  Mock responses mirror the complete real structure.

  A method only tests call lives in test utilities, not production.

  About to assert on the mock itself?
    Unmock it or delete the assertion.
```

## The mutation check

Before finishing, mentally mutate the production code. At least one test should fail for each realistic mutation:

- wrong constant or argument;
- wrong branch handler;
- missing state change or side effect;
- empty or default return;
- missing validation for zero, empty, nil, unauthorized or malformed input.

A mutation nothing catches marks the behavior as unprotected, or the test as tautological.

## Warning signs

- Setup and assertion share the same object, guaranteeing equality
- Expected values are hidden behind loops, builders or helpers
- The test can fail only through a panic, crash or missing selector
- The test fails on every intentional change, never on accidental breakage
- The name describes how, not what
- The test greps source text, or asserts a removed symbol stays removed
- The test would still matter if only the framework remained
- The test exists for coverage, checking no side effect or outcome
- Mocking "just to be safe"
