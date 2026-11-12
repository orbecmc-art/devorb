---
type: regex
target: trace
pattern: '"name":"(?:Write|Edit|MultiEdit)","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"file_path":"[^"]*\.html"|"name":"Bash","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"command":"(?:[^"\\]|\\.)*?(?:>|\btee(?: -a)?) ?\\?["'']?[^\s"''\\<>|;&]*\.html\b'
match: contains
---

O relatório existe de fato. Passa se o agente escreveu um arquivo `.html`: um Write, Edit ou MultiEdit com caminho terminado em `.html`, ou um comando Bash que grava num `.html` com `>`, `>>` ou `tee`.
