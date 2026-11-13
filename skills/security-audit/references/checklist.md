# Audit checklist

Questions to ask at each boundary from the map. A suspicious answer is only a lead: it still needs the six parts of a candidate (step 3 of the skill) and a verifier. Skip a section the project has no surface for, and say so under Coverage.

## Who is calling

- For every route that isn't meant to be public, find the line that checks the session or token. Look for routes registered outside the auth middleware, or before it runs.
- Tokens: is the signature checked, with an algorithm and key the server picks, not the token? Are expiry, issuer and audience checked? Is there a path that decodes a token without verifying it?
- Sessions: a new session id after login or a change of role; old sessions dead after logout, password change or account deactivation.
- Password reset, email change, invitations: the token is random, single-use, short-lived and tied to one account and one action. The link's host comes from configuration, not from the request's `Host` header.
- Session cookies: `HttpOnly`, `Secure`, a `SameSite` that fits the flows. A missing flag alone is hardening, unless a concrete path lets someone read or plant the cookie.
- Login, reset and code entry: is there a limit on attempts? With no account at risk, a missing limit is hardening.

## What they may touch

- Every id that arrives in a request (path, query, body, header): is the record fetched with the caller's ownership or tenant inside the query, or checked right after loading? Picture the same request carrying another user's id.
- The same operation through every door: REST route, server action, GraphQL, export, batch job, admin screen, old API version. Check each one; the least guarded decides what is really allowed.
- Fields the client shouldn't set: `role`, `isAdmin`, `ownerId`, `price`, `tenantId` accepted from the body, or a whole body passed to an update.
- Tenant scoping on every query, cache key, file path and background job, not only on the main list screen.

## Input that reaches a sink

- Database: queries built by string concatenation or template literals, raw-query helpers fed with interpolation. Column names and sort order from input need an allowlist, since placeholders don't cover identifiers.
- Shell: a command built as one string that contains input; argument arrays avoid the shell.
- Files: a path joined with input must be resolved and confirmed to stay inside its base folder. Uploads: size, type, stored name, and whether they are served from the app's own origin.
- Outgoing requests to a URL taken from input: internal addresses, cloud metadata endpoints, redirects that lead inside.
- HTML: raw-HTML escape hatches, user Markdown rendered with HTML enabled, user content placed in a template unescaped.
- Redirects to a URL from input: only relative paths or an allowlist.
- Untrusted data turned into objects: unsafe deserializers, or a deep merge of request JSON that can write `__proto__`, followed by code that reads the polluted property.
- Regular expressions built from input, or ones that backtrack badly on long input.

## The browser

- Values only the browser sees (URL fragment, `postMessage` data, local storage) flowing into `innerHTML`, `document.write`, `eval` or a `javascript:` URL.
- `postMessage` handlers: the origin compared exactly, not with `includes` or a loose regex.
- CORS: the request's origin echoed back, or loosely matched, while credentials are allowed and the response is private.
- Cookie-authenticated routes that change state: an anti-CSRF token or a strict origin check. Read-only routes don't count.
- Server secrets in client bundles through public environment prefixes.

## Secrets

- Credentials in tracked files, in history, in build output and images, in logs, in error pages, and in responses that echo configuration.
- Only the commands from step 2 of the skill. A value is never printed, not even to judge whether it is real.

## Dependencies, CI and release

- A new package: does it exist on the public registry under that exact name? Look it up; never install or run it.
- Lockfile changes no manifest change explains, or packages now fetched from a different host.
- Install scripts in dependencies. Known advisories matter when the project reaches the vulnerable code; an unreached one is a note.
- CI and deploy: who can trigger each job, whose code it runs, which secrets and write permissions it holds. Details in `ecosystems.md`.

## Models and agents

- Model output or tool arguments reaching a query, shell, file path or URL without the handler checking them like any other input.
- A tool acting with a broad service credential without rechecking that the requesting user may touch that resource.
- Text another person controls (a document, page, email, ticket) reaching a prompt that can trigger actions for a different user; an approval that doesn't pin the exact action and arguments that run.
- An instruction in the prompt is not a control. Only checks in code count.

## Money and repeated effects

- Paid calls per request (model, SMS, email, card) with no per-user limit or budget checked before the call.
- Webhooks: signature verified, and a replay of the same event doesn't charge, send or create twice.

## What leaves the system

- Responses that return whole records: password hashes, tokens, other users' contact data.
- Error messages with stack traces or queries; logs carrying tokens or personal data.
