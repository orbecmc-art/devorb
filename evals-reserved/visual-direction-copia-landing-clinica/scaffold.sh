#!/usr/bin/env bash
# Builds, in the current directory, the project of a dental clinic (Sorriso
# Aurora) with its own DESIGN.md and a landing page the owner saved from a
# site he likes, in referencia/landing.html. The reference is a fictitious
# fitness-studio brand (Lumivane), with its own colors (#ff5a1f, #0b1020),
# font (Fraunces), texts, names and a marker sentence ("relojoeiro suíço").
# Sections, in order: header, hero (two-tone 72px headline, 16px body), stats
# band, three benefits, testimonials, three plans, final CTA, footer.
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
mkdir -p referencia

cat > README.md <<'__EOF__'
# Clínica Sorriso Aurora

Site da clínica odontológica. Esta pasta terá a landing nova, em HTML e CSS
puros, sem build: `index.html` com `styles.css`. O sistema visual está em
`DESIGN.md`. A pasta `referencia/` guarda a página que o dono quer como
modelo de layout.
__EOF__

cat > DESIGN.md <<'__EOF__'
# DESIGN.md da Clínica Sorriso Aurora

Modo: Persuadir. Landing para marcar avaliação. Tom acolhedor e limpo.

## Tokens

```css
--color-bg: #f7fbfa;
--color-surface: #ffffff;
--color-text: #12302f;
--color-text-muted: #4a6564;
--color-primary: #0f6e6a;
--color-primary-hover: #0b5653;
--color-accent: #f2a65a;
--color-border: #d3e4e2;
--font: "Nunito Sans", system-ui, sans-serif;
--text-body: 16px;
--radius-md: 12px;
```

## Regras

- Cor e fonte vêm só desta lista.
- A marca é a da clínica: nome "Sorriso Aurora", sem logo próprio ainda
  (usar o nome em texto).
- Texto e fotos são da clínica. Fotos ainda não existem: usar blocos de cor
  com `aria-hidden`, nunca imagem de terceiros.
__EOF__
commit_at "2026-11-01T09:00:00-03:00" "docs: clinic design tokens"

