#!/usr/bin/env bash
# Builds, in the current directory, a small online store in Node whose price
# helpers live in a shallow module, src/precos.js: five tiny functions that
# every caller (carrinho, pedido, nota) must compose in the right order. The
# history has 15 commits; src/precos.js changes in 12 of them, mostly in fixes
# about the order of discount, coupon, tax and shipping. src/relatorios.js is
# the biggest file but changes only once. Tests pass. Self-contained, no
# network. Reproducible: fixed author, dates and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

commit_at() { # date, message
  git add -A
  GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git commit --quiet -m "$2"
}

replace() { # file, exact old text, new text
  node -e '
    const fs = require("fs");
    const [file, from, to] = process.argv.slice(1);
    const text = fs.readFileSync(file, "utf8");
    if (!text.includes(from)) { console.error("scaffold: text not found in " + file); process.exit(1); }
    fs.writeFileSync(file, text.replace(from, to));
  ' "$1" "$2" "$3"
}

git init --quiet -b main
mkdir -p src test

# 1. Catalog and reports.
cat > package.json <<'__EOF__'
{ "name": "loja", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > README.md <<'__EOF__'
# Loja

Catálogo, carrinho, pedido e nota fiscal da loja. Sem dependências:
`npm test` roda os testes. Valores sempre em centavos inteiros.
__EOF__
cat > src/catalogo.js <<'__EOF__'
// Product catalog.

export function produto(catalogo, sku) {
  const item = catalogo.find((p) => p.sku === sku);
  if (!item) throw new Error(`produto ${sku} não existe`);
  return item;
}
__EOF__
cat > src/relatorios.js <<'__EOF__'
// Sales reports for the back office. Amounts are integer cents.

function mesDe(data) {
  return data.slice(0, 7);
}

function somar(lista, campo) {
  return lista.reduce((soma, item) => soma + item[campo], 0);
}

export function vendasPorMes(pedidos) {
  const meses = {};
  for (const pedido of pedidos) {
    const mes = mesDe(pedido.data);
    if (!meses[mes]) meses[mes] = { mes, pedidos: 0, totalCentavos: 0 };
    meses[mes].pedidos += 1;
    meses[mes].totalCentavos += pedido.totalCentavos;
  }
  return Object.values(meses).sort((a, b) => a.mes.localeCompare(b.mes));
}

export function ticketMedio(pedidos) {
  if (pedidos.length === 0) return 0;
  return Math.round(somar(pedidos, 'totalCentavos') / pedidos.length);
}

export function maisVendidos(pedidos, limite = 5) {
  const quantidades = {};
  for (const pedido of pedidos) {
    for (const item of pedido.itens) {
      quantidades[item.sku] = (quantidades[item.sku] ?? 0) + item.quantidade;
    }
  }
  return Object.entries(quantidades)
    .map(([sku, quantidade]) => ({ sku, quantidade }))
    .sort((a, b) => b.quantidade - a.quantidade || a.sku.localeCompare(b.sku))
    .slice(0, limite);
}

export function vendasPorEstado(pedidos) {
  const estados = {};
  for (const pedido of pedidos) {
    const uf = pedido.endereco?.uf ?? 'desconhecido';
    estados[uf] = (estados[uf] ?? 0) + pedido.totalCentavos;
  }
  return estados;
}

export function clientesRecorrentes(pedidos) {
  const contagem = {};
  for (const pedido of pedidos) contagem[pedido.clienteId] = (contagem[pedido.clienteId] ?? 0) + 1;
  return Object.keys(contagem).filter((id) => contagem[id] > 1).sort();
}

export function linhaCsv(campos) {
  return campos.map((campo) => String(campo).replaceAll(';', ',')).join(';');
}

export function relatorioMensalCsv(pedidos) {
  const linhas = [linhaCsv(['mes', 'pedidos', 'total_centavos'])];
  for (const mes of vendasPorMes(pedidos)) linhas.push(linhaCsv([mes.mes, mes.pedidos, mes.totalCentavos]));
  return linhas.join('\n') + '\n';
}

export function resumo(pedidos) {
  return {
    pedidos: pedidos.length,
    totalCentavos: somar(pedidos, 'totalCentavos'),
    ticketMedioCentavos: ticketMedio(pedidos),
    maisVendidos: maisVendidos(pedidos, 3),
    recorrentes: clientesRecorrentes(pedidos).length,
  };
}
__EOF__
cat > test/catalogo.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { produto } from '../src/catalogo.js';

const catalogo = [{ sku: 'caneca', nome: 'Caneca', precoCentavos: 3990 }];

test('finds a product by sku', () => {
  assert.equal(produto(catalogo, 'caneca').nome, 'Caneca');
});

test('unknown sku throws', () => {
  assert.throws(() => produto(catalogo, 'nada'), /não existe/);
});
__EOF__
cat > test/relatorios.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { vendasPorMes, ticketMedio } from '../src/relatorios.js';

const pedidos = [
  { data: '2026-09-02', totalCentavos: 1000, itens: [] },
  { data: '2026-09-20', totalCentavos: 3000, itens: [] },
  { data: '2026-10-01', totalCentavos: 2000, itens: [] },
];

test('groups sales by month', () => {
  assert.deepEqual(vendasPorMes(pedidos).map((m) => [m.mes, m.totalCentavos]), [['2026-09', 4000], ['2026-10', 2000]]);
});

test('average ticket', () => {
  assert.equal(ticketMedio(pedidos), 2000);
});
__EOF__
commit_at "2026-09-01T10:00:00-03:00" "feat: catálogo e relatórios de vendas"

# 2. Percentage discount in the cart.
cat > src/precos.js <<'__EOF__'
// Price helpers. Amounts are integer cents; percentages are 0-100.

export function aplicarDesconto(centavos, percentual) {
  return centavos - (centavos * percentual) / 100;
}
__EOF__
cat > src/carrinho.js <<'__EOF__'
import { aplicarDesconto } from './precos.js';

export function subtotal(itens) {
  return itens.reduce((soma, item) => soma + item.precoCentavos * item.quantidade, 0);
}

export function totalCarrinho(itens, { descontoPercentual = 0 } = {}) {
  return aplicarDesconto(subtotal(itens), descontoPercentual);
}
__EOF__
cat > test/precos.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { aplicarDesconto } from '../src/precos.js';

test('10% off', () => {
  assert.equal(aplicarDesconto(10000, 10), 9000);
});
__EOF__
commit_at "2026-09-03T10:00:00-03:00" "feat: desconto percentual no carrinho"

# 3. Tax in the order total (applied before the discount: bug).
cat >> src/precos.js <<'__EOF__'

export function somarImposto(centavos, aliquota) {
  return centavos + (centavos * aliquota) / 100;
}
__EOF__
cat > src/pedido.js <<'__EOF__'
import { aplicarDesconto, somarImposto } from './precos.js';
import { subtotal } from './carrinho.js';

export function totalPedido(pedido) {
  return aplicarDesconto(somarImposto(subtotal(pedido.itens), pedido.aliquota), pedido.descontoPercentual ?? 0);
}
__EOF__
commit_at "2026-09-05T10:00:00-03:00" "feat: imposto no total do pedido"

# 4. Fix the order of discount and tax.
replace src/precos.js "// Price helpers. Amounts are integer cents; percentages are 0-100.
" "// Price helpers. Amounts are integer cents; percentages are 0-100.
// Callers: apply the discount before the tax.
"
cat > src/pedido.js <<'__EOF__'
import { aplicarDesconto, somarImposto } from './precos.js';
import { subtotal } from './carrinho.js';

export function totalPedido(pedido) {
  const mercadorias = aplicarDesconto(subtotal(pedido.itens), pedido.descontoPercentual ?? 0);
  return somarImposto(mercadorias, pedido.aliquota);
}
__EOF__
commit_at "2026-09-09T10:00:00-03:00" "fix: pedido aplicava o imposto antes do desconto"

# 5. Fixed-value coupon.
cat >> src/precos.js <<'__EOF__'

export function aplicarCupom(centavos, cupom) {
  if (!cupom) return centavos;
  return centavos - cupom.valor;
}
__EOF__
cat > src/carrinho.js <<'__EOF__'
import { aplicarDesconto, aplicarCupom } from './precos.js';

export function subtotal(itens) {
  return itens.reduce((soma, item) => soma + item.precoCentavos * item.quantidade, 0);
}

export function totalCarrinho(itens, { descontoPercentual = 0, cupom = null } = {}) {
  // Order matters: discount first, then coupon.
  const comDesconto = aplicarDesconto(subtotal(itens), descontoPercentual);
  return aplicarCupom(comDesconto, cupom);
}
__EOF__
cat > src/pedido.js <<'__EOF__'
import { somarImposto } from './precos.js';
import { totalCarrinho } from './carrinho.js';

export function totalPedido(pedido) {
  const mercadorias = totalCarrinho(pedido.itens, pedido);
  return somarImposto(mercadorias, pedido.aliquota);
}
__EOF__
commit_at "2026-09-12T10:00:00-03:00" "feat: cupom de valor fixo"

# 6. Rounding.
replace src/precos.js "return centavos - (centavos * percentual) / 100;" "return centavos - Math.round((centavos * percentual) / 100);"
replace src/precos.js "return centavos + (centavos * aliquota) / 100;" "return centavos + Math.round((centavos * aliquota) / 100);"
cat >> test/precos.test.js <<'__EOF__'

test('discount is rounded to the cent', () => {
  assert.equal(aplicarDesconto(999, 15), 849);
});
__EOF__
commit_at "2026-09-16T10:00:00-03:00" "fix: desconto e imposto geravam centavos quebrados"

# 7. Invoice with the tax shown apart (coupon after tax: bug).
replace src/precos.js "export function somarImposto(centavos, aliquota) {
  return centavos + Math.round((centavos * aliquota) / 100);
}" "export function valorImposto(centavos, aliquota) {
  return Math.round((centavos * aliquota) / 100);
}

