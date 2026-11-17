---
type: regex
target:
  source: file
  path: .devorb/sdd/2026-11-11-em-breve-agenda/task-1-report.md
pattern: 'Mirror: rounds \d'
match: contains
---

O relatório do implementador traz o campo do espelho. Passa se o relatório da Task 1, no lugar que `devorb:implementing` dá para ele (`.devorb/sdd/2026-11-11-em-breve-agenda/task-1-report.md`, ao lado do brief), tem `Mirror: rounds` seguido de um número, como em `Mirror: rounds 2/3 · shots …`. O modelo `Mirror: rounds <n>/3` sem número não conta. Falha se o relatório não existe, se não tem o campo, ou se diz `Mirror: not run`.
