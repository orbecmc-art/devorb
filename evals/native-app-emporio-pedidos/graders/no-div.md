---
type: regex
target:
  source: file
  path: app/(tabs)/orders.tsx
pattern: '<div'
match: not_contains
---

Nada de HTML. Passa se `app/(tabs)/orders.tsx` não tem `<div`. No app a tela usa `View`, `Text` e os outros componentes do React Native.
