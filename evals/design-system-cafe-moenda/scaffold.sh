#!/usr/bin/env bash
# Builds, in the current directory, the skeleton of a Vite site with Tailwind 4
# for Café Moenda, a roastery and coffee shop in Belo Horizonte. No tokens yet:
# src/app.css only imports Tailwind, there is no DESIGN.md and no
# tailwind.config. The owner's approved spec in docs/devorb/specs/ already has
# its `## Direção visual` contract (mode, type families, the direction in
# words, no values), as if devorb:visual-direction had run.
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
  "name": "cafe-moenda",
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
# Café Moenda

Site do Café Moenda, torrefação e cafeteria em Belo Horizonte. Vite e
Tailwind 4 (plugin `@tailwindcss/vite`). O CSS do site fica em `src/app.css`.

Este ambiente não tem rede: `npm install` não funciona aqui.
__X__
cat > vite.config.js <<'__X__'
import { defineConfig } from "vite";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [tailwindcss()],
});
__X__
cat > src/app.css <<'__X__'
@import "tailwindcss";
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
    <title>Café Moenda</title>
    <script type="module" src="/src/main.js"></script>
  </head>
  <body>
    <main class="p-8">
      <p>Café Moenda: site em construção.</p>
    </main>
  </body>
</html>
__X__
commit_at "2026-01-01T09:00:00-03:00" "chore: start the site with Vite and Tailwind 4"

cat > docs/devorb/specs/2026-01-01-cafe-moenda-design.md <<'__X__'
# Site do Café Moenda

Aprovada pelo dono.

## Contexto

O Café Moenda é uma torrefação com cafeteria em Belo Horizonte (MG). Torra
café especial de pequenos produtores do sul de Minas e vende o grão na
cafeteria e pelo site. O site novo apresenta a torra da semana e leva o
visitante a comprar café em grão.

## Escopo

- Projeto Vite com Tailwind 4. O CSS fica em `src/app.css`.
- Tema claro e tema escuro, seguindo a preferência do sistema.
- Em português do Brasil, funciona no celular e no computador.
- Antes da página, o sistema de design do projeto. A página vem depois.

## Fora do escopo

- Carrinho e pagamento: o botão de compra leva ao WhatsApp da cafeteria.

## Direção visual

- **Modo:** Persuade. **Nível de invenção:** mundo novo (o projeto ainda não
  tem identidade).
- **Fontes:** fundação Tailwind 4, sem biblioteca de componentes. Nenhum
  componente de destaque. Nenhuma biblioteca nova.
- **Direção:** vem do balcão de torrefação: sacas de juta, o papel kraft dos
  pacotes, o marrom da torra média, o creme do leite vaporizado e a luz da
  manhã. A ideia: a página lê como a ficha de uma torra, com origem, data e
  notas à vista. O que a página comum de cafeteria faz e esta não faz: foto de
  xícara fumegante sobre fundo preto. Teste do espelho: a ficha de torra no
  lugar do hero de foto.
- **Tipos:** Fraunces nos títulos e Source Sans 3 no texto e na interface.
  Ambas livres e com os acentos do português.
- **Primeira tela:** o nome, a torra da semana com origem e data, e a ação
  "Comprar café em grão".
- **Seções:** torra da semana, origens, como pedir, endereço e horário da
  cafeteria, e o fechamento com a mesma ação de compra.
- **Material:** dado o nome e o WhatsApp; fotos dos pacotes chegam depois e
  ficam como lacuna visível até lá.
- **Texto:** a ação principal é sempre "Comprar café em grão". Voz de quem
  torra: direta, sem exagero.
- **Estados:** o botão de compra tem normal, hover, foco visível e
  desabilitado (torra esgotada).
- **Piso:** só tokens no CSS; nenhuma cor solta nos componentes.
__X__
commit_at "2026-01-01T10:00:00-03:00" "docs: approved spec with the visual direction"