export function somarImposto(centavos, aliquota) {
  return centavos + valorImposto(centavos, aliquota);
}"
cat > src/nota.js <<'__EOF__'
import { aplicarDesconto, aplicarCupom, valorImposto } from './precos.js';
import { subtotal } from './carrinho.js';

export function linhasNota(pedido) {
  const mercadorias = aplicarDesconto(subtotal(pedido.itens), pedido.descontoPercentual ?? 0);
  const imposto = valorImposto(mercadorias, pedido.aliquota);
  return { mercadorias, imposto, total: aplicarCupom(mercadorias + imposto, pedido.cupom ?? null) };
}
__EOF__
commit_at "2026-09-19T10:00:00-03:00" "feat: nota fiscal com imposto destacado"

# 8. Fix the coupon order in the invoice.
replace src/precos.js "// Callers: apply the discount before the tax." "// Callers: apply the discount, then the coupon, then the tax."
cat > src/nota.js <<'__EOF__'
import { aplicarDesconto, aplicarCupom, valorImposto } from './precos.js';
import { subtotal } from './carrinho.js';

export function linhasNota(pedido) {
  const comDesconto = aplicarDesconto(subtotal(pedido.itens), pedido.descontoPercentual ?? 0);
  const mercadorias = aplicarCupom(comDesconto, pedido.cupom ?? null);
  const imposto = valorImposto(mercadorias, pedido.aliquota);
  return { mercadorias, imposto, total: mercadorias + imposto };
}
__EOF__
commit_at "2026-09-24T10:00:00-03:00" "fix: nota aplicava o cupom depois do imposto"

