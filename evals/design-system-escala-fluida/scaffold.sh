#!/usr/bin/env bash
# Builds, in the current directory, the static landing of Lote, a fictional
# tool that collects and searches deploy logs for development teams. No
# tokens yet: styles.css holds only an empty `:root {}`, and there is no
# DESIGN.md. The owner's approved spec in docs/devorb/specs/ already has its
# `## Direção visual` contract (Persuade, devtools, Geist and Geist Mono, the
# direction in words, no values), as if devorb:visual-direction had run.
# No build step and no network; the case judges the files.
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
ambientes num lugar só e deixa o time pesquisar o que mudou entre um deploy e
outro. Site estático: `index.html` e `styles.css`, sem build.

Este ambiente não tem rede.
__X__
cat > styles.css <<'__X__'
:root {}
__X__
cat > index.html <<'__X__'
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Lote</title>
    <link rel="stylesheet" href="styles.css" />
  </head>
  <body>
    <main>
      <p>Lote: landing em construção.</p>
    </main>
  </body>
</html>
__X__
commit_at "2026-01-01T09:00:00-03:00" "chore: start the static landing"

cat > docs/devorb/specs/2026-01-01-lote-landing-design.md <<'__X__'
# Landing do Lote

Aprovada pelo dono.

## Contexto

O Lote é uma ferramenta de logs de deploy para times de desenvolvimento.
Junta os logs de todos os ambientes num lugar só, marca cada deploy com o
commit que subiu e deixa o time pesquisar o que mudou entre um deploy e
outro. A landing apresenta o produto a desenvolvedores e leva ao cadastro do
plano gratuito.

## Escopo

- Site estático: `index.html` e `styles.css`, sem framework e sem build.
- Tema escuro só, como o terminal de quem vai usar.
- Em português do Brasil, funciona no celular e no computador.
- Antes da página, os tokens e o `DESIGN.md`. A página vem depois.

## Fora do escopo

- O cadastro em si: o botão leva para `https://app.lote.invalid/cadastro`.

## Direção visual

- **Mode:** Persuade. **Invention level:** New world (o projeto ainda não tem
  identidade).
- **Sources:** setor devtools. Fundação em CSS puro, sem biblioteca de
  componentes. Nenhum componente de destaque. Nenhuma biblioteca nova.
- **Direction:** vem do terminal e da linha do tempo de um deploy: texto
  alinhado em coluna, hashes de commit, horários exatos. A ideia: a página lê
  como um log bem formatado, calmo e preciso. O que a landing comum de
  devtools faz e esta não faz: gradiente roxo com brilho atrás do título.
  Teste do espelho: um trecho de log real no lugar da ilustração do hero.
- **Type:** Geist nos títulos, no texto e na interface; Geist Mono nos trechos
  de log, nos hashes e nos horários. Ambas livres.
- **First screen:** o nome, a frase "Todo deploy, num log só", um trecho de
  log de exemplo e a ação "Começar grátis".
- **Sections:** o problema (logs espalhados por ambiente), como funciona em
  três passos, a busca entre deploys, integrações, preço, e o fechamento com
  a mesma ação.
- **Material:** dados o nome, a frase e o trecho de log; logos de
  integrações chegam depois e ficam como lacuna visível até lá.
- **Copy:** a ação principal é sempre "Começar grátis". Voz de quem já foi
  acordado por um deploy quebrado: direta, sem exagero.
- **States:** a landing não carrega dados nem envia formulário; o botão tem
  normal, hover e foco visível.
- **Floor:** vale inteiro, nenhum reflexo quebrado.
- **Do not:** gradiente roxo com brilho, ícones em caixinha colorida, sombra
  forte nos cartões.
__X__
commit_at "2026-01-01T10:00:00-03:00" "docs: approved spec with the visual direction"
