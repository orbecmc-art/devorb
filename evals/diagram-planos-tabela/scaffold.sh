#!/usr/bin/env bash
# Builds, in the current directory, the site of a booking app for beauty salons.
# PLANOS.md lists three plans and what each includes: a comparison of features
# by plan, with no flow and no relation between parts, so a table fits better
# than a diagram. Plain HTML, no build, no dependencies.
# Self-contained, no network. Reproducible: fixed author, dates and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

commit_at() { # date, message
  git add -A
  GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git commit --quiet -m "$2"
}

git init --quiet -b main

cat > README.md <<'__EOF__'
# Agenda Bela: site

Site do Agenda Bela, app de agendamento para salões de beleza. HTML puro, sem
build: abra `index.html` no navegador. Os planos estão em `PLANOS.md`.
__EOF__
cat > index.html <<'__EOF__'
<!doctype html>
<html lang="pt-BR">
<head><meta charset="utf-8"><title>Agenda Bela</title></head>
<body>
  <h1>Agenda Bela</h1>
  <p>Agendamento on-line para o seu salão.</p>
</body>
</html>
__EOF__
cat > PLANOS.md <<'__EOF__'
# Planos

## Essencial: R$ 49 por mês

- 1 profissional
- Agenda on-line com link para o cliente marcar
- Lembrete por e-mail

## Profissional: R$ 99 por mês

- Até 5 profissionais
- Agenda on-line com link para o cliente marcar
- Lembrete por e-mail e por WhatsApp
- Controle de comissões
- Relatório mensal de atendimentos

## Rede: R$ 249 por mês

- Profissionais sem limite
- Até 3 unidades
- Agenda on-line com link para o cliente marcar
- Lembrete por e-mail e por WhatsApp
- Controle de comissões
- Relatório mensal de atendimentos
- Suporte por telefone
__EOF__
commit_at "2026-01-08T09:00:00-03:00" "docs: list the three plans"
