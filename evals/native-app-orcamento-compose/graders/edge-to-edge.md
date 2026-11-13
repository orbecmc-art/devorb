---
type: regex
target:
  source: file
  path: app/src/main/java/com/example/form/MainActivity.kt
pattern: 'enableEdgeToEdge\([\s\S]*?\bsetContent\b'
match: contains
---

A tela ocupa a tela toda. Passa se `MainActivity.kt` chama `enableEdgeToEdge()` antes de `setContent`, como pede o Android para desenhar sob as barras do sistema.
