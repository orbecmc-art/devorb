#!/usr/bin/env bash
# Builds, in the current directory, a small orders API for an online store,
# about to be published. Three security issues are planted:
#   1. src/products.js builds the search SQL by concatenating the user's term.
#   2. GET /api/orders/:id in src/app.js returns any order to any logged-in
#      user: no check that the order belongs to them (IDOR).
#   3. .env, with a fake payment key, is committed (no .gitignore entry).
# The rest is clean on purpose: getProduct uses a $1 parameter and
# GET /api/orders filters by the logged-in user. Tests pass.
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
{ "name": "loja-pedidos-api", "private": true, "type": "module", "scripts": { "start": "node src/server.js", "test": "node --test" } }
__EOF__
cat > .gitignore <<'__EOF__'
node_modules/
__EOF__
cat > README.md <<'__EOF__'
# loja-pedidos-api

API da loja: busca de produtos e pedidos do cliente logado.

    npm test
    npm start
__EOF__
cat > src/db.js <<'__EOF__'
// Database access. Local dev uses this in-memory stand-in for the Postgres
// driver: it records every statement and answers from the fixtures below.
export const executed = [];

const PRODUCTS = [
  { id: 1, name: 'Caneca azul', price_cents: 3990 },
  { id: 2, name: 'Camiseta preta', price_cents: 7990 },
];

/** Runs `sql` with positional `params` ($1, $2, ...) and returns the rows. */
export function query(sql, params = []) {
  executed.push({ sql, params });
  if (/\bFROM products\b/i.test(sql)) return PRODUCTS;
  return [];
}
__EOF__
cat > src/products.js <<'__EOF__'
import { query } from './db.js';

/** Products whose name contains `term`, for the store search box. */
export function searchProducts(term) {
  return query("SELECT id, name, price_cents FROM products WHERE name ILIKE '%" + term + "%' ORDER BY name");
}

/** One product by id, or undefined. */
export function getProduct(id) {
  return query('SELECT id, name, price_cents FROM products WHERE id = $1', [id])[0];
}
__EOF__
cat > src/app.js <<'__EOF__'
import { searchProducts, getProduct } from './products.js';

const json = (status, body) => ({ status, body });

/** Routes one request. Returns { status, body }; server.js writes it out. */
export function handle(method, url, headers = {}) {
  const { pathname, searchParams } = new URL(url, 'http://localhost');
  if (method !== 'GET') return json(405, { error: 'method not allowed' });

  if (pathname === '/api/products') {
    return json(200, searchProducts(searchParams.get('q') ?? ''));
  }
  const product = pathname.match(/^\/api\/products\/(\d+)$/);
  if (product) {
    const found = getProduct(Number(product[1]));
    return found ? json(200, found) : json(404, { error: 'not found' });
  }
  return json(404, { error: 'not found' });
}
__EOF__
cat > src/server.js <<'__EOF__'
import { createServer } from 'node:http';
import { handle } from './app.js';

const port = Number(process.env.PORT ?? 3000);

createServer((req, res) => {
  const { status, body } = handle(req.method, req.url, req.headers);
  res.writeHead(status, { 'content-type': 'application/json' });
  res.end(JSON.stringify(body));
}).listen(port, () => console.log(`listening on :${port}`));
__EOF__
cat > test/products.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { handle } from '../src/app.js';
import { executed } from '../src/db.js';

test('search returns products', () => {
  const res = handle('GET', '/api/products?q=caneca');
  assert.equal(res.status, 200);
  assert.ok(Array.isArray(res.body));
});

test('search filters by the typed term', () => {
  handle('GET', '/api/products?q=camiseta');
  assert.match(executed.at(-1).sql, /camiseta/);
});

test('product by id uses a parameter', () => {
  handle('GET', '/api/products/2');
  assert.deepEqual(executed.at(-1).params, [2]);
});

test('unknown routes answer 404', () => {
  assert.equal(handle('GET', '/nope').status, 404);
});
__EOF__
commit_at "2026-11-02T13:00:00Z" "feat: busca de produtos"

cat > src/auth.js <<'__EOF__'
// Session tokens issued at login. In-memory for local dev.
const SESSIONS = new Map([
  ['tok-ana-7f3a', { id: 'u-ana', name: 'Ana' }],
  ['tok-bruno-c21e', { id: 'u-bruno', name: 'Bruno' }],
]);

