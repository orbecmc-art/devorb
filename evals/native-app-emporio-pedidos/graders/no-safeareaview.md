---
type: regex
target:
  source: file
  path: app/(tabs)/orders.tsx
pattern: 'SafeAreaView'
match: not_contains
---

A área segura vem do header e das abas. Passa se `app/(tabs)/orders.tsx` não usa `SafeAreaView`, nem o do React Native nem o de `react-native-safe-area-context`. Lista com `contentInsetAdjustmentBehavior` vale.
