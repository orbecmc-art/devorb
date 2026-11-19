#!/usr/bin/env bash
# Builds, in the current directory, the landing of Lote, a fictional tool that
# collects and searches deploy logs, with a DESIGN.md that declares every value
# the page uses (so no token finding is legitimate) and a built page,
# index.html with styles.css, that carries the tells of a generated page:
# a 64px h1 at weight 800 with letter-spacing 0, purple, pink and teal all
# used as highlights, a big icon where the product UI should be, three equal
# icon cards titled "Feature 1/2/3", generic numbers ("10x mais rápido",
# "99% de satisfação"), every block centred, and a mobile layout that only
# stacks the columns. No spec, no reference pack. Plain HTML and CSS, no
# build, no dependencies; the font loads from Google Fonts when there is
# network. Reproducible: fixed author, dates and git config.
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
# Lote

Landing do Lote, ferramenta que junta os logs de deploy de todos os
ambientes num lugar só. Site estático: `index.html` e `styles.css`, sem build
e sem dependências. Abra `index.html` no navegador.
__X__

cat > DESIGN.md <<'__X__'
# Lote — sistema visual

## Marca

O Lote fala com times de desenvolvimento: direto, técnico, sem enfeite. Tema
escuro, como o terminal de quem usa.

## Cores

| Token | Valor | Uso |
|---|---|---|
| `--fundo` | `#0B0B12` | fundo da página |
| `--superficie` | `#16161F` | cartões, faixas |
| `--borda` | `#26263A` | bordas e divisórias |
| `--texto` | `#F4F4F5` | texto principal |
| `--texto-suave` | `#A1A1AA` | texto secundário |
| `--branco` | `#FFFFFF` | texto sobre cor |
| `--roxo` | `#7C3AED` | cor da marca: botões, links |
| `--rosa` | `#EC4899` | cor de apoio |
| `--verde-agua` | `#14B8A6` | cor de apoio |

Gradiente da marca: `--gradiente: linear-gradient(135deg, #7C3AED, #EC4899)`.

## Tipografia

- Família única: **Inter** (licença SIL OFL 1.1), pesos 400, 600 e 800,
  carregada do Google Fonts (`https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap`).
- Pilha de reserva: `"Inter", system-ui, -apple-system, "Segoe UI", sans-serif`.

| Token | Valor |
|---|---|
| `--fs-14` | `14px` |
| `--fs-16` | `16px` |
| `--fs-20` | `20px` |
| `--fs-24` | `24px` |
| `--fs-40` | `40px` |
| `--fs-64` | `64px` |
| `--lh-titulo` | `1.1` |
| `--lh-texto` | `1.6` |

## Espaço

Base de 4px: `--esp-1` 4px, `--esp-2` 8px, `--esp-3` 12px, `--esp-4` 16px,
`--esp-6` 24px, `--esp-8` 32px, `--esp-12` 48px, `--esp-16` 64px,
`--esp-24` 96px. Largura máxima do conteúdo: 1120px; texto corrido até 560px.

## Forma

- Raio de 16px em cartões (`--raio-cartao`) e 999px em botões e selos
  (`--raio-botao`).
- Bordas de 1px em `--borda`.
- Sombra dos botões em roxo (`--sombra: 0 8px 24px rgba(124, 58, 237, .4)`).
- Ícones de 24px em traço de 2px.
__X__
commit_at "2026-11-03T09:00:00-03:00" "chore: start the Lote site with its design system"

cat > index.html <<'__X__'
<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Lote — logs de deploy num lugar só</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap">
<link rel="stylesheet" href="styles.css">
</head>
<body>
<header class="topo">
  <a class="marca" href="#">Lote</a>
  <nav>
    <a href="#recursos">Recursos</a>
    <a href="#numeros">Números</a>
    <a href="#comecar">Preços</a>
  </nav>
</header>

