#!/usr/bin/env bash
# Builds, in the current directory, a tiny static-site repo for "Oficina Roda
# Viva", a fictional bicycle repair shop: README, DESIGN.md, and on branch
# feature/landing an approved spec (docs/devorb/specs/) whose `## Direção
# visual` contract is already filled (Mode: Persuade, a `Sources:` line naming
# Land-book and shadcn/ui from the owner's ui-sources.json) plus an approved
# plan (docs/devorb/plans/) with exactly one task that builds index.html and
# styles.css. Nothing is built yet. The project has no ui-sources.json: the
# list ships with the visual-direction skill, so the agent must find and read
# it before writing the first UI file.
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

cat > README.md <<'__X__'
# Oficina Roda Viva

Site da Oficina Roda Viva, oficina de bicicletas. HTML e CSS puros, sem build
e sem dependências: abra `index.html` no navegador. O sistema visual está em
`DESIGN.md`.
__X__

cat > DESIGN.md <<'__X__'
# DESIGN.md da Oficina Roda Viva

Modo: Persuade. Página curta, uma ação: chamar a oficina no WhatsApp.

## Tokens

```css
--bg: #fbf8f3;
--surface: #ffffff;
--text: #1d2330;
--text-muted: #4a5160;
--accent: #1d4e89;
--accent-hover: #163c6b;
--border: #e3ddd2;
--radius: 10px;
--space-2: 8px;
--space-4: 16px;
--space-6: 24px;
--space-12: 48px;
--text-body: 17px;
--font: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
```

## Foco

Anel de 3px em `:focus-visible`, que aparece na hora.
__X__
commit_at "2026-11-01T09:00:00-03:00" "chore: start the shop site"

git checkout --quiet -b feature/landing
mkdir -p docs/devorb/specs docs/devorb/plans

cat > docs/devorb/specs/2026-11-17-landing-design.md <<'__X__'
# Landing da Oficina Roda Viva

**Status:** aprovada em 2026-11-17 pelo dono.

## Contexto

A Roda Viva conserta bicicletas no bairro e quer uma página que leve o
visitante a chamar a oficina no WhatsApp.

## Dados do produto

- Revisão completa: R$ 120.
- Bicicleta pronta em 2 dias úteis.
- Atendimento de segunda a sábado.

## Escopo

- Uma página: `index.html` com `styles.css`, HTML e CSS puros.
- Segue o `DESIGN.md`.
- Funciona no computador e no celular.

## Direção visual

- Mode: Persuade. Invention level: New surface, same world.
- Motion level: Suave.
- Sources: consultadas Land-book (galeria de landings, estilo clean) e
  shadcn/ui (botão e cartão de base); puladas as bibliotecas de animação
  (a página não se move). Sem biblioteca nova.
- Direction: a oficina de bairro que fala claro; o preço e o prazo na frente,
  sem jargão de mecânico. O teste do espelho muda o hero: o título é o prazo.
- Type: família do sistema, título leve e grande, corpo de leitura. Confirmado.
- First screen: `hero:split-left`; título à esquerda com o prazo, parágrafo, botão
  "Chamar no WhatsApp".
- Sections: hero; `section:price-card` com a revisão a R$ 120; `section:closing-cta`
  repete o botão. A página termina no botão.
- Material: dados do produto acima; sem fotos (falta, o hero usa só texto).
- Copy: botão "Chamar no WhatsApp"; voz direta e amiga, uma linha.
- States: não se aplica, a página não carrega dados.
- Floor: `references/floor.md` vale, nenhum reflexo quebrado.
- Do not: sem gradiente roxo, sem cartões com sombra, sem números além dos
  dados do produto.
__X__
commit_at "2026-11-17T18:00:00Z" "docs: spec aprovada da landing"

cat > docs/devorb/plans/2026-11-18-landing.md <<'__X__'
# Plano: landing da Oficina Roda Viva

**Spec:** `docs/devorb/specs/2026-11-17-landing-design.md` (aprovada).
**Status:** aprovado em 2026-11-18.
**Branch:** `feature/landing`.

Uma task só. Sem teste automatizado: a conferência é abrir `index.html` e ver
as três seções do contrato.

### Task 1: construir a landing

**Arquivos:** criar `index.html` e `styles.css`.

**Passos:**

1. Criar `index.html` em português do Brasil (`lang="pt-BR"`), com `meta
   viewport`, o `styles.css` ligado e as três seções da spec (hero, cartão do
   preço, fechamento com o botão). O texto vem só dos dados do produto.
2. Criar `styles.css` com os tokens do `DESIGN.md` em `:root` e as regras das
   três seções. Sem valor de cor fora dos tokens.
3. Conferir que o botão "Chamar no WhatsApp" aparece no hero e no
   fechamento, e que a página cabe em 375px sem rolagem horizontal.
4. Commit `feat: landing da oficina`.
__X__
commit_at "2026-11-18T09:00:00Z" "docs: plano aprovado da landing"
