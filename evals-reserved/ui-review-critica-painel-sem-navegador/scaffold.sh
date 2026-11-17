#!/usr/bin/env bash
# Builds, in the current directory, a built pricing page for a small SaaS
# (Faturô): DESIGN.md with tokens, an approved spec with a `## Direção visual`
# contract (Persuade mode, no reference pack), index.html and styles.css that use
# the tokens but have composition problems readable from code. Plain HTML/CSS,
# no network, no dependencies. Reproducible: fixed author, dates and git config.
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

cat > DESIGN.md <<'__EOF__'
# Faturô — identidade visual

Fonte da verdade da identidade do Faturô. Toda tela usa estes tokens pelas
variáveis CSS declaradas no topo de `styles.css`.

## Tokens

```yaml
cores:
  tinta: '#14213D'      # --cor-tinta: texto e títulos
  papel: '#F7F5F0'      # --cor-papel: fundo da página
  folha: '#FFFFFF'      # --cor-folha: cartões
  lima: '#7BD389'       # --cor-lima: ação principal, destaque
  musgo: '#2F6B3F'      # --cor-musgo: texto sobre fundo claro em destaque
  cinza: '#6B7280'      # --cor-cinza: texto secundário, bordas
tipografia:
  titulo: "'Space Grotesk', system-ui, sans-serif"  # --fonte-titulo
  texto: "'Inter', system-ui, sans-serif"           # --fonte-texto
  escala: [1rem, 1.25rem, 1.75rem, 2.5rem, 3.5rem]  # --t-1 a --t-5
espaco: [8px, 16px, 24px, 32px, 48px, 64px, 96px]   # --e-1 a --e-7
raio:
  medio: 12px   # --raio-m
```

## Princípios

- Confiança de contador, ritmo de startup: poucas cores, muito ar.
- Um único plano em destaque por vez, sempre em `--cor-lima`.
__EOF__

cat > docs/devorb/specs/2026-01-01-precos-design.md <<'__EOF__'
# Página de preços do Faturô

Aprovada em 2026-01-01.

## Objetivo

Levar o MEI que chegou pelo anúncio a escolher um plano e abrir a conta de
teste. Três planos: Solo (R$ 29/mês), Time (R$ 59/mês), Escala (R$ 129/mês).

## Direção visual

- **Modo:** Persuadir.
- **Referência:** nenhuma (sem pacote de referência).
- **Hierarquia:** o título da página domina; o plano Time é o recomendado e
  precisa ser o primeiro ponto de atenção depois do título. Um só botão
  principal por tela, em `--cor-lima`.
- **Escala:** título de ao menos 2,5 vezes o corpo; corpo de 16px ou mais.
  No máximo cinco tamanhos de fonte, todos da escala `--t-1` a `--t-5`.
- **Ritmo:** seções separadas por `--e-7` (96px) em cima e embaixo, cartões com
  `--e-4` de respiro interno.
- **Grid:** três colunas iguais no desktop, uma coluna no celular.
- **Momento visual:** o plano recomendado se destaca (cor, tamanho ou selo) do
  resto; as outras seções são calmas.
- **Movimento:** discreto; só estados de hover e foco, respeitando
  `prefers-reduced-motion`.
- **Cor:** só os tokens do `DESIGN.md`.
__EOF__

cat > index.html <<'__EOF__'
<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Faturô — preços</title>
<link rel="stylesheet" href="styles.css">
</head>
<body>
<header class="topo">
  <span class="marca">Faturô</span>
  <a class="entrar" href="#entrar">Entrar</a>
</header>
<section class="abertura">
  <h1>Notas fiscais sem dor de cabeça</h1>
  <p class="lead">Escolha o plano do tamanho do seu negócio. Teste 14 dias sem cartão.</p>
</section>
<section class="planos">
  <article class="plano">
    <h2>Faturô Solo</h2>
    <p class="preco">R$ 29<span>/mês</span></p>
    <p class="nota">Para quem emite poucas notas.</p>
    <ul><li>Até 30 notas por mês</li><li>1 usuário</li><li>Suporte por e-mail</li></ul>
    <a class="botao" href="#solo">Começar teste</a>
  </article>
  <article class="plano">
    <h2>Faturô Time</h2>
    <p class="preco">R$ 59<span>/mês</span></p>
    <p class="nota">Para quem já tem equipe.</p>
    <ul><li>Até 200 notas por mês</li><li>5 usuários</li><li>Suporte por chat</li></ul>
    <a class="botao" href="#time">Começar teste</a>
  </article>
  <article class="plano">
    <h2>Faturô Escala</h2>
    <p class="preco">R$ 129<span>/mês</span></p>
    <p class="nota">Para quem emite o dia todo.</p>
    <ul><li>Notas ilimitadas</li><li>Usuários ilimitados</li><li>Suporte por telefone</li></ul>
    <a class="botao" href="#escala">Começar teste</a>
  </article>
</section>
<section class="duvidas">
  <h2>Perguntas frequentes</h2>
  <p class="resp">Posso trocar de plano depois? Sim, a qualquer momento, sem multa.</p>
  <p class="resp">Preciso de cartão para testar? Não.</p>
</section>
<footer class="rodape"><small>Faturô Tecnologia Ltda. Todos os direitos reservados.</small></footer>
</body>
</html>
__EOF__

cat > styles.css <<'__EOF__'
:root {
  --cor-tinta: #14213D;
  --cor-papel: #F7F5F0;
  --cor-folha: #FFFFFF;
  --cor-lima: #7BD389;
  --cor-musgo: #2F6B3F;
  --cor-cinza: #6B7280;
  --fonte-titulo: 'Space Grotesk', system-ui, sans-serif;
  --fonte-texto: 'Inter', system-ui, sans-serif;
  --raio-m: 12px;
}
body { margin: 0; background: var(--cor-papel); color: var(--cor-tinta); font-family: var(--fonte-texto); font-size: 14px; line-height: 1.5; }
.topo { display: flex; justify-content: space-between; padding: 17px 40px; }
.marca { font-family: var(--fonte-titulo); font-size: 18px; color: var(--cor-tinta); }
.entrar { font-size: 13px; color: var(--cor-cinza); }
.abertura { padding: 37px 40px; text-align: center; }
.abertura h1 { font-family: var(--fonte-titulo); font-size: 21px; margin: 0 0 8px; }
.lead { font-size: 15px; color: var(--cor-cinza); margin: 0; }
.planos { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; padding: 52px 40px; }
.plano { background: var(--cor-folha); border: 1px solid var(--cor-cinza); border-radius: var(--raio-m); padding: 22px; }
.plano h2 { font-family: var(--fonte-titulo); font-size: 17px; margin: 0 0 6px; }
.preco { font-size: 20px; margin: 0 0 6px; }
.preco span { font-size: 12px; color: var(--cor-cinza); }
.nota { color: var(--cor-cinza); margin: 0 0 14px; }
.plano ul { padding-left: 18px; margin: 0 0 18px; }
.botao { display: inline-block; background: var(--cor-lima); color: var(--cor-tinta); padding: 9px 16px; border-radius: var(--raio-m); text-decoration: none; }
.duvidas { padding: 90px 40px; }
.duvidas h2 { font-family: var(--fonte-titulo); font-size: 18px; }
.resp { margin: 0 0 10px; }
.rodape { padding: 24px 40px; color: var(--cor-cinza); }
@media (max-width: 700px) { .planos { grid-template-columns: 1fr; } }
__EOF__

commit_at 2026-01-01T09:00:00Z "feat: pagina de precos"
