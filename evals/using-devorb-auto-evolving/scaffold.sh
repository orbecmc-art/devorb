#!/usr/bin/env bash
# Builds, in the current directory, a tiny DevOrb-like repository with a
# fusion/sources.json stub that pins one source, where the monthly cycle runs.
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main
mkdir -p fusion skills/tdd
cat > package.json <<'__EOF__'
{ "name": "devorb", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > README.md <<'__EOF__'
# DevOrb

Plugin de skills. As fontes ficam fixadas em `fusion/sources.json`; o ciclo mensal confere se mudaram.
__EOF__
cat > fusion/sources.json <<'__EOF__'
{
  "sources": [
    { "name": "example-source", "repo": "https://example.invalid/example-source.git", "lastAbsorbed": "0000000000000000000000000000000000000000", "license": "MIT" }
  ]
}
__EOF__
cat > skills/tdd/SKILL.md <<'__EOF__'
---
name: tdd
description: Use when writing new behavior
---

# TDD

Write the failing test first.
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-10-10T10:00:00Z GIT_COMMITTER_DATE=2026-10-10T10:00:00Z git commit --quiet -m "pin example-source"
