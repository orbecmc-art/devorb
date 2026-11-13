#!/usr/bin/env bash
# Builds, in the current directory, the small back office of an online store
# (orders, stock, payments) whose CONTRIBUTING.md defines the team's own
# commit message convention, and whose history follows it. One example skill
# lives in skills/rodar-testes/; skills/commit-do-time/ does
# not exist. Tests pass. Self-contained, no network.
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
mkdir -p src test skills/rodar-testes

cat > package.json <<'__EOF__'
{ "name": "loja-backoffice", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > README.md <<'__EOF__'
# Loja backoffice

Pedidos, estoque e pagamentos da loja. Sem dependências: `npm test` roda os
testes.
__EOF__
cat > skills/rodar-testes/SKILL.md <<'__EOF__'
---
name: rodar-testes
description: Use when about to say a change in this repo works, or when asked to run the tests.
---

Rode `npm test` na raiz do projeto e leia a saída inteira.

- Mostre ao usuário a linha final com `pass` e `fail`.
- Com falha, mostre o nome do teste e a mensagem de erro, e só então diga o que mudou.
- Os testes ficam em `test/`, um arquivo por pasta de `src/`.
__EOF__
cat > src/pedidos.js <<'__EOF__'
// Orders. Amounts are integer cents.

export function totalPedido(itens) {
  return itens.reduce((soma, item) => soma + item.precoCentavos * item.quantidade, 0);
}
__EOF__
cat > src/estoque.js <<'__EOF__'
// Stock levels per sku.

export function baixar(estoque, sku, quantidade) {
  const saldo = estoque[sku] ?? 0;
  if (quantidade > saldo) throw new Error(`saldo insuficiente de ${sku}`);
  estoque[sku] = saldo - quantidade;
  return estoque[sku];
}
__EOF__
cat > test/pedidos.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { totalPedido } from '../src/pedidos.js';

test('total multiplies price by quantity', () => {
  assert.equal(totalPedido([{ precoCentavos: 2990, quantidade: 2 }, { precoCentavos: 4990, quantidade: 1 }]), 10970);
});
__EOF__
cat > test/estoque.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { baixar } from '../src/estoque.js';

test('baixar lowers the stock', () => {
  assert.equal(baixar({ caneca: 5 }, 'caneca', 2), 3);
});

test('baixar refuses more than the stock', () => {
  assert.throws(() => baixar({ caneca: 1 }, 'caneca', 2), /saldo insuficiente/);
});
__EOF__
commit_at "2026-09-01T10:00:00Z" "novo(geral): cria pedidos e estoque

Primeira versão do backoffice, com o total do pedido e a baixa de
estoque, para tirar as planilhas do processo.

Ticket: LOJA-401"

cat > src/pagamentos.js <<'__EOF__'
// Payments. Amounts are integer cents.

export const TAXA_CARTAO = 0.035;

export function taxaCartao(valorCentavos) {
  return Math.round(valorCentavos * TAXA_CARTAO);
}
__EOF__
cat > test/pagamentos.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { taxaCartao } from '../src/pagamentos.js';

test('card fee is 3.5% rounded to the cent', () => {
  assert.equal(taxaCartao(10000), 350);
});
__EOF__
commit_at "2026-09-15T10:00:00Z" "novo(pagamentos): calcula a taxa do cartão

O financeiro precisa da taxa de cada venda no cartão para conciliar o
extrato da adquirente.

Ticket: LOJA-433"

cat > CONTRIBUTING.md <<'__EOF__'
# Como contribuir

## Branches

Trabalhe numa branch `<seu-nome>/<assunto>` a partir da `main` e abra um pull
request. Rode `npm test` antes de pedir revisão.

## Mensagens de commit

O time usa um padrão próprio. Formato da primeira linha:

    <tipo>(<área>): <resumo>

- `tipo` é um destes, em português: `novo` (funcionalidade), `corrige` (bug),
  `ajusta` (refatoração sem mudar comportamento), `testes`, `docs` e `infra`
  (build, CI, dependências).
- `área` é a pasta de `src/` que a mudança toca: `pedidos`, `estoque` ou
  `pagamentos`. Mudança em mais de uma área, ou fora de `src/`, usa `geral`.
- `resumo` no imperativo, em português, começando com letra minúscula e sem
  ponto final. A primeira linha inteira tem no máximo 60 caracteres.
- Depois de uma linha em branco, o corpo explica o porquê da mudança, não o
  como, em linhas de até 72 caracteres.
- A última linha é `Ticket: LOJA-<número>` quando houver ticket no Jira, ou
  `Ticket: nenhum` quando não houver.
- Sem emoji e sem `[WIP]`.

Exemplo:

    corrige(estoque): impede saldo negativo na baixa

    A baixa aceitava quantidade maior que o saldo e deixava o estoque
    negativo, o que travava o relatório de reposição.

    Ticket: LOJA-482
__EOF__
cat >> README.md <<'__EOF__'

Antes de contribuir, leia o `CONTRIBUTING.md`.
__EOF__
commit_at "2026-09-22T10:00:00Z" "docs(geral): descreve o padrão de commit do time

Cada pessoa escrevia o commit de um jeito e o histórico ficou difícil
de ler na hora de montar as notas de versão.

Ticket: nenhum"
