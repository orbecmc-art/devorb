---
type: regex
target: trace
pattern: '^(?:(?!"name":"(?:Edit|Write|MultiEdit)","input":\{[^}]{0,80}?"file_path":"[^"]*/src/)[\s\S])*?"name":"Bash","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"command":"(?:[^"\\]|\\.)*?(?:performance\.now|hrtime|console\.time|\btime\s+(?:node|npm)|hyperfine|(?:(?<![\w./-])(?:node|bash|sh|zsh|python3?|npx|tsx|bun|deno)\s+(?:-[^\s"\\]*\s+)*|(?<![\w./-])(?:npm\s+run(?:-script)?|pnpm(?:\s+run)?|yarn(?:\s+run)?|bun\s+run)\s+|(?<=(?:"command":"|[;&|(]|\\n|\btime)\s*)(?=[^\s"\\;&|]*/))(?:[^\s"\\;&|]*/)*[^\s"\\/;&|]*?(?:bench|medi[rç]|mede\b|tempo|timing|perf)(?![^\s"\\;&|]*/))'
match: contains
---

A medição do antes vem antes da primeira edição. Passa se, antes de qualquer Edit, Write ou MultiEdit em `src/`, o agente rodou no Bash um comando que mede tempo: `performance.now`, `process.hrtime`, `console.time`, `time node`, `hyperfine`, ou a execução de um script cujo nome de arquivo traz `bench`, `medir`, `mede`, `tempo`, `timing` ou `perf`. O script conta quando vem depois de `node`, `bash`, `sh`, `python`, `npx`, `tsx`, `bun`, `deno`, `npm run`, `pnpm` ou `yarn`, ou quando é chamado direto pelo caminho (`./bench.sh`, `/tmp/x/bench.sh`) no início do comando. A palavra só vale no nome do arquivo, nunca numa pasta do caminho, e um arquivo só lido, listado ou buscado (`cat`, `ls`, `grep`) não conta. Os arquivos do projeto não usam nenhuma dessas palavras, então só um comando do próprio agente casa.
