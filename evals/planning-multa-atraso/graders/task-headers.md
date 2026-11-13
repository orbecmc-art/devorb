---
type: regex
target:
  source: file
  path: docs/devorb/plans/2026-11-11-multa-atraso.md
pattern: '^### Task 1: \S[\s\S]*^### Task 2: \S'
flags: m
match: contains
---

O plano no caminho pedido tem as tasks com o cabeçalho `### Task N: <título>`, que é o contrato com os scripts de execução: há pelo menos `### Task 1:` e, depois dele, `### Task 2:`, cada um no começo da linha e seguido de título. Outro nível de título (`## Task 1`), outra palavra (`### Tarefa 1`) ou plano fora desse caminho falham.
