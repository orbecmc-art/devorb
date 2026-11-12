---
type: regex
target: trace
pattern: '^(?:(?!"name":"(?:Edit|Write|MultiEdit)","input":\{[^}]{0,60}?"file_path":"[^"]*/src/|cat >+ ?''?[^\n"]{0,40}src/)[\s\S])*?(?:"name":"(?:Edit|Write|MultiEdit)","input":\{[^}]{0,60}?"file_path":"[^"]*/test/|cat >+ ?''?[^\n"]{0,40}test/)(?:(?!"name":"(?:Edit|Write|MultiEdit)","input":\{[^}]{0,60}?"file_path":"[^"]*/src/|cat >+ ?''?[^\n"]{0,40}src/)[\s\S])*?(?:fail [1-9]|not ok [0-9]|actual: )'
match: contains
weight: 3
---

Ordem no trace (o juiz `llm` com `focus: trace` só recebe o começo e o fim de um trace longo e perde os primeiros ciclos): passa se, antes de qualquer Edit, Write ou `cat >` em `src/`, o agente escreveu em `test/` e uma execução de teste depois disso mostrou uma falha (`fail N`, `not ok N` ou `actual:`). Escrever o código primeiro, ou nunca ver o teste falhar antes do código, falha.
