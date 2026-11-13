---
type: regex
target:
  source: file
  path: src/styles.css
pattern: 'transition:\s*all'
flags: i
match: not_contains
---

Nenhuma transição em todas as propriedades. Passa se `src/styles.css` não tem `transition: all` (com ou sem espaço depois dos dois-pontos, em qualquer caixa). Transição que nomeia as propriedades, como `transition: opacity 200ms`, vale.
