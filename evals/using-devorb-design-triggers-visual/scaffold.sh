#!/usr/bin/env bash
# Builds, in the current directory, a tiny static site for a small shop
# (index.html and styles.css, plain HTML and CSS with no build step) plus the
# owner's approved spec for the landing. The page has the content but no visual
# identity yet: system fonts, no colors, no layout.
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main
mkdir -p docs/devorb/specs

cat > README.md <<'__EOF__'
# Ateliê Fio de Lã

Site estático da loja. Abra `index.html` no navegador; o CSS fica em `styles.css`.
__EOF__
cat > index.html <<'__EOF__'
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Ateliê Fio de Lã</title>
    <link rel="stylesheet" href="styles.css" />
  </head>
  <body>
    <header>
      <h1>Ateliê Fio de Lã</h1>
      <p>Novelos tingidos à mão e kits de tricô para iniciantes.</p>
      <a href="https://wa.me/5500000000000">Pedir pelo WhatsApp</a>
    </header>
    <main>
      <section>
        <h2>Kits</h2>
        <ul>
          <li>Kit gorro, R$ 89</li>
          <li>Kit cachecol, R$ 119</li>
          <li>Kit manta, R$ 249</li>
        </ul>
      </section>
      <section>
        <h2>Como funciona</h2>
        <p>Você escolhe o kit, a gente envia em até 3 dias úteis com a receita impressa.</p>
      </section>
    </main>
    <footer>Rua das Flores, 120, Curitiba</footer>
  </body>
</html>
__EOF__
cat > styles.css <<'__EOF__'
body {
  font-family: system-ui, sans-serif;
}
__EOF__
cat > docs/devorb/specs/2026-01-01-loja-landing-design.md <<'__EOF__'
# Landing do Ateliê Fio de Lã

Aprovada pelo dono.

## Objetivo

Uma página só que apresenta a loja e leva o visitante a pedir pelo WhatsApp.

## Conteúdo

- Nome da loja e frase curta: novelos tingidos à mão e kits de tricô para iniciantes.
- Três kits com preço: gorro (R$ 89), cachecol (R$ 119) e manta (R$ 249).
- Como funciona: escolha do kit, envio em até 3 dias úteis, receita impressa.
- Botão "Pedir pelo WhatsApp" no topo e no fim da página.
- Endereço no rodapé.

## Fora do escopo

Carrinho, pagamento e cadastro.
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-10-10T10:00:00Z GIT_COMMITTER_DATE=2026-10-10T10:00:00Z git commit --quiet -m "landing content and approved spec"
