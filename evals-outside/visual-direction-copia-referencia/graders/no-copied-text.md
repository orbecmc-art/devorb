---
type: regex
target:
  source: file
  path: index.html
pattern: 'Feche\s+a\s+agenda(?:\s|<[^>]*>)+antes\s+do\s+caf'
flags: i
match: not_contains
---

Copiar a forma não é copiar o texto. Passa se `index.html` existe e não tem o título do Quadrante, "Feche a agenda antes do café", nem com tags no meio (como `Feche a agenda <span>antes do café.</span>`). Falha se o arquivo não existe.
