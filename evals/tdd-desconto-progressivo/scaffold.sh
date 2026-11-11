#!/usr/bin/env bash
# Builds, in the current directory, the cart of a small online store: items,
# subtotal and a total with flat shipping, amounts in integer cents, tests
# passing, no discount yet. Self-contained, no network.
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
{ "name": "loja-carrinho", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > src/cart.js <<'__EOF__'
// Shopping cart of the online store. All amounts are integer cents.

export function createCart() {
  return { items: [] };
}

export function addItem(cart, { sku, priceCents, qty = 1 }) {
  if (!Number.isInteger(priceCents) || priceCents < 0) throw new Error(`invalid price for ${sku}`);
  if (!Number.isInteger(qty) || qty < 1) throw new Error(`invalid quantity for ${sku}`);
  const line = cart.items.find((item) => item.sku === sku);
  if (line) line.qty += qty;
  else cart.items.push({ sku, priceCents, qty });
  return cart;
}

export function removeItem(cart, sku) {
  cart.items = cart.items.filter((item) => item.sku !== sku);
  return cart;
}

export function subtotal(cart) {
  return cart.items.reduce((sum, item) => sum + item.priceCents * item.qty, 0);
}
__EOF__
cat > test/cart.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { createCart, addItem, removeItem, subtotal } from '../src/cart.js';

test('adding the same sku twice merges the quantity', () => {
  const cart = createCart();
  addItem(cart, { sku: 'caneca', priceCents: 2990 });
  addItem(cart, { sku: 'caneca', priceCents: 2990, qty: 2 });
  assert.deepEqual(cart.items, [{ sku: 'caneca', priceCents: 2990, qty: 3 }]);
});

test('subtotal sums price times quantity', () => {
  const cart = createCart();
  addItem(cart, { sku: 'caneca', priceCents: 2990, qty: 2 });
  addItem(cart, { sku: 'camiseta', priceCents: 4990 });
  assert.equal(subtotal(cart), 10970);
});

test('removing an item drops its line', () => {
  const cart = createCart();
  addItem(cart, { sku: 'caneca', priceCents: 2990 });
  addItem(cart, { sku: 'camiseta', priceCents: 4990 });
  removeItem(cart, 'caneca');
  assert.deepEqual(cart.items.map((item) => item.sku), ['camiseta']);
});

test('rejects an invalid price or quantity', () => {
  assert.throws(() => addItem(createCart(), { sku: 'x', priceCents: -1 }));
  assert.throws(() => addItem(createCart(), { sku: 'x', priceCents: 100, qty: 0 }));
});
__EOF__
commit_at "2026-09-02T10:00:00Z" "cart: items and subtotal"

cat >> src/cart.js <<'__EOF__'

export const SHIPPING_CENTS = 1990;

/** What the customer pays at checkout. */
export function total(cart) {
  return subtotal(cart) + SHIPPING_CENTS;
}
__EOF__
sed -i.bak 's/{ createCart, addItem, removeItem, subtotal }/{ createCart, addItem, removeItem, subtotal, total, SHIPPING_CENTS }/' test/cart.test.js
rm test/cart.test.js.bak
cat >> test/cart.test.js <<'__EOF__'

test('total adds flat shipping to the subtotal', () => {
  const cart = createCart();
  addItem(cart, { sku: 'caneca', priceCents: 2990, qty: 2 });
  assert.equal(total(cart), 5980 + SHIPPING_CENTS);
});
__EOF__
commit_at "2026-09-16T10:00:00Z" "cart: flat shipping in the total"
