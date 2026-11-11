---
type: regex
target:
  source: file
  path: test/payment-processing.test.js
pattern: 'await\s+sleep\(|setTimeout\([^)]*\d'
match: not_contains
---
