---
name: browser-testing
description: Use when a change touches a web page or UI, or someone asks to check a screen, form or flow, before saying it works; drives the running app in a real headless browser
---

# Browser testing

Unit tests and reading the markup do not show what a user sees. A screen works only when a real browser loaded it, a user action ran, and the console and network stayed clean.

```
NO "THE SCREEN WORKS" WITHOUT A BROWSER RUN THAT CLICKED IT.
```

## 1. Pick the tool

1. **The project already has browser tests** (Playwright, Cypress, Selenium, a `test:e2e` script): use them. Add a case for this screen there when one is missing.
2. **None, but Playwright is installed:** write a headless Playwright script in the project's language (`.mjs` for Node, Python for Python), outside the source tree or in a scratch folder.
3. **No browser tool at all:** adding Playwright and downloading a browser is the user's call. Ask. If they are away, say the screen is unverified and why; never call it checked on unit tests alone.

## 2. Run the app

- Already running? Use it. Otherwise start the project's own command (`npm start`, `npm run dev`) in the background, on a free port when the default may be taken, with its output sent to a log file.
- Wait for the port to answer (a loop on `curl -s -o /dev/null` with a deadline), not a fixed sleep.
- Stop every server you started when done, by its PID, and say so.

Production URL? Read-only: navigate and look, never submit. A flow that changes data (sign-up, payment, delete) runs only on local, staging or preview, with the user's explicit permission and test credentials.

## 3. Look before you act

Load the page, wait for a specific element the screen needs (`getByRole('button', { name: 'Salvar' })`), then list what is there: buttons, links, inputs, a screenshot. Pick selectors from that rendered state, preferring role and visible text over CSS. Use `networkidle` only on apps without websockets or polling, where it never settles.

## 4. Drive it like a user

Before navigating, record:

- every `console` message of type `error`, and `pageerror`;
- every response with status 400 or more, and every `requestfailed`.

Then, for the screen in question:

- **Forms:** submit empty, then invalid, then valid data. A valid submit must show success and reach the server: check the response status, not only the page.
- **Buttons:** each one does something visible; a click with no visible change and an error in the console or network is a bug.
- **Links:** each one lands on a page that loads.
- **Viewports:** 1280 px wide, then 375 px with touch on (`hasTouch: true`, `isMobile: true`): no horizontal scroll, nothing clipped, controls reachable.

Before clicking, check the element is visible: a click on a hidden element can pass without doing anything. Screenshot the page when a check fails, and keep the file path.

Console errors and failed requests are bugs. Warnings and deprecation notices are not. Visual comparison with no committed baseline image is inconclusive, never a pass.

`references/playwright.md` has a script that does all of this.

## 5. Report

One line per check: what you did, what happened, pass or fail. For each failure: steps, expected, actual, the console or network line, the screenshot path. Then a verdict: works, or does not work and why. Never "ready" with an open failure.

A failure goes to `devorb:debugging` when fixing is part of the task. Otherwise report it and stop: the user decides.

## Stop signs

| Thought | Reality |
|---|---|
| "The unit tests pass, so the screen works" | They never loaded the page or sent the request. |
| "I read the code and the handler looks right" | Routes, build steps and runtime config break only at run time. |
| "The page loaded without errors" | Loading is not working: the user action is the test. |
| "Nothing showed on screen, so nothing failed" | Silent failures live in the console and the network. Read them. |
| "I'll just submit the form on the live site" | Production is read-only. Staging, permission, test credentials. |

## Connects to

- **Receives:** a changed screen from `devorb:implementing`, or a request to check a UI.
- **Uses:** the project's browser tests, or Playwright; `references/playwright.md`.
- **Hands off to:** `devorb:verifying`, which takes this run as the UI evidence; `devorb:debugging` for a failure the task must fix.
