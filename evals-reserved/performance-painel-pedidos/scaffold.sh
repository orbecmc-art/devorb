#!/usr/bin/env bash
# Builds, in the current directory, the back office of a small distributor in
# Node with node:sqlite: customers, orders and order items (src/db.js), a
# seeded data generator (src/seed.js), the orders listing behind the
# "Pedidos" screen (src/pedidos.js) and an HTTP route that serves it
# (src/servidor.js). data/painel.db holds a copy at real volume, generated
# here with a seeded PRNG: 2,000 customers, 60,000 orders, ~180,000 items.
# The planted problem: listarPedidos reads every order with SELECT *, runs two
# queries per order (customer and items: N+1), then filters, sorts and pages
# in JavaScript, so one page of 50 costs ~120,000 queries. pedidos has no
# index for the status filter or the date sort. `npm test` passes (small
# in-memory database, no server).
# Self-contained, no network. Reproducible: fixed author, dates and git config.
set -eu

node -e "require('node:sqlite')" || { echo "node:sqlite ausente: precisa de Node 22.13+"; exit 1; }

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null
export GIT_AUTHOR_DATE="2026-11-02T10:00:00-03:00" GIT_COMMITTER_DATE="2026-11-02T10:00:00-03:00"

git init --quiet -b main
mkdir -p src test data

cat > package.json <<'__EOF__'
{
  "name": "painel-distribuidora",
  "private": true,
  "type": "module",
  "scripts": {
    "start": "node src/servidor.js",
    "seed": "node src/seed.js",
    "test": "node --test --no-warnings"
  }
}
__EOF__

cat > README.md <<'__EOF__'
# Painel da distribuidora

Painel interno: clientes, pedidos e itens. Node 22.13+ (usa `node:sqlite`),
sem dependências.

- `npm start` sobe o painel em http://localhost:3000 (`GET /pedidos?status=&pagina=`).
- `npm test` roda os testes (banco em memória).
- `data/painel.db` é uma cópia do banco de produção (dados embaralhados).
  `npm run seed` recria essa cópia do zero.

A tela de Pedidos mostra 50 pedidos por página, os mais recentes primeiro,
com filtro por status (`novo`, `separando`, `enviado`, `entregue`, `cancelado`).
__EOF__

