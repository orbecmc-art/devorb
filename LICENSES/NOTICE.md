# Notices

License texts for third-party material adapted in DevOrb are in this folder:
`superpowers-MIT.txt`, `mattpocock-skills-MIT.txt` and
`anthropic-webapp-testing-Apache-2.0.txt`. Sources marked `textReuse: false`
in `fusion/sources.json` contribute ideas only, rewritten in DevOrb's own
words, and are credited in `fusion/ledger/`.

## `skills/finishing/references/pr-body.md`

Adapted from the `pr` skill of Matt Pocock's skills
(https://github.com/mattpocock/skills, `skills/engineering/pr/`, commit
`4ae2317ddb22b046e26455e4f9c9b3aaaf62212d`), MIT, see
`mattpocock-skills-MIT.txt`.

Matt's `CREDITS.md` for that skill records that the Summary section's menu of
visuals (pseudocode, call trees, component trees, file trees, Mermaid, diffs)
and its placement guidance come from Dex Horthy's `show-me` skill
(HumanLayer; `CREDITS.md` links https://github.com/humanlayer/humanlayer and
the skill's frontmatter links
https://github.com/humanlayer/skills/blob/main/plugins/show-me/skills/show-me/SKILL.md).
DevOrb carries a
condensed version of that menu, so the credit carries over here.

## `skills/browser-testing/`

Adapted from the `webapp-testing` skill of Anthropic's skills
(https://github.com/anthropics/skills, `skills/webapp-testing/`, commit
`2c5958ecac7cee2b583967a2c4981d0f4a75c579`), Apache-2.0, see
`anthropic-webapp-testing-Apache-2.0.txt`. Changed by DevOrb: rewritten for
Node and the project's own browser tests, the Python helper `with_server.py`
replaced by a shell loop that waits on the port, `networkidle` limited to apps
without websockets or polling, and console, network, viewport and
production-safety checks added. Ideas from the `browser-qa` skills of the
Spartan toolkit and ECC are rewritten in DevOrb's own words.
