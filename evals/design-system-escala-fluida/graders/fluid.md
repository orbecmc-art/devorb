---
type: regex
target:
  source: file
  path: styles.css
pattern: '[\s\S]*clamp\([\s\S]*clamp\([\s\S]*clamp\('
match: contains
---

A escala de tipo é fluida: o `styles.css` tem pelo menos três `clamp(`, um por passo da escala, para o tamanho crescer com a largura da tela entre um mínimo e um máximo. Antes da execução, o arquivo só tem `:root {}`. Falha se a escala usa tamanhos fixos ou trocas por `@media` sem `clamp()`.