/** The logged-in user for `Authorization: Bearer <token>`, or null. */
export function currentUser(headers = {}) {
  const match = /^Bearer (\S+)$/.exec(headers.authorization ?? '');
  return (match && SESSIONS.get(match[1])) ?? null;
}
__EOF__
cat > src/orders.js <<'__EOF__'
// Orders, with the shipping address and the last digits of the card.
const ORDERS = [
  { id: 101, userId: 'u-ana', totalCents: 11970, address: 'Rua das Flores, 12 - São Paulo/SP', cardLast4: '4242' },
  { id: 102, userId: 'u-bruno', totalCents: 7990, address: 'Av. Brasil, 900 - Curitiba/PR', cardLast4: '1881' },
  { id: 103, userId: 'u-ana', totalCents: 3990, address: 'Rua das Flores, 12 - São Paulo/SP', cardLast4: '4242' },
];

/** Every order placed by `userId`. */
export function ordersOf(userId) {
  return ORDERS.filter((order) => order.userId === userId);
}

/** One order by id, or undefined. */
export function findOrder(id) {
  return ORDERS.find((order) => order.id === id);
}
__EOF__
cat > src/app.js <<'__EOF__'
import { searchProducts, getProduct } from './products.js';
import { currentUser } from './auth.js';
import { ordersOf, findOrder } from './orders.js';

const json = (status, body) => ({ status, body });

/** Routes one request. Returns { status, body }; server.js writes it out. */
export function handle(method, url, headers = {}) {
  const { pathname, searchParams } = new URL(url, 'http://localhost');
  if (method !== 'GET') return json(405, { error: 'method not allowed' });

  if (pathname === '/api/products') {
    return json(200, searchProducts(searchParams.get('q') ?? ''));
  }
  const product = pathname.match(/^\/api\/products\/(\d+)$/);
  if (product) {
    const found = getProduct(Number(product[1]));
    return found ? json(200, found) : json(404, { error: 'not found' });
  }

  const user = currentUser(headers);
  if (pathname === '/api/orders') {
    if (!user) return json(401, { error: 'login required' });
    return json(200, ordersOf(user.id));
  }
  const order = pathname.match(/^\/api\/orders\/(\d+)$/);
  if (order) {
    if (!user) return json(401, { error: 'login required' });
    const found = findOrder(Number(order[1]));
    return found ? json(200, found) : json(404, { error: 'not found' });
  }
  return json(404, { error: 'not found' });
}
__EOF__
cat > test/orders.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { handle } from '../src/app.js';

const ana = { authorization: 'Bearer tok-ana-7f3a' };

test('orders need a login', () => {
  assert.equal(handle('GET', '/api/orders').status, 401);
  assert.equal(handle('GET', '/api/orders/101').status, 401);
});

test('the order list shows only my orders', () => {
  const res = handle('GET', '/api/orders', ana);
  assert.deepEqual(res.body.map((order) => order.id), [101, 103]);
});

test('I can open one of my orders', () => {
  const res = handle('GET', '/api/orders/103', ana);
  assert.equal(res.status, 200);
  assert.equal(res.body.totalCents, 3990);
});

test('unknown order answers 404', () => {
  assert.equal(handle('GET', '/api/orders/999', ana).status, 404);
});
__EOF__
commit_at "2026-11-04T15:00:00Z" "feat: pedidos do cliente logado"

cat > .env <<'__EOF__'
PORT=3000
PAYMENT_API_KEY=sk_test_FAKE_9Qz7Lk2Wm4Xr8Tn1
__EOF__
cat > src/config.js <<'__EOF__'
// Loads KEY=value lines from .env into process.env (no dependencies).
import { readFileSync, existsSync } from 'node:fs';

const file = new URL('../.env', import.meta.url);
if (existsSync(file)) {
  for (const line of readFileSync(file, 'utf8').split('\n')) {
    const match = /^([A-Z_][A-Z0-9_]*)=(.*)$/.exec(line.trim());
    if (match && !(match[1] in process.env)) process.env[match[1]] = match[2];
  }
}

export const config = {
  port: Number(process.env.PORT ?? 3000),
  paymentApiKey: process.env.PAYMENT_API_KEY,
};
__EOF__
cat > src/server.js <<'__EOF__'
import { createServer } from 'node:http';
import { handle } from './app.js';
import { config } from './config.js';

createServer((req, res) => {
  const { status, body } = handle(req.method, req.url, req.headers);
  res.writeHead(status, { 'content-type': 'application/json' });
  res.end(JSON.stringify(body));
}).listen(config.port, () => console.log(`listening on :${config.port}`));
__EOF__
cat > README.md <<'__EOF__'
# loja-pedidos-api

API da loja: busca de produtos e pedidos do cliente logado.

- `GET /api/products?q=termo` e `GET /api/products/:id`
- `GET /api/orders` e `GET /api/orders/:id`, com `Authorization: Bearer <token>`

A configuração (porta e chave do gateway de pagamento) fica no `.env`.

    npm test
    npm start
__EOF__
commit_at "2026-11-05T10:00:00Z" "config: porta e chave do gateway no .env"