# 9. Catalog search.
cat >> src/catalogo.js <<'__EOF__'

export function buscar(catalogo, termo) {
  const t = termo.toLowerCase();
  return catalogo.filter((p) => p.nome.toLowerCase().includes(t));
}
__EOF__
commit_at "2026-09-30T10:00:00-03:00" "feat: busca no catálogo por nome"

# 10. Percentage coupon.
replace src/precos.js "  return centavos - cupom.valor;" "  const desconto = cupom.tipo === 'percentual' ? (centavos * cupom.valor) / 100 : cupom.valor;
  return centavos - desconto;"
commit_at "2026-10-06T10:00:00-03:00" "feat: cupom percentual"

# 11. Shipping in the order total (taxed: bug).
cat >> src/precos.js <<'__EOF__'

export function somarFrete(centavos, freteCentavos) {
  return centavos + freteCentavos;
}
__EOF__
cat > src/pedido.js <<'__EOF__'
import { somarImposto, somarFrete } from './precos.js';
import { totalCarrinho } from './carrinho.js';

export function totalPedido(pedido) {
  const mercadorias = totalCarrinho(pedido.itens, pedido);
  return somarImposto(somarFrete(mercadorias, pedido.freteCentavos ?? 0), pedido.aliquota);
}
__EOF__
commit_at "2026-10-14T10:00:00-03:00" "feat: frete no total do pedido"

