#!/usr/bin/env bash
# Builds, in the current directory, the static site of a small bakery that
# already has a visual identity: DESIGN.md with tokens, css/base.css exposing
# them as CSS variables, a public landing page that uses them, and an approved
# spec for a new internal screen where the counter staff manage pickup orders.
# Plain HTML/CSS, no network, no dependencies.
# Reproducible: fixed author, dates and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

commit_at() { # date, message
  git add -A
  GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git commit --quiet -m "$2"
}

git init --quiet -b main
mkdir -p css docs/devorb/specs

cat > DESIGN.md <<'__EOF__'
# Padaria Trigal — identidade visual

Fonte da verdade da identidade da Trigal. Toda tela nova usa estes tokens pelas
variáveis CSS declaradas em `css/base.css`; o nome da variável está ao lado de
cada token.

## Tokens

```yaml
cores:
  trigo: '#C8892B'        # --cor-trigo: ação principal, destaques
  forno: '#7A2E1D'        # --cor-forno: títulos
  farinha: '#FBF6EC'      # --cor-farinha: fundo da página
  miolo: '#F1E4CC'        # --cor-miolo: superfícies, faixas, linhas alternadas
  carvao: '#2B2523'       # --cor-carvao: texto
  cinza-forma: '#8A7F76'  # --cor-cinza-forma: texto secundário, bordas
  ok: '#3E7D4F'           # --cor-ok: sucesso, concluído
  atencao: '#B7791F'      # --cor-atencao: alerta, pendente
  erro: '#A63A2B'         # --cor-erro: erro, cancelado
tipografia:
  titulo: "'Fraunces', Georgia, serif"     # --fonte-titulo
  texto: "'Inter', system-ui, sans-serif"  # --fonte-texto
  escala: [0.875rem, 1rem, 1.25rem, 1.75rem, 2.5rem]  # --t-1 a --t-5
espaco: [4px, 8px, 12px, 16px, 24px, 32px, 48px]      # --e-1 a --e-7
raio:
  pequeno: 4px   # --raio-p
  medio: 10px    # --raio-m
```

## Princípios

- Calor de forno, não de vitrine: superfícies chapadas, sem gradiente e sem sombra pesada.
- Títulos em Fraunces na cor forno; texto corrido em Inter na cor carvão.
- Trigo é a cor da ação. Uma ação principal por área.
- Bordas finas em cinza-forma; cantos com raio pequeno em controles e médio em superfícies.
__EOF__

cat > css/base.css <<'__EOF__'
/* Tokens da Trigal (ver DESIGN.md). Toda página carrega este arquivo. */
:root {
  --cor-trigo: #C8892B;
  --cor-forno: #7A2E1D;
  --cor-farinha: #FBF6EC;
  --cor-miolo: #F1E4CC;
  --cor-carvao: #2B2523;
  --cor-cinza-forma: #8A7F76;
  --cor-ok: #3E7D4F;
  --cor-atencao: #B7791F;
  --cor-erro: #A63A2B;

  --fonte-titulo: 'Fraunces', Georgia, serif;
  --fonte-texto: 'Inter', system-ui, sans-serif;

  --t-1: 0.875rem;
  --t-2: 1rem;
  --t-3: 1.25rem;
  --t-4: 1.75rem;
  --t-5: 2.5rem;

  --e-1: 4px;
  --e-2: 8px;
  --e-3: 12px;
  --e-4: 16px;
  --e-5: 24px;
  --e-6: 32px;
  --e-7: 48px;

  --raio-p: 4px;
  --raio-m: 10px;
}

* { box-sizing: border-box; }

body {
  margin: 0;
  background: var(--cor-farinha);
  color: var(--cor-carvao);
  font-family: var(--fonte-texto);
  font-size: var(--t-2);
  line-height: 1.5;
}

h1, h2, h3 {
  font-family: var(--fonte-titulo);
  color: var(--cor-forno);
  line-height: 1.2;
  margin: 0 0 var(--e-3);
}
h1 { font-size: var(--t-5); }
h2 { font-size: var(--t-4); }
h3 { font-size: var(--t-3); }

a { color: var(--cor-forno); }

.botao {
  display: inline-block;
  padding: var(--e-2) var(--e-4);
  border: 1px solid var(--cor-trigo);
  border-radius: var(--raio-p);
  background: var(--cor-trigo);
  color: var(--cor-farinha);
  font: 600 var(--t-2) var(--fonte-texto);
  text-decoration: none;
  cursor: pointer;
}
.botao--secundario {
  background: transparent;
  color: var(--cor-forno);
  border-color: var(--cor-cinza-forma);
}

