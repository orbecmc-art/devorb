---
type: regex
target:
  source: file
  path: DESIGN.md
pattern: '#(?!(?:c8892b|7a2e1d|fbf6ec|f1e4cc|2b2523|8a7f76|3e7d4f|b7791f|a63a2b)\b)[0-9a-f]{3,8}\b|\b(?:rgba?|hsla?|oklch|oklab)\('
flags: i
match: not_contains
---

Nenhuma cor nova no `DESIGN.md`: a paleta da Trigal tem nove cores e a tela de pedidos cabe nela (há até `ok`, `atencao` e `erro` para as situações). Passa se o `DESIGN.md` final não tem cor em hexadecimal fora dessas nove nem cor em `rgb()`, `hsl()`, `oklch()` ou `oklab()`. Acrescentar uma cor de status, um tom novo ou uma segunda paleta falha.
