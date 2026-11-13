---
type: regex
target:
  source: file
  path: DESIGN.md
pattern: '^(?=[\s\S]*O foco aparece na hora, sem transição nem fade\.)(?=[\s\S]*- O selo "Beta" ao lado do título usa `border-radius: 999px` \(pílula\), fora da escala de raios\.)'
match: contains
---

A revisão não reescreve o contrato. Passa se `DESIGN.md` ainda tem, como o scaffold deixou, a regra "O foco aparece na hora, sem transição nem fade." e a exceção autorizada do selo "Beta" com `border-radius: 999px`.
