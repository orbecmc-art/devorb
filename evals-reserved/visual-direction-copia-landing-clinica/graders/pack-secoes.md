---
type: regex
target: files
pattern: 'design/referencias/[^/]+/secoes\.md'
match: contains
weight: 2
---

O agente gravou o mapa das seções da referência em `design/referencias/<slug>/secoes.md`. O slug é livre; só o formato da pasta conta.