<main>
  <section class="hero">
    <span class="selo">✨ Novo: alertas no Slack</span>
    <h1>Deploys sem mistério</h1>
    <p class="lede">O Lote junta os logs de deploy de todos os ambientes num lugar só, para o seu time achar o erro antes do cliente.</p>
    <div class="acoes">
      <a class="botao botao-cheio" href="https://app.lote.invalid/cadastro">Comece grátis</a>
      <a class="botao botao-vazado" href="#recursos">Ver demo</a>
    </div>
    <div class="icone-hero" aria-hidden="true">
      <svg viewBox="0 0 24 24" width="96" height="96" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4.5 16.5c-1.5 1.26-2 5-2 5s3.74-.5 5-2c.71-.84.7-2.13-.09-2.91a2.18 2.18 0 0 0-2.91-.09z"/><path d="M12 15l-3-3a22 22 0 0 1 2-3.95A12.88 12.88 0 0 1 22 2c0 2.72-.78 7.5-6 11a22.35 22.35 0 0 1-4 2z"/><path d="M9 12H4s.55-3.03 2-4c1.62-1.08 5 0 5 0"/><path d="M12 15v5s3.03-.55 4-2c1.08-1.62 0-5 0-5"/></svg>
    </div>
  </section>

  <section class="numeros" id="numeros">
    <div class="numero">
      <strong class="n-roxo">10x</strong>
      <span>mais rápido</span>
    </div>
    <div class="numero">
      <strong class="n-rosa">99%</strong>
      <span>de satisfação</span>
    </div>
    <div class="numero">
      <strong class="n-verde">24/7</strong>
      <span>monitoramento</span>
    </div>
  </section>

  <section class="recursos" id="recursos">
    <h2>Tudo que seu time precisa</h2>
    <p class="lede">Ferramentas poderosas para levar seus deploys ao próximo nível.</p>
    <div class="cartoes">
      <article class="cartao">
        <div class="icone icone-roxo" aria-hidden="true"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z"/></svg></div>
        <h3 class="t-roxo">Feature 1</h3>
        <p>Junte os logs de produção, homologação e preview num lugar só.</p>
      </article>
      <article class="cartao">
        <div class="icone icone-rosa" aria-hidden="true"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></div>
        <h3 class="t-rosa">Feature 2</h3>
        <p>Compare dois deploys e veja o que mudou entre eles.</p>
      </article>
      <article class="cartao">
        <div class="icone icone-verde" aria-hidden="true"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg></div>
        <h3 class="t-verde">Feature 3</h3>
        <p>Pesquise em todos os logs por ambiente, serviço e commit.</p>
      </article>
    </div>
  </section>

  <section class="chamada" id="comecar">
    <h2>Pronto para começar?</h2>
    <p class="lede">Crie sua conta grátis em segundos. Sem cartão de crédito.</p>
    <a class="botao botao-branco" href="https://app.lote.invalid/cadastro">Comece grátis</a>
  </section>
</main>

<footer class="rodape">
  <p>© 2026 Lote. Todos os direitos reservados.</p>
</footer>
</body>
</html>
__X__

cat > styles.css <<'__X__'
:root {
  --fundo: #0B0B12;
  --superficie: #16161F;
  --borda: #26263A;
  --texto: #F4F4F5;
  --texto-suave: #A1A1AA;
  --branco: #FFFFFF;
  --roxo: #7C3AED;
  --rosa: #EC4899;
  --verde-agua: #14B8A6;
  --gradiente: linear-gradient(135deg, #7C3AED, #EC4899);

  --fs-14: 14px;
  --fs-16: 16px;
  --fs-20: 20px;
  --fs-24: 24px;
  --fs-40: 40px;
  --fs-64: 64px;
  --lh-titulo: 1.1;
  --lh-texto: 1.6;

  --esp-1: 4px;
  --esp-2: 8px;
  --esp-3: 12px;
  --esp-4: 16px;
  --esp-6: 24px;
  --esp-8: 32px;
  --esp-12: 48px;
  --esp-16: 64px;
  --esp-24: 96px;

  --raio-cartao: 16px;
  --raio-botao: 999px;
  --sombra: 0 8px 24px rgba(124, 58, 237, .4);
}

* { box-sizing: border-box; }

body {
  margin: 0;
  font-family: "Inter", system-ui, -apple-system, "Segoe UI", sans-serif;
  font-size: var(--fs-16);
  line-height: var(--lh-texto);
  color: var(--texto);
  background: var(--fundo);
  text-align: center;
}

a { color: inherit; text-decoration: none; }

h1, h2, h3, p { margin: 0; }

h1 {
  font-size: var(--fs-64);
  font-weight: 800;
  letter-spacing: 0;
  line-height: var(--lh-titulo);
}

h2 {
  font-size: var(--fs-40);
  font-weight: 800;
  letter-spacing: 0;
  line-height: var(--lh-titulo);
}

h3 { font-size: var(--fs-20); font-weight: 600; }

.topo {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--esp-2);
  padding: var(--esp-6) var(--esp-6) 0;
}

