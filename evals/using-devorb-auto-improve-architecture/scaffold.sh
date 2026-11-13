#!/usr/bin/env bash
# Builds, in the current directory, a small order service whose price, stock and
# notification logic call each other across files, with a short history of fixes
# that kept touching the same places.
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main
mkdir -p src test
cat > package.json <<'__EOF__'
{ "name": "pedidos", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > src/db.js <<'__EOF__'
export const db = { products: { cafe: { price: 20, stock: 5 } }, orders: [] };
__EOF__
cat > src/price.js <<'__EOF__'
import { db } from './db.js';
import { notify } from './notify.js';

export function price(order) {
  let total = 0;
  for (const item of order.items) {
    const p = db.products[item.sku];
    if (p.stock < item.qty) notify('estoque baixo: ' + item.sku);
    total += p.price * item.qty;
  }
  if (order.coupon === 'DEZ') total *= 0.9;
  return total;
}
__EOF__
cat > src/notify.js <<'__EOF__'
import { db } from './db.js';

export function notify(msg) {
  db.orders.push({ log: msg });
  console.log(msg);
}
__EOF__
cat > src/order.js <<'__EOF__'
import { db } from './db.js';
import { price } from './price.js';
import { notify } from './notify.js';

export function placeOrder(order) {
  const total = price(order);
  for (const item of order.items) db.products[item.sku].stock -= item.qty;
  db.orders.push({ ...order, total });
  notify('pedido criado: ' + total);
  return total;
}
__EOF__
cat > test/order.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { placeOrder } from '../src/order.js';

test('places an order with the coupon', () => {
  assert.equal(placeOrder({ items: [{ sku: 'cafe', qty: 1 }], coupon: 'DEZ' }), 18);
});
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-10-01T10:00:00Z GIT_COMMITTER_DATE=2026-10-01T10:00:00Z git commit --quiet -m "orders with coupon"
echo '// fix: stock check' >> src/price.js
echo '// fix: log order' >> src/notify.js
git add -A
GIT_AUTHOR_DATE=2026-10-08T10:00:00Z GIT_COMMITTER_DATE=2026-10-08T10:00:00Z git commit --quiet -m "fix stock warning breaking the order log"
echo '// fix: coupon after stock' >> src/price.js
echo '// fix: stock decrement' >> src/order.js
git add -A
GIT_AUTHOR_DATE=2026-10-15T10:00:00Z GIT_COMMITTER_DATE=2026-10-15T10:00:00Z git commit --quiet -m "fix coupon broken by the stock fix"
