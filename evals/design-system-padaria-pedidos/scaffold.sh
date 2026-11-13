#!/usr/bin/env bash
# Builds, in the current directory, the Vite + Tailwind 4 site of Padaria
# Fermento, a bakery in Recife that already has an identity: DESIGN.md at the
# root holds its tokens (YAML front matter, light and dark), and src/app.css
# carries the same tokens in `@theme`, with dark values under
# prefers-color-scheme. The owner's approved spec asks for a new "Meus
# pedidos" page whose order states need colors the system does not have yet;
# its `## Direção visual` contract says to extend the existing identity.
# No node_modules: the sandbox has no network, so nothing installs and nothing
# builds; the case judges the files.
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
mkdir -p src docs/devorb/specs

cat > package.json <<'__X__'
{
  "name": "padaria-fermento",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "devDependencies": {
    "@tailwindcss/vite": "^4.1.8",
    "tailwindcss": "^4.1.8",
    "vite": "^6.3.5"
  }
}
__X__
cat > .gitignore <<'__X__'
node_modules/
dist/
__X__
cat > README.md <<'__X__'
# Padaria Fermento

Site da Padaria Fermento, padaria de fermentação natural em Recife. Vite e
Tailwind 4 (plugin `@tailwindcss/vite`). O CSS do site fica em `src/app.css`,
e a identidade visual está em `DESIGN.md`.

Este ambiente não tem rede: `npm install` não funciona aqui.
__X__
cat > vite.config.js <<'__X__'
import { defineConfig } from "vite";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [tailwindcss()],
});
__X__
cat > DESIGN.md <<'__X__'
---
name: Padaria Fermento
colors:
  light:
    surface: "#FBF7F0"
    on-surface: "#2B2118"
    surface-muted: "#F0E8DC"
    on-surface-muted: "#5C4B3B"
    brand: "#8A3B12"
    on-brand: "#FFFFFF"
    border: "#D9CBB8"
    focus: "#8A3B12"
  dark:
    surface: "#1C1612"
    on-surface: "#F3EBE0"
    surface-muted: "#2A221C"
    on-surface-muted: "#C9B8A4"
    brand: "#E08A5A"
    on-brand: "#1C1612"
    border: "#4A3D33"
    focus: "#E08A5A"
typography:
  display: "Fraunces, Georgia, serif"
  body: "Source Sans 3, system-ui, sans-serif"
rounded:
  card: "12px"
  button: "999px"
spacing:
  unit: "4px"
---

# Padaria Fermento

Padaria de fermentação natural em Recife. A identidade vem da casca do pão
de longa fermentação e da farinha sobre a bancada: superfícies claras e
quentes, a cor da marca é a da casca.

## Cores

Cada superfície tem a cor do que vai sobre ela (`on-*`). Contraste dos pares,
calculado:

| Par | Claro | Escuro |
| --- | --- | --- |
| on-surface sobre surface | 14,75:1 | 15,15:1 |
| on-surface-muted sobre surface-muted | 6,84:1 | 8,09:1 |
| on-brand sobre brand | 7,73:1 | 6,78:1 |

## Tipografia

Fraunces nos títulos, Source Sans 3 no texto e na interface.

## Foco

Contorno de 2px na cor `focus`, afastado 2px do elemento.
__X__
cat > src/app.css <<'__X__'
@import "tailwindcss";

@theme {
  --color-surface: #FBF7F0;
  --color-on-surface: #2B2118;
  --color-surface-muted: #F0E8DC;
  --color-on-surface-muted: #5C4B3B;
  --color-brand: #8A3B12;
  --color-on-brand: #FFFFFF;
  --color-border: #D9CBB8;
  --color-focus: #8A3B12;

  --font-display: "Fraunces", Georgia, serif;
  --font-sans: "Source Sans 3", system-ui, sans-serif;

  --radius-card: 12px;
  --radius-button: 999px;
}

@media (prefers-color-scheme: dark) {
  :root {
    --color-surface: #1C1612;
    --color-on-surface: #F3EBE0;
    --color-surface-muted: #2A221C;
    --color-on-surface-muted: #C9B8A4;
    --color-brand: #E08A5A;
    --color-on-brand: #1C1612;
    --color-border: #4A3D33;
    --color-focus: #E08A5A;
  }
}

@layer base {
  body {
    background-color: var(--color-surface);
    color: var(--color-on-surface);
    font-family: var(--font-sans);
  }
  :focus-visible {
    outline: 2px solid var(--color-focus);
    outline-offset: 2px;
  }
}
__X__
cat > src/main.js <<'__X__'
import "./app.css";
__X__
cat > index.html <<'__X__'
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Padaria Fermento</title>
    <script type="module" src="/src/main.js"></script>
  </head>
  <body>
    <main class="mx-auto max-w-3xl p-8">
      <h1 class="font-display text-4xl">Padaria Fermento</h1>
      <p class="mt-4 text-on-surface-muted">Pão de fermentação natural, assado todo dia em Recife.</p>
      <a class="mt-8 inline-block rounded-button bg-brand px-6 py-3 text-on-brand" href="https://wa.me/5581900000000">Encomendar pelo WhatsApp</a>
    </main>
  </body>
</html>
__X__
commit_at "2026-01-01T09:00:00-03:00" "feat: landing page with the bakery identity"

cat > docs/devorb/specs/2026-01-01-meus-pedidos-design.md <<'__X__'
# Página "Meus pedidos" da Padaria Fermento

Aprovada pelo dono.

## Contexto

A Padaria Fermento já tem site e identidade visual (`DESIGN.md` e
`src/app.css`). Os clientes de encomenda agora acompanham os pedidos numa
página nova, `pedidos.html`, com a lista dos pedidos e o estado de cada um.

## Estados de um pedido

- Aguardando pagamento.
- Em preparo.
- Saiu para entrega.
- Entregue.
- Cancelado.

Quando a lista não carrega, a página mostra uma mensagem de erro com a opção
de tentar de novo.

## Escopo

- O sistema de design da página nova, no mesmo projeto Vite com Tailwind 4. O
  CSS fica em `src/app.css`.
- Tema claro e tema escuro, como o resto do site.
- A página em si vem depois.

## Direção visual

- **Modo:** Operate. **Nível de invenção:** estender a identidade que já
  existe.
- **Fontes:** fundação Tailwind 4, sem biblioteca de componentes. Nenhum
  componente de destaque. Nenhuma biblioteca nova.
- **Direção:** a mesma do site: casca de pão e farinha sobre a bancada. Nada
  de mundo novo.
- **Tipos:** os do `DESIGN.md`, Fraunces nos títulos e Source Sans 3 no
  resto.
- **Estados:** os cinco estados do pedido se distinguem entre si por cor e por
  texto, e o erro de carregamento tem cor própria. Faltam ao sistema as cores
  desses estados.
- **Piso:** só tokens no CSS; nenhuma cor solta nos componentes.
__X__
commit_at "2026-01-01T10:00:00-03:00" "docs: approved spec for the orders page"
