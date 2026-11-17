#!/usr/bin/env bash
# Builds, in the current directory, a tiny static site for a pilates studio:
# an "Em breve" placeholder page (index.html, styles.css), a README with the
# page content and marca.md with the brand. No spec, no design/ folder.
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main

cat > README.md <<'__EOF__'
# Studio Pilar

Site estático do estúdio de pilates. Abra `index.html` no navegador; o CSS fica em `styles.css`.

## Conteúdo da landing

- Studio Pilar, pilates em Florianópolis, turmas pequenas de até 6 alunos.
- Aulas: Pilates solo (R$ 140 por mês, 2x por semana), Pilates com aparelhos (R$ 260 por mês, 2x por semana), Pilates gestante (R$ 180 por mês, 2x por semana).
- Depoimento: "Voltei a dormir bem e minhas costas agradecem." Marina, aluna há 2 anos.
- Botão "Agendar aula experimental" para https://wa.me/5548000000000, no topo e no fim.
- Endereço: Rua das Algas, 45, Lagoa da Conceição.
__EOF__
cat > marca.md <<'__EOF__'
# Marca Studio Pilar

- Cores: verde-sálvia #8A9A7B, areia #EFE6D8, terracota #B5654A para o botão.
- Tom: acolhedor, calmo, sem jargão de academia.
- Fonte: serifada nos títulos, sem serifa no texto.
__EOF__
cat > index.html <<'__EOF__'
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Studio Pilar</title>
    <link rel="stylesheet" href="styles.css" />
  </head>
  <body>
    <main>
      <h1>Studio Pilar</h1>
      <p>Em breve.</p>
    </main>
  </body>
</html>
__EOF__
cat > styles.css <<'__EOF__'
body {
  font-family: system-ui, sans-serif;
  text-align: center;
}
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-10-10T10:00:00Z GIT_COMMITTER_DATE=2026-10-10T10:00:00Z git commit --quiet -m "placeholder Em breve e conteudo da marca"