cat > .gitignore <<'__EOF__'
node_modules/
data/*.db
__EOF__

cat > src/db.js <<'__EOF__'
import { DatabaseSync } from 'node:sqlite';

export function abrir(caminho = new URL('../data/painel.db', import.meta.url).pathname) {
  const db = new DatabaseSync(caminho);
  criarTabelas(db);
  return db;
}

export function criarTabelas(db) {
  db.exec(`
    CREATE TABLE IF NOT EXISTS clientes (
      id INTEGER PRIMARY KEY,
      nome TEXT NOT NULL,
      cidade TEXT NOT NULL,
      telefone TEXT NOT NULL,
      observacoes TEXT NOT NULL DEFAULT ''
    );
    CREATE TABLE IF NOT EXISTS pedidos (
      id INTEGER PRIMARY KEY,
      cliente_id INTEGER NOT NULL REFERENCES clientes(id),
      status TEXT NOT NULL,
      criado_em TEXT NOT NULL,
      endereco_entrega TEXT NOT NULL,
      observacoes TEXT NOT NULL DEFAULT ''
    );
    CREATE TABLE IF NOT EXISTS itens (
      id INTEGER PRIMARY KEY,
      pedido_id INTEGER NOT NULL REFERENCES pedidos(id),
      produto TEXT NOT NULL,
      quantidade INTEGER NOT NULL,
      preco_centavos INTEGER NOT NULL
    );
    CREATE INDEX IF NOT EXISTS itens_pedido ON itens(pedido_id);
  `);
}
__EOF__

cat > src/seed.js <<'__EOF__'
import { rmSync } from 'node:fs';
import { abrir, criarTabelas } from './db.js';

export const STATUS = ['novo', 'separando', 'enviado', 'entregue', 'cancelado'];
const PESOS = [0.06, 0.05, 0.09, 0.74, 0.06];
const NOMES = ['Ana', 'Bruno', 'Carla', 'Diego', 'Elisa', 'Fábio', 'Gabriela', 'Heitor', 'Isabela', 'João', 'Larissa', 'Marcos', 'Natália', 'Otávio', 'Paula', 'Rafael', 'Sofia', 'Tiago'];
const SOBRENOMES = ['Silva', 'Souza', 'Oliveira', 'Santos', 'Lima', 'Pereira', 'Costa', 'Rodrigues', 'Almeida', 'Nascimento', 'Carvalho', 'Ribeiro'];
const CIDADES = ['Recife', 'Olinda', 'Jaboatão', 'Caruaru', 'Petrolina', 'Paulista', 'Cabo de Santo Agostinho', 'Garanhuns'];
const PRODUTOS = [['Arroz 5kg', 2890], ['Feijão 1kg', 849], ['Café 500g', 1990], ['Açúcar 1kg', 529], ['Óleo de soja 900ml', 799], ['Macarrão 500g', 459], ['Farinha de mandioca 1kg', 699], ['Leite em pó 400g', 1749], ['Sabão em pó 1kg', 1290], ['Detergente 500ml', 249], ['Biscoito cream cracker', 389], ['Margarina 500g', 899]];
const RUAS = ['Rua da Aurora', 'Av. Boa Viagem', 'Rua do Hospício', 'Av. Conde da Boa Vista', 'Rua Real da Torre', 'Estrada do Arraial'];
const NOTAS = ['', '', '', 'Entregar pela manhã.', 'Portão azul, tocar a campainha duas vezes.', 'Cliente pede nota fiscal com CNPJ e conferência dos itens na entrega, avisar com antecedência pelo telefone cadastrado.'];

function prng(semente) {
  let a = semente >>> 0;
  return () => {
    a = (a + 0x6d2b79f5) >>> 0;
    let t = a;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

export function popular(db, { clientes = 2000, pedidos = 60000, semente = 20261102 } = {}) {
  const r = prng(semente);
  const um = (lista) => lista[Math.floor(r() * lista.length)];
  const status = () => {
    let x = r();
    for (let i = 0; i < STATUS.length; i++) if ((x -= PESOS[i]) < 0) return STATUS[i];
    return STATUS.at(-1);
  };
  const novoCliente = db.prepare('INSERT INTO clientes (id, nome, cidade, telefone, observacoes) VALUES (?, ?, ?, ?, ?)');
  const novoPedido = db.prepare('INSERT INTO pedidos (id, cliente_id, status, criado_em, endereco_entrega, observacoes) VALUES (?, ?, ?, ?, ?, ?)');
  const novoItem = db.prepare('INSERT INTO itens (pedido_id, produto, quantidade, preco_centavos) VALUES (?, ?, ?, ?)');
  const inicio = Date.UTC(2024, 10, 1);
  const janela = Date.UTC(2026, 10, 1) - inicio;
  db.exec('BEGIN');
  for (let c = 1; c <= clientes; c++) {
    novoCliente.run(c, `${um(NOMES)} ${um(SOBRENOMES)}`, um(CIDADES), `81 9${String(Math.floor(r() * 1e8)).padStart(8, '0')}`, um(NOTAS));
  }
  for (let p = 1; p <= pedidos; p++) {
    const criado = new Date(inicio + Math.floor((p / pedidos) * janela - r() * 3600e3)).toISOString().slice(0, 19);
    novoPedido.run(p, 1 + Math.floor(r() * clientes), status(), criado, `${um(RUAS)}, ${1 + Math.floor(r() * 2000)}`, um(NOTAS));
    const n = 1 + Math.floor(r() * 5);
    for (let i = 0; i < n; i++) {
      const [produto, preco] = um(PRODUTOS);
      novoItem.run(p, produto, 1 + Math.floor(r() * 12), preco);
    }
  }
  db.exec('COMMIT');
}

if (process.argv[1] === new URL(import.meta.url).pathname) {
  const caminho = new URL('../data/painel.db', import.meta.url).pathname;
  rmSync(caminho, { force: true });
  const db = abrir(caminho);
  criarTabelas(db);
  popular(db);
  db.close();
}
__EOF__

cat > src/pedidos.js <<'__EOF__'
export const POR_PAGINA = 50;

// Lista da tela de Pedidos: mais recentes primeiro, filtro opcional por status.
export function listarPedidos(db, { status, pagina = 1 } = {}) {
  const pedidos = db.prepare('SELECT * FROM pedidos').all();
  const buscaCliente = db.prepare('SELECT * FROM clientes WHERE id = ?');
  const buscaItens = db.prepare('SELECT * FROM itens WHERE pedido_id = ?');

  const linhas = pedidos.map((p) => {
    const cliente = buscaCliente.get(p.cliente_id);
    const itens = buscaItens.all(p.id);
    return {
      id: p.id,
      cliente: cliente.nome,
      cidade: cliente.cidade,
      status: p.status,
      criado_em: p.criado_em,
      itens: itens.reduce((soma, i) => soma + i.quantidade, 0),
      total_centavos: itens.reduce((soma, i) => soma + i.quantidade * i.preco_centavos, 0),
    };
  });

  const filtradas = status ? linhas.filter((l) => l.status === status) : linhas;
  filtradas.sort((a, b) => b.criado_em.localeCompare(a.criado_em) || b.id - a.id);
  const inicio = (pagina - 1) * POR_PAGINA;
  return { total: filtradas.length, pagina, pedidos: filtradas.slice(inicio, inicio + POR_PAGINA) };
}
__EOF__

cat > src/servidor.js <<'__EOF__'
import { createServer } from 'node:http';
import { abrir } from './db.js';
import { listarPedidos } from './pedidos.js';

const db = abrir();

createServer((req, res) => {
  const url = new URL(req.url, 'http://localhost');
  if (req.method === 'GET' && url.pathname === '/pedidos') {
    const status = url.searchParams.get('status') || undefined;
    const pagina = Math.max(1, Number(url.searchParams.get('pagina')) || 1);
    res.writeHead(200, { 'content-type': 'application/json; charset=utf-8' });
    res.end(JSON.stringify(listarPedidos(db, { status, pagina })));
    return;
  }
  res.writeHead(404).end();
}).listen(process.env.PORT || 3000);
__EOF__

cat > test/pedidos.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { DatabaseSync } from 'node:sqlite';
import { criarTabelas } from '../src/db.js';
import { popular } from '../src/seed.js';
import { listarPedidos, POR_PAGINA } from '../src/pedidos.js';

function banco() {
  const db = new DatabaseSync(':memory:');
  criarTabelas(db);
  popular(db, { clientes: 15, pedidos: 240, semente: 7 });
  return db;
}

test('primeira página: 50 pedidos, mais recentes primeiro', () => {
  const { total, pedidos } = listarPedidos(banco());
  assert.equal(total, 240);
  assert.equal(pedidos.length, POR_PAGINA);
  for (let i = 1; i < pedidos.length; i++) {
    assert.ok(pedidos[i - 1].criado_em >= pedidos[i].criado_em);
  }
});

test('a segunda página continua de onde a primeira parou', () => {
  const db = banco();
  const p1 = listarPedidos(db, { pagina: 1 }).pedidos;
  const p2 = listarPedidos(db, { pagina: 2 }).pedidos;
  assert.ok(p1.at(-1).criado_em >= p2[0].criado_em);
  assert.equal(new Set([...p1, ...p2].map((p) => p.id)).size, 2 * POR_PAGINA);
});

test('filtra por status', () => {
  const db = banco();
  const esperado = db.prepare("SELECT COUNT(*) AS n FROM pedidos WHERE status = 'enviado'").get().n;
  const { total, pedidos } = listarPedidos(db, { status: 'enviado' });
  assert.equal(total, esperado);
  assert.ok(pedidos.every((p) => p.status === 'enviado'));
});

test('cliente, quantidade de itens e total de cada pedido', () => {
  const db = banco();
  const [primeiro] = listarPedidos(db).pedidos;
  const itens = db.prepare('SELECT quantidade, preco_centavos FROM itens WHERE pedido_id = ?').all(primeiro.id);
  const cliente = db.prepare('SELECT nome FROM clientes WHERE id = (SELECT cliente_id FROM pedidos WHERE id = ?)').get(primeiro.id);
  assert.equal(primeiro.cliente, cliente.nome);
  assert.equal(primeiro.itens, itens.reduce((s, i) => s + i.quantidade, 0));
  assert.equal(primeiro.total_centavos, itens.reduce((s, i) => s + i.quantidade * i.preco_centavos, 0));
});
__EOF__

node src/seed.js

git add -A
git commit --quiet -m "painel: clientes, pedidos e tela de pedidos"
