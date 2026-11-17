---
type: regex
target: trace
pattern: '"command":\s*"[^"]*capture\.mjs|design/referencias/[\w.-]+/secoes\.md'
match: contains
---

A referência virou um pacote antes da cópia. Passa se o agente rodou `capture.mjs` num comando do Bash, ou se o rastro mostra um arquivo `design/referencias/<pasta>/secoes.md` de verdade (o nome da pasta tem só letras, números, ponto, hífen ou sublinhado, então um modelo como `design/referencias/<slug>/secoes.md`, lido num texto de instrução, não conta). Falha se a página foi copiada direto do HTML, sem pacote.
