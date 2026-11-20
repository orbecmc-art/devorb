# Search: where it lives and how it is indexed

Read this when rows are matched against typed text. Pick the section for where the data lives.

## Every engine

- **Index the searchable columns only:** the ones people type to find a row. When the search you are fixing already covers every column, keep every column: narrowing it changes behavior, so record it as a decision.
- **The database normalizes:** its tokenizer or a generated column strips accents and case, for the rows and for the term. Text normalized in application code and copied into an index goes stale on any write that skips that code.
- **The match kind picks the index.** Whole words and prefixes ("dama" finds "Damasceno"): full-text. Any substring ("masc" finds "Damasceno"): trigram. Read what the current search and its tests promise before choosing.
- **A trigram index needs 3 characters.** A shorter term matches nothing or falls back to a scan: ask for 3 characters on the screen, and report that as a change.
- **The term is data.** Bind it as a parameter and quote it in the engine's query syntax (below); a hyphen or a quote in a raw term is a syntax error or an operator.
- **One query per page:** a limit, a stable order that ends in the id (after a rank, where the section below orders by one), named columns. Count the matches only when the screen shows the total.
- **Matched text:** to show why a row came, take it from the index in the page's own query, when the index can give it. Shown below for SQLite only (FTS5 `snippet()`).
- **The index follows the table:** a generated column, or triggers. A search that misses a row written a second ago is a bug.

## Postgres: a generated `search_text` column

```sql
create extension if not exists unaccent;
create extension if not exists pg_trgm;

-- unaccent() is not immutable, and a generated column needs an immutable expression
-- public is the schema the extension is in: name yours, in both places
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

- Escape `\`, `%` and `_` in the term before the `like`, each with a `\` in front and the backslash first. An unescaped `\` at the end of a term escapes the closing `%`.
- Whole words and prefixes instead of substrings: a generated column `search_tsv`, `to_tsvector('simple', f_unaccent(...))` over the same text, a GIN index on it, and the term built into query syntax inside the query (`dama silv` becomes `dama:* & silv:*`). Unaccent before the split: unaccented after it, `x½y:*` becomes `x 1/2y:*`, a syntax error. `websearch_to_tsquery` takes raw text but has no prefix match.

```sql
select id, name, city, code, ts_rank(search_tsv, q) as rank
from customers, to_tsquery('simple', (
  select string_agg(w || ':*', ' & ')
  from regexp_split_to_table(lower(f_unaccent($1)), '[^[:alnum:]]+') w
  where length(w) >= 3)) q
where search_tsv @@ q
order by rank desc, id desc
limit 50;
```

- Words under 3 characters drop out, as for trigram: ask for 3 characters on the screen. A one-letter prefix ranks every row it matches, a cost that grows with the table. A term with no word left matches nothing, without an error.
- The rank sort has no index, and needs none: it sorts only the rows the GIN index matched, bounded by the minimum length, then stops at the limit. Ordered by id alone, the planner walks the primary key and filters: on 100,000 rows, a term with 2 matches read every row.
- Next page: add `and (ts_rank(search_tsv, q), id) < ($2, $3)`, with the last row's `rank` and `id` sent back unchanged. The rank of a row is the same for the same term and data, so `(rank, id)` is the cursor, not an offset or `id > $last`.
- On a table in production, build with `create index concurrently`, outside a transaction block: it fails inside one, so turn off the migration tool's transaction for that migration. `add column ... stored` rewrites the whole table under an `ACCESS EXCLUSIVE` lock, and reads and writes wait until it ends: there, skip the column and index the expression itself, `using gin ((lower(f_unaccent(...))) gin_trgm_ops)` or `using gin (to_tsvector('simple', f_unaccent(...)))`, with that expression in place of the column in the query.
- Confirm with `explain (analyze, buffers)` on a rare term: a `Bitmap Index Scan` on the new index, no `Seq Scan`. The substring query may walk the primary key for a common term and stop at the limit.

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
- One FTS column per searchable column, as above, not one column of concatenated text: the index then knows which column matched. The matched text is one more item in the select list: `snippet(customers_fts, -1, '', '', '…', 16) as matched`, where `-1` picks the column that matched.
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
