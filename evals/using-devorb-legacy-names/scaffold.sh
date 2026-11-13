#!/usr/bin/env bash
# Builds, in the current directory, a tiny to-do list module (add, complete,
# list pending), where task priority is a small, concrete next change.
# Self-contained, no network. Reproducible: fixed author, date and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

git init --quiet -b main
mkdir -p src test

cat > package.json <<'__EOF__'
{ "name": "tarefas", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__EOF__
cat > src/tasks.js <<'__EOF__'
export function addTask(tasks, title) {
  return [...tasks, { title, done: false }];
}

export function completeTask(tasks, title) {
  return tasks.map((t) => (t.title === title ? { ...t, done: true } : t));
}

export function pending(tasks) {
  return tasks.filter((t) => !t.done);
}
__EOF__
cat > test/tasks.test.js <<'__EOF__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { addTask, completeTask, pending } from '../src/tasks.js';

test('pending leaves out completed tasks', () => {
  let tasks = addTask(addTask([], 'pagar luz'), 'comprar pão');
  tasks = completeTask(tasks, 'pagar luz');
  assert.deepEqual(pending(tasks).map((t) => t.title), ['comprar pão']);
});
__EOF__

git add -A
GIT_AUTHOR_DATE=2026-10-10T10:00:00Z GIT_COMMITTER_DATE=2026-10-10T10:00:00Z git commit --quiet -m "to-do list with pending view"
