#!/usr/bin/env bash
# Builds, in the current directory, a tiny expense tracker with a CSV export
# half done and uncommitted, so there is work in progress to hand off.
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main
mkdir -p src test
cat > package.json <<'__EOF__'
{ "name": "gastos", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > src/expenses.js <<'__EOF__'
export const expenses = [
  { date: '2026-10-02', description: 'Mercado', amount: 182.4 },
  { date: '2026-10-05', description: 'Conta de luz', amount: 96.15 },
];
__EOF__
cat > test/expenses.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { expenses } from '../src/expenses.js';

test('has the month expenses', () => {
  assert.equal(expenses.length, 2);
});
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-10-10T10:00:00Z GIT_COMMITTER_DATE=2026-10-10T10:00:00Z git commit --quiet -m "list the month's expenses"
cat > src/csv.js <<'__EOF__'
import { expenses } from './expenses.js';

// TODO: escapar vírgulas e aspas na descrição
export function toCsv(list = expenses) {
  return ['data,descricao,valor', ...list.map((e) => `${e.date},${e.description},${e.amount}`)].join('\n');
}
__EOF__
