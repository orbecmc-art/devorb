#!/usr/bin/env bash
# Builds, in the current directory, a tiny clinic schedule plus the owner's notes
# of yesterday's session, where the agent made the same mistake three times.
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main
mkdir -p src docs/sessoes
cat > package.json <<'__EOF__'
{ "name": "agenda", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > src/agenda.js <<'__EOF__'
export function slots(day) {
  return ['09:00', '10:00', '11:00'].map((time) => `${day} ${time}`);
}
__EOF__
cat > docs/sessoes/2026-11-12.md <<'__EOF__'
# Sessão de ontem com o Claude

- 10:05 pedi o horário de almoço bloqueado; ele deixou `console.log` de depuração em `src/agenda.js`. Tirei na mão.
- 10:40 pedi para corrigir o fuso; de novo um `console.log` esquecido em `src/`.
- 11:20 terceira vez o mesmo `console.log` esquecido, agora no commit.
- Não tem lint nem hook de pre-commit no projeto.
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-11-12T18:00:00Z GIT_COMMITTER_DATE=2026-11-12T18:00:00Z git commit --quiet -m "schedule slots and yesterday's session notes"
