#!/usr/bin/env bash
# Builds, in the current directory, a small billing repository: boletos whose due
# date is the issue date plus a term in calendar days, a list of 2026 bank
# holidays already in the code, and UTC-safe date helpers. Several holidays sit
# next to a weekend. Self-contained, no network, no dependencies (node --test).
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
mkdir -p src test

cat > package.json <<'__EOF__'
{ "name": "cobranca", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > src/datas.js <<'__EOF__'
// Datas no formato 'AAAA-MM-DD'. Tudo em UTC para não depender do fuso da máquina.

export function somarDias(iso, dias) {
  const d = new Date(`${iso}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() + dias);
  return d.toISOString().slice(0, 10);
}

/** 0 = domingo, 1 = segunda, ..., 6 = sábado. */
export function diaDaSemana(iso) {
  return new Date(`${iso}T00:00:00Z`).getUTCDay();
}
__EOF__
cat > src/feriados.js <<'__EOF__'
// Feriados bancários nacionais (sem expediente nos bancos). Mantido pelo financeiro.
export const FERIADOS = [
  { data: '2026-01-01', nome: 'Confraternização Universal' },
  { data: '2026-02-16', nome: 'Carnaval' },
  { data: '2026-02-17', nome: 'Carnaval' },
  { data: '2026-04-03', nome: 'Sexta-feira Santa' },
  { data: '2026-04-21', nome: 'Tiradentes' },
  { data: '2026-05-01', nome: 'Dia do Trabalho' },
  { data: '2026-06-04', nome: 'Corpus Christi' },
  { data: '2026-09-07', nome: 'Independência do Brasil' },
  { data: '2026-10-12', nome: 'Nossa Senhora Aparecida' },
  { data: '2026-11-02', nome: 'Finados' },
  { data: '2026-11-15', nome: 'Proclamação da República' },
  { data: '2026-11-20', nome: 'Dia da Consciência Negra' },
  { data: '2026-12-25', nome: 'Natal' },
  { data: '2027-01-01', nome: 'Confraternização Universal' },
];
__EOF__
cat > src/calendario.js <<'__EOF__'
import { FERIADOS } from './feriados.js';

export function ehFeriado(iso) {
  return FERIADOS.some((f) => f.data === iso);
}

export function nomeDoFeriado(iso) {
  return FERIADOS.find((f) => f.data === iso)?.nome ?? null;
}
__EOF__
cat > test/datas.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { somarDias, diaDaSemana } from '../src/datas.js';

test('somarDias atravessa mês e ano', () => {
  assert.equal(somarDias('2026-01-30', 3), '2026-02-02');
  assert.equal(somarDias('2026-12-30', 5), '2027-01-04');
});

test('diaDaSemana não depende do fuso', () => {
  assert.equal(diaDaSemana('2026-03-01'), 0); // domingo
  assert.equal(diaDaSemana('2026-03-07'), 6); // sábado
});
__EOF__
cat > test/calendario.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { ehFeriado, nomeDoFeriado } from '../src/calendario.js';

test('reconhece feriado da lista', () => {
  assert.equal(ehFeriado('2026-12-25'), true);
  assert.equal(nomeDoFeriado('2026-04-21'), 'Tiradentes');
});

test('dia comum não é feriado', () => {
  assert.equal(ehFeriado('2026-12-24'), false);
  assert.equal(nomeDoFeriado('2026-12-24'), null);
});
__EOF__
commit_at "2026-09-01T10:00:00Z" "datas e calendário de feriados bancários"

cat > src/vencimento.js <<'__EOF__'
import { somarDias } from './datas.js';

/** Vencimento do boleto: data de emissão mais o prazo, em dias corridos. */
export function calcularVencimento(emissao, prazoDias) {
  return somarDias(emissao, prazoDias);
}
__EOF__
cat > src/boleto.js <<'__EOF__'
import { calcularVencimento } from './vencimento.js';

export function gerarBoleto({ cliente, valorCentavos, emissao, prazoDias = 30 }) {
  if (!Number.isInteger(valorCentavos) || valorCentavos <= 0) {
    throw new Error('valor do boleto inválido');
  }
  return { cliente, valorCentavos, emissao, vencimento: calcularVencimento(emissao, prazoDias) };
}
__EOF__
cat > test/vencimento.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { calcularVencimento } from '../src/vencimento.js';

test('soma o prazo em dias corridos', () => {
  assert.equal(calcularVencimento('2026-03-02', 30), '2026-04-01');
});

test('prazo atravessa a virada do mês', () => {
  assert.equal(calcularVencimento('2026-01-20', 15), '2026-02-04');
});
__EOF__
cat > test/boleto.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { gerarBoleto } from '../src/boleto.js';

test('boleto usa prazo padrão de 30 dias', () => {
  const b = gerarBoleto({ cliente: 'ACME', valorCentavos: 15990, emissao: '2026-05-04' });
  assert.equal(b.vencimento, '2026-06-03');
});

test('recusa valor zerado', () => {
  assert.throws(() => gerarBoleto({ cliente: 'ACME', valorCentavos: 0, emissao: '2026-05-04' }));
});
__EOF__
commit_at "2026-10-06T10:00:00Z" "boleto com vencimento por prazo em dias corridos"
