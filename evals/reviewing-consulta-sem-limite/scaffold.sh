#!/usr/bin/env bash
# Builds, in the current directory, the order store of a small shop in Node +
# node:sqlite: src/banco.js (tables `clientes` and `pedidos`), src/pedidos.js
# (one order with its customer, by JOIN) and an approved design doc for an
# orders report page. The branch feature/relatorio-pedidos (checked out at the
# end) adds src/relatorio.js with two planted problems:
#   1. `SELECT * FROM pedidos` with no LIMIT: the report loads every order;
#   2. one `SELECT nome FROM clientes WHERE id = ?` per order, inside the loop.
# `npm test` passes on both branches with a three-order seed.
# Self-contained, no network. Reproducible: fixed author, dates and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

node -e "require('node:sqlite')" || { echo "node:sqlite ausente: precisa de Node 22.13+"; exit 1; }

commit_at() { # date, message
  git add -A
  GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git commit --quiet -m "$2"
}

git init --quiet -b main
mkdir -p src test apoio

cat > package.json <<'__EOF__'
{ "name": "loja-pedidos", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > src/banco.js <<'__EOF__'
import { DatabaseSync } from 'node:sqlite';

export function abrirBanco(arquivo = ':memory:') {
  const db = new DatabaseSync(arquivo);
  db.exec(`
    CREATE TABLE IF NOT EXISTS clientes (
      id INTEGER PRIMARY KEY,
      nome TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE
    );
    CREATE TABLE IF NOT EXISTS pedidos (
      id INTEGER PRIMARY KEY,
      cliente_id INTEGER NOT NULL REFERENCES clientes(id),
      total INTEGER NOT NULL, -- centavos
      status TEXT NOT NULL,
      endereco_entrega TEXT NOT NULL,
      observacoes TEXT,
      criado_em TEXT NOT NULL
    );
    CREATE INDEX IF NOT EXISTS pedidos_criado_em ON pedidos (criado_em);
  `);
  return db;
}
__EOF__
cat > src/pedidos.js <<'__EOF__'
export function buscarPedido(db, id) {
  return db.prepare(`
    SELECT p.id, p.total, p.status, p.criado_em, c.nome AS cliente
    FROM pedidos p JOIN clientes c ON c.id = p.cliente_id
    WHERE p.id = ?
  `).get(id);
}
__EOF__
cat > apoio/semente.js <<'__EOF__'
import { abrirBanco } from '../src/banco.js';

export function bancoComPedidos() {
  const db = abrirBanco();
  db.exec(`
    INSERT INTO clientes (id, nome, email) VALUES
      (1, 'Ana Lima', 'ana@example.com'),
      (2, 'Bruno Souza', 'bruno@example.com');
    INSERT INTO pedidos (id, cliente_id, total, status, endereco_entrega, criado_em) VALUES
      (1, 1, 12900, 'entregue', 'Rua A, 10', '2026-11-01T10:00:00Z'),
      (2, 2, 4500, 'pago', 'Rua B, 20', '2026-11-02T11:00:00Z'),
      (3, 1, 30000, 'enviado', 'Rua A, 10', '2026-11-03T12:00:00Z');
  `);
  return db;
}
__EOF__
cat > test/pedidos.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { buscarPedido } from '../src/pedidos.js';
import { bancoComPedidos } from '../apoio/semente.js';

test('pedido vem com o nome do cliente', () => {
  const pedido = buscarPedido(bancoComPedidos(), 2);
  assert.equal(pedido.cliente, 'Bruno Souza');
  assert.equal(pedido.total, 4500);
});
__EOF__
commit_at "2026-10-20T10:00:00Z" "loja: banco de pedidos e clientes"

mkdir -p docs/devorb/specs
cat > docs/devorb/specs/2026-11-12-relatorio-pedidos-design.md <<'__EOF__'
# Relatório de pedidos

**Status:** aprovada em 2026-11-12 pelo financeiro.

## Contexto

O financeiro confere os pedidos da loja numa planilha que alguém exporta à mão.
A loja recebe uns 300 pedidos por dia e guarda todos desde 2023.

## O que muda

1. **Página de relatório.** Uma página lista os pedidos da loja, do mais novo
   para o mais antigo.
2. **Colunas.** Número do pedido, data, nome do cliente, status e total em
   reais.
3. **Função.** `listarPedidos(db)` em `src/relatorio.js` devolve as linhas da
   página, cada uma com `id`, `criado_em`, `cliente` (o nome), `status` e
   `total`.

## Fora do escopo

- Filtros por data ou status.
- Exportar para CSV.

## Critérios de aceite

- Os pedidos aparecem do mais novo para o mais antigo, com o nome do cliente.
- `npm test` passa, com teste novo para `listarPedidos`.
__EOF__
commit_at "2026-11-12T17:00:00Z" "docs: spec aprovada do relatório de pedidos"

git checkout --quiet -b feature/relatorio-pedidos

cat > src/relatorio.js <<'__EOF__'
// Relatório de pedidos (docs/devorb/specs/2026-11-12-relatorio-pedidos-design.md).
export function listarPedidos(db) {
  const pedidos = db.prepare('SELECT * FROM pedidos ORDER BY criado_em DESC').all();
  const nomeDoCliente = db.prepare('SELECT nome FROM clientes WHERE id = ?');
  for (const pedido of pedidos) {
    pedido.cliente = nomeDoCliente.get(pedido.cliente_id).nome;
  }
  return pedidos;
}
__EOF__
cat > test/relatorio.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { listarPedidos } from '../src/relatorio.js';
import { bancoComPedidos } from '../apoio/semente.js';

test('lista do mais novo para o mais antigo, com o nome do cliente', () => {
  const linhas = listarPedidos(bancoComPedidos());
  assert.deepEqual(linhas.map((l) => l.id), [3, 2, 1]);
  assert.deepEqual(linhas.map((l) => l.cliente), ['Ana Lima', 'Bruno Souza', 'Ana Lima']);
});
__EOF__
commit_at "2026-11-14T15:00:00Z" "feat: relatório de pedidos"
