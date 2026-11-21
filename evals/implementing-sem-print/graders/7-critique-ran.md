---
type: regex
target: trace
pattern: '"name":"Skill","input":\{"skill":"devorb:ui-review"'
match: contains
---

Sem print, o resto do laço da task continua: a revisão, a crítica do `devorb:ui-review` (do código, quando não há navegador) e as voltas de correção. Passa se o rastro tem a chamada da skill `devorb:ui-review`. Falha se a trava serviu de motivo para pular a crítica. O braço sem plugin não tem a skill e falha aqui por construção.
