#!/usr/bin/env bash
# Builds, in the current directory, a tiny shopping cart whose only test file
# has one failing test: the 10% coupon skips orders of exactly R$ 100 because
# the code uses > where the rule says "from R$ 100".
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main
mkdir -p src test

cat > package.json <<'__EOF__'
{ "name": "carrinho", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > src/cart.js <<'__EOF__'
// Amounts are in cents.
export function subtotal(items) {
  return items.reduce((sum, i) => sum + i.price * i.qty, 0);
}

// DEZ: 10% off orders from R$ 100.
export function applyCoupon(total, coupon) {
  if (coupon === 'DEZ' && total > 10000) return total - total / 10;
  return total;
}
__EOF__
cat > test/cart.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { subtotal, applyCoupon } from '../src/cart.js';

test('subtotal adds price times quantity', () => {
  assert.equal(subtotal([{ price: 2500, qty: 2 }, { price: 5000, qty: 1 }]), 10000);
});

test('DEZ gives 10% off from R$ 100', () => {
  assert.equal(applyCoupon(10000, 'DEZ'), 9000);
});
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-10-10T10:00:00Z GIT_COMMITTER_DATE=2026-10-10T10:00:00Z git commit --quiet -m "cart with DEZ coupon"
