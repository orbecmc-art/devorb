---
type: regex
target: trace
pattern: '"name":"(?:Write|Edit|MultiEdit)","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"file_path":"[^"]*\.html"|"name":"Bash","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"command":"(?=(?:[^"\\]|\\.)*?\.html\b)(?=(?:[^"\\]|\\.)*?(?:>|\btee\b))'
match: contains
---

O relatório existe de fato. Passa se o agente escreveu um arquivo `.html`: um Write, Edit ou MultiEdit com caminho terminado em `.html`, ou um comando Bash que cita um caminho `.html` e grava com `>`, `>>` ou `tee` (o caminho pode estar numa variável, como `F="$TMPDIR/x.html"; cat > "$F"`).
