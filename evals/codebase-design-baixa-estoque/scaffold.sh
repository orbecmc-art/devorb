#!/usr/bin/env bash
# Builds, in the current directory, the stock code of a small online store.
# The stock module is shallow: five tiny functions (load, check, decrement,
# log movement, save) that every caller must call in the right order, over a
# pass-through JSON wrapper, with the data paths hard-coded. Checkout follows
# the order; the exchange flow already repeats it differently (no movement
# log). Only the pure helpers have tests, since the flows write to data/.
# Tests pass. Self-contained, no network.
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
mkdir -p src test data

cat > package.json <<'__EOF__'
{ "name": "loja-estoque", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > README.md <<'__EOF__'
# Loja: estoque

Sem dependências: `npm test` roda os testes.

- `data/estoque.json`: saldo por SKU.
- `data/movimentos.json`: cada baixa de estoque, com SKU, quantidade e motivo.
- `src/arquivo.js`: lê e grava JSON em disco.
- `src/estoque.js`: funções do estoque (carregar, conferir saldo, baixar,
  registrar movimento, salvar).
- `src/checkout.js`: confirma o pedido do site e dá baixa no estoque.
__EOF__
cat > data/estoque.json <<'__EOF__'
{
  "caneca-azul": 12,
  "camiseta-p": 4,
  "camiseta-m": 0,
  "ecobag": 30
}
__EOF__
cat > data/movimentos.json <<'__EOF__'
[]
__EOF__
cat > src/arquivo.js <<'__EOF__'
// Leitura e gravação de JSON em disco.
import { readFileSync, writeFileSync } from 'node:fs';

export function lerJson(caminho) {
  return JSON.parse(readFileSync(caminho, 'utf8'));
}

export function gravarJson(caminho, dados) {
  writeFileSync(caminho, JSON.stringify(dados, null, 2) + '\n');
}
__EOF__
cat > src/estoque.js <<'__EOF__'
// Estoque da loja. Saldo por SKU em data/estoque.json; cada baixa vira uma
// linha em data/movimentos.json.
import { lerJson, gravarJson } from './arquivo.js';

const ESTOQUE = new URL('../data/estoque.json', import.meta.url);
const MOVIMENTOS = new URL('../data/movimentos.json', import.meta.url);

export function carregarEstoque() {
  return lerJson(ESTOQUE);
}

export function temSaldo(estoque, sku, qtd) {
  return (estoque[sku] ?? 0) >= qtd;
}

export function baixar(estoque, sku, qtd) {
  estoque[sku] = (estoque[sku] ?? 0) - qtd;
  return estoque;
}

export function registrarMovimento(sku, qtd, motivo) {
  const movimentos = lerJson(MOVIMENTOS);
  movimentos.push({ sku, qtd: -qtd, motivo, em: new Date().toISOString() });
  gravarJson(MOVIMENTOS, movimentos);
}

export function salvarEstoque(estoque) {
  gravarJson(ESTOQUE, estoque);
}
__EOF__
cat > src/checkout.js <<'__EOF__'
import { carregarEstoque, temSaldo, baixar, registrarMovimento, salvarEstoque } from './estoque.js';

// Ordem: carregar, conferir TODOS os itens, só então baixar e registrar cada
// um, e salvar no fim. Baixar antes de conferir deixa pedido pela metade.
export function finalizarPedido(pedido) {
  const estoque = carregarEstoque();
  for (const item of pedido.itens) {
    if (!temSaldo(estoque, item.sku, item.qtd)) throw new Error(`sem estoque: ${item.sku}`);
  }
  for (const item of pedido.itens) {
    baixar(estoque, item.sku, item.qtd);
    registrarMovimento(item.sku, item.qtd, `pedido ${pedido.id}`);
  }
  salvarEstoque(estoque);
  return { id: pedido.id, status: 'confirmado' };
}
__EOF__
cat > test/estoque.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { temSaldo, baixar } from '../src/estoque.js';

// finalizarPedido não tem teste: carrega e grava em data/ de verdade.

test('there is stock when the balance covers the quantity', () => {
  assert.equal(temSaldo({ caneca: 2 }, 'caneca', 2), true);
  assert.equal(temSaldo({ caneca: 2 }, 'caneca', 3), false);
  assert.equal(temSaldo({}, 'caneca', 1), false);
});

test('decrementing subtracts the quantity from the balance', () => {
  assert.deepEqual(baixar({ caneca: 5 }, 'caneca', 2), { caneca: 3 });
});
__EOF__
commit_at "2026-09-08T10:00:00Z" "stock: decrement on site checkout"

cat > src/troca.js <<'__EOF__'
import { carregarEstoque, temSaldo, baixar, salvarEstoque } from './estoque.js';

// Troca: o cliente devolve um item e leva outro.
export function trocarItem({ pedidoId, devolve, leva }) {
  const estoque = carregarEstoque();
  baixar(estoque, devolve.sku, -devolve.qtd); // a devolução volta para o estoque
  if (!temSaldo(estoque, leva.sku, leva.qtd)) throw new Error(`sem estoque: ${leva.sku}`);
  baixar(estoque, leva.sku, leva.qtd);
  salvarEstoque(estoque);
  return { pedidoId, status: 'trocado' };
}
__EOF__
cat >> README.md <<'__EOF__'
- `src/troca.js`: troca de item (o cliente devolve um e leva outro).
__EOF__
commit_at "2026-10-21T10:00:00Z" "stock: item exchange"
