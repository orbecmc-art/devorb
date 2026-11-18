---
type: regex
target: last_message
pattern: '^(?=[\s\S]*display-weight)(?=[\s\S]*accent-count)'
match: contains
---

A revisão relata as duas medidas novas do piso. Passa se a resposta final cita os dois ids, `display-weight` (título de 48px ou mais com peso 700 ou mais e tracking 0 ou maior) e `accent-count` (mais de dois matizes saturados), em qualquer ordem. Falta de um dos dois falha.
