#!/usr/bin/env bash
# Builds, in the current directory, a brand-new project: a git repo whose only
# file is a one-line README. No code, no stack chosen yet. Self-contained, no
# network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null
export GIT_AUTHOR_DATE=2026-01-01T09:00:00Z GIT_COMMITTER_DATE=2026-01-01T09:00:00Z

git init --quiet -b main
printf '# agenda\n\nProjeto novo, ainda sem código.\n' > README.md
git add -A
git commit --quiet -m "chore: start project"
