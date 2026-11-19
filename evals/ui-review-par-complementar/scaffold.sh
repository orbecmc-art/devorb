#!/usr/bin/env bash
# Builds, in the current directory, the landing page of Prumo, a fictional
# online accounting service for Brazilian sole traders (MEI), already written
# as index.html and styles.css, with DESIGN.md and the owner's approved spec
# in docs/devorb/specs/. Mode: Persuade. The page text is in Portuguese.
# The colour work is not declared anywhere: light sections use navy (--accent)
# for the CTA; one dark warm band (ground #1c100c) uses
# orange (--complement) for the big number and the labels.
# Navy and orange sit about 200 degrees apart and never share a block.
# DESIGN.md lists both tokens with a neutral role and the spec says nothing
# about colour, so nothing authorises the pair or says which section owns
# which colour: the reviewer must accept it by the critique rule alone.
# Planted real defect, in styles.css:47: .lead (the hero paragraph, "Cuidamos do
# seu CNPJ...") is #9ca3af on the #ffffff section, about 2.5:1, below 4.5:1.
# Everything else passes. Plain HTML and CSS, no build, no dependencies.
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
# Prumo

Landing page do Prumo, contabilidade online para MEI. HTML e CSS puros, sem
build e sem dependências: abra `index.html` no navegador. O sistema visual
está em `DESIGN.md`.
__X__
commit_at "2026-01-01T09:00:00-03:00" "chore: start the landing"

cat > docs/devorb/specs/2026-01-01-prumo-landing-design.md <<'__X__'
# Landing do Prumo

Aprovada pelo dono.

## Contexto

O Prumo é uma contabilidade online para MEI (microempreendedor individual).
A landing existe para o visitante abrir a conta.

## Dados do produto

- Plano único: R$ 79 por mês.
- Primeira resposta em 1 dia útil.
- A declaração anual do MEI (DASN) está incluída.

## Escopo

- Uma página: `index.html` com `styles.css`, HTML e CSS puros.
- Segue o `DESIGN.md` do projeto.
- Funciona no computador e no celular.

## Direção visual

- Mode: Persuade. Invention level: New surface, same world.
- Direction: a contabilidade que parece papel limpo, sem jargão.
- First screen: título à esquerda, parágrafo, botão "Abrir minha conta".
- Sections: hero (claro); faixa do plano (escura e quente); rodapé claro com
  o botão de novo.
- Copy: botão "Abrir minha conta".
__X__
commit_at "2026-01-01T10:00:00-03:00" "docs: approved spec for the landing"

cat > DESIGN.md <<'__X__'
# DESIGN.md do Prumo

Modo: Persuade. Página de venda curta, uma ação: abrir a conta.

## Tokens

Todo valor de cor, espaço, tipo e raio sai daqui. Valor fora desta lista é
desvio.

```css
--bg: #ffffff;
--surface: #f4f6fb;
--text: #1f2937;
--text-muted: #4b5563;
--accent: #1e3a8a; /* destaque */
--accent-hover: #172e6e;
--complement: #f97316; /* complemento */
--ground-dark: #1c100c;
--text-on-dark: #f3e7e1;
--focus: #2563eb;
--radius: 10px;
--space-2: 8px;
--space-4: 16px;
--space-6: 24px;
--space-12: 48px;
--text-body: 17px;
--text-small: 14px;
--font: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
```

## Foco

Anel de 3px em `--focus` com `:focus-visible`, que aparece na hora.

## Movimento

Hover do botão troca a cor de fundo em 150ms. Com
`prefers-reduced-motion: reduce`, nada transiciona.
__X__

cat > index.html <<'__X__'
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Prumo · contabilidade online para MEI</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <main>
    <section class="hero">
      <div class="wrap">
        <p class="eyebrow">Contabilidade para MEI</p>
        <h1>Seu CNPJ em dia, sem papelada</h1>
        <p class="lead">Cuidamos do seu CNPJ e da declaração anual para você tocar o negócio.</p>
        <a class="button" href="#abrir">Abrir minha conta</a>
      </div>
    </section>

    <section class="plan">
      <div class="wrap">
        <p class="label">Plano único</p>
        <h2>Um preço, tudo incluído</h2>
        <p class="big">R$ 79<span class="per">/mês</span></p>
        <ul class="facts">
          <li><span class="label">Resposta</span> Primeira resposta em 1 dia útil</li>
          <li><span class="label">Declaração</span> DASN anual incluída</li>
        </ul>
      </div>
    </section>

    <section class="closing" id="abrir">
      <div class="wrap">
        <h2>Pronto para começar?</h2>
        <p class="body">A abertura da conta leva poucos minutos.</p>
        <a class="button" href="#abrir">Abrir minha conta</a>
      </div>
    </section>
  </main>
</body>
</html>
__X__

cat > styles.css <<'__X__'
:root {
  --bg: #ffffff;
  --surface: #f4f6fb;
  --text: #1f2937;
  --text-muted: #4b5563;
  --accent: #1e3a8a;
  --accent-hover: #172e6e;
  --complement: #f97316;
  --ground-dark: #1c100c;
  --text-on-dark: #f3e7e1;
  --focus: #2563eb;
  --radius: 10px;
  --space-2: 8px;
  --space-4: 16px;
  --space-6: 24px;
  --space-12: 48px;
  --text-body: 17px;
  --text-small: 14px;
  --font: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
}

* { box-sizing: border-box; }

body {
  margin: 0;
  background: var(--bg);
  color: var(--text);
  font-family: var(--font);
  font-size: var(--text-body);
  line-height: 1.55;
}

.wrap {
  max-width: 880px;
  margin: 0 auto;
  padding: var(--space-12) var(--space-4);
}

h1, h2 { margin: 0 0 var(--space-4); line-height: 1.1; letter-spacing: -0.02em; }
h1 { font-size: clamp(2.25rem, 7vw, 3.75rem); font-weight: 300; }
h2 { font-size: clamp(1.75rem, 5vw, 2.5rem); font-weight: 300; }
p { margin: 0 0 var(--space-4); }

.eyebrow { color: var(--text-muted); font-size: var(--text-small); }

.hero { background: var(--bg); }
.lead { color: #9ca3af; max-width: 34em; }

.button {
  display: inline-block;
  padding: var(--space-4) var(--space-6);
  border-radius: var(--radius);
  background: var(--accent);
  color: #ffffff;
  font-weight: 600;
  text-decoration: none;
  transition: background-color 150ms ease;
}
.button:hover { background: var(--accent-hover); }
.button:focus-visible { outline: 3px solid var(--focus); outline-offset: 2px; }

.plan { background: var(--ground-dark); color: var(--text-on-dark); }
.plan .label {
  color: var(--complement);
  font-size: var(--text-small);
}
.big { color: var(--complement); font-size: clamp(4rem, 14vw, 7rem); font-weight: 700; line-height: 1; }
.per { font-size: 1.5rem; font-weight: 400; color: var(--text-on-dark); }
.facts { list-style: none; margin: 0; padding: 0; display: grid; gap: var(--space-2); }

.closing { background: var(--surface); }
.closing .body { color: var(--text-muted); }

@media (prefers-reduced-motion: reduce) {
  .button { transition: none; }
}
__X__
commit_at "2026-01-01T11:00:00-03:00" "feat: landing page"
