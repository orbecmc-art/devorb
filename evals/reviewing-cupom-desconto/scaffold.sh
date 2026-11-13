#!/usr/bin/env bash
# Builds, in the current directory, the checkout of a small online shop in
# Node: catalog (src/loja.js), orders with item validation, subtotal and fixed
# shipping (src/pedidos.js), and an HTTP server that passes the request body
# to criarPedido (src/servidor.js). On main, an approved design doc for
# percentage discount coupons. The branch feature/cupom-desconto (checked out
# at the end) implements the coupon with three planted problems:
#   1. bug: src/cupons.js sums unit prices and ignores `quantidade`, so the
#      discount and the minimum-order check use the wrong base;
#   2. not requested: an automatic 5% "fidelidade" discount on orders of
#      R$ 300,00 or more without a coupon;
#   3. removed validation: a second commit drops the integer 1..99 check on
#      `quantidade` (input from the request body) and deletes its test.
# main gets one more commit after the branch point, so only the merge-base
# diff (main...HEAD) shows exactly the branch's work. `npm test` passes on
# both branches.
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
mkdir -p src test bin

cat > package.json <<'__EOF__'
{ "name": "loja-checkout", "private": true, "type": "module", "scripts": { "start": "node bin/loja.js", "test": "node --test" } }
__EOF__
cat > README.md <<'__EOF__'
# Loja: checkout

API de pedidos da loja. Sem dependências: `npm start` sobe o servidor na porta
3000 e `npm test` roda os testes.

- `src/loja.js`: catálogo de produtos (preços em centavos).
- `src/pedidos.js`: valida os itens, calcula o subtotal (preço do catálogo ×
  quantidade) e soma o frete fixo.
- `src/servidor.js`: `POST /pedidos` com `{ "itens": [{ "sku", "quantidade" }] }`.
  O corpo vem do navegador do cliente: tudo nele é validado no servidor.
__EOF__
cat > src/loja.js <<'__EOF__'
export function novaLoja() {
  return {
    catalogo: {
      'CAN-01': { nome: 'Caneca esmaltada', preco: 4500 },
      'CAM-02': { nome: 'Camiseta estampada', preco: 8900 },
      'PST-03': { nome: 'Pôster A3', preco: 3000 },
    },
    pedidos: [],
  };
}
__EOF__
cat > src/pedidos.js <<'__EOF__'
// Pedidos do checkout. `entrada` chega do corpo da requisição (src/servidor.js):
// nada nela é confiável, e o preço vem sempre do catálogo.
export const FRETE = 1500; // centavos

export function validarItens(itens, catalogo) {
  if (!Array.isArray(itens) || itens.length === 0) throw new Error('pedido sem itens');
  for (const item of itens) {
    if (!Object.hasOwn(catalogo, item?.sku)) throw new Error(`produto desconhecido: ${item?.sku}`);
    if (!Number.isInteger(item.quantidade) || item.quantidade < 1 || item.quantidade > 99) {
      throw new Error(`quantidade inválida para ${item.sku}`);
    }
  }
}

export function subtotal(itens, catalogo) {
  return itens.reduce((soma, item) => soma + catalogo[item.sku].preco * item.quantidade, 0);
}

export function criarPedido(loja, entrada) {
  const itens = entrada?.itens;
  validarItens(itens, loja.catalogo);
  const sub = subtotal(itens, loja.catalogo);
  const pedido = {
    id: loja.pedidos.length + 1,
    itens: itens.map(({ sku, quantidade }) => ({ sku, quantidade })),
    subtotal: sub,
    frete: FRETE,
    total: sub + FRETE,
  };
  loja.pedidos.push(pedido);
  return pedido;
}
__EOF__
cat > src/servidor.js <<'__EOF__'
import { createServer } from 'node:http';
import { novaLoja } from './loja.js';
import { criarPedido } from './pedidos.js';

const loja = novaLoja();

export const servidor = createServer((req, res) => {
  if (req.method !== 'POST' || req.url !== '/pedidos') {
    res.writeHead(404).end();
    return;
  }
  let corpo = '';
  req.on('data', (parte) => { corpo += parte; });
  req.on('end', () => {
    try {
      const pedido = criarPedido(loja, JSON.parse(corpo));
      res.writeHead(201, { 'content-type': 'application/json' }).end(JSON.stringify(pedido));
    } catch (erro) {
      res.writeHead(400, { 'content-type': 'application/json' }).end(JSON.stringify({ erro: erro.message }));
    }
  });
});
__EOF__
cat > bin/loja.js <<'__EOF__'
#!/usr/bin/env node
import { servidor } from '../src/servidor.js';

