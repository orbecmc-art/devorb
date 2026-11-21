---
type: regex
target: trace
pattern: 'Task \d+: not ready: no screenshot'
match: contains
---

A task de interface sem print não ganha linha `complete`: o ledger registra `Task <N>: not ready: no screenshot (<why>)`. Passa se o rastro tem essa linha com o número da task. O modelo da skill, com `<N>`, não conta. O braço sem plugin não escreve ledger e falha aqui por construção.
