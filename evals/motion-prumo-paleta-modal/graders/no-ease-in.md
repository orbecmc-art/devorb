---
type: regex
target:
  source: file
  path: src/styles.css
pattern: 'ease-in[^-]'
match: not_contains
---

Nenhuma curva que começa devagar. Passa se `src/styles.css` não usa a curva `ease-in`. `ease-in-out`, `ease-out`, `ease` e `cubic-bezier(...)` valem.