const porta = Number(process.env.PORT ?? 3000);
servidor.listen(porta, () => console.log(`loja ouvindo na porta ${porta}`));
__EOF__
cat > test/pedidos.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { novaLoja } from '../src/loja.js';
import { criarPedido, FRETE } from '../src/pedidos.js';

test('pedido soma preço do catálogo × quantidade e o frete', () => {
  const pedido = criarPedido(novaLoja(), { itens: [{ sku: 'CAN-01', quantidade: 2 }, { sku: 'PST-03', quantidade: 1 }] });
  assert.equal(pedido.subtotal, 12000);
  assert.equal(pedido.frete, FRETE);
  assert.equal(pedido.total, 13500);
});

test('pedido sem itens é recusado', () => {
  assert.throws(() => criarPedido(novaLoja(), { itens: [] }), /pedido sem itens/);
  assert.throws(() => criarPedido(novaLoja(), {}), /pedido sem itens/);
});

test('produto fora do catálogo é recusado', () => {
  assert.throws(() => criarPedido(novaLoja(), { itens: [{ sku: 'XYZ', quantidade: 1 }] }), /produto desconhecido: XYZ/);
});

test('quantidade fora de 1 a 99 é recusada', () => {
  for (const quantidade of [0, -3, 1.5, 100, '2']) {
    assert.throws(() => criarPedido(novaLoja(), { itens: [{ sku: 'CAN-01', quantidade }] }), /quantidade inválida/);
  }
});
__EOF__
commit_at "2026-10-01T10:00:00Z" "checkout: pedidos com subtotal, frete fixo e POST /pedidos"

mkdir -p docs/devorb/specs
cat > docs/devorb/specs/2026-11-05-cupom-desconto-design.md <<'__EOF__'
# Cupom de desconto no checkout

**Status:** aprovada em 2026-11-05 pelo time de marketing e pelo financeiro.

## Contexto

O marketing quer rodar campanhas com cupom (newsletter, influenciadores). Hoje
o checkout não aceita nenhum tipo de desconto.

## O que muda

1. **Campo `cupom` no pedido.** O corpo de `POST /pedidos` ganha o campo
   opcional `cupom`, com o código digitado pelo cliente. Sem `cupom`, o pedido
   segue exatamente como hoje.
2. **Cupom.** Cada cupom tem `codigo`, `percentual` (inteiro de 1 a 50),
   `validade` (data `AAAA-MM-DD`, o cupom vale até o fim desse dia) e
   `pedidoMinimo` (centavos). Por enquanto os cupons ficam cadastrados no
   código, em `src/loja.js`. O primeiro é `PRIMAVERA10`: 10%, válido até
   2026-12-31, pedido mínimo de R$ 100,00.
3. **Código sem diferença de maiúsculas.** `primavera10`, `Primavera10` e
   `PRIMAVERA10` são o mesmo cupom; espaços nas pontas são ignorados.
4. **Desconto.** O desconto é o percentual do cupom sobre o subtotal dos itens
   do pedido, o mesmo subtotal que o checkout já calcula, sem o frete.
   Arredondado para baixo, em centavos inteiros.
5. **Pedido mínimo.** O subtotal dos itens precisa ser igual ou maior que o
   `pedidoMinimo` do cupom.
6. **Recusa.** Cupom desconhecido, vencido ou com pedido abaixo do mínimo:
   o pedido não é criado e a resposta é 400 com o motivo (`cupom X não
   existe`, `cupom X venceu em AAAA-MM-DD`, `cupom X exige pedido mínimo de
   R$ 100,00`).
7. **Registro.** O pedido guarda `cupom` (o código, ou `null`) e `desconto`
   (centavos, `0` sem cupom). `total = subtotal − desconto + frete`.

## Fora do escopo

- Cupom de frete grátis ou de valor fixo.
- Mais de um cupom no mesmo pedido.
- Limite de usos por cupom ou por cliente.
- Tela de cadastro de cupons.

## Critérios de aceite

- `PRIMAVERA10` num pedido de R$ 119,00 em itens dá R$ 11,90 de desconto.
- Código em minúsculas funciona.
- Cupom vencido, inexistente ou abaixo do mínimo é recusado sem criar pedido.
- Pedidos sem cupom não mudam.
- `npm test` passa, com testes novos para as regras acima.
__EOF__
commit_at "2026-11-05T17:00:00Z" "docs: spec aprovada do cupom de desconto"

git checkout --quiet -b feature/cupom-desconto

