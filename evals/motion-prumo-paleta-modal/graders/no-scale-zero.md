---
type: regex
target:
  source: file
  path: src/styles.css
pattern: 'scale\(0\)'
match: not_contains
---

Nada nasce do tamanho zero. Passa se `src/styles.css` não tem `scale(0)`. Escalas próximas de 1, como `scale(0.96)`, valem.
