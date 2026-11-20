---
type: regex
target: trace
pattern: '^(?:(?!"name":"(?:Edit|Write|MultiEdit)","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"file_path":"(?:[^"]*/)?(?:src|public)/)[\s\S])*?"name":"Bash","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"command":"(?:[^"\\]|\\.)*?(?:performance\.now|console\.time|hrtime|Date\.now|hyperfine|autocannon|(?:(?<=[\s;&|("])|(?<=\\n))time\s|\bcurl\b(?:[^"\\]|\\.)*?\s(?:-[a-zA-Z]*w\b|--write-out)|(?:\b(?:node|bun|tsx|bash|sh|python3?)\s+(?:-[-\w=]+\s+)*|\bnpm run\s+|(?<=[\s;&|("])\./)[\w./-]*(?:bench|medi|measure|perf|tempo))'
match: contains
weight: 2
---

Medir vem antes de mexer, conferido pela ordem no trace inteiro (o juiz `llm` com `focus: trace` só recebe o começo e o fim de um trace longo). Passa se, antes do primeiro Edit, Write ou MultiEdit num arquivo em `src/` ou `public/`, o agente rodou no Bash um comando que mede tempo: com `performance.now`, `console.time`, `hrtime`, `Date.now`, `time` como comando, `curl` com `-w`, `hyperfine` ou `autocannon`, ou rodando um script cujo nome tem `bench`, `medi`, `measure`, `perf` ou `tempo`. Escrever antes um script de medição novo fora de `src/` e `public/` (por exemplo, `scripts/medir.mjs` ou `bench/busca.mjs`) é permitido. Mexer na busca ou na tela primeiro e medir depois, ou nunca medir, falha.
