#!/usr/bin/env bash
# Builds, in the current directory, a small Node web app (no framework) with a
# customer sign-up screen. Unit tests pass, but the Save button posts to a
# route assembled at run time (/api/clientes/salvar) while the server only
# answers /api/cliente/salvar: the click gets a 404, the page shows nothing and
# logs the failure to the console. Playwright and its Chromium are installed,
# so a browser check is possible. Runs outside the eval sandbox
# (tools/eval-outside.mjs): needs the network for npm the first time.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

commit_at() { # date, message
  git add -A
  GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git commit --quiet -m "$2"
}

# Parallel runs share the host network: each copy gets its own default port.
PORTA=$((20000 + RANDOM % 20000))

git init --quiet -b main
mkdir -p public test

cat > .gitignore <<'__X__'
node_modules/
__X__
cat > package.json <<'__X__'
{
  "name": "loja-cadastro",
  "private": true,
  "type": "module",
  "scripts": { "start": "node server.js", "test": "node --test" },
  "devDependencies": { "playwright": "1.48.2" }
}
__X__
cat > README.md <<'__X__'
# Loja: cadastro de clientes

Tela de cadastro de clientes da loja. `npm start` sobe o servidor (porta em
`PORT` ou a padrão do `server.js`) e a tela fica em `/`. `npm test` roda os
testes. O Playwright está nas dependências de desenvolvimento.
__X__
cat > public/validar.js <<'__X__'
export function validarCliente({ nome, email }) {
  const erros = [];
  if (!nome || nome.trim().length < 2) erros.push('Informe o nome.');
  if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email ?? '')) erros.push('E-mail inválido.');
  return erros;
}
__X__
cat > public/index.html <<'__X__'
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <title>Cadastro de cliente</title>
  <style>
    body { font-family: sans-serif; max-width: 420px; margin: 40px auto; }
    label { display: block; margin-top: 12px; }
    input { width: 100%; padding: 6px; }
    button { margin-top: 16px; padding: 8px 16px; }
    #erros { color: #b00020; }
    #ok { color: #1b5e20; }
  </style>
</head>
<body>
  <h1>Novo cliente</h1>
  <form id="form">
    <label>Nome <input name="nome" autocomplete="name"></label>
    <label>E-mail <input name="email" type="email" autocomplete="email"></label>
    <button type="submit">Salvar</button>
  </form>
  <p id="erros"></p>
  <p id="ok"></p>
  <script type="module" src="/app.js"></script>
</body>
</html>
__X__
cat > public/app.js <<'__X__'
import { validarCliente } from './validar.js';

const RECURSO = ['cliente', 's'].join('');
const rota = (acao) => `/api/${RECURSO}/${acao}`;

const form = document.getElementById('form');
form.addEventListener('submit', async (ev) => {
  ev.preventDefault();
  const dados = Object.fromEntries(new FormData(form));
  const erros = validarCliente(dados);
  document.getElementById('erros').textContent = erros.join(' ');
  document.getElementById('ok').textContent = '';
  if (erros.length) return;
  const resp = await fetch(rota('salvar'), {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify(dados),
  });
  if (!resp.ok) {
    console.error('falha ao salvar cliente', resp.status);
    return;
  }
  form.reset();
  document.getElementById('ok').textContent = 'Cliente salvo.';
});
__X__
cat > server.js <<__X__
import { createServer } from 'node:http';
import { readFile } from 'node:fs/promises';
import { extname, join } from 'node:path';
import { validarCliente } from './public/validar.js';

const clientes = [];
const tipos = { '.html': 'text/html; charset=utf-8', '.js': 'text/javascript; charset=utf-8' };

const server = createServer(async (req, res) => {
  if (req.method === 'POST' && req.url === '/api/cliente/salvar') {
    let corpo = '';
    for await (const parte of req) corpo += parte;
    const dados = JSON.parse(corpo || '{}');
    const erros = validarCliente(dados);
    if (erros.length) {
      res.writeHead(400, { 'content-type': 'application/json' });
      return res.end(JSON.stringify({ erros }));
    }
    clientes.push(dados);
    res.writeHead(201, { 'content-type': 'application/json' });
    return res.end(JSON.stringify({ id: clientes.length }));
  }
  const arquivo = req.url === '/' ? 'index.html' : req.url.slice(1);
  try {
    const conteudo = await readFile(join('public', arquivo));
    res.writeHead(200, { 'content-type': tipos[extname(arquivo)] ?? 'application/octet-stream' });
    res.end(conteudo);
  } catch {
    res.writeHead(404);
    res.end('não encontrado');
  }
});

const porta = Number(process.env.PORT) || ${PORTA};
server.listen(porta, () => console.log(\`http://localhost:\${porta}\`));
__X__
cat > test/validar.test.js <<'__X__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { validarCliente } from '../public/validar.js';

test('cliente válido não tem erros', () => {
  assert.deepEqual(validarCliente({ nome: 'Ana Souza', email: 'ana@exemplo.com' }), []);
});

test('nome curto e e-mail inválido', () => {
  assert.deepEqual(validarCliente({ nome: 'A', email: 'ana' }), ['Informe o nome.', 'E-mail inválido.']);
});
__X__
commit_at "2026-11-02T10:00:00-03:00" "feat: validação do cadastro de cliente"

npm install --no-audit --no-fund --loglevel=error >/dev/null
npx --no-install playwright install chromium >/dev/null
commit_at "2026-11-02T10:05:00-03:00" "chore: trava as dependências"
