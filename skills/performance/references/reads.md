# Reads: pages, columns, loops and indexes

Read this when a query lists, filters, sorts or loads related rows.

## A limit on every list query

- Every query that can return many rows has a limit. `select *` with no limit is never the answer: the table grows and the query grows with it.
- The server caps the limit. A page size sent by the client is clamped to a maximum (100 is a common one).

## Cursor pagination

Page by the sort key, not by offset: an offset reads and throws away every skipped row, so page 400 costs 400 pages.

```sql
-- first page
select id, name, created_at from orders
order by created_at desc, id desc
limit 51;

-- next page: the cursor is the last row's (created_at, id)
select id, name, created_at from orders
where (created_at, id) < ($1, $2)
order by created_at desc, id desc
limit 51;
```

- Ask for one row more than the page: the extra row says a next page exists, and it is not sent.
- The sort key ends in a unique column (the id), so no row is skipped or repeated when two rows share a value.
- The client gets the cursor as an opaque string and sends it back unchanged.
- A cursor page has no total. Show "load more"; count only when the screen needs the number.

## Only the displayed columns

- Name the columns the screen shows. A column nobody sees costs disk reads, memory and bytes on the wire for every row.
- A wide table (dozens of columns): the list carries the columns that identify a row, and the full row loads by id when the user opens it.

## N+1: one query per row

A loop that runs a query for each row of an earlier query. 50 rows become 51 queries.

- Replace it with a join, or with one batched load: collect the ids, run one `where id in (...)`, and match the results in memory. In an ORM this is the eager-load option (`include`, `preload`, `with`).
- To find it, log the queries of one request: the count must not grow with the number of rows.

## An index for every filter and every sort

- A column in a `where`, a `join` or an `order by` of a list query has an index. A filter plus a sort takes one composite index: filter columns first, then the sort columns, in the query's order.
- Read the plan before and after. Postgres: `explain (analyze, buffers)`, and no `Seq Scan` on the big table. SQLite: `explain query plan`, and `SEARCH ... USING INDEX` where it said `SCAN`, with no `USE TEMP B-TREE FOR ORDER BY`.
- An index costs on every write. Add the ones a query uses, and no others.
- Postgres in production: `create index concurrently`.
