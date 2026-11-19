#!/usr/bin/env bash
# Builds, in the current directory, the finished static landing of Quintal, a
# small editorial magazine of short essays: index.html and all the CSS in
# styles.css. Nothing moves yet: no transition, no animation and no script.
# Plus the owner's approved spec, whose `## Direção visual` contract says
# `Motion level: Suave`. The case judges styles.css.
# Self-contained, no network. Reproducible: fixed author, date and git config.
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
# Quintal

Página de apresentação da Quintal, revista de ensaios curtos. Site estático:
abra `index.html` no navegador. Todo o CSS fica em `styles.css`.
__X__
cat > index.html <<'__X__'
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quintal — ensaios curtos</title>
    <link rel="stylesheet" href="styles.css" />
  </head>
  <body>
    <header class="masthead">
      <a class="logo" href="/">Quintal</a>
      <nav class="nav">
        <a href="#ensaios">Ensaios</a>
        <a href="#assinar">Assinar</a>
      </nav>
    </header>
    <main>
      <section class="hero">
        <p class="kicker">Número 14 · Outono</p>
        <h1>Ensaios curtos para ler devagar</h1>
        <p class="lede">Toda quinta, um texto de até dez minutos sobre cidade, comida e o que sobra do dia.</p>
        <a class="button" href="#assinar">Receber às quintas</a>
      </section>
      <section class="essays" id="ensaios">
        <h2>Neste número</h2>
        <ol class="essay-list">
          <li class="essay">
            <span class="essay-number">01</span>
            <h3>O ônibus das seis</h3>
            <p>Quem pega a primeira linha da manhã conhece a cidade antes dela acordar.</p>
          </li>
          <li class="essay">
            <span class="essay-number">02</span>
            <h3>Feira de domingo</h3>
            <p>Três gerações de uma barraca de pastel e o preço do óleo.</p>
          </li>
          <li class="essay">
            <span class="essay-number">03</span>
            <h3>Varal</h3>
            <p>Um prédio inteiro visto pelas roupas que seca na janela.</p>
          </li>
        </ol>
      </section>
      <section class="quote">
        <blockquote>
          <p>“A Quintal é o único e-mail que eu guardo para ler no sábado.”</p>
          <cite>Helena Prado, assinante desde o número 1</cite>
        </blockquote>
      </section>
      <section class="subscribe" id="assinar">
        <h2>Uma carta por semana</h2>
        <p>Grátis. Sai quando quiser.</p>
        <form class="subscribe-form">
          <label for="email">Seu e-mail</label>
          <input id="email" type="email" name="email" placeholder="voce@exemplo.com" required />
          <button class="button" type="submit">Assinar</button>
        </form>
      </section>
    </main>
    <footer class="footer">
      <p>Quintal · revista independente · São Paulo</p>
    </footer>
  </body>
</html>
__X__
cat > styles.css <<'__X__'
:root {
  --paper: #f6f1e7;
  --ink: #1f1b16;
  --muted: #6d655a;
  --rule: #d9cfbd;
  --accent: #8a3b1f;
  --serif: 'Iowan Old Style', 'Palatino Linotype', Georgia, serif;
  --sans: system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
  color: var(--ink);
  background: var(--paper);
  font-family: var(--serif);
}

* {
  box-sizing: border-box;
}

body {
  margin: 0;
}

:focus-visible {
  outline: 2px solid var(--accent);
  outline-offset: 3px;
}

.masthead {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  max-width: 1080px;
  margin: 0 auto;
  padding: 1.5rem 1.25rem;
  border-bottom: 1px solid var(--rule);
}

.logo {
  color: var(--ink);
  font-size: 1.5rem;
  font-style: italic;
  text-decoration: none;
}

.nav {
  display: flex;
  gap: 1.5rem;
  font-family: var(--sans);
  font-size: 0.875rem;
}

.nav a {
  color: var(--muted);
  text-decoration: none;
}

main > section {
  max-width: 1080px;
  margin: 0 auto;
  padding: 6rem 1.25rem;
  border-bottom: 1px solid var(--rule);
}

