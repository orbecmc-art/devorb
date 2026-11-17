#!/usr/bin/env bash
# Builds, in the current directory, a tiny static project for the "Estoque"
# module of a small tool: an "Em breve" placeholder (index.html, styles.css),
# a DESIGN.md with the project's colours and font, and a local reference page
# ref/index.html (5 sections, own text, MIT) to be copied into the placeholder.
# No spec, no design/ folder.
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main
mkdir -p ref

cat > README.md <<'__EOF__'
# Módulo Estoque

Página estática do módulo Estoque. Abra `index.html` no navegador; o CSS fica em `styles.css`. Hoje é só a página "Em breve".
__EOF__
cat > DESIGN.md <<'__EOF__'
# Design do Estoque

- Cores: fundo #F7F4EE, texto #1F2A2E, destaque #0F766E (teal), botão #D9822B.
- Fonte: "Inter", sem serifa, em títulos e texto.
- Cantos arredondados de 8px.
__EOF__
cat > index.html <<'__EOF__'
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Estoque</title>
    <link rel="stylesheet" href="styles.css" />
  </head>
  <body>
    <main>
      <h1>Estoque</h1>
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
cat > ref/index.html <<'__EOF__'
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Armazém Leve</title>
    <style>
      * { box-sizing: border-box; margin: 0; }
      body { font-family: Georgia, serif; color: #222; background: #fff; line-height: 1.5; }
      section, header, footer { padding: 72px 8vw; }
      header { background: #1B3A4B; color: #fff; display: grid; grid-template-columns: 1.2fr 1fr; gap: 48px; align-items: center; }
      header h1 { font-size: 3rem; line-height: 1.1; }
      header .foto { background: #5C8AA3; height: 280px; border-radius: 24px; }
      .botao { display: inline-block; margin-top: 24px; padding: 14px 28px; background: #F2A541; color: #1B3A4B; border-radius: 999px; text-decoration: none; font-weight: bold; }
      .logos { display: flex; justify-content: space-between; gap: 24px; background: #F1F4F6; text-align: center; }
      .passos, .planos { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; }
      .cartao { border: 1px solid #D5DDE2; border-radius: 16px; padding: 28px; box-shadow: 0 6px 18px rgba(27, 58, 75, 0.08); }
      .depoimento { background: #F2A541; text-align: center; font-size: 1.5rem; }
      footer { background: #1B3A4B; color: #fff; display: flex; justify-content: space-between; }
      @media (max-width: 700px) { header, .passos, .planos { grid-template-columns: 1fr; } .logos, footer { flex-direction: column; } }
    </style>
  </head>
  <body>
    <header>
      <div>
        <h1>Saiba o que tem na prateleira, sem contar de novo</h1>
        <p>O Armazém Leve acompanha entradas e saídas e avisa quando falta produto.</p>
        <a class="botao" href="#planos">Começar grátis</a>
      </div>
      <div class="foto"></div>
    </header>
    <section class="logos"><span>Padaria Sol</span><span>Mercado Vila</span><span>Casa Verde</span><span>Doces da Lia</span></section>
    <section>
      <h2>Como funciona</h2>
      <div class="passos">
        <div class="cartao"><h3>1. Cadastre</h3><p>Importe sua lista de produtos em um minuto.</p></div>
        <div class="cartao"><h3>2. Registre</h3><p>Dê entrada e baixa pelo celular.</p></div>
        <div class="cartao"><h3>3. Receba avisos</h3><p>Alerta quando o estoque chega no mínimo.</p></div>
      </div>
    </section>
    <section class="depoimento"><p>"Parei de perder venda por falta de produto."</p><p>Lia, Doces da Lia</p></section>
    <section id="planos">
      <h2>Planos</h2>
      <div class="planos">
        <div class="cartao"><h3>Grátis</h3><p>Até 50 produtos.</p></div>
        <div class="cartao"><h3>Loja</h3><p>R$ 49 por mês, produtos ilimitados.</p></div>
        <div class="cartao"><h3>Rede</h3><p>R$ 149 por mês, várias lojas.</p></div>
      </div>
    </section>
    <footer><span>Armazém Leve</span><span>contato@armazemleve.example</span></footer>
  </body>
</html>
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-10-10T10:00:00Z GIT_COMMITTER_DATE=2026-10-10T10:00:00Z git commit --quiet -m "placeholder Em breve, DESIGN.md e pagina de referencia"
