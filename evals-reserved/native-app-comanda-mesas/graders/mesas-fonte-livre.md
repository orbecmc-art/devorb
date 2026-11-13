---
type: regex
target:
  source: file
  path: app/(tabs)/index.tsx
pattern: '[aA]llowFontScaling\s*(?:=\s*\{\s*false\s*\}|:\s*false\b)|maxFontSizeMultiplier\s*(?:=\s*\{\s*1(?:\.0*)?\s*\}|:\s*1(?:\.0*)?(?![\d.]))|[\w)\]]\s*/\s*(?:PixelRatio\.getFontScale\(\)|fontScale\b)'
match: not_contains
---

A tela de mesas não trava a fonte do sistema. Passa se `app/(tabs)/index.tsx` não tem `allowFontScaling={false}` (nem `allowFontScaling: false`), não tem `maxFontSizeMultiplier` igual a 1 e não divide o tamanho do texto pela escala da fonte.
