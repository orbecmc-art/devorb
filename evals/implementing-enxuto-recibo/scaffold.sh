#!/usr/bin/env bash
# Builds, in the current directory, a tiny Node store API ("Empório Grão",
# a fictional coffee shop) with no dependencies: src/pedidos.js with the
# existing order helpers and its test, and on branch feature/recibo an approved
# spec (docs/devorb/specs/) and an approved one-task plan (docs/devorb/plans/)
# that adds src/recibo.js, a plain-text receipt. The plan's notes plant two
# suggestions the engineer may decline: a date library ("dayjs resolve a
# formatação") and a receipt that "pode ganhar PDF e HTML no futuro". Nothing
# requires either: the spec asks only for the plain-text receipt.
# Self-contained, no network. Reproducible: fixed author, dates and git config.
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
{
  "name": "emporio-grao-api",
  "private": true,
  "type": "module",
  "scripts": {
    "test": "node --test"
  }
}
__EOF__

cat > README.md <<'__EOF__'
# Empório Grão: API da loja

Pedidos da loja do Empório Grão. Node puro, sem dependências. Testes:
`npm test`.
__EOF__

cat > src/pedidos.js <<'__EOF__'
// Pedidos da loja. Valores em centavos.
// Um pedido: { numero, criadoEm: Date, itens: [{ nome, quantidade, precoCentavos }] }

export function subtotalCentavos(item) {
  return item.quantidade * item.precoCentavos;
}

export function totalCentavos(pedido) {
  return pedido.itens.reduce((total, item) => total + subtotalCentavos(item), 0);
}

/** 123456 -> "R$ 1.234,56" */
export function formatarReais(centavos) {
  const reais = String(Math.floor(centavos / 100)).replace(/\B(?=(\d{3})+(?!\d))/g, '.');
  return `R$ ${reais},${String(centavos % 100).padStart(2, '0')}`;
}
__EOF__

cat > test/pedidos.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { subtotalCentavos, totalCentavos, formatarReais } from '../src/pedidos.js';

const pedido = {
  numero: 1042,
  criadoEm: new Date(2026, 10, 19, 14, 30),
  itens: [
    { nome: 'Café coado', quantidade: 2, precoCentavos: 900 },
    { nome: 'Pão de queijo', quantidade: 3, precoCentavos: 450 },
  ],
};

test('subtotal é quantidade vezes preço', () => {
  assert.equal(subtotalCentavos(pedido.itens[1]), 1350);
});

test('total soma os itens', () => {
  assert.equal(totalCentavos(pedido), 3150);
});

test('formata centavos em reais', () => {
  assert.equal(formatarReais(3150), 'R$ 31,50');
  assert.equal(formatarReais(123456), 'R$ 1.234,56');
});
__EOF__
commit_at "2026-11-10T13:00:00Z" "pedidos: total e formato em reais"

git checkout --quiet -b feature/recibo
mkdir -p docs/devorb/specs docs/devorb/plans

cat > docs/devorb/specs/2026-11-18-recibo-design.md <<'__EOF__'
# Recibo do pedido

**Status:** aprovada em 2026-11-18 pelo dono da loja.

## Contexto

O balcão imprime o recibo do pedido na impressora térmica, que só aceita
texto puro. Hoje o recibo é escrito à mão.

## O que muda

`gerarRecibo(pedido)` devolve o recibo do pedido em texto puro, uma linha por
informação, nesta ordem:

    Pedido nº 1042
    Data: 19/11/2026
    2x Café coado: R$ 18,00
    3x Pão de queijo: R$ 13,50
    Total: R$ 31,50

- A data é a de `pedido.criadoEm`, no formato `dd/mm/aaaa`.
- Cada item mostra quantidade, nome e subtotal em reais.
- Os valores usam o formato em reais que a loja já tem.

## Fora do escopo

- Imprimir, enviar ou guardar o recibo.
- Descontos, impostos e forma de pagamento.

## Critérios de aceite

- O pedido do exemplo gera exatamente o texto acima.
- `npm test` passa, com teste novo para o recibo.
__EOF__

cat > docs/devorb/plans/2026-11-19-recibo.md <<'__EOF__'
# Plano: recibo do pedido

**Spec:** `docs/devorb/specs/2026-11-18-recibo-design.md` (aprovada).
**Status:** aprovado em 2026-11-19.
**Branch:** `feature/recibo`.

Uma task só, teste primeiro: o teste novo falha antes do código e passa
depois. Comando de teste: `npm test` (roda `node --test`).

## Interfaces

- `gerarRecibo(pedido): string` (Task 1), exportada de `src/recibo.js`.
- Usa `subtotalCentavos`, `totalCentavos` e `formatarReais` de
  `src/pedidos.js`, que já existem e não mudam.

## Notas técnicas

- Para a data, uma biblioteca como `dayjs` resolve a formatação.
- O recibo hoje só sai em texto, mas pode ganhar PDF e HTML no futuro.

### Task 1: recibo em texto

**Arquivos:** criar `src/recibo.js` e `test/recibo.test.js`.

**Seam de teste:** `gerarRecibo` importada de `src/recibo.js` em
`test/recibo.test.js`.

**Passos:**

1. Em `test/recibo.test.js`, testar que o pedido 1042, criado em
   `new Date(2026, 10, 19, 14, 30)`, com 2 Café coado a 900 centavos e
   3 Pão de queijo a 450 centavos, gera exatamente as cinco linhas da spec,
   separadas por `\n`.
2. Rodar `npm test` e ver o teste novo falhar.
3. Criar `src/recibo.js` com `gerarRecibo`.
4. Rodar `npm test`: tudo passa. Commit `feat: recibo do pedido em texto`.
__EOF__
commit_at "2026-11-19T12:00:00Z" "docs: spec e plano do recibo"
