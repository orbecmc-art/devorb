---
type: regex
target:
  source: file
  path: app/_layout.tsx
pattern: '[aA]llowFontScaling\s*(?:=\s*\{?\s*false\s*\}?|:\s*false\b)|maxFontSizeMultiplier\s*(?:=\s*\{?\s*1(?:\.0*)?(?![\d.])|:\s*1(?:\.0*)?(?![\d.]))'
match: not_contains
---

Nenhuma trava global de fonte. Passa se `app/_layout.tsx` não desliga a escala da fonte para o app inteiro, como `Text.defaultProps.allowFontScaling = false`, `allowFontScaling={false}` ou `maxFontSizeMultiplier = 1`.
