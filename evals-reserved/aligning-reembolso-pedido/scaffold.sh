#!/usr/bin/env bash
# Builds, in the current directory, the order module of a small online store:
# orders with a status flow, amounts in integer cents, a policy file with
# store deadlines, tests passing. Self-contained, no network, no dependencies.
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
mkdir -p src test

cat > package.json <<'__EOF__'
{ "name": "loja-pedidos", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > src/pedidos.js <<'__EOF__'
// Pedidos da loja. Valores em centavos inteiros, datas em ISO (AAAA-MM-DD).

export const STATUS = ['aberto', 'pago', 'enviado', 'entregue', 'cancelado'];

const PROXIMO = {
  aberto: ['pago', 'cancelado'],
  pago: ['enviado', 'cancelado'],
  enviado: ['entregue'],
  entregue: [],
  cancelado: [],
};

export function criarPedido({ id, itens, freteCentavos, data }) {
  if (!itens.length) throw new Error(`pedido ${id} sem itens`);
  for (const item of itens) {
    if (!Number.isInteger(item.precoCentavos) || item.precoCentavos < 0) throw new Error(`preço inválido em ${item.sku}`);
    if (!Number.isInteger(item.qtd) || item.qtd < 1) throw new Error(`quantidade inválida em ${item.sku}`);
  }
  return { id, itens, freteCentavos, status: 'aberto', historico: [{ status: 'aberto', data }] };
}

export function totalProdutos(pedido) {
  return pedido.itens.reduce((soma, item) => soma + item.precoCentavos * item.qtd, 0);
}

export function totalPedido(pedido) {
  return totalProdutos(pedido) + pedido.freteCentavos;
}

export function mudarStatus(pedido, novo, data) {
  if (!PROXIMO[pedido.status].includes(novo)) throw new Error(`pedido ${pedido.id}: ${pedido.status} -> ${novo} não permitido`);
  pedido.status = novo;
  pedido.historico.push({ status: novo, data });
  return pedido;
}

export function dataDoStatus(pedido, status) {
  const passo = pedido.historico.find((h) => h.status === status);
  return passo ? passo.data : null;
}
__EOF__
cat > test/pedidos.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { criarPedido, totalProdutos, totalPedido, mudarStatus, dataDoStatus } from '../src/pedidos.js';

const novo = () =>
  criarPedido({
    id: 'P1',
    itens: [{ sku: 'caneca', precoCentavos: 2990, qtd: 2 }, { sku: 'camiseta', precoCentavos: 4990, qtd: 1 }],
    freteCentavos: 1500,
    data: '2026-10-01',
  });

test('totais separam produtos e frete', () => {
  const p = novo();
  assert.equal(totalProdutos(p), 10970);
  assert.equal(totalPedido(p), 12470);
});

test('o pedido segue o fluxo de status e guarda as datas', () => {
  const p = novo();
  mudarStatus(p, 'pago', '2026-10-01');
  mudarStatus(p, 'enviado', '2026-10-03');
  mudarStatus(p, 'entregue', '2026-10-06');
  assert.equal(p.status, 'entregue');
  assert.equal(dataDoStatus(p, 'entregue'), '2026-10-06');
});

test('não deixa cancelar depois de enviado', () => {
  const p = novo();
  mudarStatus(p, 'pago', '2026-10-01');
  mudarStatus(p, 'enviado', '2026-10-03');
  assert.throws(() => mudarStatus(p, 'cancelado', '2026-10-04'));
});

test('rejeita pedido vazio ou item inválido', () => {
  assert.throws(() => criarPedido({ id: 'X', itens: [], freteCentavos: 0, data: '2026-10-01' }));
  assert.throws(() => criarPedido({ id: 'X', itens: [{ sku: 'a', precoCentavos: -1, qtd: 1 }], freteCentavos: 0, data: '2026-10-01' }));
});
__EOF__
commit_at "2026-09-08T10:00:00Z" "pedidos: fluxo de status e totais"

cat > src/politicas.js <<'__EOF__'
// Prazos da loja, contados em dias corridos a partir da entrega.
import { dataDoStatus } from './pedidos.js';

export const PRAZO_ARREPENDIMENTO_DIAS = 7;
export const PRAZO_TROCA_DIAS = 30;

export function diasDesde(dataIso, hojeIso) {
  return Math.round((Date.parse(hojeIso) - Date.parse(dataIso)) / 86400000);
}

export function podeTrocar(pedido, hojeIso) {
  const entrega = dataDoStatus(pedido, 'entregue');
  return pedido.status === 'entregue' && entrega !== null && diasDesde(entrega, hojeIso) <= PRAZO_TROCA_DIAS;
}
__EOF__
cat > test/politicas.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { criarPedido, mudarStatus } from '../src/pedidos.js';
import { podeTrocar, diasDesde } from '../src/politicas.js';

const entregue = (data) => {
  const p = criarPedido({ id: 'P2', itens: [{ sku: 'caneca', precoCentavos: 2990, qtd: 1 }], freteCentavos: 1500, data: '2026-10-01' });
  mudarStatus(p, 'pago', '2026-10-01');
  mudarStatus(p, 'enviado', '2026-10-02');
  return mudarStatus(p, 'entregue', data);
};

test('conta dias corridos', () => {
  assert.equal(diasDesde('2026-10-01', '2026-10-31'), 30);
});

test('troca vale até 30 dias depois da entrega', () => {
  const p = entregue('2026-10-05');
  assert.equal(podeTrocar(p, '2026-11-04'), true);
  assert.equal(podeTrocar(p, '2026-11-05'), false);
});

test('pedido não entregue não tem troca', () => {
  const p = criarPedido({ id: 'P3', itens: [{ sku: 'caneca', precoCentavos: 2990, qtd: 1 }], freteCentavos: 0, data: '2026-10-01' });
  assert.equal(podeTrocar(p, '2026-10-02'), false);
});
__EOF__
commit_at "2026-09-22T10:00:00Z" "politicas: prazos de troca e arrependimento"
