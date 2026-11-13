---
type: regex
target: trace
pattern: '^(?:(?!"name":"(?:Edit|Write|MultiEdit)","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"file_path":"(?:[^"]*/)?(?:app|components)/|(?:(?<![=-])>>?|\btee(?: -a)?) ?(?:\\?["''])?(?:[^\s"''\\<>|;&]*/)?(?:app|components)/[\w./-]*\.(?:tsx?|css))[\s\S])*?(?:"name":"(?:Read|Grep)","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"(?:file_path|path)":"[^"]*ui-sources\.json"|"name":"Bash","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"command":"(?:[^"\\]|\\.)*?\b(?:cat|head|tail|sed|less|more|jq|grep|node|python3?)\b(?:[^"\\]|\\.)*?ui-sources\.json)'
match: contains
weight: 2
---

A lista fixa de fontes vem antes do código, conferida pela ordem no trace inteiro (o juiz `llm` com `focus: trace` só recebe o começo e o fim de um trace longo). Passa se, antes do primeiro Edit, Write ou MultiEdit num arquivo em `app/` ou `components/` (ou de um `>`, `>>` ou `tee` para um `.ts`, `.tsx` ou `.css` nessas pastas), o agente leu um arquivo cujo caminho termina em `ui-sources.json`: com Read ou Grep, ou no Bash com `cat`, `head`, `tail`, `sed`, `less`, `more`, `jq`, `grep`, `node` ou `python`. Escrever a página primeiro e ler a lista depois, ou nunca ler, falha. Sem a skill não há `ui-sources.json` no projeto, então os braços de base devem falhar aqui.
