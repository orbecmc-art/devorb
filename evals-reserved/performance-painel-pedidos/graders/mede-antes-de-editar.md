---
type: regex
target: trace
pattern: '^(?:(?!"name":"(?:Edit|Write|MultiEdit)","input":\{[^}]{0,80}?"file_path":"[^"]*/src/)[\s\S])*?"name":"Bash","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"command":"(?:[^"\\]|\\.)*?(?:performance\.now|hrtime|console\.time|\btime\s+(?:node|npm)|hyperfine|bench|medi[rç]|mede\b|tempo|timing|perf)'
match: contains
---

A medição do antes vem antes da primeira edição. Passa se, antes de qualquer Edit, Write ou MultiEdit em `src/`, o agente rodou no Bash um comando que mede tempo: `performance.now`, `process.hrtime`, `console.time`, `time node`, `hyperfine`, ou um script cujo nome ou conteúdo traz `bench`, `medir`, `mede`, `tempo`, `timing` ou `perf`. Os arquivos do projeto não usam nenhuma dessas palavras, então só um comando do próprio agente casa.
