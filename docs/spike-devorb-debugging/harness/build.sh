#!/usr/bin/env bash
# Builds the throwaway bug repo used to compare debugging skills.
set -e
C="$1"
rm -rf "$C"; mkdir -p "$C/fixture/src" "$C/fixture/test" "$C/hidden"
cd "$C/fixture"
G='git -c user.name=fixture -c user.email=fixture@example.invalid'
T='Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>'
git init -q -b main

cat > package.json <<'__EOF__'
{ "name": "payments-demo", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > src/gateway.js <<'__EOF__'
const delay = (ms) => new Promise((r) => setTimeout(r, ms));

export async function charge(amount) {
  await delay(Math.random() * 10);
  return { ok: amount > 0 };
}
__EOF__
cat > src/audit.js <<'__EOF__'
const delay = (ms) => new Promise((r) => setTimeout(r, ms));
const events = [];

export async function log(event) {
  await delay(Math.random() * 30);
  events.push(event);
}
__EOF__
cat > src/payments.js <<'__EOF__'
import * as store from './store.js';
import * as gateway from './gateway.js';
import * as audit from './audit.js';

/**
 * Charges the payment. Resolves once it is settled: callers can read the
 * final status with getPayment() as soon as this resolves.
 */
export async function processPayment({ id, amount }) {
  store.insert({ id, amount, status: 'pending' });
  const result = await gateway.charge(amount);
  store.update(id, { status: result.ok ? 'completed' : 'failed' });
  await audit.log({ type: 'payment.processed', id });
}

export function getPayment(id) {
  return store.get(id);
}
__EOF__
cat > src/refunds.js <<'__EOF__'
import * as store from './store.js';
import * as audit from './audit.js';

/** Refunds a settled payment and returns its final state. */
export async function refundPayment(id) {
  store.update(id, { status: 'refunded' });
  await audit.log({ type: 'payment.refunded', id });
  const { status, amount } = store.get(id);
  return { status, amount };
}
__EOF__
cat > src/store.js <<'__EOF__'
// In-memory payment store.
const records = new Map();

export function insert(record) {
  records.set(record.id, { ...record });
}

export function update(id, patch) {
  records.set(id, { ...records.get(id), ...patch });
}

export function get(id) {
  const record = records.get(id);
  return record ? { ...record } : undefined;
}
__EOF__
cat > test/payment-processing.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { processPayment, getPayment } from '../src/payments.js';

test('payment is completed once processPayment resolves', async () => {
  await processPayment({ id: 'p1', amount: 100 });
  const { status, amount } = getPayment('p1');
  assert.deepEqual({ status, amount }, { status: 'completed', amount: 100 });
});
__EOF__
git add -A; $G commit -q -m "payments, refunds and in-memory store" -m "$T"

cat > src/store.js <<'__EOF__'
// In-memory payment store.
// Updates are batched and applied on a timer to reduce write load on the database.
const committed = new Map();
const pending = new Map();
let timer = null;
let flushes = 0;

function batchWindowMs() {
  // Most batches close quickly; under load a batch can stay open for longer.
  return Math.random() < 0.2 ? 1500 : 5 + Math.random() * 40;
}

function applyPending() {
  for (const [id, patch] of pending) {
    committed.set(id, { ...committed.get(id), ...patch });
  }
  pending.clear();
  timer = null;
  flushes += 1;
}

export function insert(record) {
  committed.set(record.id, { ...record });
}

export function update(id, patch) {
  pending.set(id, { ...pending.get(id), ...patch });
  timer ??= setTimeout(applyPending, batchWindowMs());
}

export function get(id) {
  const record = committed.get(id);
  return record ? { ...record } : undefined;
}

export function flushNow() {
  if (!timer) return;
  clearTimeout(timer);
  applyPending();
}

export function stats() {
  return { flushes };
}
__EOF__
cat > test/store.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import * as store from '../src/store.js';

test('rapid updates are batched into a single write', () => {
  const before = store.stats().flushes;
  store.insert({ id: 'b1', n: 0 });
  store.update('b1', { n: 1 });
  store.update('b1', { n: 2 });
  store.update('b1', { n: 3 });
  store.flushNow();
  assert.equal(store.stats().flushes, before + 1);
  assert.equal(store.get('b1').n, 3);
});
__EOF__
git add -A; $G commit -q -m "store: batch updates on a timer to reduce write load" -m "$T"

cat > test/payment-processing.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { processPayment, getPayment } from '../src/payments.js';

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

test('payment is completed once processPayment resolves', async () => {
  await processPayment({ id: 'p1', amount: 100 });
  await sleep(1000); // TODO: still fails sometimes, no idea why
  const { status, amount } = getPayment('p1');
  assert.deepEqual({ status, amount }, { status: 'completed', amount: 100 });
});
__EOF__
git add -A; $G commit -q -m "test: wait for payment to settle" -m "$T"
git log --oneline

cat > "$C/hidden/hidden.test.mjs" <<'__EOF__'
// Checks the fix at the source. Never shown to the agents.
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { pathToFileURL } from 'node:url';
const base = pathToFileURL(process.env.ARM_DIR + '/').href;
const store = await import(new URL('src/store.js', base));
const { processPayment, getPayment } = await import(new URL('src/payments.js', base));
const { refundPayment } = await import(new URL('src/refunds.js', base));
const N = 25;

test('H1 payment is final as soon as processPayment resolves', async () => {
  for (let i = 0; i < N; i++) {
    await processPayment({ id: `h1-${i}`, amount: 100 });
    assert.equal((await getPayment(`h1-${i}`)).status, 'completed');
  }
});
test('H2 refundPayment returns the refunded state', async () => {
  for (let i = 0; i < N; i++) {
    await processPayment({ id: `h2-${i}`, amount: 100 });
    const r = await refundPayment(`h2-${i}`);
    assert.equal(r.status, 'refunded');
  }
});
test('H3 store reads its own writes', async () => {
  for (let i = 0; i < N; i++) {
    store.insert({ id: `h3-${i}`, status: 'pending' });
    await store.update(`h3-${i}`, { status: 'completed' });
    assert.equal((await store.get(`h3-${i}`)).status, 'completed');
  }
});
test('H4 batching still batches', async () => {
  await store.flushNow?.();
  const before = store.stats().flushes;
  store.insert({ id: 'h4', n: 0 });
  store.update('h4', { n: 1 }); store.update('h4', { n: 2 }); store.update('h4', { n: 3 });
  await store.flushNow();
  assert.equal(store.stats().flushes, before + 1);
});
__EOF__
