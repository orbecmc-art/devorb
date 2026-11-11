---
type: regex
target:
  source: file
  path: test/payment-processing.test.js
pattern: 'sleep\(|setTimeout\('
match: not_contains
---
