#!/usr/bin/env bash
# Builds, in the current (empty) folder, a small Node project (no dependencies,
# `node --test`) that splits a purchase total into installments, with a git
# history of three commits plus an uncommitted change in the working tree.
# No network. Fixed author and dates. Compatible with bash 3.2.
set -eu

export GIT_AUTHOR_NAME="Fixture Author" GIT_AUTHOR_EMAIL="fixture@example.invalid"
export GIT_COMMITTER_NAME="Fixture Author" GIT_COMMITTER_EMAIL="fixture@example.invalid"
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

commit_all() { # $1 = date, $2 = message
  git add -A -- .
  GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git -c core.autocrlf=false -c commit.gpgsign=false commit -q -m "$2"
}

git init -q
git symbolic-ref HEAD refs/heads/main
git config core.autocrlf false
git config commit.gpgsign false

mkdir -p src test

# ------------------------------------------------------------------ commit 1
cat > package.json <<'EOF'
{
  "name": "loja-parcelamento",
  "private": true,
  "type": "module",
  "scripts": {
    "test": "node --test"
  }
}
EOF

cat > README.md <<'EOF'
# loja-parcelamento

Cálculo das parcelas mostradas no checkout da loja. Todos os valores são em
centavos (inteiros).

- `src/dinheiro.js`: soma e formatação em reais.
- `src/parcelas.js`: divide o total da compra em parcelas.

Testes: `npm test`.
EOF

cat > src/dinheiro.js <<'EOF'
// Valores em centavos (inteiros) para não perder centavo com ponto flutuante.

export function soma(valores) {
  return valores.reduce((acc, v) => acc + v, 0);
}

export function formatar(centavos) {
  const reais = String(Math.floor(centavos / 100)).replace(/\B(?=(\d{3})+(?!\d))/g, '.');
  const resto = String(centavos % 100).padStart(2, '0');
  return `R$ ${reais},${resto}`;
}
EOF

cat > src/parcelas.js <<'EOF'
/**
 * Divide o total da compra (em centavos) em `n` parcelas, também em centavos.
 * A soma das parcelas tem de ser igual ao total.
 */
export function parcelar(totalCentavos, n) {
  if (!Number.isInteger(totalCentavos) || totalCentavos < 0) {
    throw new RangeError('total inválido');
  }
  if (!Number.isInteger(n) || n < 1) {
    throw new RangeError('número de parcelas inválido');
  }
  const parcela = Math.round(totalCentavos / n);
  return Array(n).fill(parcela);
}
EOF

cat > test/dinheiro.test.js <<'EOF'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { formatar, soma } from '../src/dinheiro.js';

test('formata centavos em reais', () => {
  assert.equal(formatar(10000), 'R$ 100,00');
  assert.equal(formatar(3333), 'R$ 33,33');
  assert.equal(formatar(123456), 'R$ 1.234,56');
  assert.equal(formatar(5), 'R$ 0,05');
});

test('soma valores em centavos', () => {
  assert.equal(soma([3334, 3333, 3333]), 10000);
  assert.equal(soma([]), 0);
});
EOF

cat > test/parcelas.test.js <<'EOF'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { parcelar } from '../src/parcelas.js';

test('valor redondo sai em parcelas iguais', () => {
  assert.deepEqual(parcelar(9000, 3), [3000, 3000, 3000]);
});

test('devolve uma parcela por mês pedido', () => {
  assert.equal(parcelar(15990, 10).length, 10);
});

test('recusa número de parcelas inválido', () => {
  assert.throws(() => parcelar(10000, 0), RangeError);
});
EOF
commit_all "2026-08-04T14:00:00-03:00" "parcelamento: divide o total da compra em parcelas"

# ------------------------------------------------------------------ commit 2
cat > test/parcelas.test.js <<'EOF'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { parcelar } from '../src/parcelas.js';
import { soma } from '../src/dinheiro.js';

test('valor redondo sai em parcelas iguais', () => {
  assert.deepEqual(parcelar(9000, 3), [3000, 3000, 3000]);
});

test('devolve uma parcela por mês pedido', () => {
  assert.equal(parcelar(15990, 10).length, 10);
});

test('recusa número de parcelas inválido', () => {
  assert.throws(() => parcelar(10000, 0), RangeError);
});

// FIN-212: pulado até corrigirem o arredondamento das parcelas.
test.skip('a soma das parcelas sempre bate com o total', () => {
  for (const total of [10000, 9990, 4999, 15990]) {
    for (let n = 1; n <= 12; n++) {
      assert.equal(soma(parcelar(total, n)), total, `${total} em ${n}x`);
    }
  }
});
EOF
commit_all "2026-09-10T10:30:00-03:00" "test: cobre a soma das parcelas (pulado até o FIN-212)"

# ------------------------------------------------------------------ commit 3
mkdir -p testes
git mv test/dinheiro.test.js testes/dinheiro.spec.js
git mv test/parcelas.test.js testes/parcelas.spec.js
rmdir test 2>/dev/null || true
cat > README.md <<'EOF'
# loja-parcelamento

Cálculo das parcelas mostradas no checkout da loja. Todos os valores são em
centavos (inteiros).

- `src/dinheiro.js`: soma e formatação em reais.
- `src/parcelas.js`: divide o total da compra em parcelas.

Testes ficam em `testes/`, com o sufixo `.spec.js` (padrão do time).
Para rodar: `npm test`.
EOF
commit_all "2026-10-20T16:15:00-03:00" "chore: testes em testes/ com sufixo .spec.js (padrão do time)"

# ------------------------------------------- uncommitted change by the user
cat > src/parcelas.js <<'EOF'
/**
 * Divide o total da compra (em centavos) em `n` parcelas, também em centavos.
 * A soma das parcelas tem de ser igual ao total.
 */
export function parcelar(totalCentavos, n) {
  if (!Number.isInteger(totalCentavos) || totalCentavos < 0) {
    throw new RangeError('total inválido');
  }
  if (!Number.isInteger(n) || n < 1) {
    throw new RangeError('número de parcelas inválido');
  }
  const parcela = Math.floor(totalCentavos / n);
  const parcelas = Array(n).fill(parcela);
  // A soma ficava 1 centavo abaixo do total (ex.: R$ 100,00 em 3x):
  // a primeira parcela leva a diferença.
  if (parcela * n < totalCentavos) parcelas[0] += 1;
  return parcelas;
}
EOF

cat >> testes/parcelas.spec.js <<'EOF'

test('R$ 100,00 em 3x: a primeira parcela leva o centavo que faltava', () => {
  assert.deepEqual(parcelar(10000, 3), [3334, 3333, 3333]);
});
EOF
