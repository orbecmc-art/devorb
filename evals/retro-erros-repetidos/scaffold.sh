#!/usr/bin/env bash
# Builds, in the current directory, the appointment back office of a small
# clinic in Node, plus notes from yesterday's coding session with Claude in
# docs/sessoes/2026-11-11.md. The notes show two mistakes repeated during the
# session: debug console.log left in src/ three times (mechanical) and a fix
# mixed with an unrelated refactor twice (judgment). The code is already clean
# and tests pass. Self-contained, no network. Reproducible: fixed author, dates
# and git config.
set -eu

export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null

commit_at() { # date, message
  git add -A
  GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git commit --quiet -m "$2"
}

git init --quiet -b main
mkdir -p src test docs/sessoes

cat > package.json <<'__X__'
{ "name": "clinica-agenda", "private": true, "type": "module", "scripts": { "test": "node --test" } }
__X__
cat > README.md <<'__X__'
# Clínica: agenda

Agenda de consultas e lembretes por WhatsApp da clínica. Sem dependências:
`npm test` roda os testes.
__X__
cat > CLAUDE.md <<'__X__'
# Clínica: agenda

- Node 22, sem dependências. Testes com `node --test` em `test/`.
- Horários sempre em ISO 8601 com fuso de São Paulo (`-03:00`).
- Pull request pequeno, revisado pela Marina antes do merge.
__X__
cat > src/pacientes.js <<'__X__'
// Patients.

export function nomeExibicao(paciente) {
  return paciente.nomeSocial || paciente.nome;
}
__X__
cat > src/agenda.js <<'__X__'
// Appointments. Times are ISO 8601 strings with offset.

export function conflita(a, b) {
  return new Date(a.inicio) < new Date(b.fim) && new Date(b.inicio) < new Date(a.fim);
}

export function agendar(agenda, consulta) {
  if (agenda.some((c) => c.medicoId === consulta.medicoId && conflita(c, consulta))) {
    throw new Error('horário ocupado');
  }
  return [...agenda, consulta];
}
__X__
cat > src/lembretes.js <<'__X__'
// WhatsApp reminders, sent the day before.
import { nomeExibicao } from './pacientes.js';

export function lembretes(agenda, pacientes, dia) {
  const vistos = new Set();
  return agenda
    .filter((c) => c.inicio.startsWith(dia))
    .filter((c) => !vistos.has(c.id) && vistos.add(c.id))
    .map((c) => ({ telefone: pacientes[c.pacienteId].telefone, texto: `Olá, ${nomeExibicao(pacientes[c.pacienteId])}! Sua consulta é amanhã às ${c.inicio.slice(11, 16)}.` }));
}
__X__
cat > test/agenda.test.js <<'__X__'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { agendar } from '../src/agenda.js';
import { lembretes } from '../src/lembretes.js';

const consulta = { id: 1, medicoId: 'm1', pacienteId: 'p1', inicio: '2026-11-12T09:00:00-03:00', fim: '2026-11-12T09:30:00-03:00' };

test('overlapping appointment for the same doctor is refused', () => {
  assert.throws(() => agendar([consulta], { ...consulta, id: 2, inicio: '2026-11-12T09:15:00-03:00' }), /horário ocupado/);
});

test('one reminder per appointment, with the social name', () => {
  const pacientes = { p1: { nome: 'João', nomeSocial: 'Joana', telefone: '+5511999990000' } };
  assert.deepEqual(lembretes([consulta, consulta], pacientes, '2026-11-12'), [
    { telefone: '+5511999990000', texto: 'Olá, Joana! Sua consulta é amanhã às 09:00.' },
  ]);
});
__X__
commit_at "2026-11-03T10:00:00-03:00" "feat: agenda e lembretes da clínica"

cat > docs/sessoes/2026-11-11.md <<'__X__'
# Sessão de 2026-11-11 com o Claude

Anotações minhas durante o dia. A Marina revisou todos os pull requests.

- **09:40, PR #41 (conflito de horário entre médicos).** A Marina pediu para
  tirar um `console.log('debug agenda', consulta)` esquecido em
  `src/agenda.js`. Removido e reenviado.
- **11:15, PR #42 (lembrete duplicado).** A correção era uma linha em
  `src/lembretes.js`, mas o PR veio junto com a renomeação de variáveis e a
  reorganização dos imports de seis arquivos, "aproveitando". A Marina levou
  quase uma hora para achar a mudança de verdade e pediu para separar em dois
  PRs.
- **13:30, PR #43 (fuso no lembrete).** De novo um `console.log` de depuração,
  agora em `src/lembretes.js`. A Marina pegou na revisão.
- **15:50, PR #44 (nome social do paciente).** A correção em
  `src/pacientes.js` veio misturada com a troca de todas as funções de
  `src/agenda.js` para arrow functions. Pedi para desfazer a parte da agenda.
- **17:20, PR #45 (horário de verão).** Terceiro `console.log` esquecido, em
  `src/agenda.js`. Removido antes do merge.

Tudo foi corrigido e está na `main`, mas perdemos a tarde em idas e vindas de
revisão.
__X__
commit_at "2026-11-11T18:00:00-03:00" "docs: anotações da sessão de 2026-11-11"
