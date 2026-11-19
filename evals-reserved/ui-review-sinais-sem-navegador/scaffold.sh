#!/usr/bin/env bash
# Builds, in the current directory, a git repo with a small landing page for a
# Brazilian accounting office: plain HTML/CSS plus a DESIGN.md. Tokens are
# consistent (every value comes from a variable), but the page carries seven
# generated-page tells readable from the code. No network. Reproducible: fixed
# author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null
export GIT_AUTHOR_DATE=2026-01-01T09:00:00Z GIT_COMMITTER_DATE=2026-01-01T09:00:00Z

git init --quiet -b main

cat > DESIGN.md <<'MD'
# Contas Claras Contabilidade

Landing que leva micro e pequenas empresas a pedir um orçamento de contabilidade.
Persuade: uma página para convencer e converter.

## Tokens

- Cores: `--paper` #FBFAF7, `--ink` #1B1F2A, `--muted` #5B6272, `--line` #E4E1D8.
- Destaque: `--accent` #1F5FBF (azul). Uma cor de destaque só.
- Tipografia: system-ui. Título 56px, corpo 16px, lead 20px.
- Espaço: escala 8, 16, 24, 48, 96px. Raio 12px.

## Contrato

- Um CTA principal por tela: "Pedir orçamento".
- Contraste AA em todo texto.
- Deve funcionar em 375px de largura.
MD

cat > index.html <<'HTML'
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Contas Claras Contabilidade</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <header class="hero">
    <p class="tag">Contabilidade online</p>
    <h1>Contabilidade que simplifica o seu negócio</h1>
    <p class="lead">Soluções completas para a sua empresa crescer com tranquilidade.</p>
    <a class="cta" href="#orcamento">Pedir orçamento</a>
    <a class="cta cta-2" href="#planos">Ver planos</a>
  </header>

  <section class="features">
    <h2>Por que escolher a Contas Claras</h2>
    <div class="grid">
      <article class="card c1"><span class="icon">&#9889;</span><h3>Benefício 1</h3><p>Descrição do benefício um para o seu negócio.</p></article>
      <article class="card c2"><span class="icon">&#128274;</span><h3>Benefício 2</h3><p>Descrição do benefício dois para o seu negócio.</p></article>
      <article class="card c3"><span class="icon">&#128200;</span><h3>Benefício 3</h3><p>Descrição do benefício três para o seu negócio.</p></article>
    </div>
  </section>

  <section class="numbers">
    <div><strong>10.000+</strong><span>clientes satisfeitos</span></div>
    <div><strong>99%</strong><span>de satisfação</span></div>
    <div><strong>24/7</strong><span>atendimento</span></div>
  </section>

  <section class="final" id="orcamento">
    <h2>Pronto para começar?</h2>
    <p>Fale com a gente e receba uma proposta sem compromisso.</p>
    <a class="cta" href="#">Pedir orçamento</a>
  </section>

  <footer><p>Contas Claras Contabilidade Ltda.</p></footer>
</body>
</html>
HTML

cat > styles.css <<'CSS'
:root {
  --paper: #fbfaf7;
  --ink: #1b1f2a;
  --muted: #5b6272;
  --line: #e4e1d8;
  --accent: #1f5fbf;
  --accent-2: #7a3fd1;
  --accent-3: #e0701f;
  --accent-4: #1f9d6b;
  --accent-5: #d1347a;
  --s1: 8px;
  --s2: 16px;
  --s3: 24px;
  --s4: 48px;
  --s5: 96px;
  --radius: 12px;
}

* { box-sizing: border-box; }
body { margin: 0; background: var(--paper); color: var(--ink); font: 16px/1.5 system-ui, sans-serif; text-align: center; }
section, header, footer { padding: var(--s5) var(--s3); text-align: center; }

.hero { background: linear-gradient(135deg, var(--accent), var(--accent-2)); color: var(--paper); }
.hero h1 { font-size: 56px; font-weight: 800; letter-spacing: 0; line-height: 1.1; margin: 0 auto var(--s3); max-width: 18ch; }
.hero .lead { font-size: 20px; margin: 0 auto var(--s4); max-width: 40ch; }
.tag { text-transform: uppercase; font-size: 14px; margin: 0 0 var(--s2); }

.cta { display: inline-block; background: var(--accent-3); color: var(--paper); padding: var(--s2) var(--s4); border-radius: var(--radius); text-decoration: none; font-weight: 700; margin: var(--s1); }
.cta-2 { background: var(--accent-4); }

.features h2, .final h2 { font-size: 40px; font-weight: 800; letter-spacing: 0; margin: 0 0 var(--s4); }
.grid { display: flex; gap: var(--s3); justify-content: center; }
.card { flex: 1; background: var(--paper); border: 1px solid var(--line); border-radius: var(--radius); padding: var(--s4) var(--s3); box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12); }
.card h3 { margin: var(--s2) 0 var(--s1); font-size: 24px; }
.card p { color: var(--muted); margin: 0; }
.icon { display: inline-block; width: 64px; height: 64px; line-height: 64px; font-size: 32px; border-radius: 50%; color: var(--paper); }
.c1 .icon { background: var(--accent); }
.c2 .icon { background: var(--accent-5); }
.c3 .icon { background: var(--accent-4); }

.numbers { display: flex; justify-content: center; gap: var(--s4); background: var(--ink); color: var(--paper); }
.numbers strong { display: block; font-size: 48px; font-weight: 800; color: var(--accent-3); }

.final { background: var(--line); }
footer { color: var(--muted); border-top: 1px solid var(--line); }

@media (max-width: 700px) {
  .grid, .numbers { flex-direction: column; }
}
CSS

git add -A
git commit --quiet -m "feat: landing do escritório"