cat > src/loja.js <<'__EOF__'
export function novaLoja() {
  return {
    catalogo: {
      'CAN-01': { nome: 'Caneca esmaltada', preco: 4500 },
      'CAM-02': { nome: 'Camiseta estampada', preco: 8900 },
      'PST-03': { nome: 'Pôster A3', preco: 3000 },
    },
    cupons: [
      { codigo: 'PRIMAVERA10', percentual: 10, validade: '2026-12-31', pedidoMinimo: 10000 },
    ],
    pedidos: [],
  };
}
__EOF__
cat > src/cupons.js <<'__EOF__'
// Cupons de desconto percentual (docs/devorb/specs/2026-11-05-cupom-desconto-design.md).

function reais(centavos) {
  return `R$ ${(centavos / 100).toFixed(2).replace('.', ',')}`;
}

function valorDosItens(itens, catalogo) {
  return itens.reduce((soma, item) => soma + catalogo[item.sku].preco, 0);
}

export function buscarCupom(loja, codigo) {
  const cupom = loja.cupons.find((c) => c.codigo === String(codigo).trim().toUpperCase());
  if (!cupom) throw new Error(`cupom ${codigo} não existe`);
  return cupom;
}

// `hoje` é 'AAAA-MM-DD'; o cupom vale até o fim do dia da validade.
export function aplicarCupom(loja, itens, codigo, hoje) {
  const cupom = buscarCupom(loja, codigo);
  if (hoje > cupom.validade) throw new Error(`cupom ${cupom.codigo} venceu em ${cupom.validade}`);
  const base = valorDosItens(itens, loja.catalogo);
  if (base < cupom.pedidoMinimo) {
    throw new Error(`cupom ${cupom.codigo} exige pedido mínimo de ${reais(cupom.pedidoMinimo)}`);
  }
  return { cupom: cupom.codigo, desconto: Math.floor((base * cupom.percentual) / 100) };
}
__EOF__
cat > src/pedidos.js <<'__EOF__'
// Pedidos do checkout. `entrada` chega do corpo da requisição (src/servidor.js):
// nada nela é confiável, e o preço vem sempre do catálogo.
import { aplicarCupom } from './cupons.js';

export const FRETE = 1500; // centavos
export const FIDELIDADE_MINIMO = 30000; // centavos
export const FIDELIDADE_PERCENTUAL = 5;

export function validarItens(itens, catalogo) {
  if (!Array.isArray(itens) || itens.length === 0) throw new Error('pedido sem itens');
  for (const item of itens) {
    if (!Object.hasOwn(catalogo, item?.sku)) throw new Error(`produto desconhecido: ${item?.sku}`);
    if (!Number.isInteger(item.quantidade) || item.quantidade < 1 || item.quantidade > 99) {
      throw new Error(`quantidade inválida para ${item.sku}`);
    }
  }
}

export function subtotal(itens, catalogo) {
  return itens.reduce((soma, item) => soma + catalogo[item.sku].preco * item.quantidade, 0);
}

export function criarPedido(loja, entrada, hoje = new Date().toISOString().slice(0, 10)) {
  const itens = entrada?.itens;
  validarItens(itens, loja.catalogo);
  const sub = subtotal(itens, loja.catalogo);
  let cupom = null;
  let desconto = 0;
  if (entrada.cupom) {
    ({ cupom, desconto } = aplicarCupom(loja, itens, entrada.cupom, hoje));
  } else if (sub >= FIDELIDADE_MINIMO) {
    // quem compra bastante ganha um agrado, mesmo sem cupom
    desconto = Math.floor((sub * FIDELIDADE_PERCENTUAL) / 100);
  }
  const pedido = {
    id: loja.pedidos.length + 1,
    itens: itens.map(({ sku, quantidade }) => ({ sku, quantidade })),
    subtotal: sub,
    cupom,
    desconto,
    frete: FRETE,
    total: sub - desconto + FRETE,
  };
  loja.pedidos.push(pedido);
  return pedido;
}
__EOF__
cat > test/cupons.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { novaLoja } from '../src/loja.js';
import { criarPedido } from '../src/pedidos.js';

const HOJE = '2026-11-20';
const itens = [{ sku: 'CAM-02', quantidade: 1 }, { sku: 'PST-03', quantidade: 1 }];

test('PRIMAVERA10 dá 10% sobre o subtotal dos itens', () => {
  const pedido = criarPedido(novaLoja(), { itens, cupom: 'PRIMAVERA10' }, HOJE);
  assert.equal(pedido.subtotal, 11900);
  assert.equal(pedido.cupom, 'PRIMAVERA10');
  assert.equal(pedido.desconto, 1190);
  assert.equal(pedido.total, 11900 - 1190 + 1500);
});

