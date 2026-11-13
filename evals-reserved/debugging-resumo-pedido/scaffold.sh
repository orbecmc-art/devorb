#!/usr/bin/env bash
# Builds, in the current (empty) folder, a small Node project (no dependencies,
# `node --test`) with a git history of two commits. The second commit leaves one
# test failing. No network. Fixed author and dates. Compatible with bash 3.2.
set -eu

export GIT_AUTHOR_NAME="Fixture Author" GIT_AUTHOR_EMAIL="fixture@example.invalid"
export GIT_COMMITTER_NAME="Fixture Author" GIT_COMMITTER_EMAIL="fixture@example.invalid"
export GIT_CONFIG_NOSYSTEM=1

commit_all() { # $1 = date, $2 = message
  git add -A -- .
  GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git -c core.autocrlf=false -c commit.gpgsign=false commit -q -m "$2"
}

git init -q
git symbolic-ref HEAD refs/heads/main
git config core.autocrlf false
git config user.name "Fixture Author"
git config user.email "fixture@example.invalid"
git config commit.gpgsign false

mkdir -p src test

# ------------------------------------------------------------------ commit 1
cat > package.json <<'EOF'
{
  "name": "loja-pedidos",
  "private": true,
  "type": "module",
  "scripts": {
    "test": "node --test"
  }
}
EOF

cat > README.md <<'EOF'
# loja-pedidos

Resumo do pedido, formatação de preço e cotação de frete da loja.

Sem dependências. Testes: `npm test` (usa `node --test`).
EOF

cat > src/memo.js <<'EOF'
// Cache em memória para funções puras chamadas muitas vezes com os mesmos valores.
// A chave usa só os parâmetros que a função declara (fn.length). Assim a função
// memoizada pode ir direto para .map() sem que o índice e o array entrem na chave.
export function memoize(fn) {
  const cache = new Map();
  return function memoized(...args) {
    const key = JSON.stringify(args.slice(0, fn.length));
    if (!cache.has(key)) cache.set(key, fn(...args));
    return cache.get(key);
  };
}
EOF

cat > src/preco.js <<'EOF'
import { memoize } from './memo.js';

// Chamada para cada linha de cada pedido na listagem do painel, por isso fica em cache.
export const formatPrice = memoize(function formatPrice(cents) {
  const [inteiro, decimal] = (cents / 100).toFixed(2).split('.');
  const milhar = inteiro.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
  return `R$ ${milhar},${decimal}`;
});
EOF

cat > src/resumo.js <<'EOF'
import { formatPrice } from './preco.js';

export function resumoDoPedido(itens) {
  return itens
    .map((item) => `${item.nome} x${item.qtd}: ${formatPrice(item.precoCentavos * item.qtd)}`)
    .join('\n');
}
EOF

cat > src/frete.js <<'EOF'
import { memoize } from './memo.js';

// Valor base por região (primeiro dígito do CEP), em centavos, para até 1 kg.
const BASE = { 0: 1500, 1: 1700, 2: 2200, 3: 2400, 4: 2900, 5: 3100, 6: 3400, 7: 2600, 8: 2300, 9: 2500 };
const POR_KG_EXTRA = 450;

export const cotarFrete = memoize(function cotarFrete(cep, pesoKg = 1) {
  const regiao = cep.replace(/\D/g, '')[0];
  const extra = Math.max(0, Math.ceil(pesoKg) - 1) * POR_KG_EXTRA;
  return BASE[regiao] + extra;
});
EOF

cat > test/memo.test.js <<'EOF'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { memoize } from '../src/memo.js';

test('chama a função uma vez para os mesmos argumentos', () => {
  let chamadas = 0;
  const dobro = memoize((n) => {
    chamadas++;
    return n * 2;
  });
  assert.equal(dobro(4), 8);
  assert.equal(dobro(4), 8);
  assert.equal(dobro(5), 10);
  assert.equal(chamadas, 2);
});
EOF

cat > test/preco.test.js <<'EOF'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { formatPrice } from '../src/preco.js';

test('formata centavos em reais com separador de milhar', () => {
  assert.equal(formatPrice(123456), 'R$ 1.234,56');
});

test('formata valores pequenos', () => {
  assert.equal(formatPrice(5), 'R$ 0,05');
});
EOF

cat > test/resumo.test.js <<'EOF'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { resumoDoPedido } from '../src/resumo.js';

test('lista cada item com quantidade e total da linha', () => {
  const texto = resumoDoPedido([
    { nome: 'Camiseta', qtd: 2, precoCentavos: 4990 },
    { nome: 'Boné', qtd: 1, precoCentavos: 3500 },
  ]);
  assert.equal(texto, 'Camiseta x2: R$ 99,80\nBoné x1: R$ 35,00');
});
EOF

cat > test/frete.test.js <<'EOF'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { cotarFrete } from '../src/frete.js';

test('cota até 1 kg pelo valor base da região', () => {
  assert.equal(cotarFrete('01310-100'), 1500);
});

test('cobra cada kg extra', () => {
  assert.equal(cotarFrete('20040-020', 3), 3100);
});
EOF

commit_all '2026-09-02T14:00:00+0000' 'feat: resumo do pedido, preço e frete'

# ------------------------------------------------------------------ commit 2
cat > src/preco.js <<'EOF'
import { memoize } from './memo.js';

const SIMBOLO = { BRL: 'R$', USD: 'US$' };

// Chamada para cada linha de cada pedido na listagem do painel, por isso fica em cache.
export const formatPrice = memoize(function formatPrice(cents, currency = 'BRL') {
  const [inteiro, decimal] = (cents / 100).toFixed(2).split('.');
  const milhar = inteiro.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
  return `${SIMBOLO[currency]} ${milhar},${decimal}`;
});
EOF

cat > src/resumo.js <<'EOF'
import { formatPrice } from './preco.js';

export function resumoDoPedido(itens) {
  return itens
    .map((item) => `${item.nome} x${item.qtd}: ${formatPrice(item.precoCentavos * item.qtd, item.moeda)}`)
    .join('\n');
}
EOF

cat >> test/preco.test.js <<'EOF'

test('formata preço em dólar', () => {
  assert.equal(formatPrice(2599, 'USD'), 'US$ 25,99');
});
EOF

cat >> test/resumo.test.js <<'EOF'

test('mostra cada item na moeda do produto', () => {
  const texto = resumoDoPedido([
    { nome: 'Chaveiro', qtd: 1, precoCentavos: 1000 },
    { nome: 'Caneca importada', qtd: 1, precoCentavos: 1000, moeda: 'USD' },
  ]);
  assert.equal(texto, 'Chaveiro x1: R$ 10,00\nCaneca importada x1: US$ 10,00');
});
EOF

commit_all '2026-10-20T18:30:00+0000' 'feat: produtos importados com preço em dólar'
