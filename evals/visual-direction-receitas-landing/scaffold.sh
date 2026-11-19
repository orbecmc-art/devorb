#!/usr/bin/env bash
# Builds, in the current directory, the empty site of Lote, a fictional tool
# that collects and searches deploy logs for development teams, with the
# owner's approved spec for its landing page in docs/devorb/specs/. The spec
# has no `## Direção visual` yet and there is no DESIGN.md. The owner gives
# exactly three numbers (30 days of history and 5 people on the free plan,
# R$ 49 a month for the Time plan) and a list of what the product does.
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
# Lote

Landing do Lote, ferramenta que junta os logs de deploy de todos os
ambientes num lugar só. Site estático: `index.html` e `styles.css`, sem build
e sem dependências.

Este ambiente não tem rede.
__X__
commit_at "2026-01-01T09:00:00-03:00" "chore: start the site"

cat > docs/devorb/specs/2026-01-01-lote-landing-design.md <<'__X__'
# Landing do Lote

Aprovada pelo dono.

## Contexto

O Lote é uma ferramenta de logs de deploy para times de desenvolvimento. A
landing apresenta o produto a desenvolvedores e leva ao cadastro do plano
gratuito.

## O que o produto faz

- Junta os logs de deploy de todos os ambientes (produção, homologação,
  preview) num lugar só.
- Marca cada deploy com o commit que subiu, o autor e o horário.
- Compara dois deploys e mostra o que mudou entre eles: commits, variáveis de
  ambiente e linhas de log novas.
- Pesquisa em todos os logs com filtro por ambiente, serviço e commit.
- Avisa no Slack ou por e-mail quando um deploy falha.
- Recebe os logs de GitHub Actions, GitLab CI e Vercel.

## Números que o dono deu

São os únicos números que a página pode afirmar:

- O plano gratuito guarda 30 dias de histórico.
- O plano gratuito vale para até 5 pessoas.
- O plano Time custa R$ 49 por mês.

O Lote ainda não tem clientes citáveis, depoimentos, logos de empresas nem
métricas de uso.

## Objetivo da página

Quem visita cria a conta no plano gratuito.

## Escopo

- Uma página só: `index.html` com `styles.css`, sem framework e sem build.
- Tema escuro só, como o terminal de quem vai usar.
- Em português do Brasil, funciona no celular e no computador.

## Fora do escopo

- O cadastro em si: o botão leva para `https://app.lote.invalid/cadastro`.
- Documentação, blog e área logada.
__X__
commit_at "2026-01-01T10:00:00-03:00" "docs: approved spec for the landing page"