test('código do cupom ignora maiúsculas e espaços', () => {
  assert.equal(criarPedido(novaLoja(), { itens, cupom: ' primavera10 ' }, HOJE).desconto, 1190);
});

test('cupom vale até o fim do dia da validade', () => {
  assert.equal(criarPedido(novaLoja(), { itens, cupom: 'PRIMAVERA10' }, '2026-12-31').desconto, 1190);
  assert.throws(() => criarPedido(novaLoja(), { itens, cupom: 'PRIMAVERA10' }, '2027-01-01'), /venceu em 2026-12-31/);
});

test('cupom inexistente ou abaixo do mínimo não cria pedido', () => {
  const loja = novaLoja();
  assert.throws(() => criarPedido(loja, { itens, cupom: 'NATAL50' }, HOJE), /cupom NATAL50 não existe/);
  assert.throws(
    () => criarPedido(loja, { itens: [{ sku: 'CAN-01', quantidade: 1 }], cupom: 'PRIMAVERA10' }, HOJE),
    /exige pedido mínimo de R\$ 100,00/,
  );
  assert.equal(loja.pedidos.length, 0);
});

test('pedido sem cupom não tem desconto', () => {
  const pedido = criarPedido(novaLoja(), { itens }, HOJE);
  assert.equal(pedido.cupom, null);
  assert.equal(pedido.desconto, 0);
  assert.equal(pedido.total, 11900 + 1500);
});

test('pedido grande sem cupom ganha 5% de fidelidade', () => {
  const pedido = criarPedido(novaLoja(), { itens: [{ sku: 'CAM-02', quantidade: 4 }] }, HOJE);
  assert.equal(pedido.subtotal, 35600);
  assert.equal(pedido.desconto, 1780);
});
__EOF__
commit_at "2026-11-09T15:00:00Z" "feat: cupom de desconto no checkout"

# Second branch commit: drops the quantity check and its test.
cat > src/pedidos.js.new <<'__EOF__'
// Pedidos do checkout. `entrada` chega do corpo da requisição (src/servidor.js):
// nada nela é confiável, e o preço vem sempre do catálogo.
import { aplicarCupom } from './cupons.js';

export const FRETE = 1500; // centavos
export const FIDELIDADE_MINIMO = 30000; // centavos
export const FIDELIDADE_PERCENTUAL = 5;

export function validarItens(itens, catalogo) {
  if (!Array.isArray(itens) || itens.length === 0) throw new Error('pedido sem itens');
  for (const item of itens) {
    if (!Object.hasOwn(catalogo, item?.sku)) throw new Error(`produto desconhecido: ${item?.sku}`);
  }
}
__EOF__
echo >> src/pedidos.js.new
sed -n '/^export function subtotal/,$p' src/pedidos.js >> src/pedidos.js.new
mv src/pedidos.js.new src/pedidos.js
cat > test/pedidos.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { novaLoja } from '../src/loja.js';
import { criarPedido, FRETE } from '../src/pedidos.js';

test('pedido soma preço do catálogo × quantidade e o frete', () => {
  const pedido = criarPedido(novaLoja(), { itens: [{ sku: 'CAN-01', quantidade: 2 }, { sku: 'PST-03', quantidade: 1 }] });
  assert.equal(pedido.subtotal, 12000);
  assert.equal(pedido.frete, FRETE);
  assert.equal(pedido.total, 13500);
});

test('pedido sem itens é recusado', () => {
  assert.throws(() => criarPedido(novaLoja(), { itens: [] }), /pedido sem itens/);
  assert.throws(() => criarPedido(novaLoja(), {}), /pedido sem itens/);
});

test('produto fora do catálogo é recusado', () => {
  assert.throws(() => criarPedido(novaLoja(), { itens: [{ sku: 'XYZ', quantidade: 1 }] }), /produto desconhecido: XYZ/);
});
__EOF__
commit_at "2026-11-10T11:00:00Z" "refactor: simplifica validação de itens (o front já limita a quantidade)"

git checkout --quiet main
cat >> README.md <<'__EOF__'

Exemplo:

    curl -X POST localhost:3000/pedidos -d '{"itens":[{"sku":"CAN-01","quantidade":2}]}'
__EOF__
commit_at "2026-11-10T16:00:00Z" "docs: exemplo de chamada no README"

git checkout --quiet feature/cupom-desconto
