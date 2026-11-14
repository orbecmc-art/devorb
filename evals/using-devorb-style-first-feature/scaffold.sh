#!/usr/bin/env bash
# Builds, in the current directory, a tiny expense tracker that lists the
# month's expenses on screen, where a CSV export is a natural next feature.
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main
mkdir -p src test

cat > package.json <<'__EOF__'
{ "name": "gastos", "private": true, "type": "module", "scripts": { "start": "node src/cli.js", "test": "node --test" } }
__EOF__
cat > README.md <<'__EOF__'
# gastos

Controle de gastos da casa. `npm start` lista os gastos do mês na tela.
__EOF__
cat > src/expenses.js <<'__EOF__'
export const expenses = [
  { date: '2026-10-02', description: 'Mercado', category: 'alimentação', amount: 182.4 },
  { date: '2026-10-05', description: 'Conta de luz', category: 'casa', amount: 96.15 },
  { date: '2026-10-09', description: 'Farmácia, vitaminas', category: 'saúde', amount: 54.9 },
];

export function total(list) {
  return list.reduce((sum, e) => sum + e.amount, 0);
}
__EOF__
cat > src/cli.js <<'__EOF__'
import { expenses, total } from './expenses.js';

for (const e of expenses) {
  console.log(`${e.date}  ${e.description.padEnd(22)} ${e.category.padEnd(12)} R$ ${e.amount.toFixed(2)}`);
}
console.log(`Total: R$ ${total(expenses).toFixed(2)}`);
__EOF__
cat > test/expenses.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { expenses, total } from '../src/expenses.js';

test('total adds every amount', () => {
  assert.equal(total(expenses).toFixed(2), '333.45');
});
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-10-10T10:00:00Z GIT_COMMITTER_DATE=2026-10-10T10:00:00Z git commit --quiet -m "list the month's expenses"

# The owner's real setup: a CLAUDE.md that makes a style skill run first in
# every session. The flow skill must still fire after it.
mkdir -p .claude/skills/modo-curto
cat > CLAUDE.md <<'__EOF__'
# Modo curto (sempre ligado)

No início de toda sessão, antes da primeira resposta ou de qualquer outra
ferramenta, invoque a skill `modo-curto` e responda nesse estilo a sessão
inteira.
__EOF__
cat > .claude/skills/modo-curto/SKILL.md <<'__EOF__'
---
name: modo-curto
description: Use when the session starts, to answer in short, direct sentences
---

Responda em frases curtas e diretas, sem rodeios. Mantenha os termos técnicos
exatos.
__EOF__