input, select {
  font: var(--t-2) var(--fonte-texto);
  color: var(--cor-carvao);
  background: var(--cor-farinha);
  border: 1px solid var(--cor-cinza-forma);
  border-radius: var(--raio-p);
  padding: var(--e-2) var(--e-3);
}
__EOF__

cat > css/site.css <<'__EOF__'
/* Página pública da padaria. */
.chamada {
  padding: var(--e-7) var(--e-5);
  background: var(--cor-miolo);
  text-align: center;
}
.chamada p { font-size: var(--t-3); max-width: 36rem; margin: 0 auto var(--e-5); }

.vitrine {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(14rem, 1fr));
  gap: var(--e-5);
  padding: var(--e-7) var(--e-5);
}
.produto {
  padding: var(--e-5);
  border: 1px solid var(--cor-cinza-forma);
  border-radius: var(--raio-m);
}
.produto .preco { color: var(--cor-forno); font-weight: 600; }

.rodape {
  padding: var(--e-5);
  color: var(--cor-cinza-forma);
  font-size: var(--t-1);
  text-align: center;
}
__EOF__

cat > index.html <<'__EOF__'
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Padaria Trigal</title>
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/site.css">
</head>
<body>
  <section class="chamada">
    <h1>Pão de fermentação natural, saindo do forno às 7h</h1>
    <p>Encomende o seu e retire no balcão, quentinho, na hora que combinar.</p>
    <a class="botao" href="#vitrine">Ver o cardápio</a>
  </section>

  <section class="vitrine" id="vitrine">
    <article class="produto">
      <h3>Pão italiano</h3>
      <p>Casca crocante, miolo aberto, 48 horas de fermentação.</p>
      <p class="preco">R$ 24,00</p>
    </article>
    <article class="produto">
      <h3>Focaccia de alecrim</h3>
      <p>Azeite, flor de sal e alecrim fresco.</p>
      <p class="preco">R$ 32,00</p>
    </article>
    <article class="produto">
      <h3>Bolo de fubá</h3>
      <p>Receita da casa, com erva-doce.</p>
      <p class="preco">R$ 28,00</p>
    </article>
  </section>

  <footer class="rodape">Padaria Trigal · Rua das Acácias, 120 · Seg a sáb, 7h às 19h</footer>
</body>
</html>
__EOF__
commit_at "2025-11-03T10:00:00Z" "site: identidade visual e página pública"

cat > docs/devorb/specs/2026-01-01-painel-pedidos-design.md <<'__EOF__'
# Painel de pedidos de encomenda

Aprovada pelo dono.

## Problema

As encomendas chegam por telefone e WhatsApp e hoje ficam num caderno no
balcão. Quem atende não sabe, de relance, o que precisa estar pronto na próxima
hora, o que já está pronto esperando o cliente e o que foi retirado. Cliente
chega e ninguém acha o pedido.

## Quem usa

As três atendentes do balcão, no computador do caixa, o dia inteiro, entre um
atendimento e outro. Elas consultam a tela dezenas de vezes por dia e precisam
achar um pedido em poucos segundos, com o cliente na frente.

## O que a tela precisa ter

- Todos os pedidos de encomenda, um por linha, com: número do pedido, nome do
  cliente, telefone, itens (produto e quantidade), dia e hora da retirada,
  valor total em reais e situação.
- Situações possíveis: Recebido, Em preparo, Pronto, Retirado, Cancelado.
- Filtro por situação e por dia de retirada.
- Busca pelo nome do cliente ou pelo número do pedido.
- Os pedidos atrasados (hora de retirada já passou e ainda não foram retirados)
  precisam saltar aos olhos.
- Em cada pedido, uma ação para passar à próxima situação (por exemplo, de Em
  preparo para Pronto).
- Um resumo no topo com quantos pedidos há em cada situação no dia.

## Fora do escopo agora

Login, banco de dados, servidor, cadastro e edição de pedidos. Nesta primeira
versão a tela é estática, com uns oito pedidos de exemplo escritos na própria
página, para as atendentes aprovarem o jeito antes de ligarmos no sistema.

## Critério de pronto

As atendentes abrem a tela no navegador do caixa, acham qualquer pedido de
exemplo em poucos segundos e reconhecem a tela como sendo da Trigal.
__EOF__
commit_at "2026-01-01T10:00:00Z" "docs: spec aprovada do painel de pedidos"
