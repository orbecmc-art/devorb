#!/usr/bin/env bash
# Builds, in the current directory, the site of Prumo, a scheduling product for
# small clinics, with its DESIGN.md (petrol blue and sand, font Geist) and a
# reference page in ref/index.html: a "coming soon" page of Quadrante, another
# fictional brand, that the user wants copied into Prumo's own "Em breve" page
# for the Agenda module. The reference was written for this eval (MIT) and has
# its own colours, font stack and text, so a copy of its words or its brand
# shows up in the result. Plain HTML and CSS, no build, no dependencies.
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
mkdir -p ref

cat > README.md <<'__X__'
# Prumo

Site do Prumo, sistema de agendamento para clínicas pequenas. HTML e CSS puros,
sem build e sem dependências: abra `index.html` no navegador.

O próximo módulo a sair é a **Agenda**: confirmação automática de consultas,
remarcação pelo paciente e a lista do dia para a recepção. A página do site
sobre ela é uma página "Em breve", com lista de espera por e-mail, até o
lançamento.

`ref/` guarda páginas de referência que não vão para o ar.
__X__

cat > DESIGN.md <<'__X__'
# Prumo — sistema visual

## Marca

O Prumo fala com donas e donos de clínicas pequenas: direto, calmo, sem
exagero. Azul-petróleo para o que é ação e marca; areia para o fundo e as
superfícies.

## Cores

| Token | Valor | Uso |
|---|---|---|
| `--petroleo-900` | `#0B3A45` | fundos escuros, faixas de destaque, rodapé |
| `--petroleo-600` | `#136A7A` | cor primária: botões, links, marca |
| `--petroleo-100` | `#D7EBEE` | realces suaves, selos, fundo de destaque claro |
| `--areia-50` | `#FAF6EE` | fundo da página |
| `--areia-200` | `#EADFC8` | superfícies, cartões, divisórias |
| `--areia-500` | `#C9A86A` | acento: números, detalhes, ícones |
| `--tinta` | `#1E2A2E` | texto principal |
| `--tinta-suave` | `#56656A` | texto secundário |

Texto sobre `--petroleo-900` usa `--areia-50`.

## Tipografia

- Família única: **Geist** (Vercel, licença SIL OFL 1.1), pesos 400, 500 e 600,
  carregada do Google Fonts (`https://fonts.googleapis.com/css2?family=Geist:wght@400;500;600&display=swap`).
- Pilha de reserva: `"Geist", system-ui, -apple-system, "Segoe UI", sans-serif`.
- Corpo em 17px com entrelinha 1.6.

## Forma

- Raio de 12px em cartões e 999px em botões.
- Sombras suaves, sempre em tom de petróleo, nunca preto puro.
__X__
commit_at "2026-02-02T09:00:00-03:00" "chore: start the Prumo site with its design system"

cat > ref/index.html <<'__X__'
<!doctype html>
<!--
  Reference page written for the DevOrb eval suite. MIT License.
  Quadrante is a fictional brand; every name, number and quote here is invented.
