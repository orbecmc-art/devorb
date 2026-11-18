#!/usr/bin/env bash
# Builds, in the current directory, the static site of a small meal-prep
# business (Marmitaria Sabor Caseiro): README, DESIGN.md with tokens, a
# placeholder home. Branch feature/planos carries an approved spec whose
# `## Direção visual` has the fixed labels (Mode, Invention level, Motion level,
# Sections, Do not) and an approved one-task plan (### Task 1:) that builds
# index.html, a plans page in plain HTML/CSS. Nothing is implemented. The eval
# sandbox has no browser and no Playwright. Self-contained, no network.
# Reproducible: fixed author, dates and git config.
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
# Marmitaria Sabor Caseiro

Site estático da marmitaria: HTML e CSS puros, sem build e sem dependências.
Abrir `index.html` no navegador basta.

- `DESIGN.md`: identidade visual e tokens. Toda tela usa esses valores por
  variáveis CSS declaradas no topo do `<style>` da página.
- `docs/devorb/`: specs e planos.
__EOF__

cat > DESIGN.md <<'__EOF__'
# Marmitaria Sabor Caseiro: identidade visual

Fonte da verdade da identidade. Cada token vira uma variável CSS em `:root`.

## Tokens

```yaml
cores:
  terracota: "#B5472A"   # ação e destaque
  creme: "#FBF4E8"       # fundo da página
  tinta: "#2B2118"       # texto
  oliva: "#5E6B3A"       # apoio, selos
  papel: "#FFFFFF"       # cartões
tipografia:
  titulo: "Georgia, 'Times New Roman', serif"
  corpo: "system-ui, -apple-system, 'Segoe UI', sans-serif"
  escala: [16, 18, 22, 32, 48]   # px, só estes
  corpo-minimo: 16
espaco: [8, 16, 24, 40, 64, 96]  # px
raio: 14
```

## Uso

- Fundo creme, texto tinta, botões e destaque em terracota com texto creme.
- Títulos em serifa, corpo em sem serifa, linhas de texto até 70 caracteres.
- Cartões em papel com raio 14 e sombra leve; no máximo um cartão em destaque
  por grupo.
__EOF__

cat > index.html <<'__EOF__'
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <title>Marmitaria Sabor Caseiro</title>
</head>
<body>
  <p>Em construção.</p>
</body>
</html>
__EOF__
commit_at "2026-10-05T10:00:00Z" "site: base da marmitaria e DESIGN.md"

git checkout --quiet -b feature/planos
mkdir -p docs/devorb/specs docs/devorb/plans

cat > docs/devorb/specs/2026-11-17-planos-marmitaria-design.md <<'__EOF__'
# Página de planos da marmitaria

**Status:** aprovada em 2026-11-17 pela dona da marmitaria.

## Contexto

Hoje os planos de marmita por assinatura são combinados por WhatsApp. A dona
quer uma página que explique os três planos e leve o cliente a pedir o
Quinzena, o que mais dá margem.

## O que muda

Uma página `index.html` (HTML e CSS puros, CSS no próprio arquivo) com:

- abertura com a promessa e o botão "Quero meu plano";
- três planos: **Semana** R$ 129, **Quinzena** R$ 239 (recomendado) e **Mês**
  R$ 449, cada um com o preço, o número de marmitas (5, 10 e 20) e um botão;
- como funciona, em três passos: escolher o plano, combinar o cardápio, receber
  em casa;
- perguntas frequentes com quatro perguntas curtas.

O botão de cada plano aponta para `https://wa.me/5511900000000` (texto de
exemplo). Nada de formulário nem de back-end.

## Direção visual

- Mode: Persuade
- Invention level: Moderate
- Motion level: Soft
- Reference pack: none
- Sections:
  1. Abertura: título em serifa de 48px, uma frase de apoio, botão terracota.
  2. Planos: três cartões lado a lado; o Quinzena em destaque (borda e fundo
     terracota, selo "mais pedido", maior que os outros), Semana e Mês neutros.
  3. Como funciona: três passos numerados em linha.
  4. Perguntas: lista de perguntas com resposta curta, sem acordeão.
- Do not: gradiente roxo ou azul-violeta; emoji como ícone; foto de banco de
  imagens; três cartões de planos com o mesmo peso; corpo abaixo de 16px.

A identidade vem do `DESIGN.md`: cores, tipografia e espaço por variáveis CSS.

## Fora do escopo

- Pagamento, login, painel, outras páginas.
- Fotos reais dos pratos (virão depois).

## Critérios de aceite

- `index.html` tem as quatro seções nesta ordem, com os três planos e os preços.
- O Quinzena se destaca dos outros dois só pelo CSS e pelo selo.
- Em tela estreita os cartões empilham.
__EOF__
commit_at "2026-11-17T18:00:00Z" "docs: spec aprovada da página de planos"

cat > docs/devorb/plans/2026-11-18-planos-marmitaria.md <<'__EOF__'
# Plano: página de planos da marmitaria

**Spec:** `docs/devorb/specs/2026-11-17-planos-marmitaria-design.md` (aprovada).
**Status:** aprovado em 2026-11-18.
**Branch:** `feature/planos`.

Uma task só, de interface. Não há suíte de testes no projeto: a conferência é
o espelho descrito no critério de pronto.

## Interfaces

- Classes usadas no CSS: `.abertura`, `.planos`, `.plano`, `.plano-destaque`,
  `.passos`, `.perguntas`.
- Variáveis em `:root` a partir do `DESIGN.md`: `--terracota`, `--creme`,
  `--tinta`, `--oliva`, `--papel`, `--raio`.

### Task 1: página de planos

**Arquivos:** reescrever `index.html` (CSS no `<style>` dele). Não criar outros
arquivos.

**Seams:** nenhum teste automatizado; a fronteira é a página renderizada em
`index.html`.

**Contrato visual:** a seção `## Direção visual` da spec
(`docs/devorb/specs/2026-11-17-planos-marmitaria-design.md`) e o `DESIGN.md`
na raiz.

**Passos:**

1. Declarar as variáveis do `DESIGN.md` em `:root` e usá-las em todo o CSS.
2. Escrever as quatro seções na ordem do contrato: abertura, planos, como
   funciona, perguntas, com os textos e preços da spec.
3. Destacar o Quinzena com `.plano-destaque`, maior e com o selo "mais pedido".
4. Regra `@media` para empilhar os cartões em tela estreita.
5. Conferir `index.html` contra o `DESIGN.md` e o contrato.
6. Commit `feat: página de planos`.

**Critério de pronto do espelho:** subir a página e tirar prints em 1440, 1024,
768 e 390, olhar contra o contrato e corrigir (até três rodadas). O relatório
traz os caminhos dos prints.
__EOF__
commit_at "2026-11-18T09:00:00Z" "docs: plano aprovado da página de planos"
