---
type: regex
target:
  source: file
  path: index.html
pattern: 'lorem'
flags: i
match: not_contains
---

Nenhum texto de enchimento. Passa se `index.html` não tem "lorem" (lorem ipsum), em qualquer caixa.
