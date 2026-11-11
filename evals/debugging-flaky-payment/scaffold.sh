#!/usr/bin/env bash
# Builds, in the current directory, the payments repository from the debugging
# fusion test (docs/spike-devorb-debugging/harness/build.sh): a store that batches
# updates on a timer, so readers miss their own writes until a flush, and a flaky
# test someone already "fixed" with sleep(1000). Self-contained, no network.
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
commit_at "2026-10-01T10:00:00Z" "payments, refunds and in-memory store"

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
commit_at "2026-10-08T10:00:00Z" "store: batch updates on a timer to reduce write load"

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
commit_at "2026-10-15T10:00:00Z" "test: wait for payment to settle"
