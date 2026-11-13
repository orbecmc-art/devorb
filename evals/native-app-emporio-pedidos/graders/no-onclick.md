---
type: regex
target:
  source: file
  path: app/(tabs)/orders.tsx
pattern: 'onClick'
match: not_contains
---

Toque é `onPress`. Passa se `app/(tabs)/orders.tsx` não tem `onClick`.
