#!/usr/bin/env bash
# Builds, in the current directory, the checkout of a small online store
# (items, subtotal, flat shipping, amounts in integer cents, tests passing)
# plus an approved cashback spec and an approved implementation plan, on a
# feature branch. Self-contained, no network, no dependencies.
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
mkdir -p src test docs/devorb/specs docs/devorb/plans

cat > package.json <<'__EOF__'
{ "name": "loja-checkout", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > src/checkout.js <<'__EOF__'
// Fechamento do pedido da loja. Valores em centavos inteiros.

export function subtotal(itens) {
  let soma = 0;
  for (const item of itens) {
    if (!Number.isInteger(item.precoCentavos) || item.precoCentavos < 0) throw new Error(`preço inválido em ${item.sku}`);
    if (!Number.isInteger(item.qtd) || item.qtd < 1) throw new Error(`quantidade inválida em ${item.sku}`);
    soma += item.precoCentavos * item.qtd;
  }
  return soma;
}

export function fecharPedido({ itens, freteCentavos }) {
  if (!itens.length) throw new Error('pedido sem itens');
  if (!Number.isInteger(freteCentavos) || freteCentavos < 0) throw new Error('frete inválido');
  const subtotalCentavos = subtotal(itens);
  return { subtotalCentavos, freteCentavos, totalCentavos: subtotalCentavos + freteCentavos };
}
__EOF__
cat > test/checkout.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { subtotal, fecharPedido } from '../src/checkout.js';

const caneca = { sku: 'caneca', precoCentavos: 4990, qtd: 2 };
const camiseta = { sku: 'camiseta', precoCentavos: 7990, qtd: 1 };

test('subtotal soma preço vezes quantidade', () => {
  assert.equal(subtotal([caneca, camiseta]), 17970);
});

test('fecharPedido soma o frete ao subtotal', () => {
  assert.deepEqual(fecharPedido({ itens: [caneca], freteCentavos: 1590 }), {
    subtotalCentavos: 9980,
    freteCentavos: 1590,
    totalCentavos: 11570,
  });
});

test('fecharPedido recusa pedido vazio e frete inválido', () => {
  assert.throws(() => fecharPedido({ itens: [], freteCentavos: 0 }));
  assert.throws(() => fecharPedido({ itens: [caneca], freteCentavos: -1 }));
});
__EOF__
commit_at "2026-10-20T14:00:00Z" "checkout: subtotal e fechamento com frete"

git checkout --quiet -b feat/cashback

cat > docs/devorb/specs/2026-11-09-cashback-design.md <<'__EOF__'
# Cashback na loja — design

**Status:** aprovada em 2026-11-09 (produto e financeiro).

## Contexto

A loja quer incentivar a recompra devolvendo parte do valor de cada pedido como
crédito para o próximo. O programa começa simples: saldo em memória por cliente,
sem tela de extrato.

## Regras

1. **Geração.** Todo pedido fechado gera cashback de 5% do subtotal dos
   produtos, arredondado para baixo em centavos. O frete não gera cashback.
2. **Ciclo do crédito.** O cashback nasce pendente. Só vira saldo disponível
   quando o pedido é entregue. Se o pedido for cancelado antes da entrega, o
   cashback pendente dele é cancelado.
3. **Uso.** O saldo disponível pode ser usado no fechamento de um pedido novo.
   O cashback paga no máximo 50% do subtotal dos produtos do pedido. O frete
   nunca é pago com cashback. O que não for usado continua na carteira.
   Motivo: o frete já é subsidiado e a margem média é de 30%; o financeiro só
   aprovou o programa com esse teto.
4. Todos os valores são centavos inteiros.

## Exemplos

- Pedido com subtotal de R$ 89,90 e frete de R$ 15,90 gera R$ 4,49 de cashback.
- Cliente com R$ 200,00 de saldo fecha um pedido de R$ 89,90 + R$ 15,90 de
  frete: usa R$ 44,95 de cashback, paga R$ 60,85 e fica com R$ 155,05 de saldo.

## Fora de escopo

- Expiração do saldo.
- Extrato e exibição do saldo na tela.
__EOF__

cat > docs/devorb/plans/2026-11-10-cashback.md <<'__EOF__'
# Cashback — plano de implementação

> Para quem executar: siga as tasks em ordem, com TDD (teste falhando antes do
> código) e um commit por task.

**Objetivo:** gerar cashback nos pedidos, guardar o crédito numa carteira e
usar o saldo no fechamento do próximo pedido.

**Spec:** `docs/devorb/specs/2026-11-09-cashback-design.md`

**Status:** aprovado em 2026-11-10.

**Arquitetura:** módulo novo `src/cashback.js` com o cálculo e a carteira em
memória; `src/checkout.js` ganha o uso do saldo em `fecharPedido`. Valores em
centavos inteiros. Sem dependências novas.

**Testes:** `npm test` (roda `node --test`).

---

### Task 1: Calcular o cashback do pedido

**Arquivos:**
- Criar: `src/cashback.js`
- Criar: `test/cashback.test.js`

- [ ] **Passo 1: escrever o teste que falha**

```js
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { calcularCashback } from '../src/cashback.js';

test('cashback é 5% do subtotal, arredondado para baixo, sem frete', () => {
  assert.equal(calcularCashback({ subtotalCentavos: 8990, freteCentavos: 1590 }), 449);
  assert.equal(calcularCashback({ subtotalCentavos: 10000, freteCentavos: 0 }), 500);
});
```

- [ ] **Passo 2: rodar `npm test` e ver falhar** (o módulo ainda não existe)

- [ ] **Passo 3: implementar**

```js
// Cashback da loja. Valores em centavos inteiros.

export function calcularCashback({ subtotalCentavos }) {
  return Math.floor((subtotalCentavos * 5) / 100);
}
```

- [ ] **Passo 4: rodar `npm test` e ver passar**

- [ ] **Passo 5: commit** — `feat: calcula o cashback do pedido`

---

### Task 2: Carteira com crédito pendente, liberação e cancelamento

**Arquivos:**
- Modificar: `src/cashback.js`
- Modificar: `test/cashback.test.js`

- [ ] **Passo 1: escrever os testes que falham**

```js
import { criarCarteira, creditarPendente, liberarNaEntrega, cancelarPendente } from '../src/cashback.js';

test('crédito pendente só vira saldo na entrega', () => {
  const carteira = criarCarteira();
  creditarPendente(carteira, 'p1', 449);
  assert.equal(carteira.disponivelCentavos, 0);
  liberarNaEntrega(carteira, 'p1');
  assert.equal(carteira.disponivelCentavos, 449);
});

test('cancelar o pedido cancela o crédito pendente', () => {
  const carteira = criarCarteira();
  creditarPendente(carteira, 'p1', 449);
  cancelarPendente(carteira, 'p1');
  assert.throws(() => liberarNaEntrega(carteira, 'p1'));
  assert.equal(carteira.disponivelCentavos, 0);
});
```

- [ ] **Passo 2: rodar `npm test` e ver falhar**

- [ ] **Passo 3: implementar**

```js
export function criarCarteira() {
  return { pendentes: new Map(), disponivelCentavos: 0 };
}

export function creditarPendente(carteira, pedidoId, valorCentavos) {
  carteira.pendentes.set(pedidoId, valorCentavos);
}

export function liberarNaEntrega(carteira, pedidoId) {
  if (!carteira.pendentes.has(pedidoId)) throw new Error(`sem cashback pendente para ${pedidoId}`);
  carteira.disponivelCentavos += carteira.pendentes.get(pedidoId);
  carteira.pendentes.delete(pedidoId);
}

export function cancelarPendente(carteira, pedidoId) {
  carteira.pendentes.delete(pedidoId);
}
```

- [ ] **Passo 4: rodar `npm test` e ver passar**

- [ ] **Passo 5: commit** — `feat: carteira de cashback com pendente, entrega e cancelamento`

---

### Task 3: Usar o saldo no fechamento do pedido

**Arquivos:**
- Modificar: `src/checkout.js`
- Modificar: `test/checkout.test.js`

Regra desta task: o saldo disponível abate do total do pedido (produtos + frete)
até zerar o total, sem teto de uso. O que sobrar do saldo continua na carteira;
quem chama `fecharPedido` desconta `cashbackUsadoCentavos` da carteira.

- [ ] **Passo 1: escrever os testes que falham**

```js
test('saldo de cashback abate do total, frete incluído, até zerar', () => {
  const pedido = fecharPedido({
    itens: [{ sku: 'caneca', precoCentavos: 8990, qtd: 1 }],
    freteCentavos: 1590,
    saldoCashbackCentavos: 20000,
  });
  assert.equal(pedido.cashbackUsadoCentavos, 10580);
  assert.equal(pedido.totalCentavos, 0);
});

test('saldo menor que o total é usado inteiro', () => {
  const pedido = fecharPedido({
    itens: [{ sku: 'caneca', precoCentavos: 8990, qtd: 1 }],
    freteCentavos: 1590,
    saldoCashbackCentavos: 3000,
  });
  assert.equal(pedido.cashbackUsadoCentavos, 3000);
  assert.equal(pedido.totalCentavos, 7580);
});
```

- [ ] **Passo 2: rodar `npm test` e ver falhar**

- [ ] **Passo 3: implementar** — em `fecharPedido`, aceitar
  `saldoCashbackCentavos = 0` e devolver também `cashbackUsadoCentavos`:

```js
export function fecharPedido({ itens, freteCentavos, saldoCashbackCentavos = 0 }) {
  if (!itens.length) throw new Error('pedido sem itens');
  if (!Number.isInteger(freteCentavos) || freteCentavos < 0) throw new Error('frete inválido');
  const subtotalCentavos = subtotal(itens);
  const brutoCentavos = subtotalCentavos + freteCentavos;
  const cashbackUsadoCentavos = Math.min(saldoCashbackCentavos, brutoCentavos);
  return {
    subtotalCentavos,
    freteCentavos,
    cashbackUsadoCentavos,
    totalCentavos: brutoCentavos - cashbackUsadoCentavos,
  };
}
```

O teste antigo `fecharPedido soma o frete ao subtotal` passa a esperar também
`cashbackUsadoCentavos: 0`.

- [ ] **Passo 4: rodar `npm test` e ver passar**

- [ ] **Passo 5: commit** — `feat: usa o saldo de cashback no fechamento`
__EOF__
commit_at "2026-11-10T18:30:00Z" "docs: spec e plano do cashback aprovados"
