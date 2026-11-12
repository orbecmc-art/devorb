---
type: regex
target: trace
pattern: '"name":"Bash","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"command":"(?:[^"\\]|\\.)*?(?:(?<![\w./-])|(?<=\\[nt]))git(?:\s+-[cC]\s+(?:[^\s"\\]|\\.)+)*\s+(?:short)?log\b|"name":"(?:Agent|Task)","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"\w+":"(?:[^"\\]|\\.)*?\bgit (?:short)?log\b'
match: contains
---

O ponto quente vem do histórico. Passa se algum comando da ferramenta Bash rodou `git log` ou `git shortlog` (também com `git -C <pasta> log`), ou se o agente pediu a um subagente (`Agent` ou `Task`) que rodasse `git log`. Ler só os arquivos de `src/` falha.
