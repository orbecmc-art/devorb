# ADR format

ADRs live in `docs/adr/`, numbered in sequence: `0001-slug.md`, `0002-slug.md`. Create `docs/adr/` only when the first ADR is needed.

## Template

```md
# {Short title of the decision}

{One to three sentences: the context, what was decided, and why.}
```

That is enough. An ADR can be a single paragraph. Its value is recording *that* a decision was made and *why*, not filling in sections.

## Optional sections

Add these only when they carry real value. Most ADRs need none.

- **Status** frontmatter (`proposed | accepted | deprecated | superseded by ADR-NNNN`): useful when decisions get revisited. When a new ADR replaces an old one, mark the old one `superseded by ADR-NNNN`.
- **Considered options:** only when the rejected alternatives are worth remembering.
- **Consequences:** only when non-obvious downstream effects need calling out.

## Numbering

Find the highest number in `docs/adr/` and add one.

## Whether it deserves an ADR

Apply the three-part test in `SKILL.md`: hard to reverse, surprising without context, a real trade-off. Easy to reverse? You will just reverse it. Not surprising? Nobody will wonder why. No real alternative? There is nothing to record beyond "we did the obvious thing".

### What qualifies

- **Architectural shape.** "We use a monorepo." "The write model is event-sourced; the read model is projected into Postgres."
- **How contexts integrate.** "Ordering and Billing talk through domain events, not synchronous HTTP."
- **Technology choices with lock-in.** Database, message bus, auth provider, deployment target. Not every library: only the ones that would take months to swap out.
- **Boundaries and scope.** "Customer data is owned by the Customer context; other contexts reference it by ID only." The explicit no's are as valuable as the yes's.
- **Deliberate departures from the obvious path.** "Hand-written SQL instead of an ORM, because X." Anything where a reasonable reader would assume the opposite. These stop the next engineer from "fixing" something deliberate.
- **Constraints the code doesn't show.** "No AWS, for compliance reasons." "Responses under 200 ms, because of the partner API contract."
- **Rejections that aren't obvious.** If GraphQL was considered and REST picked for subtle reasons, record it, or someone will suggest GraphQL again in six months.
