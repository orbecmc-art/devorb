# GLOSSARY.md format

## Structure

```md
# {Context name}

{One or two sentences: what this context is and why it exists.}

## Language

**Order**:
{One or two sentences describing the term.}
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request

**Customer**:
A person or organization that places orders.
_Avoid_: Client, buyer, account
```

## Rules

- **Be opinionated.** When several words name the same concept, pick the best one and list the others under `_Avoid_`.
- **Keep definitions tight.** One or two sentences. Define what the concept is, not what it does or how the code stores it.
- **Only terms specific to this project.** General programming concepts (timeouts, error types, utility patterns) stay out even if the project uses them everywhere. Before adding a term, ask: is this unique to this domain, or general programming? Only the first belongs.
- **Group terms under subheadings** when natural clusters emerge. A single cohesive area can stay a flat list.

## One context or several

**One context (most repos):** one `GLOSSARY.md` at the repo root.

**Several contexts:** a `GLOSSARY-MAP.md` at the repo root lists the contexts, where each lives, and how they relate:

```md
# Glossary Map

## Contexts

- [Ordering](./src/ordering/GLOSSARY.md): receives and tracks customer orders
- [Billing](./src/billing/GLOSSARY.md): generates invoices and processes payments
- [Fulfillment](./src/fulfillment/GLOSSARY.md): manages warehouse picking and shipping

## Relationships

- **Ordering → Fulfillment**: Ordering emits `OrderPlaced` events; Fulfillment consumes them to start picking
- **Fulfillment → Billing**: Fulfillment emits `ShipmentDispatched` events; Billing consumes them to generate invoices
- **Ordering ↔ Billing**: shared types for `CustomerId` and `Money`
```

Which structure applies:

- `GLOSSARY-MAP.md` exists: read it to find the contexts.
- Only a root `GLOSSARY.md` exists: one context.
- Neither exists: create a root `GLOSSARY.md` when the first term is resolved.

With several contexts, work out which one the topic belongs to. If that is unclear, ask.
