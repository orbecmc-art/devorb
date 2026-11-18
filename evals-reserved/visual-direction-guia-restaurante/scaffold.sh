#!/usr/bin/env bash
# Builds, in the current directory, a nearly empty project: a git repo whose only
# file is a README about a small restaurant. No DESIGN.md, no code. Self-contained,
# no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null
export GIT_AUTHOR_DATE=2026-01-01T09:00:00Z GIT_COMMITTER_DATE=2026-01-01T09:00:00Z

git init --quiet -b main
cat > README.md <<'EOT'
# Cantina da Nonna Rosa

Restaurante de comida italiana caseira em Curitiba (PR), aberto desde 2014.

- Almoço de terça a domingo, jantar só de sexta e sábado.
- Prato mais pedido: lasanha de forno à bolonhesa.
- Cerca de 40 lugares; reservas só por WhatsApp.

Projeto do site: ainda sem código e sem identidade visual definida.
EOT
git add -A
git commit --quiet -m "chore: start project"
