#!/usr/bin/env bash
# Builds, in the current directory, the command-line system of a community
# library: members (src/socios.js), books (src/acervo.js), loans with a 14-day
# due date (src/emprestimos.js) and the CLI (src/cli.js), tests passing. The
# loan code reads today's date from the system clock. The last commit adds an
# approved design doc for late-return fines, which touches socios, emprestimos
# and cli. No plan yet, no docs/devorb/plans/.
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
{ "name": "biblioteca-bairro", "private": true, "type": "module", "bin": { "biblioteca": "bin/biblioteca.js" }, "scripts": { "test": "node --test" } }
__EOF__
cat > .gitignore <<'__EOF__'
data/*.json
__EOF__
cat > README.md <<'__EOF__'
# Biblioteca do Bairro

Controle de empréstimos da biblioteca comunitária, pela linha de comando. Sem
dependências: `npm test` roda os testes.

    node bin/biblioteca.js novo-socio "Ana Lima"
    node bin/biblioteca.js novo-livro "Dom Casmurro"
    node bin/biblioteca.js emprestar 1 1
    node bin/biblioteca.js devolver 1
    node bin/biblioteca.js socio 1

Os dados ficam em `data/biblioteca.json` (fora do git).

- `src/store.js`: lê e grava o arquivo de dados.
- `src/socios.js`: cadastro de sócios.
- `src/acervo.js`: cadastro de livros.
- `src/emprestimos.js`: empréstimo e devolução, prazo de 14 dias.
- `src/cli.js`: os comandos; `bin/biblioteca.js` só carrega, executa e salva.
__EOF__
cat > src/store.js <<'__EOF__'
import { existsSync, readFileSync, writeFileSync } from 'node:fs';

export function vazio() {
  return { socios: [], livros: [], emprestimos: [] };
}

export function carregar(caminho) {
  return existsSync(caminho) ? JSON.parse(readFileSync(caminho, 'utf8')) : vazio();
}

export function salvar(caminho, db) {
  writeFileSync(caminho, `${JSON.stringify(db, null, 2)}\n`);
}
__EOF__
cat > src/socios.js <<'__EOF__'
export function cadastrarSocio(db, { nome }) {
  if (!nome || !nome.trim()) throw new Error('nome do sócio é obrigatório');
  const socio = { id: db.socios.length + 1, nome: nome.trim() };
  db.socios.push(socio);
  return socio;
}

export function buscarSocio(db, id) {
  const socio = db.socios.find((s) => s.id === id);
  if (!socio) throw new Error(`sócio ${id} não existe`);
  return socio;
}
__EOF__
cat > src/acervo.js <<'__EOF__'
export function cadastrarLivro(db, { titulo }) {
  if (!titulo || !titulo.trim()) throw new Error('título é obrigatório');
  const livro = { id: db.livros.length + 1, titulo: titulo.trim() };
  db.livros.push(livro);
  return livro;
}

export function buscarLivro(db, id) {
  const livro = db.livros.find((l) => l.id === id);
  if (!livro) throw new Error(`livro ${id} não existe`);
  return livro;
}
__EOF__
cat > src/emprestimos.js <<'__EOF__'
import { buscarSocio } from './socios.js';
import { buscarLivro } from './acervo.js';

export const PRAZO_DIAS = 14;

// Datas são strings 'AAAA-MM-DD'.
function hoje() {
  return new Date().toISOString().slice(0, 10);
}

function somarDias(data, dias) {
  const d = new Date(`${data}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() + dias);
  return d.toISOString().slice(0, 10);
}

export function emprestar(db, { socioId, livroId }) {
  buscarSocio(db, socioId);
  const livro = buscarLivro(db, livroId);
  if (db.emprestimos.some((e) => e.livroId === livroId && !e.devolvidoEm)) {
    throw new Error(`"${livro.titulo}" já está emprestado`);
  }
  const data = hoje();
  const emprestimo = { id: db.emprestimos.length + 1, socioId, livroId, emprestadoEm: data, prazo: somarDias(data, PRAZO_DIAS), devolvidoEm: null };
  db.emprestimos.push(emprestimo);
  return emprestimo;
}

export function devolver(db, emprestimoId) {
  const emprestimo = db.emprestimos.find((e) => e.id === emprestimoId);
  if (!emprestimo) throw new Error(`empréstimo ${emprestimoId} não existe`);
  if (emprestimo.devolvidoEm) throw new Error(`empréstimo ${emprestimoId} já foi devolvido`);
  emprestimo.devolvidoEm = hoje();
  return emprestimo;
}

export function emprestimosAbertos(db, socioId) {
  return db.emprestimos.filter((e) => e.socioId === socioId && !e.devolvidoEm);
}
__EOF__
cat > src/cli.js <<'__EOF__'
import { cadastrarSocio, buscarSocio } from './socios.js';
import { cadastrarLivro, buscarLivro } from './acervo.js';
import { emprestar, devolver, emprestimosAbertos } from './emprestimos.js';

// Executa um comando sobre `db` (alterando-o) e devolve o texto a mostrar.
export function executar(db, [comando, ...args]) {
  switch (comando) {
    case 'novo-socio': {
      const socio = cadastrarSocio(db, { nome: args.join(' ') });
      return `sócio ${socio.id}: ${socio.nome}`;
    }
    case 'novo-livro': {
      const livro = cadastrarLivro(db, { titulo: args.join(' ') });
      return `livro ${livro.id}: ${livro.titulo}`;
    }
    case 'emprestar': {
      const e = emprestar(db, { socioId: Number(args[0]), livroId: Number(args[1]) });
      return `empréstimo ${e.id}: devolver até ${e.prazo}`;
    }
    case 'devolver': {
      const e = devolver(db, Number(args[0]));
      return `empréstimo ${e.id} devolvido em ${e.devolvidoEm}`;
    }
    case 'socio': {
      const socio = buscarSocio(db, Number(args[0]));
      const linhas = emprestimosAbertos(db, socio.id).map((e) => `  ${buscarLivro(db, e.livroId).titulo} (até ${e.prazo})`);
      return [`${socio.nome}: ${linhas.length} empréstimo(s) em aberto`, ...linhas].join('\n');
    }
    default:
      throw new Error(`comando desconhecido: ${comando ?? '(nenhum)'}`);
  }
}
__EOF__
cat > bin/biblioteca.js <<'__EOF__'
#!/usr/bin/env node
import { carregar, salvar } from '../src/store.js';
import { executar } from '../src/cli.js';

const caminho = new URL('../data/biblioteca.json', import.meta.url);
const db = carregar(caminho);
try {
  console.log(executar(db, process.argv.slice(2)));
  salvar(caminho, db);
} catch (erro) {
  console.error(erro.message);
  process.exitCode = 1;
}
__EOF__
cat > test/emprestimos.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { vazio } from '../src/store.js';
import { cadastrarSocio } from '../src/socios.js';
import { cadastrarLivro } from '../src/acervo.js';
import { emprestar, devolver, emprestimosAbertos, PRAZO_DIAS } from '../src/emprestimos.js';

function biblioteca() {
  const db = vazio();
  cadastrarSocio(db, { nome: 'Ana Lima' });
  cadastrarLivro(db, { titulo: 'Dom Casmurro' });
  return db;
}

test('empréstimo vence 14 dias depois', () => {
  const e = emprestar(biblioteca(), { socioId: 1, livroId: 1 });
  assert.equal((Date.parse(e.prazo) - Date.parse(e.emprestadoEm)) / 86400000, PRAZO_DIAS);
});

test('livro emprestado não sai de novo até voltar', () => {
  const db = biblioteca();
  emprestar(db, { socioId: 1, livroId: 1 });
  assert.throws(() => emprestar(db, { socioId: 1, livroId: 1 }), /já está emprestado/);
  devolver(db, 1);
  assert.equal(emprestar(db, { socioId: 1, livroId: 1 }).id, 2);
});

test('devolução fecha o empréstimo uma vez só', () => {
  const db = biblioteca();
  emprestar(db, { socioId: 1, livroId: 1 });
  devolver(db, 1);
  assert.deepEqual(emprestimosAbertos(db, 1), []);
  assert.throws(() => devolver(db, 1), /já foi devolvido/);
});

test('sócio e livro precisam existir', () => {
  assert.throws(() => emprestar(biblioteca(), { socioId: 9, livroId: 1 }), /sócio 9/);
  assert.throws(() => emprestar(biblioteca(), { socioId: 1, livroId: 9 }), /livro 9/);
});
__EOF__
cat > test/cli.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { vazio } from '../src/store.js';
import { executar } from '../src/cli.js';

test('fluxo de empréstimo pela linha de comando', () => {
  const db = vazio();
  assert.equal(executar(db, ['novo-socio', 'Ana', 'Lima']), 'sócio 1: Ana Lima');
  assert.equal(executar(db, ['novo-livro', 'Dom', 'Casmurro']), 'livro 1: Dom Casmurro');
  assert.match(executar(db, ['emprestar', '1', '1']), /^empréstimo 1: devolver até \d{4}-\d{2}-\d{2}$/);
  assert.match(executar(db, ['socio', '1']), /^Ana Lima: 1 empréstimo\(s\) em aberto\n {2}Dom Casmurro/);
  assert.match(executar(db, ['devolver', '1']), /^empréstimo 1 devolvido em /);
  assert.equal(executar(db, ['socio', '1']), 'Ana Lima: 0 empréstimo(s) em aberto');
});

test('comando desconhecido é erro', () => {
  assert.throws(() => executar(vazio(), ['multar']), /comando desconhecido: multar/);
});
__EOF__
commit_at "2026-10-06T10:00:00Z" "biblioteca: sócios, acervo e empréstimos pela linha de comando"

mkdir -p docs/devorb/specs
cat > docs/devorb/specs/2026-11-10-multa-atraso-design.md <<'__EOF__'
# Multa por atraso na devolução

**Status:** aprovada em 2026-11-10 pela coordenação da biblioteca.

## Contexto

Hoje o empréstimo vence 14 dias depois de sair, mas nada acontece quando o
livro volta atrasado. Alguns sócios ficam com livros por meses e a fila de
espera não anda. A coordenação decidiu cobrar uma multa simbólica e segurar
novos empréstimos de quem deve.

## O que muda

1. **Multa ao devolver com atraso.** Na devolução, se a data de devolução é
   posterior ao prazo, nasce uma multa de R$ 1,00 por dia de atraso, contando
   dias corridos. A multa tem teto de R$ 20,00 por empréstimo. Devolver no
   próprio dia do prazo não gera multa. Exemplo: prazo 2026-11-20, devolução
   2026-11-23, multa de R$ 3,00; devolução 30 dias depois do prazo, R$ 20,00.
2. **A multa é do sócio.** Cada multa fica ligada ao sócio e ao empréstimo que
   a gerou, com o valor, e fica em aberto até ser paga. Valores em centavos
   inteiros, como no resto do sistema.
3. **Quem deve não pega livro novo.** Sócio com qualquer multa em aberto não
   consegue novo empréstimo. A mensagem de erro diz quanto ele deve, por
   exemplo: `Ana Lima tem R$ 3,00 em multas em aberto`. Empréstimos que já
   estão com ele continuam valendo e podem ser devolvidos normalmente.
4. **Pagar quita tudo.** Novo comando `pagar-multas <socioId>` quita todas as
   multas em aberto do sócio de uma vez e mostra o total pago. Sem multa em
   aberto, o comando avisa e não altera nada.
5. **Linha de comando.**
   - `devolver <emprestimoId>`: quando houver multa, a saída ganha uma segunda
     linha, `multa: R$ 3,00 (3 dias de atraso)`.
   - `socio <id>`: a primeira linha passa a terminar com o total em aberto
     quando houver, `Ana Lima: 1 empréstimo(s) em aberto, R$ 3,00 em multas`.
     Sem multa, a saída fica como hoje.

## Fora do escopo

- Pagamento parcial, desconto ou perdão de multa.
- Multa por livro perdido ou danificado.
- Aviso ao sócio (e-mail, mensagem) antes ou depois do prazo.
- Mudar o prazo de 14 dias.

## Decisões

- Dias corridos, sem calendário de feriados: a biblioteca abre todos os dias.
- Multas antigas não são recalculadas: só devoluções feitas depois da entrega
  geram multa.
- O arquivo `data/biblioteca.json` de quem já usa o sistema não tem multas.
  Ele precisa continuar abrindo sem erro e sem passo manual.

## Critérios de aceite

- Devolução no prazo ou antes: nenhuma multa.
- Devolução 1 dia depois do prazo: R$ 1,00. 20 dias depois: R$ 20,00. 21 dias
  ou mais: R$ 20,00.
- Sócio com multa em aberto recebe erro ao tentar emprestar, com o valor
  devido; depois de `pagar-multas`, consegue emprestar.
- `npm test` passa, com testes novos para as regras acima.
__EOF__
commit_at "2026-11-10T18:00:00Z" "docs: spec aprovada da multa por atraso"