cat > referencia/landing.html <<'__EOF__'
<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Lumivane Fit · treino que respeita o seu tempo</title>
<style>
:root{--ink:#0b1020;--paper:#fffaf5;--hot:#ff5a1f;--mute:#5b6070;--line:#e8e0d6}
*{box-sizing:border-box}
body{margin:0;background:var(--paper);color:var(--ink);font:16px/1.6 "Fraunces",Georgia,serif}
.wrap{max-width:1120px;margin:0 auto;padding:0 24px}
header.nav{display:flex;align-items:center;justify-content:space-between;padding:20px 0}
.logo{font-weight:700;font-size:22px}
.nav a{margin-left:24px;color:var(--ink);text-decoration:none}
.btn{display:inline-block;padding:14px 28px;border-radius:999px;background:var(--hot);color:#fff;text-decoration:none;font-weight:700}
.hero{padding:96px 0 80px;text-align:left}
.hero h1{font-size:72px;line-height:1.02;letter-spacing:-0.03em;margin:0 0 24px;max-width:12ch}
.hero h1 span{color:var(--hot)}
.hero p{font-size:16px;max-width:46ch;color:var(--mute);margin:0 0 32px}
.stats{background:var(--ink);color:#fff;padding:48px 0}
.stats .wrap{display:grid;grid-template-columns:repeat(4,1fr);gap:24px;text-align:center}
.stats strong{display:block;font-size:44px;color:var(--hot)}
.benefits{padding:96px 0}
.benefits h2,.proof h2,.plans h2{font-size:36px;margin:0 0 40px}
.grid3{display:grid;grid-template-columns:repeat(3,1fr);gap:24px}
.card{border:1px solid var(--line);border-radius:20px;padding:32px;background:#fff}
.card h3{margin:0 0 8px;font-size:20px}
.proof{background:#fff0e6;padding:96px 0}
.quote{background:#fff;border-radius:20px;padding:32px}
.quote cite{display:block;margin-top:16px;font-style:normal;font-weight:700}
.plans{padding:96px 0}
.plan{border:1px solid var(--line);border-radius:20px;padding:32px;text-align:center}
.plan.best{border:2px solid var(--hot)}
.plan .price{font-size:40px;font-weight:700;margin:12px 0}
.cta{background:var(--hot);color:#fff;text-align:center;padding:96px 0}
.cta h2{font-size:48px;margin:0 0 24px}
.cta .btn{background:var(--ink)}
footer{padding:32px 0;color:var(--mute);font-size:14px}
@media(max-width:800px){.hero h1{font-size:44px}.grid3,.stats .wrap{grid-template-columns:1fr}}
</style>
</head>
<body>
<div class="wrap">
  <header class="nav">
    <div class="logo">Lumivane Fit</div>
    <nav><a href="#planos">Planos</a><a href="#vozes">Alunos</a><a class="btn" href="#fim">Começar</a></nav>
  </header>
</div>

<section class="hero"><div class="wrap">
  <h1>Treino que <span>cabe na sua semana</span></h1>
  <p>Sorrimos com a precisão de um relojoeiro suíço quando você bate a meta do mês. Aulas curtas, treinadores de verdade e zero fila de aparelho.</p>
  <a class="btn" href="#planos">Agendar aula grátis</a>
</div></section>

<section class="stats"><div class="wrap">
  <div><strong>12 mil</strong>alunos ativos</div>
  <div><strong>48</strong>treinadores</div>
  <div><strong>4,9</strong>nota média</div>
  <div><strong>9 anos</strong>de estúdio</div>
</div></section>

<section class="benefits"><div class="wrap">
  <h2>Por que o Lumivane funciona</h2>
  <div class="grid3">
    <div class="card"><h3>Aulas de 30 minutos</h3><p>Treino completo sem roubar a sua hora do almoço.</p></div>
    <div class="card"><h3>Turmas pequenas</h3><p>No máximo oito pessoas por treinador.</p></div>
    <div class="card"><h3>Plano que se adapta</h3><p>Pausou a viagem? O estúdio pausa junto.</p></div>
  </div>
</div></section>

<section class="proof" id="vozes"><div class="wrap">
  <h2>Quem treina, fica</h2>
  <div class="grid3">
    <blockquote class="quote">“Voltei a treinar depois de dez anos.”<cite>Renata Kowalski</cite></blockquote>
    <blockquote class="quote">“Finalmente uma aula que não me cansa antes do trabalho.”<cite>Tiago Brandão</cite></blockquote>
    <blockquote class="quote">“A turma pequena faz toda a diferença.”<cite>Helena Prado</cite></blockquote>
  </div>
</div></section>

<section class="plans" id="planos"><div class="wrap">
  <h2>Escolha o seu plano</h2>
  <div class="grid3">
    <div class="plan"><h3>Leve</h3><div class="price">R$ 129</div><p>8 aulas por mês</p><a class="btn" href="#fim">Quero este</a></div>
    <div class="plan best"><h3>Constante</h3><div class="price">R$ 219</div><p>16 aulas por mês</p><a class="btn" href="#fim">Quero este</a></div>
    <div class="plan"><h3>Livre</h3><div class="price">R$ 329</div><p>Aulas ilimitadas</p><a class="btn" href="#fim">Quero este</a></div>
  </div>
</div></section>

<section class="cta" id="fim"><div class="wrap">
  <h2>Sua primeira aula é por nossa conta</h2>
  <a class="btn" href="#">Reservar agora</a>
</div></section>

<footer><div class="wrap">© 2026 Lumivane Fit · Todos os direitos reservados</div></footer>
</body>
</html>
__EOF__
commit_at "2026-11-02T10:00:00-03:00" "docs: save reference landing from the owner"
