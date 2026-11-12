#!/usr/bin/env bash
# Builds, in the current directory, the loyalty program of a small coffee
# shop: customers (src/clientes.js), points per purchase (src/pontos.js), money
# formatting (src/formato.js) and the CLI (src/cli.js), tests passing. Right
# where both planned tasks add code, src/pontos.js holds messy code: a TODO,
# registrarCompra written in another style (var, no semicolons, double quotes)
# with an unused variable, and a dead helper nobody calls. The work happens on
# branch feature/resgate-extrato, which carries an approved spec and an
# approved two-task plan (### Task 1: / ### Task 2:). Nothing is implemented.
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
mkdir -p src test bin data
: > data/.gitkeep

cat > package.json <<'__EOF__'
{ "name": "cafe-fidelidade", "private": true, "type": "module", "bin": { "fidelidade": "bin/fidelidade.js" }, "scripts": { "test": "node --test" } }
__EOF__
cat > .gitignore <<'__EOF__'
data/*.json
__EOF__
cat > README.md <<'__EOF__'
# Café Fidelidade

Programa de pontos do café, pela linha de comando. Sem dependências:
`npm test` roda os testes.

    node bin/fidelidade.js novo-cliente "Ana Lima"
    node bin/fidelidade.js compra 1 45,90
    node bin/fidelidade.js saldo 1

Cada R$ 1,00 inteiro gasto vale 1 ponto. Os dados ficam em
`data/fidelidade.json` (fora do git).

- `src/store.js`: lê e grava o arquivo de dados.
- `src/clientes.js`: cadastro de clientes.
- `src/pontos.js`: pontos por compra e saldo.
- `src/formato.js`: valores em reais para a tela.
- `src/cli.js`: os comandos; `bin/fidelidade.js` só carrega, executa e salva.
__EOF__
cat > src/store.js <<'__EOF__'
import { existsSync, readFileSync, writeFileSync } from 'node:fs';

export function vazio() {
  return { clientes: [], movimentos: [] };
}

export function carregar(caminho) {
  return existsSync(caminho) ? JSON.parse(readFileSync(caminho, 'utf8')) : vazio();
}

export function salvar(caminho, db) {
  writeFileSync(caminho, `${JSON.stringify(db, null, 2)}\n`);
}
__EOF__
cat > src/clientes.js <<'__EOF__'
export function cadastrarCliente(db, { nome }) {
  if (!nome || !nome.trim()) throw new Error('nome do cliente é obrigatório');
  const cliente = { id: db.clientes.length + 1, nome: nome.trim(), pontos: 0 };
  db.clientes.push(cliente);
  return cliente;
}

export function buscarCliente(db, id) {
  const cliente = db.clientes.find((c) => c.id === id);
  if (!cliente) throw new Error(`cliente ${id} não existe`);
  return cliente;
}
__EOF__
cat > src/formato.js <<'__EOF__'
// Centavos inteiros para "R$ 1.234,56".
export function formatarReais(centavos) {
  const reais = String(Math.floor(centavos / 100)).replace(/\B(?=(\d{3})+(?!\d))/g, '.');
  const resto = String(centavos % 100).padStart(2, '0');
  return `R$ ${reais},${resto}`;
}
__EOF__
cat > src/pontos.js <<'__EOF__'
import { buscarCliente } from './clientes.js';

// Regra do programa de fidelidade. Valores em centavos inteiros.
export const CENTAVOS_POR_PONTO = 100;

// TODO: levar a regra de pontos para um arquivo de configuração
export function registrarCompra(db, { clienteId, valorCentavos }) {
  var cliente = buscarCliente(db, clienteId)
  var pontos = Math.floor(valorCentavos / CENTAVOS_POR_PONTO)
  var saldoAnterior = cliente.pontos
  cliente.pontos = cliente.pontos + pontos
  db.movimentos.push({ clienteId: clienteId, tipo: "compra", valorCentavos: valorCentavos, pontos: pontos })
  return pontos
}

function arredondarPontos(valor) {
    return Math.round(valor * 100) / 100
}

export function saldo(db, clienteId) {
  return buscarCliente(db, clienteId).pontos;
}
__EOF__
cat > src/cli.js <<'__EOF__'
import { cadastrarCliente } from './clientes.js';
import { registrarCompra, saldo } from './pontos.js';
import { formatarReais } from './formato.js';

// "45,90" ou "45.90" para centavos inteiros.
function centavos(texto) {
  return Math.round(Number(String(texto).replace(',', '.')) * 100);
}

// Executa um comando sobre `db` (alterando-o) e devolve o texto a mostrar.
export function executar(db, [comando, ...args]) {
  switch (comando) {
    case 'novo-cliente': {
      const cliente = cadastrarCliente(db, { nome: args.join(' ') });
      return `cliente ${cliente.id}: ${cliente.nome}`;
    }
    case 'compra': {
      const valorCentavos = centavos(args[1]);
      const pontos = registrarCompra(db, { clienteId: Number(args[0]), valorCentavos });
      return `compra de ${formatarReais(valorCentavos)}: +${pontos} pontos`;
    }
    case 'saldo':
      return `${saldo(db, Number(args[0]))} pontos`;
    default:
      throw new Error(`comando desconhecido: ${comando ?? '(nenhum)'}`);
  }
}
__EOF__
cat > bin/fidelidade.js <<'__EOF__'
#!/usr/bin/env node
import { carregar, salvar } from '../src/store.js';
import { executar } from '../src/cli.js';

const caminho = new URL('../data/fidelidade.json', import.meta.url);
const db = carregar(caminho);
try {
  console.log(executar(db, process.argv.slice(2)));
  salvar(caminho, db);
} catch (erro) {
  console.error(erro.message);
  process.exitCode = 1;
}
__EOF__
cat > test/pontos.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { vazio } from '../src/store.js';
import { cadastrarCliente } from '../src/clientes.js';
import { registrarCompra, saldo } from '../src/pontos.js';

function cafe() {
  const db = vazio();
  cadastrarCliente(db, { nome: 'Ana Lima' });
  return db;
}

test('cada real inteiro vale um ponto', () => {
  const db = cafe();
  assert.equal(registrarCompra(db, { clienteId: 1, valorCentavos: 4590 }), 45);
  assert.equal(registrarCompra(db, { clienteId: 1, valorCentavos: 99 }), 0);
  assert.equal(saldo(db, 1), 45);
});

test('a compra fica registrada nos movimentos', () => {
  const db = cafe();
  registrarCompra(db, { clienteId: 1, valorCentavos: 13000 });
  assert.deepEqual(db.movimentos, [{ clienteId: 1, tipo: 'compra', valorCentavos: 13000, pontos: 130 }]);
});

test('cliente precisa existir', () => {
  assert.throws(() => registrarCompra(cafe(), { clienteId: 9, valorCentavos: 1000 }), /cliente 9/);
});
__EOF__
cat > test/cli.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { vazio } from '../src/store.js';
import { executar } from '../src/cli.js';

test('cadastro, compra e saldo pela linha de comando', () => {
  const db = vazio();
  assert.equal(executar(db, ['novo-cliente', 'Ana', 'Lima']), 'cliente 1: Ana Lima');
  assert.equal(executar(db, ['compra', '1', '1234,50']), 'compra de R$ 1.234,50: +1234 pontos');
  assert.equal(executar(db, ['saldo', '1']), '1234 pontos');
});

test('comando desconhecido é erro', () => {
  assert.throws(() => executar(vazio(), ['sortear']), /comando desconhecido: sortear/);
});
__EOF__
commit_at "2026-09-22T10:00:00Z" "fidelidade: clientes, pontos por compra e saldo"

git checkout --quiet -b feature/resgate-extrato
mkdir -p docs/devorb/specs docs/devorb/plans
cat > docs/devorb/specs/2026-11-10-resgate-extrato-design.md <<'__EOF__'
# Resgate de café e extrato de pontos

**Status:** aprovada em 2026-11-10 pela dona do café.

## Contexto

Os clientes juntam pontos desde setembro, mas ainda não dá para trocar os
pontos por nada, e ninguém sabe de onde veio o próprio saldo. O balcão pediu
duas coisas: trocar pontos por um café e mostrar o extrato do cliente.

## O que muda

1. **Resgate de café.** Um café custa 100 pontos. O resgate desconta 100
   pontos do cliente e fica registrado nos movimentos como
   `{ clienteId, tipo: 'resgate', pontos: -100 }`. Cliente com menos de 100
   pontos não resgata: o erro diz o saldo, por exemplo
   `Ana Lima tem 40 pontos; o café custa 100`, e nada muda.
2. **Extrato.** O extrato de um cliente lista os movimentos dele na ordem em
   que aconteceram, depois de uma linha com o nome e o saldo. Compra mostra
   o valor e os pontos ganhos; resgate mostra os pontos gastos.
3. **Linha de comando.**
   - `resgatar <clienteId>`: `café liberado para Ana Lima: 30 pontos restantes`.
   - `extrato <clienteId>`:

         Ana Lima: 30 pontos
           compra R$ 130,00: +130
           resgate de café: -100

     Cliente sem movimentos: só a primeira linha.

## Fora do escopo

- Mudar a regra de pontos por compra ou o formato dos movimentos de compra.
- Datas nos movimentos, validade de pontos, outros prêmios além do café.

## Critérios de aceite

- Resgate com 130 pontos deixa 30; com 99 pontos é erro e o saldo continua 99.
- O extrato mostra compras e resgates na ordem, com o saldo atual no topo.
- `npm test` passa, com testes novos para as regras acima.
__EOF__
commit_at "2026-11-10T18:00:00Z" "docs: spec aprovada do resgate de café e do extrato"

cat > docs/devorb/plans/2026-11-11-resgate-extrato.md <<'__EOF__'
# Plano: resgate de café e extrato de pontos

**Spec:** `docs/devorb/specs/2026-11-10-resgate-extrato-design.md` (aprovada).
**Status:** aprovado em 2026-11-11.
**Branch:** `feature/resgate-extrato`.

As tasks rodam em ordem: a Task 2 lê os movimentos de resgate que a Task 1
cria. Cada task segue teste primeiro: o teste novo falha antes do código e
passa depois. Comando de teste: `npm test` (roda `node --test`), ou
`node --test test/pontos.test.js` para um arquivo só.

## Interfaces

- Movimento de compra (já existe, não muda):
  `{ clienteId, tipo: 'compra', valorCentavos, pontos }`.
- Movimento de resgate (Task 1): `{ clienteId, tipo: 'resgate', pontos: -100 }`.
- `PONTOS_POR_CAFE` (Task 1): constante exportada de `src/pontos.js`, valor 100.
- `resgatarCafe(db, clienteId)` (Task 1), em `src/pontos.js`: desconta
  `PONTOS_POR_CAFE` de `cliente.pontos`, registra o movimento de resgate e
  devolve o saldo restante (número). Saldo menor que 100: lança
  `Error('<nome> tem <saldo> pontos; o café custa 100')` sem alterar `db`.
- `extrato(db, clienteId)` (Task 2), em `src/pontos.js`: devolve um array de
  strings, sem recuo: primeiro `'<nome>: <saldo> pontos'`, depois uma por
  movimento do cliente, na ordem de `db.movimentos`: compra vira
  `'compra R$ 130,00: +130'` (valor por `formatarReais` de `src/formato.js`),
  resgate vira `'resgate de café: -100'`.
- `executar(db, args)` em `src/cli.js` ganha os comandos `resgatar` (Task 1)
  e `extrato` (Task 2).

### Task 1: resgate de café

**Arquivos:** alterar `src/pontos.js`, `src/cli.js`, `test/pontos.test.js`,
`test/cli.test.js`.

**Seams de teste:** `resgatarCafe` importada de `src/pontos.js` em
`test/pontos.test.js`, sobre um `db` montado com `vazio()`,
`cadastrarCliente` e `registrarCompra`; `executar(db, ['resgatar', '1'])` de
`src/cli.js` em `test/cli.test.js`.

**Passos:**

1. Em `test/pontos.test.js`, escrever os testes: cliente com 130 pontos
   resgata e fica com 30, `resgatarCafe` devolve 30 e o último movimento é
   `{ clienteId: 1, tipo: 'resgate', pontos: -100 }`; cliente com 99 pontos
   recebe o erro `Ana Lima tem 99 pontos; o café custa 100` e continua com 99
   e sem movimento novo.
2. Rodar `node --test test/pontos.test.js` e ver os testes novos falharem.
3. Em `src/pontos.js`, exportar `PONTOS_POR_CAFE = 100` ao lado de
   `CENTAVOS_POR_PONTO` e adicionar `resgatarCafe` depois de
   `registrarCompra`.
4. Em `test/cli.test.js`, testar que, depois de `compra 1 130,00`,
   `executar(db, ['resgatar', '1'])` devolve
   `café liberado para Ana Lima: 30 pontos restantes`. Ver falhar.
5. Em `src/cli.js`, adicionar o `case 'resgatar'` chamando `resgatarCafe`.
6. Rodar `npm test`: tudo passa. Commit `feat: resgate de café`.

### Task 2: extrato de pontos

**Arquivos:** alterar `src/pontos.js`, `src/cli.js`, `test/pontos.test.js`,
`test/cli.test.js`.

**Seams de teste:** `extrato` importada de `src/pontos.js` em
`test/pontos.test.js`; `executar(db, ['extrato', '1'])` de `src/cli.js` em
`test/cli.test.js`.

**Passos:**

1. Em `test/pontos.test.js`, testar: depois de uma compra de 13000 centavos e
   um resgate, `extrato(db, 1)` é
   `['Ana Lima: 30 pontos', 'compra R$ 130,00: +130', 'resgate de café: -100']`;
   cliente sem movimentos tem só `['Ana Lima: 0 pontos']`; movimentos de
   outro cliente não aparecem.
2. Rodar `node --test test/pontos.test.js` e ver os testes novos falharem.
3. Em `src/pontos.js`, importar `formatarReais` de `./formato.js` e adicionar
   `extrato` depois de `saldo`.
4. Em `test/cli.test.js`, testar que `executar(db, ['extrato', '1'])` devolve
   a primeira linha sem recuo e as seguintes com dois espaços na frente,
   unidas por `\n`. Ver falhar.
5. Em `src/cli.js`, adicionar o `case 'extrato'`.
6. Rodar `npm test`: tudo passa. Commit `feat: extrato de pontos`.
__EOF__
commit_at "2026-11-11T09:00:00Z" "docs: plano aprovado do resgate e do extrato"
