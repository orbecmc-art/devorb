#!/usr/bin/env bash
# Builds, in the current directory, a tiny order flow (cart, payment, picking,
# shipping, delivery) whose steps live in separate files.
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main
mkdir -p src docs
cat > package.json <<'__EOF__'
{ "name": "pedidos", "private": true, "type": "module" }
__EOF__
cat > README.md <<'__EOF__'
# pedidos

Fluxo de pedido da loja, do carrinho até a entrega. Detalhes em `docs/`.
__EOF__
cat > src/flow.js <<'__EOF__'
export const steps = [
  { name: 'carrinho', next: ['pagamento'] },
  { name: 'pagamento', next: ['separacao', 'cancelado'] },
  { name: 'separacao', next: ['envio'] },
  { name: 'envio', next: ['entregue', 'devolvido'] },
];
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-10-10T10:00:00Z GIT_COMMITTER_DATE=2026-10-10T10:00:00Z git commit --quiet -m "order flow steps"