.kicker {
  margin: 0 0 1rem;
  color: var(--accent);
  font-family: var(--sans);
  font-size: 0.8125rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.hero h1 {
  max-width: 14ch;
  margin: 0;
  font-size: clamp(2.75rem, 7vw, 5.5rem);
  font-weight: 400;
  line-height: 1.02;
}

.lede {
  max-width: 34rem;
  margin: 1.5rem 0 2rem;
  color: var(--muted);
  font-size: 1.25rem;
  line-height: 1.5;
}

.button {
  display: inline-block;
  padding: 0.75rem 1.25rem;
  border: 1px solid var(--ink);
  border-radius: 999px;
  background: var(--ink);
  color: var(--paper);
  font-family: var(--sans);
  font-size: 0.9375rem;
  text-decoration: none;
  cursor: pointer;
}

.essays h2,
.subscribe h2 {
  margin: 0 0 2.5rem;
  font-size: 2rem;
  font-weight: 400;
}

.essay-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr));
  gap: 2.5rem;
  margin: 0;
  padding: 0;
  list-style: none;
}

.essay {
  padding-top: 1.25rem;
  border-top: 1px solid var(--ink);
}

.essay-number {
  color: var(--accent);
  font-family: var(--sans);
  font-size: 0.8125rem;
}

.essay h3 {
  margin: 0.5rem 0;
  font-size: 1.5rem;
  font-weight: 400;
}

.essay p {
  margin: 0;
  color: var(--muted);
  line-height: 1.55;
}

.quote blockquote {
  max-width: 44rem;
  margin: 0 auto;
  text-align: center;
}

.quote p {
  margin: 0 0 1.25rem;
  font-size: clamp(1.75rem, 3.5vw, 2.5rem);
  font-style: italic;
  line-height: 1.25;
}

.quote cite {
  color: var(--muted);
  font-family: var(--sans);
  font-size: 0.875rem;
  font-style: normal;
}

.subscribe p {
  margin: -1.5rem 0 2rem;
  color: var(--muted);
}

.subscribe-form {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.75rem;
  font-family: var(--sans);
}

.subscribe-form label {
  width: 100%;
  font-size: 0.875rem;
}

.subscribe-form input {
  flex: 1 1 16rem;
  padding: 0.75rem 1rem;
  border: 1px solid var(--rule);
  border-radius: 999px;
  background: #fffdf8;
  font: inherit;
}

.footer {
  max-width: 1080px;
  margin: 0 auto;
  padding: 2rem 1.25rem;
  color: var(--muted);
  font-family: var(--sans);
  font-size: 0.8125rem;
}
__X__
commit_at "2026-01-01T09:00:00-03:00" "feat: Quintal landing page"

cat > docs/devorb/specs/2026-01-01-quintal-landing-design.md <<'__X__'
# Landing da Quintal

Aprovada pela dona.

## Contexto

A Quintal é uma revista independente de ensaios curtos, enviada por e-mail
toda quinta. A landing está pronta e no ar, em HTML e CSS estáticos. Falta a
entrada das seções.

## Direção visual

- Mode: Persuade
- Invention level: Extend
- Motion level: Suave
- Direction: revista impressa de bairro; papel creme, tinta escura, serifa; a página respira e não chama atenção para si.
- Type: serifa do sistema (Iowan, Palatino, Georgia) nos títulos e no texto; sans do sistema em rótulos e botões.
- First screen: título grande à esquerda, linha de apoio e o botão "Receber às quintas".
- Sections: hero, com entrada ao carregar; lista dos três ensaios do número, com entrada ao rolar; citação de uma assinante, com entrada ao rolar; assinatura com o formulário, com entrada ao rolar. Termina na assinatura.
- Copy: "Receber às quintas"; voz calma, frases curtas.
- Floor: vale `floor.md` sem exceção.
- Do not: fundo animado, efeito de cursor, carrossel.

## Restrições

- Todo o CSS fica em `styles.css`.
- Sem dependência nem biblioteca nova. JavaScript só se for preciso para disparar a entrada ao rolar, num arquivo `main.js`.
- Não mudar textos, cores nem layout.
__X__
commit_at "2026-01-01T10:00:00-03:00" "docs: approved spec for the landing"
