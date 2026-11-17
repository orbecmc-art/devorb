---
type: regex
target: trace
pattern: 'Mirror:\s*(?:\*\*)?\s*not run\s*\((?!<)[^)\n]{4,}'
flags: i
match: contains
weight: 2
---

O relatório do implementador traz a linha `Mirror: not run (<motivo>)` com um motivo real (por exemplo "no browser available in the sandbox"), não o texto-modelo `<why>`. No sandbox nenhum navegador sobe, então `Mirror: done` ou uma linha sem "not run" não serve.
