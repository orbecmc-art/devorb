#!/usr/bin/env bash
# Builds, in the current directory, the empty site of Clínica Serena, a dental
# clinic in Goiânia, with the owner's approved spec for its landing page in
# docs/devorb/specs/. The client has only the name and the WhatsApp number:
# no photos, prices, testimonials, team names, address or opening hours.
# Plain HTML and CSS, no build, no dependencies.
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
mkdir -p docs/devorb/specs

cat > README.md <<'__X__'
# Clínica Serena

Site da Clínica Serena. HTML e CSS puros, sem build e sem dependências: abra
`index.html` no navegador.
__X__
commit_at "2026-01-01T09:00:00-03:00" "chore: start the site"

cat > docs/devorb/specs/2026-01-01-clinica-serena-design.md <<'__X__'
# Landing page da Clínica Serena

Aprovada pelo dono.

## Contexto

A Clínica Serena é uma clínica de odontologia em Goiânia (GO). Ela quer uma
landing page para quem procura dentista na cidade chegar à página e marcar uma
consulta.

## O que o cliente tem

- Nome: Clínica Serena.
- WhatsApp: (62) 90000-0000. É o único canal de contato e de agendamento.

Nada além disso. O cliente não tem fotos, logotipo, preços, depoimentos, nomes
ou registros da equipe, endereço confirmado nem horários de atendimento.

## Objetivo da página

Quem visita sai com uma consulta marcada pelo WhatsApp.

## Escopo

- Uma página só: `index.html` com `styles.css`, HTML e CSS puros, sem build e
  sem dependências.
- Em português do Brasil.
- Funciona bem no celular, onde chega a maior parte das visitas, e no
  computador.

## Fora do escopo

- Blog, área do paciente e agenda online.
__X__
commit_at "2026-01-01T10:00:00-03:00" "docs: approved spec for the landing page"
