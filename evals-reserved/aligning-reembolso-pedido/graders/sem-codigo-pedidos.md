---
type: regex
target:
  source: file
  path: src/pedidos.js
pattern: 'reembols|estorn|refund|devolu[cç]'
flags: i
match: not_contains
---
