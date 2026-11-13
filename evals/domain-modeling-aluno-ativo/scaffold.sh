#!/usr/bin/env bash
# Builds, in the current directory, the small system of a gym: enrollments
# with a monthly fee and a status (ativa, trancada, cancelada), and front-desk
# check-ins. "Aluno ativo" already means two things here: the billing code
# treats it as an enrollment that is billed, the front-desk panel as someone
# who trained in the last 30 days. Tests pass. No GLOSSARY.md, no docs/adr/.
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
mkdir -p src test data

cat > package.json <<'__EOF__'
{ "name": "academia-pulso", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > README.md <<'__EOF__'
# Academia Pulso

Sistema interno da academia. Sem dependências: `npm test` roda os testes.

- `data/matriculas.json`: uma matrícula por aluno, com plano, mensalidade em
  centavos e situação (`ativa`, `trancada` ou `cancelada`). Matrícula trancada
  fica pausada e não é cobrada; cancelada encerrou.
- `src/cobranca.js`: monta as cobranças do mês a partir das matrículas.
__EOF__
cat > data/matriculas.json <<'__EOF__'
[
  { "aluno": "Ana Ribeiro", "plano": "mensal", "mensalidadeCents": 12990, "situacao": "ativa" },
  { "aluno": "Bruno Tavares", "plano": "mensal", "mensalidadeCents": 12990, "situacao": "ativa" },
  { "aluno": "Carla Nunes", "plano": "estudante", "mensalidadeCents": 9990, "situacao": "trancada" },
  { "aluno": "Diego Lima", "plano": "premium", "mensalidadeCents": 14990, "situacao": "cancelada" },
  { "aluno": "Eva Moraes", "plano": "estudante", "mensalidadeCents": 9990, "situacao": "ativa" }
]
__EOF__
cat > src/cobranca.js <<'__EOF__'
// Monthly billing. All amounts are integer cents.
// Aluno ativo = matrícula com situação "ativa": é quem recebe cobrança no mês.

export function alunosAtivos(matriculas) {
  return matriculas.filter((m) => m.situacao === 'ativa');
}

export function cobrancasDoMes(matriculas) {
  return alunosAtivos(matriculas).map((m) => ({ aluno: m.aluno, valorCents: m.mensalidadeCents }));
}
__EOF__
cat > test/cobranca.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { cobrancasDoMes } from '../src/cobranca.js';

const matriculas = JSON.parse(readFileSync(new URL('../data/matriculas.json', import.meta.url)));

test('only enrollments with situacao ativa are billed', () => {
  assert.deepEqual(cobrancasDoMes(matriculas).map((c) => c.aluno), ['Ana Ribeiro', 'Bruno Tavares', 'Eva Moraes']);
});

test('each charge is the monthly fee of the enrollment', () => {
  assert.equal(cobrancasDoMes(matriculas).reduce((sum, c) => sum + c.valorCents, 0), 35970);
});
__EOF__
commit_at "2026-08-05T10:00:00Z" "billing: monthly charges from enrollments"

cat > data/checkins.json <<'__EOF__'
[
  { "aluno": "Ana Ribeiro", "data": "2026-10-27" },
  { "aluno": "Ana Ribeiro", "data": "2026-10-29" },
  { "aluno": "Carla Nunes", "data": "2026-10-08" },
  { "aluno": "Diego Lima", "data": "2026-10-20" },
  { "aluno": "Diego Lima", "data": "2026-10-24" },
  { "aluno": "Eva Moraes", "data": "2026-10-30" },
  { "aluno": "Bruno Tavares", "data": "2026-08-14" }
]
__EOF__
cat > src/frequencia.js <<'__EOF__'
// Front-desk panel. Dates are ISO strings (YYYY-MM-DD).
// Aluno ativo = passou na catraca nos últimos 30 dias. Os demais entram na
// lista de "sumidos" que a recepção liga para chamar de volta.

const DAY_MS = 24 * 60 * 60 * 1000;

export function alunosAtivos(checkins, hoje, dias = 30) {
  const limite = Date.parse(hoje) - dias * DAY_MS;
  return [...new Set(checkins.filter((c) => Date.parse(c.data) >= limite).map((c) => c.aluno))].sort();
}

export function sumidos(matriculas, checkins, hoje) {
  const ativos = new Set(alunosAtivos(checkins, hoje));
  return matriculas.filter((m) => m.situacao !== 'cancelada' && !ativos.has(m.aluno)).map((m) => m.aluno);
}
__EOF__
cat > test/frequencia.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { alunosAtivos, sumidos } from '../src/frequencia.js';

const load = (name) => JSON.parse(readFileSync(new URL(`../data/${name}.json`, import.meta.url)));
const matriculas = load('matriculas');
const checkins = load('checkins');

test('active on the panel means a check-in in the last 30 days', () => {
  assert.deepEqual(alunosAtivos(checkins, '2026-10-31'), ['Ana Ribeiro', 'Carla Nunes', 'Diego Lima', 'Eva Moraes']);
});

test('missing students are enrolled but without a recent check-in', () => {
  assert.deepEqual(sumidos(matriculas, checkins, '2026-10-31'), ['Bruno Tavares']);
});
__EOF__
cat >> README.md <<'__EOF__'
- `data/checkins.json`: cada passagem pela catraca, com aluno e data.
- `src/frequencia.js`: painel da recepção, com os alunos ativos do período e
  a lista de sumidos para a recepção ligar.
__EOF__
commit_at "2026-10-12T10:00:00Z" "front desk: active students and missing list"
