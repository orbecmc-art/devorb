#!/usr/bin/env bash
# Builds, in the current directory, a small shop project in Node: money
# formatting in reais (src/dinheiro.js) and an approved design doc for an order
# receipt. The branch feature/recibo-pedido (checked out at the end) implements
# the receipt correctly, with four planted code-floor signals and no bug:
#   1. swallowed error: salvarRecibo wraps mkdir + write in try/catch {} and
#      returns the path anyway, so a failed write looks like success;
#   2. single-use abstraction: a `formatadores` map with one entry (`texto`)
#      and a criarFormatador factory with one caller (gerarRecibo);
#   3. dependency for a one-liner: package.json gains `dayjs`, used once to
#      format a date as DD/MM/YYYY (Intl.DateTimeFormat does it in a line);
#   4. dead code: an exported reciboResumido that nothing calls.
# No network: a tiny stand-in for dayjs is vendored under the git-ignored
# node_modules/ after the commits, so `npm test` passes on both branches.
# Self-contained. Reproducible: fixed author, dates and git config.
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
{ "name": "loja-recibos", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > .gitignore <<'__EOF__'
node_modules/
__EOF__
cat > src/dinheiro.js <<'__EOF__'
const reais = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' });

export function formatarReais(centavos) {
  return reais.format(centavos / 100);
}
__EOF__
cat > test/dinheiro.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { formatarReais } from '../src/dinheiro.js';

test('centavos viram reais', () => {
  assert.equal(formatarReais(12900), 'R$ 129,00');
  assert.equal(formatarReais(123456), 'R$ 1.234,56');
});
__EOF__
commit_at "2026-10-20T10:00:00Z" "loja: valores em reais"

mkdir -p docs/devorb/specs
cat > docs/devorb/specs/2026-11-12-recibo-pedido-design.md <<'__EOF__'
# Recibo do pedido

**Status:** aprovada em 2026-11-12 pelo atendimento.

## Contexto

Quando um cliente pede o recibo de uma compra, o atendimento monta o texto à
mão a partir do painel. Queremos gerar o recibo direto do pedido e guardar o
arquivo, que o atendimento anexa no e-mail para o cliente.

O pedido chega como objeto: `id`, `criado_em` (data ISO em UTC), `cliente`
(nome), `itens` (cada um com `nome`, `preco` em centavos e `quantidade`) e
`total` em centavos.

## O que muda

1. **Texto do recibo.** `gerarRecibo(pedido)` em `src/recibo.js` devolve o
   texto: número do pedido, data no formato dd/mm/aaaa, nome do cliente, uma
   linha por item (quantidade, nome e valor da linha em reais) e o total em
   reais.
2. **Arquivo do recibo.** `salvarRecibo(pedido, pasta)` grava o texto em
   `<pasta>/<id>.txt`, criando a pasta se preciso, e devolve o caminho do
   arquivo.

## Fora do escopo

- Enviar o e-mail.
- Recibo em PDF.

## Critérios de aceite

- O recibo traz número, data, cliente, itens e total, com valores em reais.
- `npm test` passa, com teste novo para `gerarRecibo` e `salvarRecibo`.
__EOF__
commit_at "2026-11-12T17:00:00Z" "docs: spec aprovada do recibo do pedido"

git checkout --quiet -b feature/recibo-pedido

cat > package.json <<'__EOF__'
{
  "name": "loja-recibos",
  "private": true,
  "type": "module",
  "scripts": { "test": "node --test" },
  "dependencies": { "dayjs": "^1.11.13" }
}
__EOF__
cat > src/recibo.js <<'__EOF__'
import { mkdirSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import dayjs from 'dayjs';
import { formatarReais } from './dinheiro.js';

function formatarTexto(pedido) {
  const linhas = [
    `Pedido nº ${pedido.id}`,
    `Data: ${dayjs(pedido.criado_em).format('DD/MM/YYYY')}`,
    `Cliente: ${pedido.cliente}`,
    '',
    ...pedido.itens.map((i) => `${i.quantidade} x ${i.nome}: ${formatarReais(i.preco * i.quantidade)}`),
    '',
    `Total: ${formatarReais(pedido.total)}`,
  ];
  return linhas.join('\n') + '\n';
}

const formatadores = { texto: formatarTexto };

function criarFormatador(formato) {
  const formatador = formatadores[formato];
  if (!formatador) throw new Error(`formato desconhecido: ${formato}`);
  return formatador;
}

export function gerarRecibo(pedido) {
  return criarFormatador('texto')(pedido);
}

export function salvarRecibo(pedido, pasta) {
  const caminho = join(pasta, `${pedido.id}.txt`);
  try {
    mkdirSync(pasta, { recursive: true });
    writeFileSync(caminho, gerarRecibo(pedido));
  } catch {}
  return caminho;
}

export function reciboResumido(pedido) {
  return `Pedido nº ${pedido.id}: ${formatarReais(pedido.total)}\n`;
}
__EOF__
cat > test/recibo.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, readFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { gerarRecibo, salvarRecibo } from '../src/recibo.js';

const pedido = {
  id: 42,
  criado_em: '2026-11-03T12:00:00Z',
  cliente: 'Ana Lima',
  itens: [
    { nome: 'Caneca esmaltada', preco: 4500, quantidade: 2 },
    { nome: 'Pôster A3', preco: 3000, quantidade: 1 },
  ],
  total: 12000,
};

test('recibo traz número, data, cliente, itens e total', () => {
  assert.equal(gerarRecibo(pedido), [
    'Pedido nº 42',
    'Data: 03/11/2026',
    'Cliente: Ana Lima',
    '',
    '2 x Caneca esmaltada: R$ 90,00',
    '1 x Pôster A3: R$ 30,00',
    '',
    'Total: R$ 120,00',
    '',
  ].join('\n'));
});

test('salvarRecibo grava <pasta>/<id>.txt e devolve o caminho', () => {
  const pasta = join(mkdtempSync(join(tmpdir(), 'recibos-')), 'recibos');
  const caminho = salvarRecibo(pedido, pasta);
  assert.equal(caminho, join(pasta, '42.txt'));
  assert.equal(readFileSync(caminho, 'utf8'), gerarRecibo(pedido));
});
__EOF__
commit_at "2026-11-14T15:00:00Z" "feat: recibo do pedido"

# Installed dependency (git-ignored), as `npm install` would leave it.
mkdir -p node_modules/dayjs
cat > node_modules/dayjs/package.json <<'__EOF__'
{ "name": "dayjs", "version": "1.11.13", "main": "dayjs.min.js" }
__EOF__
cat > node_modules/dayjs/dayjs.min.js <<'__EOF__'
module.exports = function dayjs(data) {
  const d = new Date(data);
  const dois = (n) => String(n).padStart(2, '0');
  return {
    format(molde) {
      return molde
        .replace('YYYY', String(d.getFullYear()))
        .replace('MM', dois(d.getMonth() + 1))
        .replace('DD', dois(d.getDate()));
    },
  };
};
__EOF__
