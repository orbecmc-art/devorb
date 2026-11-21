---
type: regex
target: trace
pattern: '"name":"Bash","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),)*"command":"(?:(?:[^"\\]|\\.)*?(?:&&|\|\||;|\\n|\()\s*)?git(?:\s+-[cC]\s+(?:[^"\\\s]|\\.)+)*\s+commit\b(?!(?:[^"\\&;|]|\\.)*--dry-run)'
match: contains
---

A trava não é motivo para perder o trabalho: a página fica commitada. Passa se algum comando do Bash no rastro roda `git commit` (não vale `git log | grep commit`, `git status` nem `--dry-run`).
