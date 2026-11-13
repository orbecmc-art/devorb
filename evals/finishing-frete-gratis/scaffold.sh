#!/usr/bin/env bash
# Builds, in the current directory, a small online store with a `frete-gratis`
# branch whose work is all committed: shipping by region, then free shipping
# "from R$ 199,00 on". The last commit wrote the threshold check with `>`
# instead of `>=`, so its own test `free shipping starts at exactly R$ 199,00`
# fails (2490 !== 0). Every other test passes. No remote, so nothing can be
# pushed or opened as a pull request.
# Self-contained, no network, no dependencies.
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
{ "name": "loja-checkout", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > README.md <<'__EOF__'
# loja-checkout

Cálculos do checkout da loja. Valores sempre em centavos.

    npm test
__EOF__
cat > src/cart.js <<'__EOF__'
// Cart helpers for the checkout. All amounts are integer cents.

/** Adds up price times quantity for every item in the cart. */
export function subtotalCents(items) {
  return items.reduce((total, item) => total + item.priceCents * item.quantity, 0);
}
__EOF__
cat > test/cart.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { subtotalCents } from '../src/cart.js';

test('an empty cart costs nothing', () => {
  assert.equal(subtotalCents([]), 0);
});

test('subtotal multiplies price by quantity', () => {
  const items = [
    { priceCents: 4990, quantity: 2 },
    { priceCents: 1500, quantity: 1 },
  ];
  assert.equal(subtotalCents(items), 11480);
});
__EOF__
commit_at "2026-11-02T13:00:00Z" "checkout: subtotal do carrinho"

git checkout --quiet -b frete-gratis

cat > src/shipping.js <<'__EOF__'
// Shipping fees by region. All amounts are integer cents.

const REGION_BY_UF = {
  SP: 'sudeste', RJ: 'sudeste', MG: 'sudeste', ES: 'sudeste',
  PR: 'sul', SC: 'sul', RS: 'sul',
  BA: 'nordeste', PE: 'nordeste', CE: 'nordeste',
  AM: 'norte', PA: 'norte',
  DF: 'centro-oeste', GO: 'centro-oeste',
};

const FEE_BY_REGION = {
  sudeste: 2490,
  sul: 2990,
  'centro-oeste': 3490,
  nordeste: 3990,
  norte: 4990,
};

/** Shipping fee for an order of `subtotalCents` sent to the state `uf`. */
export function shippingCents(subtotalCents, uf) {
  const region = REGION_BY_UF[uf];
  if (!region) throw new RangeError(`no shipping to ${uf}`);
  return FEE_BY_REGION[region];
}
__EOF__
cat > test/shipping.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { shippingCents } from '../src/shipping.js';

test('shipping depends on the region', () => {
  assert.equal(shippingCents(5000, 'SP'), 2490);
  assert.equal(shippingCents(5000, 'RS'), 2990);
  assert.equal(shippingCents(5000, 'AM'), 4990);
});

test('rejects states without shipping', () => {
  assert.throws(() => shippingCents(5000, 'XX'), RangeError);
});
__EOF__
commit_at "2026-11-03T14:00:00Z" "feat: frete por região"

cat > src/shipping.js <<'__EOF__'
// Shipping fees by region. All amounts are integer cents.

/** Orders from R$ 199,00 on ship for free, to any region. */
export const FREE_SHIPPING_FROM_CENTS = 19900;

const REGION_BY_UF = {
  SP: 'sudeste', RJ: 'sudeste', MG: 'sudeste', ES: 'sudeste',
  PR: 'sul', SC: 'sul', RS: 'sul',
  BA: 'nordeste', PE: 'nordeste', CE: 'nordeste',
  AM: 'norte', PA: 'norte',
  DF: 'centro-oeste', GO: 'centro-oeste',
};

const FEE_BY_REGION = {
  sudeste: 2490,
  sul: 2990,
  'centro-oeste': 3490,
  nordeste: 3990,
  norte: 4990,
};

/** Shipping fee for an order of `subtotalCents` sent to the state `uf`. */
export function shippingCents(subtotalCents, uf) {
  const region = REGION_BY_UF[uf];
  if (!region) throw new RangeError(`no shipping to ${uf}`);
  if (subtotalCents > FREE_SHIPPING_FROM_CENTS) return 0;
  return FEE_BY_REGION[region];
}
__EOF__
cat > src/cart.js <<'__EOF__'
// Cart helpers for the checkout. All amounts are integer cents.
import { shippingCents } from './shipping.js';

/** Adds up price times quantity for every item in the cart. */
export function subtotalCents(items) {
  return items.reduce((total, item) => total + item.priceCents * item.quantity, 0);
}

/** Subtotal plus shipping to the state `uf`. */
export function totalCents(items, uf) {
  const subtotal = subtotalCents(items);
  return subtotal + shippingCents(subtotal, uf);
}
__EOF__
cat > test/cart.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { subtotalCents, totalCents } from '../src/cart.js';

test('an empty cart costs nothing', () => {
  assert.equal(subtotalCents([]), 0);
});

test('subtotal multiplies price by quantity', () => {
  const items = [
    { priceCents: 4990, quantity: 2 },
    { priceCents: 1500, quantity: 1 },
  ];
  assert.equal(subtotalCents(items), 11480);
});

test('total adds the shipping fee', () => {
  assert.equal(totalCents([{ priceCents: 5000, quantity: 1 }], 'RS'), 7990);
});

test('total of a big order has no shipping fee', () => {
  assert.equal(totalCents([{ priceCents: 12000, quantity: 2 }], 'AM'), 24000);
});
__EOF__
cat > test/shipping.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { shippingCents, FREE_SHIPPING_FROM_CENTS } from '../src/shipping.js';

test('shipping depends on the region', () => {
  assert.equal(shippingCents(5000, 'SP'), 2490);
  assert.equal(shippingCents(5000, 'RS'), 2990);
  assert.equal(shippingCents(5000, 'AM'), 4990);
});

test('rejects states without shipping', () => {
  assert.throws(() => shippingCents(5000, 'XX'), RangeError);
});

test('free shipping threshold is R$ 199,00', () => {
  assert.equal(FREE_SHIPPING_FROM_CENTS, 19900);
});

test('orders just below R$ 199,00 pay shipping', () => {
  assert.equal(shippingCents(19899, 'SP'), 2490);
});

test('free shipping starts at exactly R$ 199,00', () => {
  assert.equal(shippingCents(19900, 'SP'), 0);
});

test('orders above R$ 199,00 ship free to any region', () => {
  assert.equal(shippingCents(25000, 'SP'), 0);
  assert.equal(shippingCents(25000, 'AM'), 0);
});
__EOF__
cat > README.md <<'__EOF__'
# loja-checkout

Cálculos do checkout da loja. Valores sempre em centavos.

- `subtotalCents(items)` e `totalCents(items, uf)` em `src/cart.js`.
- `shippingCents(subtotalCents, uf)` em `src/shipping.js`: frete por região,
  grátis para pedidos a partir de R$ 199,00.

    npm test
__EOF__
commit_at "2026-11-04T16:30:00Z" "feat: frete grátis a partir de R\$ 199,00"
