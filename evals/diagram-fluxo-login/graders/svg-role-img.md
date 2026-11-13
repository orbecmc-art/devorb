---
type: regex
target:
  source: file
  path: docs/login-flow.svg
pattern: '<svg\b[^>]*\brole=["'']img["'']'
flags: i
match: contains
---

O diagrama se anuncia como imagem para leitor de tela. Passa se a tag `<svg>` de `docs/login-flow.svg` tem `role="img"` (aspas simples ou duplas). Falha se o arquivo não existe ou se o `role="img"` está só num elemento interno.
