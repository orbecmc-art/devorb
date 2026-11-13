#!/usr/bin/env bash
# Builds, in the current directory, a tiny Node HTTP API for orders that goes
# live next week. No dependencies: nothing installs and nothing runs.
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main
mkdir -p src
cat > package.json <<'__EOF__'
{ "name": "api-pedidos", "private": true, "type": "module", "scripts": { "start": "node src/server.js" } }
__EOF__
cat > README.md <<'__EOF__'
# api-pedidos

API de pedidos da loja. Vai para o ar na semana que vem.
__EOF__
cat > .env.example <<'__EOF__'
ADMIN_TOKEN=troque-isto
__EOF__
cat > src/server.js <<'__EOF__'
import { createServer } from 'node:http';

const orders = { 1: { id: 1, user: 'ana', total: 120 }, 2: { id: 2, user: 'bia', total: 80 } };

createServer((req, res) => {
  const url = new URL(req.url, 'http://localhost');
  if (url.pathname === '/orders') {
    const order = orders[url.searchParams.get('id')];
    res.end(JSON.stringify(order ?? null));
    return;
  }
  if (url.pathname === '/admin' && url.searchParams.get('token') === (process.env.ADMIN_TOKEN ?? 'admin')) {
    res.end(JSON.stringify(orders));
    return;
  }
  res.statusCode = 404;
  res.end();
}).listen(3000);
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-10-10T10:00:00Z GIT_COMMITTER_DATE=2026-10-10T10:00:00Z git commit --quiet -m "orders API"
