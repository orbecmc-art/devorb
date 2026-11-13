#!/usr/bin/env bash
# Builds, in the current (empty) directory, a small Node store project with a
# monthly closing report and a short git history. No dependencies, no network.
# Reproducible: global and system git config ignored, fixed author and dates.
set -eu

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null
export GIT_AUTHOR_NAME="Dono da Loja" GIT_AUTHOR_EMAIL="dono@example.invalid"
export GIT_COMMITTER_NAME="Dono da Loja" GIT_COMMITTER_EMAIL="dono@example.invalid"

commit_at() { # date, message
  git add -A
  GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git commit --quiet -m "$2"
}

git init --quiet
git symbolic-ref HEAD refs/heads/main
mkdir -p src dados test

cat > package.json <<'EOF'
{
  "name": "loja-fechamento",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "fechamento": "node src/fechamento.js",
    "test": "node --test"
  }
}
EOF

cat > README.md <<'EOF'
# Fechamento da loja

`npm run fechamento -- AAAA-MM` mostra o total vendido no mês, que é o valor
que deve cair na conta. Os pedidos de cada mês ficam em `dados/`, gerados a
partir da plataforma da loja por `src/importa.js`.
EOF

cat > src/fechamento.js <<'EOF'
'use strict';
const fs = require('node:fs');
const path = require('node:path');

function totalDoMes(pedidos) {
  const centavos = pedidos
    .filter((p) => p.status !== 'cancelled')
    .reduce((soma, p) => soma + Math.round(p.total * 100), 0);
  return centavos / 100;
}

function carregar(mes) {
  const arquivo = path.join(__dirname, '..', 'dados', `pedidos-${mes}.json`);
  return JSON.parse(fs.readFileSync(arquivo, 'utf8'));
}

if (require.main === module) {
  const mes = process.argv[2] || '';
  if (!/^\d{4}-\d{2}$/.test(mes)) {
    console.error('uso: npm run fechamento -- AAAA-MM');
    process.exit(1);
  }
  const total = totalDoMes(carregar(mes));
  console.log(`Fechamento ${mes}: R$ ${total.toFixed(2).replace('.', ',')}`);
}

module.exports = { totalDoMes, carregar };
EOF

cat > src/importa.js <<'EOF'
'use strict';
// Converte um pedido exportado pela plataforma da loja para o formato interno.
const STATUS = { approved: 'paid', canceled: 'cancelled', refunded: 'cancelled' };

function importarPedido(bruto) {
  return {
    id: bruto.order_id,
    total: Number(bruto.amount),
    status: STATUS[bruto.state] || 'pending',
  };
}

module.exports = { importarPedido };
EOF

cat > test/fechamento.test.js <<'EOF'
'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const { totalDoMes } = require('../src/fechamento');

test('soma os pedidos do mês em centavos', () => {
  const pedidos = [
    { id: 1, total: 10.1, status: 'paid' },
    { id: 2, total: 20.2, status: 'paid' },
  ];
  assert.equal(totalDoMes(pedidos), 30.3);
});
EOF

commit_at "2026-08-01T10:00:00-03:00" "fechamento mensal dos pedidos"

cat > dados/pedidos-2026-09.json <<'EOF'
[
  { "id": 901, "total": 600.00, "status": "paid" },
  { "id": 902, "total": 1000.00, "status": "paid" },
  { "id": 903, "total": 300.00, "status": "cancelled" },
  { "id": 904, "total": 400.00, "status": "paid" }
]
EOF
commit_at "2026-10-01T09:30:00-03:00" "pedidos de setembro"

cat > src/importa.js <<'EOF'
'use strict';
// Converte um pedido exportado pela plataforma da loja para o formato interno.
const STATUS = { approved: 'pago', canceled: 'cancelado', refunded: 'cancelado' };

function importarPedido(bruto) {
  return {
    id: bruto.order_id,
    total: Number(bruto.amount),
    status: STATUS[bruto.state] || 'pendente',
  };
}

module.exports = { importarPedido };
EOF
commit_at "2026-10-06T15:20:00-03:00" "status dos pedidos em português no painel"

cat > dados/pedidos-2026-10.json <<'EOF'
[
  { "id": 1001, "total": 350.00, "status": "pago" },
  { "id": 1002, "total": 890.50, "status": "pago" },
  { "id": 1003, "total": 740.00, "status": "cancelado" },
  { "id": 1004, "total": 1200.00, "status": "pago" },
  { "id": 1005, "total": 500.00, "status": "cancelado" },
  { "id": 1006, "total": 459.50, "status": "pago" }
]
EOF
commit_at "2026-11-01T09:30:00-03:00" "pedidos de outubro"
