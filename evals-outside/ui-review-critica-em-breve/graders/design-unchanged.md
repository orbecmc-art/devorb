---
type: regex
target:
  source: file
  path: DESIGN.md
pattern: '^(?=[\s\S]*\| `--fs-13` \| `13px` \|)(?=[\s\S]*\| `--fs-26` \| `26px` \|)(?=[\s\S]*\| `--lh-justa` \| `1\.25` \|)(?=[\s\S]*Raio de 12px em cartões \(`--raio-cartao`\) e 999px em botões \(`--raio-botao`\)\.)'
match: contains
---

A revisão não reescreve o sistema visual. Passa se `DESIGN.md` ainda tem, como o scaffold deixou, os tokens `--fs-13` (13px), `--fs-26` (26px) e `--lh-justa` (1.25) na tabela de tipografia e a linha dos raios de 12px e 999px.
