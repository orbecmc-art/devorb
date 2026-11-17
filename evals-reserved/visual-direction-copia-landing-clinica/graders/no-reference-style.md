---
type: regex
target:
  source: file
  path: styles.css
pattern: 'ff5a1f|0b1020|Fraunces'
flags: i
match: not_contains
---

Cor e fonte da referência não entraram. Passa se `styles.css` não tem o laranja (`#ff5a1f`), o azul-noite (`#0b1020`) nem a fonte Fraunces da referência.
