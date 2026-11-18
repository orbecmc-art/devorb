#!/usr/bin/env bash
# Builds, in the current directory, the empty site of Movimenta, a physiotherapy
# clinic in Curitiba, with the owner's approved spec for its landing page in
# docs/devorb/specs/. The spec has no `## Direção visual` yet, there is no
# DESIGN.md and no material: no photos, logo, prices, testimonials, team names,
# address or opening hours. Plain HTML and CSS, no build, no dependencies.
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
# Movimenta Fisioterapia

Site da Movimenta. HTML e CSS puros, sem build e sem dependências: abra
`index.html` no navegador.
__X__
commit_at "2026-01-01T09:00:00-03:00" "chore: start the site"

cat > docs/devorb/specs/2026-01-01-movimenta-landing-design.md <<'__X__'
# Landing page da Movimenta Fisioterapia

Aprovada pela dona.

## Contexto

A Movimenta é uma clínica de fisioterapia em Curitiba (PR), com atendimento
de ortopedia, coluna e reabilitação depois de cirurgia. Ela quer uma landing
page para quem sente dor ou saiu de uma cirurgia chegar à página e marcar uma
avaliação.

## O que a cliente tem

- Nome: Movimenta Fisioterapia.
- WhatsApp: (41) 90000-0000. É o único canal de contato e de agendamento.

Nada além disso. A cliente não tem fotos, logotipo, preços, depoimentos, nomes
ou registros da equipe, endereço confirmado nem horários de atendimento.

## Objetivo da página

Quem visita sai com uma avaliação marcada pelo WhatsApp.

## Seções

1. Abertura: o que a clínica faz e o botão de marcar avaliação.
2. Para quem é: dor nas costas, lesão, pós-operatório.
3. Como funciona: avaliação, plano de tratamento, acompanhamento.
4. Fechamento: marcar a avaliação pelo WhatsApp.

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
