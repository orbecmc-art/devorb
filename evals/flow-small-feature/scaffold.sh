#!/usr/bin/env bash
# Builds, in the current directory, a small Node store with no dependencies:
# src/pedidos.js lists orders from data/pedidos.json, src/cli.js prints them,
# tests pass. The user will ask for a CSV export of the order list and let the
# agent start without questions, so the whole flow (align, plan, implement,
# finish) has to run. Self-contained, no network. Reproducible: fixed author,
# dates and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

commit_at() { # date, message
  git add -A
  GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git commit --quiet -m "$2"
}

git init --quiet -b main
mkdir -p src test data

cat > package.json <<'__X__'
{ "name": "loja-pedidos", "private": true, "type": "module", "scripts": { "test": "node --test", "pedidos": "node src/cli.js" } }
__X__
cat > README.md <<'__X__'
# Loja: pedidos

Lista os pedidos da loja, guardados em `data/pedidos.json`. Valores em
centavos. `npm run pedidos` imprime a lista; `npm test` roda os testes. Sem
dependências.
__X__
cat > data/pedidos.json <<'__X__'
[
  { "id": 101, "cliente": "Ana Souza", "data": "2026-11-03", "status": "pago", "itens": [{ "sku": "CAF-250", "qtd": 2, "precoCentavos": 3490 }] },
  { "id": 102, "cliente": "Bruno Lima, Jr.", "data": "2026-11-04", "status": "enviado", "itens": [{ "sku": "XIC-01", "qtd": 1, "precoCentavos": 5900 }, { "sku": "CAF-500", "qtd": 1, "precoCentavos": 6290 }] },
  { "id": 103, "cliente": "Carla \"Cacá\" Mendes", "data": "2026-11-05", "status": "cancelado", "itens": [{ "sku": "FIL-100", "qtd": 3, "precoCentavos": 1290 }] }
]
__X__
cat > src/pedidos.js <<'__X__'
import { readFileSync } from 'node:fs';

export function carregarPedidos(caminho = new URL('../data/pedidos.json', import.meta.url)) {
  return JSON.parse(readFileSync(caminho, 'utf8'));
}

export function totalCentavos(pedido) {
  return pedido.itens.reduce((soma, item) => soma + item.qtd * item.precoCentavos, 0);
}

export function listarPedidos(pedidos, { status } = {}) {
  return pedidos
    .filter((p) => !status || p.status === status)
    .map((p) => ({ id: p.id, cliente: p.cliente, data: p.data, status: p.status, totalCentavos: totalCentavos(p) }));
}
__X__
cat > src/cli.js <<'__X__'
import { carregarPedidos, listarPedidos } from './pedidos.js';

const reais = (centavos) => (centavos / 100).toFixed(2).replace('.', ',');
const [, , filtro] = process.argv;

for (const p of listarPedidos(carregarPedidos(), { status: filtro })) {
  console.log(`#${p.id}  ${p.data}  ${p.cliente.padEnd(24)}  ${p.status.padEnd(10)}  R$ ${reais(p.totalCentavos)}`);
}
__X__
cat > test/pedidos.test.js <<'__X__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { listarPedidos, totalCentavos } from '../src/pedidos.js';

const pedidos = [
  { id: 1, cliente: 'Ana', data: '2026-11-01', status: 'pago', itens: [{ sku: 'A', qtd: 2, precoCentavos: 500 }] },
  { id: 2, cliente: 'Bia', data: '2026-11-02', status: 'cancelado', itens: [{ sku: 'B', qtd: 1, precoCentavos: 700 }] },
];

test('total soma quantidade vezes preço', () => {
  assert.equal(totalCentavos(pedidos[0]), 1000);
});

test('lista filtra por status', () => {
  assert.deepEqual(listarPedidos(pedidos, { status: 'pago' }).map((p) => p.id), [1]);
  assert.equal(listarPedidos(pedidos).length, 2);
});
__X__
commit_at "2026-11-06T10:00:00-03:00" "feat: lista de pedidos na linha de comando"
