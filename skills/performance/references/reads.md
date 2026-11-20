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

## Only the columns a list row needs

- Name the columns. A column nobody reads costs disk reads, memory and bytes on the wire for every row.
- **Wide table** (more than about 12 columns): the list query returns the id and the few columns that tell a person which record this is, such as a name, a code, a place, a date. On 20,000 rows × 84 columns, a page of 50 rows was 82 KB with every column and 5 KB with three columns plus the matched text.
- An existing screen that draws every column does not decide the query: change the screen to the list columns, and open the full row on a click.
- The full row is one read by primary key (`select * from orders where id = $1` is fine here: one row), behind its own route.
- With no one to ask, choose the list columns from the data: the first columns of the table, and the ones whose values read as names, codes and dates. Say which you chose in the report: it is the change a user sees first.

## N+1: one query per row

A loop that runs a query for each row of an earlier query. 50 rows become 51 queries.

- Replace it with a join, or with one batched load: collect the ids, run one `where id in (...)`, and match the results in memory. In an ORM this is the eager-load option (`include`, `preload`, `with`).
- To find it, log the queries of one request: the count must not grow with the number of rows.

## An index for every filter and every sort

- A column in a `where`, a `join` or an `order by` of a list query has an index. A filter plus a sort takes one composite index: filter columns first, then the sort columns, in the query's order.
- Read the plan before and after. Postgres: `explain (analyze, buffers)`, and no `Seq Scan` on the big table. SQLite: `explain query plan`, and `SEARCH ... USING INDEX` where it said `SCAN`, with no `USE TEMP B-TREE FOR ORDER BY`.
- An index costs on every write. Add the ones a query uses, and no others.
- Postgres in production: `create index concurrently`.
