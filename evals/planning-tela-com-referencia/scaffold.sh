#!/usr/bin/env bash
# Builds, in the current directory, a tiny static site (index.html, styles.css)
# for a pilates studio, a captured reference pack in design/referencias/estudio-ref/
# (secoes.md, notas.md, tokens.json) and an approved spec whose
# `## Direção visual` follows the contract (Replicate, with a reference pack).
# No plan yet, no docs/devorb/plans/.
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main
mkdir -p docs/devorb/specs design/referencias/estudio-ref

cat > README.md <<'__EOF__'
# Studio Pilar

Site estático do estúdio de pilates. Abra `index.html` no navegador; o CSS fica em `styles.css`.
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
}
__EOF__

cat > design/referencias/estudio-ref/url.txt <<'__EOF__'
https://estudio-referencia.example.invalid/
__EOF__
cat > design/referencias/estudio-ref/secoes.md <<'__EOF__'
# Seções de estudio-ref

1. Hero: título grande à esquerda, foto de aula à direita, botão de ação.
2. Aulas: três cartões lado a lado com nome, frequência e preço.
3. Depoimento: citação centralizada em fundo areia.
4. Chamada final: faixa verde com o botão repetido.
5. Rodapé: endereço e horário em duas colunas.
__EOF__
cat > design/referencias/estudio-ref/notas.md <<'__EOF__'
# Notas de estudio-ref

- Muito espaço em branco, cantos arredondados de 16px, sombra suave nos cartões.
- Títulos em serifa, texto em sem serifa.
- Em 390px os cartões empilham e a foto vai para cima do título.
- Não levar: textos, fotos e logo da referência.
__EOF__
cat > design/referencias/estudio-ref/tokens.json <<'__EOF__'
{
  "colors": { "fundo": "#EFE6D8", "destaque": "#8A9A7B", "botao": "#B5654A", "texto": "#2B2B2B" },
  "fonts": { "titulo": "serif", "texto": "sans-serif" },
  "radius": "16px",
  "spacing": { "secao": "96px" }
}
__EOF__

cat > docs/devorb/specs/2026-11-12-landing-design.md <<'__EOF__'
# Landing do Studio Pilar

**Status:** aprovada em 2026-11-12 pela dona do estúdio.

## Objetivo

Trocar a página "Em breve" por uma landing de uma página só que apresenta o
estúdio e leva o visitante a agendar aula experimental pelo WhatsApp.

## Conteúdo

- Studio Pilar, pilates em Florianópolis, turmas de até 6 alunos.
- Aulas: Pilates solo (R$ 140), com aparelhos (R$ 260) e gestante (R$ 180), todas por mês, 2x por semana.
- Depoimento da Marina, aluna há 2 anos.
- Botão "Agendar aula experimental" no topo e no fim.
- Endereço no rodapé.

## Fora do escopo

Agenda online, pagamento e cadastro de alunos.

## Direção visual

- Mode: Persuade
- Invention level: Replicate
- Motion level: Suave
- Reference pack: design/referencias/estudio-ref/ (até 3)
- Same as reference: ordem e estrutura das seções, grade de três cartões, espaçamento, raio dos cantos, hierarquia de tipo.
- Changed: cores, fontes e textos seguem a marca do Studio Pilar (verde-sálvia, areia, terracota no botão), não os da referência.
- Sections: hero com botão; aulas em três cartões; depoimento; chamada final com o botão; rodapé com endereço. Termina na chamada final.
- Do not: levar texto, fotos ou logo da referência; usar fonte ou cor da referência.
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-11-12T18:00:00Z GIT_COMMITTER_DATE=2026-11-12T18:00:00Z git commit --quiet -m "landing: pacote de referencia e spec aprovada"