.marca {
  font-size: var(--fs-24);
  font-weight: 800;
  background: var(--gradiente);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.topo nav { display: flex; justify-content: center; gap: var(--esp-6); font-size: var(--fs-14); color: var(--texto-suave); }

section {
  max-width: 1120px;
  margin: 0 auto;
  padding: var(--esp-24) var(--esp-6);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--esp-6);
}

.selo {
  display: inline-block;
  padding: var(--esp-1) var(--esp-4);
  border-radius: var(--raio-botao);
  border: 1px solid var(--roxo);
  color: var(--rosa);
  font-size: var(--fs-14);
  font-weight: 600;
}

.lede { max-width: 560px; color: var(--texto-suave); font-size: var(--fs-20); }

.acoes { display: flex; justify-content: center; gap: var(--esp-4); }

.botao {
  display: inline-block;
  padding: var(--esp-3) var(--esp-6);
  border-radius: var(--raio-botao);
  font-weight: 600;
}

.botao-cheio { background: var(--roxo); color: var(--branco); box-shadow: var(--sombra); }
.botao-vazado { border: 1px solid var(--borda); color: var(--texto); }
.botao-branco { background: var(--branco); color: var(--roxo); }

.icone-hero {
  margin-top: var(--esp-8);
  width: 192px;
  height: 192px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--gradiente);
  color: var(--branco);
  box-shadow: var(--sombra);
}

.numeros {
  flex-direction: row;
  justify-content: center;
  gap: var(--esp-16);
  padding-top: var(--esp-12);
  padding-bottom: var(--esp-12);
}

.numero { display: flex; flex-direction: column; align-items: center; }
.numero strong { font-size: var(--fs-40); font-weight: 800; line-height: var(--lh-titulo); }
.numero span { color: var(--texto-suave); }
.n-roxo, .t-roxo { color: var(--roxo); }
.n-rosa, .t-rosa { color: var(--rosa); }
.n-verde, .t-verde { color: var(--verde-agua); }

.cartoes {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: var(--esp-6);
  margin-top: var(--esp-6);
  width: 100%;
}

.cartao {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--esp-3);
  padding: var(--esp-8);
  background: var(--superficie);
  border: 1px solid var(--borda);
  border-radius: var(--raio-cartao);
}

.cartao p { color: var(--texto-suave); }

.icone {
  width: var(--esp-12);
  height: var(--esp-12);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--branco);
}

.icone-roxo { background: var(--roxo); }
.icone-rosa { background: var(--rosa); }
.icone-verde { background: var(--verde-agua); }

.chamada {
  margin-bottom: var(--esp-24);
  border-radius: var(--raio-cartao);
  background: var(--gradiente);
}

.chamada .lede { color: var(--branco); }

.rodape {
  padding: var(--esp-8) var(--esp-6);
  border-top: 1px solid var(--borda);
  color: var(--texto-suave);
  font-size: var(--fs-14);
}

@media (max-width: 640px) {
  .numeros { flex-direction: column; }
  .cartoes { grid-template-columns: 1fr; }
}
__X__
commit_at "2026-11-14T16:00:00-03:00" "feat: Lote landing page"
