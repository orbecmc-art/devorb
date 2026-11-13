#!/usr/bin/env bash
# Builds, in the current directory, the small cash register of a parking lot
# in Node. src/tarifa.js holds the current rule (R$ 10 per started hour) and
# src/caixa.js closes a ticket with it. The owner wants a new pricing rule;
# the user will ask to prototype it before touching the real code. Tests pass.
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

cat > package.json <<'__X__'
{ "name": "estacionamento", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__X__
cat > README.md <<'__X__'
# Estacionamento

Caixa do estacionamento: abre o ticket na entrada e calcula quanto cobrar na
saída. Sem dependências: `npm test` roda os testes. Valores em centavos.
__X__
cat > src/tarifa.js <<'__X__'
// Current price rule: R$ 10,00 per started hour. Amounts are integer cents.

export const VALOR_HORA_CENTAVOS = 1000;

export function tarifaCentavos(minutos) {
  if (minutos <= 0) return 0;
  return Math.ceil(minutos / 60) * VALOR_HORA_CENTAVOS;
}
__X__
cat > src/caixa.js <<'__X__'
import { tarifaCentavos } from './tarifa.js';

export function minutosEntre(entrada, saida) {
  return Math.ceil((new Date(saida) - new Date(entrada)) / 60000);
}

export function fecharTicket(ticket, saida) {
  const minutos = minutosEntre(ticket.entrada, saida);
  return { placa: ticket.placa, minutos, valorCentavos: tarifaCentavos(minutos) };
}
__X__
cat > test/tarifa.test.js <<'__X__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { tarifaCentavos } from '../src/tarifa.js';
import { fecharTicket } from '../src/caixa.js';

test('one started hour costs R$ 10', () => {
  assert.equal(tarifaCentavos(1), 1000);
  assert.equal(tarifaCentavos(60), 1000);
});

test('61 minutes cost two hours', () => {
  assert.equal(tarifaCentavos(61), 2000);
});

test('closing a ticket', () => {
  const t = fecharTicket({ placa: 'ABC1D23', entrada: '2026-11-10T08:00:00-03:00' }, '2026-11-10T09:30:00-03:00');
  assert.deepEqual(t, { placa: 'ABC1D23', minutos: 90, valorCentavos: 2000 });
});
__X__
commit_at "2026-10-01T09:00:00-03:00" "feat: caixa cobra R\$ 10 por hora começada"