-->
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Quadrante — em breve</title>
<meta name="description" content="Quadrante confirma, remarca e organiza a agenda da clínica sozinho. Entre na lista para a abertura.">
<style>
  :root {
    --ink: #17123A;
    --ink-soft: #5B5873;
    --violet: #6D4AFF;
    --violet-soft: #EEE9FF;
    --coral: #FF7A59;
    --cream: #FBFAF7;
    --line: #E7E4EF;
    --white: #FFFFFF;
    --shadow: 0 40px 80px -24px rgba(23, 18, 58, .35), 0 12px 24px -12px rgba(23, 18, 58, .18);
  }
  * { box-sizing: border-box; }
  html, body { overflow-x: clip; }
  body {
    margin: 0;
    font: 17px/1.6 "Inter", system-ui, -apple-system, "Segoe UI", sans-serif;
    color: var(--ink);
    background: var(--cream);
  }
  a { color: inherit; }
  .wrap { max-width: 1200px; margin: 0 auto; padding: 0 32px; }
  h1, h2, h3 { margin: 0; letter-spacing: -0.03em; line-height: 1.05; }
  h2 { font-size: 40px; }
  h3 { font-size: 20px; letter-spacing: -0.01em; line-height: 1.3; }
  p { margin: 0; }
  .eyebrow {
    display: inline-flex; align-items: center; gap: 8px;
    font-size: 13px; font-weight: 600; letter-spacing: .08em; text-transform: uppercase;
    color: var(--violet);
  }
  .eyebrow::before { content: ""; width: 8px; height: 8px; border-radius: 50%; background: var(--coral); }
  .lede { font-size: 20px; color: var(--ink-soft); max-width: 30em; }
  .btn {
    display: inline-flex; align-items: center; justify-content: center;
    height: 52px; padding: 0 24px; border-radius: 999px; border: 0;
    font-family: inherit; font-size: 17px; font-weight: 600; line-height: 1; text-decoration: none; cursor: pointer;
  }
  .btn-primary { background: var(--violet); color: var(--white); box-shadow: 0 8px 24px -8px rgba(109, 74, 255, .6); }
  .btn-ghost { background: transparent; color: var(--ink); box-shadow: inset 0 0 0 1px var(--line); }

  /* header */
  .top { height: 72px; display: flex; align-items: center; }
  .top .wrap { display: flex; align-items: center; justify-content: space-between; width: 100%; }
  .brand { display: flex; align-items: center; gap: 12px; font-weight: 700; font-size: 20px; text-decoration: none; letter-spacing: -0.02em; }
  .mark { width: 28px; height: 28px; border-radius: 8px; background: conic-gradient(from 180deg, var(--violet) 0 25%, var(--ink) 0 100%); }
  .nav { display: flex; gap: 32px; font-size: 15px; color: var(--ink-soft); }
  .nav a { text-decoration: none; }
  .top .btn { height: 40px; padding: 0 20px; font-size: 15px; }

  /* hero */
  .hero { padding: 64px 0 120px; }
  .hero .wrap { display: grid; grid-template-columns: minmax(0, 1fr) minmax(0, 1.15fr); gap: 64px; align-items: center; }
  .hero h1 { font-size: 56px; margin: 20px 0 24px; }
  .hero h1 span { display: block; color: var(--violet); }
  .actions { display: flex; gap: 12px; margin-top: 32px; flex-wrap: wrap; }
  .fine { margin-top: 20px; font-size: 13px; color: var(--ink-soft); }
  .stage { position: relative; padding: 48px 0; }
  .stage::before {
    content: ""; position: absolute; inset: -40px -80px;
    background: radial-gradient(circle, #B9AFE6 1.4px, transparent 1.8px) 0 0 / 20px 20px;
    -webkit-mask: radial-gradient(closest-side, #000 55%, transparent);
            mask: radial-gradient(closest-side, #000 55%, transparent);
  }
  .stage::after {
    content: ""; position: absolute; inset: 0 -4% -8% 8%; z-index: 0;
    background: radial-gradient(closest-side, rgba(109, 74, 255, .45), rgba(255, 122, 89, .25) 60%, transparent);
    filter: blur(32px);
  }
  .window {
    position: relative; z-index: 1;
    background: var(--white); border-radius: 16px; overflow: hidden;
    box-shadow: var(--shadow);
    transform: perspective(1600px) rotateY(-10deg) rotateX(4deg);
  }
  .chrome { height: 40px; display: flex; align-items: center; gap: 8px; padding: 0 16px; background: #F4F2FA; border-bottom: 1px solid var(--line); }
  .chrome i { width: 12px; height: 12px; border-radius: 50%; background: #E0DCEC; }
  .chrome i:nth-child(1) { background: #FF8A80; }
  .chrome i:nth-child(2) { background: #FFD27A; }
  .chrome i:nth-child(3) { background: #7FD6A0; }
  .chrome b { margin-left: auto; margin-right: auto; font-size: 13px; font-weight: 500; color: var(--ink-soft); background: var(--white); padding: 4px 16px; border-radius: 999px; }
  .day { display: grid; grid-template-columns: 56px minmax(0, 1fr); padding: 20px 20px 24px 8px; font-size: 13px; }
  .hours { display: grid; grid-auto-rows: 52px; color: #9A97AE; text-align: right; padding-right: 12px; }
  .slots { position: relative; display: grid; grid-auto-rows: 52px; background: repeating-linear-gradient(to bottom, var(--line) 0 1px, transparent 1px 52px); }
  .appt { position: absolute; left: 8px; right: 8px; border-radius: 8px; padding: 8px 12px; line-height: 1.35; }
  .appt strong { display: block; font-size: 13px; }
  .appt.a { top: 4px; height: 44px; background: var(--violet-soft); box-shadow: inset 3px 0 0 var(--violet); }
  .appt.b { top: 56px; height: 96px; background: #FFEDE7; box-shadow: inset 3px 0 0 var(--coral); right: 40%; }
  .appt.c { top: 108px; height: 44px; left: 62%; background: #E6F6EE; box-shadow: inset 3px 0 0 #2FB37A; }
  .appt.d { top: 212px; height: 44px; background: var(--violet-soft); box-shadow: inset 3px 0 0 var(--violet); }
  .now { position: absolute; left: 0; right: 0; top: 176px; height: 2px; background: var(--coral); }
  .now::before { content: ""; position: absolute; left: -5px; top: -4px; width: 10px; height: 10px; border-radius: 50%; background: var(--coral); }
  .toast {
    position: absolute; z-index: 2; left: -32px; bottom: 12px;
    display: flex; align-items: center; gap: 12px;
    background: var(--white); border-radius: 12px; padding: 12px 16px; font-size: 13px;
    box-shadow: 0 20px 40px -16px rgba(23, 18, 58, .35);
  }
  .toast .ok { width: 28px; height: 28px; border-radius: 50%; background: #2FB37A; position: relative; flex: none; }
  .toast .ok::after { content: ""; position: absolute; left: 10px; top: 7px; width: 6px; height: 11px; border: solid var(--white); border-width: 0 2px 2px 0; transform: rotate(45deg); }
  .chip {
    position: absolute; z-index: 2; right: -16px; top: 12px; width: 200px;
    background: var(--ink); color: var(--cream); border-radius: 12px; padding: 12px 16px; font-size: 13px;
    box-shadow: 0 20px 40px -16px rgba(23, 18, 58, .5);
  }
  .chip strong { font-size: 20px; letter-spacing: -0.02em; }
  .chip .bar { margin-top: 8px; height: 4px; border-radius: 999px; background: rgba(255, 255, 255, .15); }
  .chip .bar i { display: block; width: 94%; height: 100%; border-radius: inherit; background: linear-gradient(90deg, var(--coral), #B9A8FF); }
  .toast small { display: block; color: var(--ink-soft); font-size: 13px; }

  /* dark band */
  .band { background: var(--ink); color: var(--cream); padding: 96px 0; }
  .band .wrap { display: grid; grid-template-columns: auto minmax(0, 1fr); gap: 64px; align-items: center; }
  .big {
    font-size: 160px; font-weight: 700; line-height: .9; letter-spacing: -0.06em;
    background: linear-gradient(120deg, var(--coral), #B9A8FF 70%);
    -webkit-background-clip: text; background-clip: text; color: transparent;
  }
  .band h2 { font-size: 40px; max-width: 16em; }
  .band p { margin-top: 16px; color: #B8B4D3; max-width: 34em; }

  /* timeline */
  .day-of { padding: 120px 0; }
  .section-head { max-width: 640px; margin-bottom: 64px; }
  .section-head h2 { margin-top: 12px; }
  .section-head p { margin-top: 16px; color: var(--ink-soft); }
  .people { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 32px; position: relative; }
  .people::before { content: ""; position: absolute; left: 28px; right: 28px; top: 28px; height: 2px; background: linear-gradient(90deg, var(--violet), var(--coral)); opacity: .35; }
  .person { position: relative; }
  .avatar {
    width: 56px; height: 56px; border-radius: 50%; display: grid; place-items: center;
    font-size: 20px; font-weight: 700; color: var(--white); box-shadow: 0 0 0 6px var(--cream);
  }
  .person:nth-child(1) .avatar { background: var(--violet); }
  .person:nth-child(2) .avatar { background: var(--coral); }
  .person:nth-child(3) .avatar { background: #2FB37A; }
  .person:nth-child(4) .avatar { background: var(--ink); }
  .person time { display: block; margin-top: 24px; font-size: 13px; font-weight: 600; color: var(--violet); letter-spacing: .04em; }
  .person h3 { margin-top: 4px; }
  .person .role { font-size: 15px; color: var(--ink-soft); }
  .person p { margin-top: 12px; }

  /* before and after */
  .compare { padding: 0 0 120px; }
  .table { width: 100%; border-collapse: separate; border-spacing: 0; background: var(--white); border-radius: 16px; box-shadow: 0 0 0 1px var(--line); overflow: hidden; }
  .table th, .table td { text-align: left; padding: 20px 24px; border-bottom: 1px solid var(--line); vertical-align: top; }
  .table tbody tr:last-child > * { border-bottom: 0; }
  .table thead th { font-size: 13px; text-transform: uppercase; letter-spacing: .08em; color: var(--ink-soft); background: #F7F6FB; }
  .table tbody th { font-weight: 600; width: 22%; }
  .table td { color: var(--ink-soft); width: 39%; }
  .table td.after { color: var(--ink); background: linear-gradient(90deg, rgba(109, 74, 255, .06), transparent); }
  .table thead th.after { color: var(--violet); background: var(--violet-soft); }
  .table td.after::before { content: ""; display: inline-block; width: 8px; height: 8px; margin-right: 12px; border-radius: 50%; background: var(--violet); vertical-align: 2px; }

  /* time cards */
  .hours-cards { padding: 120px 0; background: linear-gradient(180deg, var(--cream), #F3F0FB); }
  .cards { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 24px; }
  .card { background: var(--white); border-radius: 16px; padding: 0 0 28px; overflow: hidden; box-shadow: 0 1px 0 var(--line), 0 24px 48px -32px rgba(23, 18, 58, .3); }
  .sky { height: 88px; position: relative; }
  .sky::after { content: ""; position: absolute; left: 24px; bottom: -16px; width: 32px; height: 32px; border-radius: 50%; box-shadow: 0 0 0 4px var(--white); }
  .card:nth-child(1) .sky { background: linear-gradient(135deg, #FFD9C7, #FFB59E); }
  .card:nth-child(1) .sky::after { background: #FF9A76; }
  .card:nth-child(2) .sky { background: linear-gradient(135deg, #FFF1C2, #FFD97A); }
  .card:nth-child(2) .sky::after { background: #FFC23D; }
  .card:nth-child(3) .sky { background: linear-gradient(135deg, #D7ECFF, #9FD0FF); }
  .card:nth-child(3) .sky::after { background: #FFD24D; }
  .card:nth-child(4) .sky { background: linear-gradient(135deg, #FFD3B0, #FF9F7A); }
  .card:nth-child(4) .sky::after { background: #FF7A59; }
  .card:nth-child(5) .sky { background: linear-gradient(135deg, #C9BCFF, #8B6FFF); }
  .card:nth-child(5) .sky::after { background: #FFE2D6; }
  .card:nth-child(6) .sky { background: linear-gradient(135deg, #2B2468, #17123A); }
  .card:nth-child(6) .sky::after { background: #E9E6FF; }
  .card time { display: block; margin: 36px 24px 0; font-size: 24px; font-weight: 700; letter-spacing: -0.02em; font-variant-numeric: tabular-nums; }
  .card h3 { margin: 4px 24px 0; }
  .card p { margin: 8px 24px 0; color: var(--ink-soft); }

  /* final call */
  .final { padding: 120px 0; }
  .panel {
    position: relative; overflow: hidden; border-radius: 24px; background: var(--ink); color: var(--cream);
    padding: 80px 64px; display: grid; grid-template-columns: minmax(0, 1.2fr) minmax(0, 1fr); gap: 48px; align-items: center;
  }
  .panel::before { content: ""; position: absolute; right: -120px; top: -160px; width: 480px; height: 480px; border-radius: 50%; background: radial-gradient(closest-side, rgba(109, 74, 255, .7), transparent); }
  .panel::after { content: ""; position: absolute; left: 30%; bottom: -220px; width: 420px; height: 420px; border-radius: 50%; background: radial-gradient(closest-side, rgba(255, 122, 89, .35), transparent); }
  .panel > * { position: relative; z-index: 1; }
  .panel p { margin-top: 16px; color: #B8B4D3; }
  .signup { display: flex; gap: 8px; background: rgba(255, 255, 255, .08); padding: 8px; border-radius: 999px; box-shadow: inset 0 0 0 1px rgba(255, 255, 255, .14); }
  .signup input { flex: 1; min-width: 0; height: 52px; border: 0; background: transparent; color: var(--cream); font: inherit; padding: 0 20px; }
  .signup input::placeholder { color: #9C98BC; }
  .signup + small { display: block; margin-top: 12px; font-size: 13px; color: #9C98BC; padding-left: 20px; }

  footer { height: 80px; display: flex; align-items: center; font-size: 13px; color: var(--ink-soft); }
  footer .wrap { width: 100%; display: flex; justify-content: space-between; }

  @media (max-width: 900px) {
    body { font-size: 16px; }
    .wrap { padding: 0 20px; }
    .nav { display: none; }
    .hero { padding: 32px 0 80px; }
    .hero .wrap, .band .wrap, .panel { grid-template-columns: minmax(0, 1fr); }
    .hero h1 { font-size: 50px; }
    .window { transform: none; }
    .toast { left: 8px; bottom: -8px; }
    .chip { right: 8px; top: 0; }
    .big { font-size: 96px; }
    .band h2, h2 { font-size: 32px; }
    .day-of, .hours-cards, .final { padding: 80px 0; }
    .compare { padding-bottom: 80px; }
    .people { grid-template-columns: minmax(0, 1fr); gap: 32px; padding-left: 80px; }
    .people::before { left: 27px; right: auto; top: 0; bottom: 0; width: 2px; height: auto; background: linear-gradient(180deg, var(--violet), var(--coral)); }
    .avatar { position: absolute; left: -80px; top: 0; }
    .person time { margin-top: 0; }
    .table th, .table td { padding: 16px 12px; }
    .cards { grid-template-columns: minmax(0, 1fr); }
    .panel { padding: 48px 24px; }
    .signup { flex-direction: column; border-radius: 16px; }
  }
</style>
</head>
<body>
<header class="top">
  <div class="wrap">
    <a class="brand" href="#inicio"><span class="mark" aria-hidden="true"></span>Quadrante</a>
    <nav class="nav" aria-label="Seções">
      <a href="#terca">Uma terça</a>
      <a href="#antes-depois">Antes e depois</a>
      <a href="#horarios">O dia inteiro</a>
    </nav>
    <a class="btn btn-primary" href="#lista">Entrar na lista</a>
  </div>
</header>

<main>
  <section class="hero" id="inicio">
    <div class="wrap">
      <div>
        <span class="eyebrow">Abre em março</span>
        <h1>Feche a agenda <span>antes do café.</span></h1>
        <p class="lede">O Quadrante confirma cada consulta por mensagem, remarca quem desmarcou e entrega a lista do dia pronta para a recepção às 7h.</p>
        <div class="actions">
          <a class="btn btn-primary" href="#lista">Quero entrar na lista</a>
          <a class="btn btn-ghost" href="#terca">Ver uma terça real</a>
        </div>
        <p class="fine">Lista de espera aberta para clínicas com até 12 profissionais.</p>
      </div>
      <div class="stage" aria-hidden="true">
        <div class="window">
          <div class="chrome"><i></i><i></i><i></i><b>terça, 14 de outubro</b></div>
          <div class="day">
            <div class="hours"><span>08:00</span><span>09:00</span><span>10:00</span><span>11:00</span><span>12:00</span></div>
            <div class="slots">
              <div class="appt a"><strong>Helena Prado</strong>Avaliação · confirmada</div>
              <div class="appt b"><strong>Otávio Reis</strong>Retorno · remarcado pelo paciente</div>
              <div class="appt c"><strong>Lia Campos</strong>Encaixe</div>
              <div class="now"></div>
              <div class="appt d"><strong>Bruno Saad</strong>Primeira consulta · confirmada</div>
            </div>
          </div>
        </div>
        <div class="chip"><strong>94%</strong> da semana confirmada<div class="bar"><i></i></div></div>
        <div class="toast"><span class="ok"></span><div><strong>Paula confirmou 10:30</strong><small>por mensagem · agora</small></div></div>
      </div>
    </div>
  </section>

  <section class="band">
    <div class="wrap">
      <div class="big">11h</div>
      <div>
        <h2>por semana voltam para o atendimento.</h2>
        <p>É o tempo que a recepção de uma clínica média passa ligando para confirmar, remarcar e caçar quem faltou. No piloto fechado, o Quadrante fez isso sozinho.</p>
      </div>
    </div>
  </section>

  <section class="day-of" id="terca">
    <div class="wrap">
      <div class="section-head">
        <span class="eyebrow">Uma terça no piloto</span>
        <h2>Quatro pessoas, nenhum telefonema.</h2>
        <p>Acompanhamos a Clínica Vila Aurora num dia comum. Cada um viu o Quadrante de um lado diferente.</p>
      </div>
      <ol class="people">
        <li class="person">
          <span class="avatar">M</span>
          <time>07:00</time>
          <h3>Marta</h3>
          <span class="role">Recepção</span>
          <p>Abriu o computador e a lista do dia já estava lá, com duas faltas avisadas e dois encaixes no lugar.</p>
        </li>
        <li class="person">
          <span class="avatar">R</span>
          <time>09:40</time>
          <h3>Dr. Rafael</h3>
          <span class="role">Fisioterapeuta</span>
          <p>Recebeu no celular o aviso de que o paciente das 10h vinha 15 minutos depois. Ajustou sem sair da sala.</p>
        </li>
        <li class="person">
          <span class="avatar">J</span>
          <time>13:15</time>
          <h3>Joana</h3>
          <span class="role">Paciente</span>
          <p>Desmarcou pelo link da mensagem e escolheu outro horário na mesma semana em menos de um minuto.</p>
        </li>
        <li class="person">
          <span class="avatar">T</span>
          <time>19:30</time>
          <h3>Teresa</h3>
          <span class="role">Dona da clínica</span>
          <p>Viu a semana com 94% dos horários confirmados antes de sair. Fechou o computador mais cedo.</p>
        </li>
      </ol>
    </div>
  </section>

  <section class="compare" id="antes-depois">
    <div class="wrap">
      <div class="section-head">
        <span class="eyebrow">Antes e depois</span>
        <h2>O mesmo dia, sem o caderno.</h2>
      </div>
      <table class="table">
        <thead><tr><th scope="col">Tarefa</th><th scope="col">Antes</th><th scope="col" class="after">Com o Quadrante</th></tr></thead>
        <tbody>
          <tr><th scope="row">Confirmar consultas</th><td>Ligação por ligação, à tarde, quando sobra tempo.</td><td class="after">Mensagem automática 24h antes, com resposta em um toque.</td></tr>
          <tr><th scope="row">Remarcar</th><td>Paciente liga, recepção procura um buraco no caderno.</td><td class="after">O paciente escolhe sozinho entre os horários livres.</td></tr>
          <tr><th scope="row">Faltas</th><td>Descobertas com a cadeira vazia.</td><td class="after">Avisadas cedo, com o horário oferecido à lista de encaixe.</td></tr>
          <tr><th scope="row">Lista do dia</th><td>Montada na hora, na correria da abertura.</td><td class="after">Pronta às 7h, já com as mudanças da noite.</td></tr>
          <tr><th scope="row">Fim do mês</th><td>Ninguém sabe quantas consultas se perderam.</td><td class="after">Relatório com faltas, remarcações e horários vazios.</td></tr>
        </tbody>
      </table>
    </div>
  </section>

  <section class="hours-cards" id="horarios">
    <div class="wrap">
      <div class="section-head">
        <span class="eyebrow">O dia inteiro</span>
        <h2>Trabalhando enquanto a clínica atende.</h2>
      </div>
      <div class="cards">
        <article class="card"><div class="sky"></div><time>06:00</time><h3>Lista pronta</h3><p>O dia chega montado, com as mudanças da madrugada.</p></article>
        <article class="card"><div class="sky"></div><time>09:00</time><h3>Atrasos avisados</h3><p>Quem vai chegar depois avisa por mensagem, e o profissional fica sabendo.</p></article>
        <article class="card"><div class="sky"></div><time>12:00</time><h3>Encaixes no almoço</h3><p>Horário que vagou vai para quem está na lista de espera.</p></article>
        <article class="card"><div class="sky"></div><time>15:00</time><h3>Confirmações de amanhã</h3><p>Cada paciente recebe a mensagem e responde com um toque.</p></article>
        <article class="card"><div class="sky"></div><time>18:00</time><h3>Remarcações</h3><p>Quem desmarcou já escolheu outro dia antes de a recepção fechar.</p></article>
        <article class="card"><div class="sky"></div><time>22:00</time><h3>Semana fechada</h3><p>Um resumo curto para quem é dono, sem precisar abrir nada.</p></article>
      </div>
    </div>
  </section>

  <section class="final" id="lista">
    <div class="wrap">
      <div class="panel">
        <div>
          <span class="eyebrow">Lista de espera</span>
          <h2>Seja uma das primeiras clínicas a abrir o Quadrante.</h2>
          <p>Abrimos em março, por ordem de inscrição. Avisamos uma vez, no dia.</p>
        </div>
        <div>
          <form class="signup" action="#lista" onsubmit="return false">
            <input id="email" type="email" placeholder="seu@email.com.br" autocomplete="email" aria-label="E-mail">
            <button class="btn btn-primary" type="submit">Entrar na lista</button>
          </form>
          <small>Sem cartão e sem spam.</small>
        </div>
      </div>
    </div>
  </section>
</main>

<footer>
  <div class="wrap"><span>© 2026 Quadrante</span><span>Página de referência fictícia · MIT</span></div>
</footer>
</body>
</html>
__X__
commit_at "2026-02-03T10:00:00-03:00" "docs: reference page for the Agenda coming-soon page"
