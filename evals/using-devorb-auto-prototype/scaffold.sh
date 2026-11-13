#!/usr/bin/env bash
# Builds, in the current directory, a tiny store checkout whose shipping is a flat
# fee, where the owner wants to try a new shipping rule before changing it.
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main
mkdir -p src test
cat > package.json <<'__EOF__'
{ "name": "loja", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > README.md <<'__EOF__'
# loja

Checkout da loja. O frete hoje é fixo em R$ 15.
__EOF__
cat > src/shipping.js <<'__EOF__'
export function shipping(cart) {
  return 15;
}
__EOF__
cat > src/checkout.js <<'__EOF__'
import { shipping } from './shipping.js';

export function checkout(cart) {
  const subtotal = cart.items.reduce((sum, i) => sum + i.price * i.qty, 0);
  return { subtotal, shipping: shipping(cart), total: subtotal + shipping(cart) };
}
__EOF__
cat > test/checkout.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { checkout } from '../src/checkout.js';

test('adds the flat shipping', () => {
  assert.equal(checkout({ items: [{ price: 50, qty: 2 }], cep: '01001-000' }).total, 115);
});
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-10-10T10:00:00Z GIT_COMMITTER_DATE=2026-10-10T10:00:00Z git commit --quiet -m "checkout with flat shipping"
