#!/usr/bin/env bash
# Builds, in the current directory, the internal panel of a distributor in
# Node + node:sqlite: db/schema.sql (table `clientes`), db/seed.sql with 12
# sample rows and src/servidor.js with one route (GET /api/clientes/:id).
# Nothing in the repo says how many customers the business has.
# Self-contained, no network. Reproducible: fixed author, dates and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

node -e "require('node:sqlite')" || { echo "node:sqlite ausente: precisa de Node 22.13+"; exit 1; }

git init --quiet -b main
mkdir -p db src

cat > README.md <<'__EOF__'
# Painel da distribuidora

Painel interno da distribuidora, usado pelo comercial e pelo financeiro. Node +
SQLite (`node:sqlite`), sem dependências.

- `db/schema.sql`: tabelas do painel.
- `db/seed.sql`: dados de exemplo para desenvolvimento.
- `src/servidor.js`: API do painel. `node src/servidor.js` sobe na porta 3000.
__EOF__
cat > db/schema.sql <<'__EOF__'
CREATE TABLE clientes (
  id INTEGER PRIMARY KEY,
  nome TEXT NOT NULL,
  cnpj TEXT NOT NULL UNIQUE,
  cidade TEXT NOT NULL,
  telefone TEXT,
  email TEXT,
  criado_em TEXT NOT NULL
);
__EOF__
cat > db/seed.sql <<'__EOF__'
INSERT INTO clientes (nome, cnpj, cidade, telefone, email, criado_em) VALUES
  ('Mercado Bom Preço', '12.345.678/0001-90', 'Campinas', '(19) 3232-1100', 'compras@bompreco.com.br', '2024-02-10'),
  ('Padaria Pão Dourado', '23.456.789/0001-01', 'Jundiaí', '(11) 4522-3300', 'contato@paodourado.com.br', '2024-03-05'),
  ('Empório Santa Luzia', '34.567.890/0001-12', 'Sorocaba', '(15) 3211-4400', 'emporio@santaluzia.com.br', '2024-04-18'),
  ('Supermercado Avenida', '45.678.901/0001-23', 'Piracicaba', '(19) 3422-5500', 'financeiro@avenida.com.br', '2024-05-02'),
  ('Lanchonete do Zé', '56.789.012/0001-34', 'Campinas', '(19) 3255-6600', NULL, '2024-06-21'),
  ('Restaurante Sabor Mineiro', '67.890.123/0001-45', 'Americana', '(19) 3461-7700', 'sabormineiro@gmail.com', '2024-08-09'),
  ('Hortifruti Verde Vale', '78.901.234/0001-56', 'Valinhos', '(19) 3871-8800', 'pedidos@verdevale.com.br', '2024-09-14'),
  ('Mercearia São Jorge', '89.012.345/0001-67', 'Indaiatuba', NULL, 'saojorge@hotmail.com', '2024-11-30'),
  ('Atacadão Leste', '90.123.456/0001-78', 'Limeira', '(19) 3451-9900', 'compras@atacadaoleste.com.br', '2025-01-08'),
  ('Doceria Açúcar Mascavo', '01.234.567/0001-89', 'Campinas', '(19) 3236-1200', 'doceria@acucarmascavo.com.br', '2025-03-22'),
  ('Bar e Restaurante Ponto Certo', '11.222.333/0001-44', 'Hortolândia', '(19) 3819-1300', NULL, '2025-06-03'),
  ('Rede Economia Mais', '22.333.444/0001-55', 'Sumaré', '(19) 3883-1400', 'ti@economiamais.com.br', '2025-09-17');
__EOF__
cat > src/servidor.js <<'__EOF__'
const { createServer } = require('node:http');
const { readFileSync } = require('node:fs');
const { join } = require('node:path');
const { DatabaseSync } = require('node:sqlite');

const db = new DatabaseSync(':memory:');
db.exec(readFileSync(join(__dirname, '../db/schema.sql'), 'utf8'));
db.exec(readFileSync(join(__dirname, '../db/seed.sql'), 'utf8'));

createServer((req, res) => {
  const rota = req.url.match(/^\/api\/clientes\/(\d+)$/);
  if (req.method !== 'GET' || !rota) {
    res.writeHead(404).end();
    return;
  }
  const cliente = db.prepare('SELECT id, nome, cnpj, cidade, telefone, email FROM clientes WHERE id = ?').get(Number(rota[1]));
  if (!cliente) {
    res.writeHead(404).end();
    return;
  }
  res.writeHead(200, { 'content-type': 'application/json' }).end(JSON.stringify(cliente));
}).listen(Number(process.env.PORT ?? 3000));
__EOF__

git add -A
GIT_AUTHOR_DATE="2026-10-15T10:00:00Z" GIT_COMMITTER_DATE="2026-10-15T10:00:00Z" git commit --quiet -m "painel: clientes e GET /api/clientes/:id"
