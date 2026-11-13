#!/usr/bin/env bash
# Builds, in the current directory, the "Teams" page of Quadro, a project
# management panel, already written, with its DESIGN.md and the owner's
# approved spec in docs/devorb/specs/. The interface text is in English.
# Planted problems, all in index.html and styles.css:
#   1. styles.css: .team-count uses #6b7280, a color outside the tokens.
#   2. styles.css: the focus ring (box-shadow on :focus-visible) sits inside a
#      transition, so it fades in. DESIGN.md says focus appears at once.
#   3. index.html: the Finance team shows "1 members" (singular bug).
#   4. styles.css: the search input uses var(--text-small), 14px, which makes
#      phones zoom in on focus.
#   5. index.html: the viewport meta has user-scalable=no.
# One deviation is authorized on purpose: the "Beta" badge uses a 999px
# radius, outside the radius scale, and DESIGN.md allows it by name.
# The rest follows the tokens. Plain HTML and CSS, no build, no dependencies.
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
# Quadro

Painel de gestão de projetos. Esta pasta tem a página de equipes, em HTML e
CSS puros, sem build e sem dependências: abra `index.html` no navegador.
O sistema visual está em `DESIGN.md`.
__X__
commit_at "2026-01-01T09:00:00-03:00" "chore: start the panel"

cat > docs/devorb/specs/2026-01-01-equipes-design.md <<'__X__'
# Página de equipes do Quadro

Aprovada pelo dono.

## Contexto

O Quadro é um painel de gestão de projetos usado por agências pequenas. Os
clientes são de fora do Brasil, então o texto da interface é em inglês.

## O que a página faz

- Lista as equipes da conta, cada uma com o nome e o número de membros.
- Tem um campo para buscar equipe pelo nome.
- Tem um botão para convidar membro.
- O título da página leva o selo "Beta", porque a página é nova.

## Escopo

- Uma página: `index.html` com `styles.css`, HTML e CSS puros.
- Segue o `DESIGN.md` do projeto: tokens, foco e exceções autorizadas.
- Funciona no computador e no celular; parte dos gestores abre o painel no
  telefone.

## Fora do escopo

- Criar, editar ou apagar equipes. Permissões.
__X__
commit_at "2026-01-01T10:00:00-03:00" "docs: approved spec for the teams page"

cat > DESIGN.md <<'__X__'
# DESIGN.md do Quadro

Modo: Operate. É um painel de trabalho, denso e calmo, sem hero nem texto de
vendas.

## Tokens

Todo valor de cor, raio, espaço, tipo e duração sai daqui. Valor fora desta
lista é desvio, salvo as exceções autorizadas abaixo.

```css
--color-bg: #ffffff;
--color-surface: #f6f7f9;
--color-text: #1c2026;
--color-text-muted: #545b66;
--color-border: #d9dde3;
--color-primary: #1f5f8b;
--color-primary-hover: #184c70;
--color-focus: #3b8ad9;
--color-badge-bg: #e7f0f7;
--radius-sm: 4px;
--radius-md: 8px;
--space-1: 4px;
--space-2: 8px;
--space-3: 12px;
--space-4: 16px;
--space-6: 24px;
--text-body: 16px;
--text-small: 14px;
--text-title: 24px;
--duration-fast: 150ms;
--font: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
```

## Foco

O anel de foco é `box-shadow: 0 0 0 3px var(--color-focus)` em `:focus-visible`.
O foco aparece na hora, sem transição nem fade.

## Movimento

Hover de botão muda a cor de fundo em `--duration-fast`. Com
`prefers-reduced-motion: reduce`, nada transiciona.

## Exceções autorizadas

- O selo "Beta" ao lado do título usa `border-radius: 999px` (pílula), fora da escala de raios. Decisão do dono em 2026-01-01: o selo segue a marca-mãe.
__X__

cat > index.html <<'__X__'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
  <title>Teams · Quadro</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <main class="page">
    <header class="page-header">
      <h1>Teams <span class="beta-badge">Beta</span></h1>
      <button class="button" type="button">Invite member</button>
    </header>

    <div class="search" role="search">
      <label for="team-search">Search teams</label>
      <input id="team-search" type="search" name="q" autocomplete="off">
    </div>

    <ul class="team-list">
      <li class="team">
        <span class="team-name">Design</span>
        <span class="team-count">12 members</span>
      </li>
      <li class="team">
        <span class="team-name">Finance</span>
        <span class="team-count">1 members</span>
      </li>
      <li class="team">
        <span class="team-name">Support</span>
        <span class="team-count">3 members</span>
      </li>
    </ul>
  </main>
</body>
</html>
__X__

cat > styles.css <<'__X__'
:root {
  --color-bg: #ffffff;
  --color-surface: #f6f7f9;
  --color-text: #1c2026;
  --color-text-muted: #545b66;
  --color-border: #d9dde3;
  --color-primary: #1f5f8b;
  --color-primary-hover: #184c70;
  --color-focus: #3b8ad9;
  --color-badge-bg: #e7f0f7;
  --radius-sm: 4px;
  --radius-md: 8px;
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-6: 24px;
  --text-body: 16px;
  --text-small: 14px;
  --text-title: 24px;
  --duration-fast: 150ms;
  --font: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
}

* { box-sizing: border-box; }

body {
  margin: 0;
  background: var(--color-bg);
  color: var(--color-text);
  font-family: var(--font);
  font-size: var(--text-body);
}

.page {
  max-width: 720px;
  margin: 0 auto;
  padding: var(--space-6) var(--space-4);
}

.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--space-4);
}

h1 {
  margin: 0;
  font-size: var(--text-title);
}

.beta-badge {
  padding: var(--space-1) var(--space-2);
  border-radius: 999px;
  background: var(--color-badge-bg);
  color: var(--color-primary);
  font-size: var(--text-small);
  vertical-align: middle;
}

.button {
  min-height: 44px;
  padding: var(--space-2) var(--space-4);
  border: 0;
  border-radius: var(--radius-sm);
  background: var(--color-primary);
  color: var(--color-bg);
  font: inherit;
  cursor: pointer;
  transition: background-color var(--duration-fast) ease, box-shadow var(--duration-fast) ease;
}

.button:hover { background: var(--color-primary-hover); }

.button:focus-visible,
.search input:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px var(--color-focus);
}

.search {
  display: grid;
  gap: var(--space-1);
  margin: var(--space-6) 0 var(--space-4);
}

.search label {
  color: var(--color-text-muted);
  font-size: var(--text-small);
}

.search input {
  min-height: 44px;
  padding: var(--space-2) var(--space-3);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
  font-family: inherit;
  font-size: var(--text-small);
}

.team-list {
  margin: 0;
  padding: 0;
  list-style: none;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
}

.team {
  display: flex;
  justify-content: space-between;
  gap: var(--space-4);
  padding: var(--space-3) var(--space-4);
}

.team + .team { border-top: 1px solid var(--color-border); }

.team-name { overflow-wrap: break-word; min-width: 0; }

.team-count {
  color: #6b7280;
  font-size: var(--text-small);
  white-space: nowrap;
}

@media (prefers-reduced-motion: reduce) {
  * { transition: none !important; }
}
__X__
commit_at "2026-01-02T15:00:00-03:00" "feat: teams page"
