---
type: regex
target: trace
pattern: '"name":"Write","input":\{[^}]{0,60}?"file_path":"[^"]*\.(?:html?|css)"'
match: not_contains
---

Nenhuma página construída antes da escolha. Passa se o rastro não tem nenhum `Write` num arquivo `.html` ou `.css`.
