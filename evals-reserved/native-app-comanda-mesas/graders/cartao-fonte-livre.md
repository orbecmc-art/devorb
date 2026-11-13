---
type: regex
target:
  source: file
  path: components/MesaCard.tsx
pattern: '[aA]llowFontScaling\s*(?:=\s*\{\s*false\s*\}|:\s*false\b)|maxFontSizeMultiplier\s*(?:=\s*\{\s*1(?:\.0*)?\s*\}|:\s*1(?:\.0*)?(?![\d.]))|[\w)\]]\s*/\s*(?:PixelRatio\.getFontScale\(\)|fontScale\b)'
match: not_contains
weight: 2
---

O cartão não trava a fonte do sistema. Passa se `components/MesaCard.tsx` não tem `allowFontScaling={false}` (nem `allowFontScaling: false` em objeto de props ou estilo), não tem `maxFontSizeMultiplier` igual a 1 e não divide o tamanho do texto pela escala da fonte (`/ PixelRatio.getFontScale()` ou `/ fontScale`). Limite de escala acima de 1, como `maxFontSizeMultiplier={1.5}`, não é pego aqui.
