---
type: regex
target: trace
pattern: '^(?:(?!"name":"(?:Edit|Write|MultiEdit)","input":\{[^}]{0,60}?"file_path":"[^"]*\.(?:html?|css|tsx)")[\s\S])*?"name":"Skill","input":\{[^}]{0,80}?visual-direction'
match: contains
weight: 2
---

Ordem no trace: passa se a chamada da skill `visual-direction` vem antes do primeiro Write, Edit ou MultiEdit num `.html`, `.css` ou `.tsx`. Ir direto ao código e chamar a skill depois, ou nunca, falha.
