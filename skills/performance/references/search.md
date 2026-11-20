# Search: where it lives and how it is indexed

Read this when rows are matched against typed text. Pick the section for where the data lives.

## Every engine

- **Index the searchable columns only:** the ones people type to find a row. When the search you are fixing already covers every column, keep every column: narrowing it changes behavior, so record it as a decision.
- **Normalize once, at write time:** unaccented and lower-case in the index, and the same treatment for the term.
- **The match kind picks the index.** Whole words and prefixes ("dama" finds "Damasceno"): full-text. Any substring ("masc" finds "Damasceno"): trigram. Read what the current search and its tests promise before choosing.
- **A trigram index needs 3 characters.** A shorter term matches nothing or falls back to a scan: ask for 3 characters on the screen, and report that as a change.
- **The term is data.** Bind it as a parameter and quote it in the engine's query syntax (below); a hyphen or a quote in a raw term is a syntax error or an operator.
- **One page per query:** a limit, a stable order (rank, then id), named columns. Count the matches only when the screen shows the total.
- **Wide table:** the page carries the list columns of `reads.md` plus the text that matched, so a row whose listed columns do not hold the term still shows why it came.
- **The index follows the table:** a generated column, or triggers. A search that misses a row written a second ago is a bug.

## Postgres: a generated `search_text` column

```sql
create extension if not exists unaccent;
create extension if not exists pg_trgm;

-- unaccent() is not immutable, and a generated column needs an immutable expression
create function f_unaccent(text) returns text
  language sql immutable parallel safe strict
  as $$ select public.unaccent('public.unaccent', $1) $$;

alter table customers add column search_text text generated always as (
  lower(f_unaccent(coalesce(name, '') || ' ' || coalesce(city, '') || ' ' || coalesce(code, '')))
) stored;

create index customers_search_trgm on customers using gin (search_text gin_trgm_ops);

select id, name, city, code
from customers
where search_text like '%' || lower(f_unaccent($1)) || '%'
order by id
limit 50;
```

- Escape `%` and `_` in the term before the `like`.
- Whole words instead of substrings: a generated `tsvector` column (`to_tsvector('simple', ...)` over the same unaccented text), a GIN index on it, and `websearch_to_tsquery('simple', ...)` for the term.
- On a table in production, build with `create index concurrently`.
- Confirm with `explain (analyze, buffers)`: a `Bitmap Index Scan` on the new index, no `Seq Scan`.

## SQLite: FTS5

```sql
create virtual table customers_fts using fts5(
  name, city, code,
  content='customers', content_rowid='id',
  tokenize='trigram remove_diacritics 1'
);
insert into customers_fts(customers_fts) values('rebuild');

select c.id, c.name, c.city, c.code
from customers_fts f join customers c on c.id = f.rowid
where customers_fts match ?
order by f.rowid
limit 50;
```

- Bind the term quoted as one FTS5 string: `'"' + term.replaceAll('"', '""') + '"'`. Unquoted, `abc-def` fails with `no such column: def`.
- `trigram` matches substrings and ignores case; `remove_diacritics` on it needs SQLite 3.45 (`select sqlite_version()`). Whole words and prefixes: `tokenize='unicode61 remove_diacritics 2'` and the term as `"dama"*`.
- On a wide table, add the matched text to the select list: `snippet(customers_fts, -1, '', '', '…', 16) as matched`. The `-1` picks the column that matched.
- `content='customers'` stores the text once, in the source table. Keep it in step with three triggers (after insert, after delete, after update) that write to the FTS table; the delete form is `insert into customers_fts(customers_fts, rowid, name, city, code) values('delete', old.id, old.name, old.city, old.code)`.
- Create and fill the index once (a migration, or at startup when the table is missing), never per request. On 20,000 rows × 84 columns the rebuild took under 1 s and a search under 1 ms.

## Other databases

Same idea with the equivalent index: MySQL `fulltext` (the `ngram` parser for substrings), SQL Server full-text, and so on.

## Browser

Only when there is no server database to ask, or the list is small and already whole on screen.

- Build the index once, when the data loads: one normalized string per row. Never normalize per keystroke.
- Above about 50,000 rows, run the scan in a Web Worker, so typing stays responsive.
- Draw one page of the matches, not all of them.

## The search box, on any engine

- Debounce 150 to 200 ms, so a typed word is one request.
- Cancel the previous request (`AbortController`), so a late answer never replaces a newer one.
