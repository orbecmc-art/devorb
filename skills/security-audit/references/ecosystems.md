# Ecosystem patterns

Where the checklist's questions usually land in JS/TS, shell, CI and Docker. A match is a place to read, not a finding. For secret-like patterns, search in `files_with_matches` or `count` mode only (step 2 of the skill).

## JavaScript and TypeScript

- **Queries:** template literals or `+` inside `query(`, `execute(`, `.raw(`, `sql.raw(`, `$queryRawUnsafe(`, `$executeRawUnsafe(`. The tagged-template form of `sql` (Drizzle, `postgres`) and Prisma's `$queryRaw` are parameterized; `sql.raw` and the `Unsafe` helpers are not.
- **Ownership:** `findUnique({ where: { id } })`, `findById(req.params.id)` or `.where(eq(table.id, id))` with no user or tenant condition, in a route that serves one user's data.
- **Auth wiring:** Express routers mounted before `app.use(auth)`; Next.js route handlers, server actions and `middleware.ts` matchers that skip a path; Supabase tables without row level security, or a `service_role` key used in code that runs for users.
- **Tokens:** `jwt.decode` where `jwt.verify` belongs; `verify` without an `algorithms` list; a hard-coded or empty secret.
- **Shell:** `child_process.exec` or `execSync` with a template string; `spawn` with `shell: true`. `execFile` or `spawn` with an argument array is the safe form.
- **Files:** `path.join(base, req.params.x)` or `res.sendFile` with input, without `path.resolve` and a prefix check against the base.
- **HTML:** `dangerouslySetInnerHTML`, `innerHTML`, `v-html`, `marked` output without a sanitizer, `eval`, `new Function`, string `setTimeout`.
- **Objects:** `lodash.merge`, `deepmerge` or hand-written recursive merges fed with request JSON; `Object.assign(record, req.body)` and spreads of `req.body` into an update.
- **CORS and cookies:** `cors({ origin: true, credentials: true })`, an origin callback that always allows, cookies set without `httpOnly` or `secure`.
- **Client exposure:** secrets read through `NEXT_PUBLIC_`, `VITE_` or `EXPO_PUBLIC_` variables, or imported into a file that runs in the browser.
- **Packages:** `postinstall` scripts, `git+` or tarball URLs in `package.json`, lockfile entries whose `resolved` host differs from the registry. Look a name up with `npm view <name> --registry https://registry.npmjs.org`. `npm audit` reports advisories; reachability is still yours to check.

## Shell scripts

- Unquoted `$var` or `$(...)` in arguments, paths and `rm`; `rm -rf "$DIR/"` when `DIR` may be empty.
- `eval`, `sh -c` or `bash -c` with input; `curl ... | sh` and other downloads run without a pinned checksum.
- `set -x` or `echo` in a script that handles secrets; secrets passed as command-line arguments, visible in the process list.
- `source .env` or `export $(cat .env)`, which run whatever the file holds.
- Fixed names in `/tmp` instead of `mktemp`; files with secrets written without `umask 077` or `chmod 600`.

## CI (GitHub Actions)

- `pull_request_target` or `workflow_run` that checks out and runs the pull request's code with secrets or a write token.
- `${{ github.event.* }}` fields (titles, branch names, comments, commit messages) placed directly in `run:`; pass them through `env:` instead.
- No top-level `permissions:`, or `write-all`, on a job that doesn't need it.
- Third-party actions pinned to a tag or branch rather than a full commit SHA.
- Secrets printed or written to artifacts; artifacts or caches made by a fork's job and later used by a privileged job.
- Self-hosted runners on a public repository.

## Docker and Compose

- `COPY . .` without a `.dockerignore` that excludes `.env`, `.git` and keys; secrets in `ARG` or `ENV`, which stay in the image history.
- No `USER`, so the app runs as root; `privileged: true`; `/var/run/docker.sock` mounted into a container.
- Database, cache or admin ports published on all interfaces (`"5432:5432"`) instead of `127.0.0.1:` or an internal network.
- Default or example passwords in `docker-compose.yml`; `latest` or other moving tags for images that are deployed.