# 12. Shipping is not taxed.
replace src/precos.js "// Callers: apply the discount, then the coupon, then the tax." "// Callers: apply the discount, then the coupon, then the tax, then the
// shipping. Shipping is never taxed."
cat > src/pedido.js <<'__EOF__'
import { somarImposto, somarFrete } from './precos.js';
import { totalCarrinho } from './carrinho.js';

export function totalPedido(pedido) {
  // Tax applies after discount and coupon, never on shipping.
  const mercadorias = totalCarrinho(pedido.itens, pedido);
  return somarFrete(somarImposto(mercadorias, pedido.aliquota), pedido.freteCentavos ?? 0);
}
__EOF__
replace src/nota.js "  return { mercadorias, imposto, total: mercadorias + imposto };" "  const frete = pedido.freteCentavos ?? 0;
  return { mercadorias, imposto, frete, total: mercadorias + imposto + frete };"
commit_at "2026-10-21T10:00:00-03:00" "fix: imposto não incide sobre o frete"

# 13. Catalog sorted by price.
cat >> src/catalogo.js <<'__EOF__'

export function porPreco(catalogo) {
  return [...catalogo].sort((a, b) => a.precoCentavos - b.precoCentavos);
}
__EOF__
commit_at "2026-10-29T10:00:00-03:00" "feat: catálogo ordenado por preço"

# 14. Percentage coupon rounding.
replace src/precos.js "(centavos * cupom.valor) / 100 : cupom.valor;" "Math.round((centavos * cupom.valor) / 100) : cupom.valor;"
replace src/nota.js "export function linhasNota(pedido) {
" "export function linhasNota(pedido) {
  // Must match totalPedido: discount, coupon, tax, then shipping.
"
cat > test/pedido.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { totalPedido } from '../src/pedido.js';
import { linhasNota } from '../src/nota.js';

const pedido = {
  itens: [{ precoCentavos: 3333, quantidade: 3 }],
  descontoPercentual: 10,
  cupom: { tipo: 'percentual', valor: 5 },
  aliquota: 12,
  freteCentavos: 1500,
};

test('invoice total matches the order total', () => {
  assert.equal(linhasNota(pedido).total, totalPedido(pedido));
});
__EOF__
commit_at "2026-11-04T10:00:00-03:00" "fix: total da nota diferia do pedido em 1 centavo"

# 15. Coupon bigger than the subtotal.
replace src/precos.js "  return centavos - desconto;" "  return Math.max(0, centavos - desconto);"
cat >> test/precos.test.js <<'__EOF__'

test('coupon never makes the total negative', async () => {
  const { aplicarCupom } = await import('../src/precos.js');
  assert.equal(aplicarCupom(1000, { tipo: 'fixo', valor: 2500 }), 0);
});
__EOF__
commit_at "2026-11-10T10:00:00-03:00" "fix: cupom maior que o subtotal deixava total negativo"
