# Replicate

The user asked to copy, clone, "deixar igual" or use a page as a base. Copying the form is the job; the content stays the client's. The reference becomes a pack in the user's project, and every later step reads the pack, not your memory of the page.

## Paths and Playwright

- `SKILL_DIR` is this skill's folder (the one holding its `SKILL.md`, under the plugin's base directory). `UI_DIR` is the sibling `ui-review` folder. Run every script by its absolute path, from the user's project: `node "$SKILL_DIR/scripts/capture.mjs" …`.
- The scripts need Playwright with Chromium. If the project has none, ask before installing it there. Without a yes, or with nobody to ask, install it in a scratch folder (`npm i --prefix <tmp>/pw playwright`, then `npx --prefix <tmp>/pw playwright install chromium`) and pass `--pw <tmp>/pw` to each script.

## 1. Capture the pack

`node "$SKILL_DIR/scripts/capture.mjs" <url> <project root> --slug <slug> [--pw <dir>]`. A local file is `file://` plus its absolute path. It writes `design/referencias/<slug>/`: `url.txt`, `notas.md`, `tokens.json`, `secoes.md`, and `1440/` and `390/` with `full.png`, `section-<i>.png`, `metrics.json` and `checks.json`.

- Exit 3: Playwright is missing; install it as above and run again. Exit 4: the project already has 3 packs; ask which one to reuse or remove, and never delete one yourself.
- Behind a login: the script cannot sign in, and you never type a password. Ask the user to log in in their own browser, then use a browser tool (Claude in Chrome or the built-in browser): paste `collect-in-page.js` from `UI_DIR/scripts/` through the JavaScript tool, run `window.__devorbMetrics()`, save the result as `1440/metrics.json`, and take the screenshots with the browser tool.
- No browser at all (no Playwright that launches and no browser tool): `capture.mjs … --dry-run` still makes the pack folder. Read the reference's HTML and CSS instead: section order, what each section holds, heading and body font sizes, grid and spacing. Write `secoes.md` and `notas.md` from that by hand. Say plainly in your final message that capture and the mirror did not run; never claim a screenshot or a measured value.
- Tokens, optional, public pages only: inside the pack folder, `npx -y dembrandt@0.39.2 <url> --design-md` writes a `DESIGN.md` under `output/`; keep it as `DESIGN.ref.md`. It is reference data, never the client's tokens.

## 2. Write the pack notes

- `secoes.md`: one line per section in order, with its pattern (hero with product mockup, dark band with one number, timeline, comparison table, card grid, closing call), its grid, and the movement you saw, in place of the `Movimento observado` line. A section marked `hidden` in `metrics.json` was a scroll reveal: read its content from the source and record the reveal as movement.
- `notas.md`: under `## Levar` and `## Não levar`, what the user said to keep and to drop, in their words; otherwise the defaults of step 3.
- Ask before committing the pack. When its content belongs to someone else, suggest adding `design/referencias/` to `.gitignore`. With nobody to ask, leave the pack uncommitted and say so.

## 3. Decide what stays and what changes

Default, written in the contract as `Same as reference:` and `Changed:`:

- **Same:** structure, section order, type scale, grid, spacing, composition and motion.
- **Changed:** colour, font and logo follow the project's `DESIGN.md` or theme, unless the user asks otherwise.
- **Always replaced:** a third party's text, photos and logo. They stay only when the content is the user's own.

When a person is in the conversation, show this default and ask once. Otherwise go with it. The new text comes from §3 of `SKILL.md` and `references/copy.md`: a slot the client has no fact for (a big number, a quote, a name) gets a fact the project gives, or becomes a visible gap. Never reuse the reference's sentences, numbers or people.

## 4. Build section by section

Follow `secoes.md` in order, one element per reference section as a direct child of `main`, so the counts compare. After each section, shoot the build and look at it next to the same section of the reference:

`node "$UI_DIR/scripts/shoot.mjs" file://<abs path>/index.html <tmp>/build --widths 1440,390 [--pw <dir>]`

Read `<tmp>/build/1440/section-<i>.png` and the pack's `1440/section-<i>.png`, and fix proportion, scale and spacing before the next section.

## 5. Compare, then hand to the critic

```bash
node --input-type=module -e "import { compareStructure } from '$UI_DIR/scripts/rules.mjs'; import { readFileSync } from 'node:fs'; const m = (p) => JSON.parse(readFileSync(p, 'utf8')); console.log(JSON.stringify(compareStructure(m('<tmp>/build/1440/metrics.json'), m('design/referencias/<slug>/1440/metrics.json')), null, 2))"
```

`grossFail` (a different section count, or a heading ratio below 80% of the reference's) is fixed before anything else. Then hand the build, the pack and the `deviations` list to `devorb:ui-review`.
