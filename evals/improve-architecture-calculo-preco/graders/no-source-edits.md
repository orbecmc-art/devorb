---
type: regex
target: trace
pattern: '"name":"(?:Edit|Write|MultiEdit|NotebookEdit)","input":\{[^}]{0,80}?"(?:file_path|notebook_path)":"[^"]*/(?:src|test)/|\b(?:cat(?: <<-?\\?[''"]?\w+\\?[''"]?)? ?>>?|tee(?: -a)?) ?\\?[''"]?[^\s''"\\<>|;&]*\b(?:src|test)/[\w./-]*\.js|\b(?:sed|perl) -[a-zA-Z]*i[^|;&]*\b(?:src|test)/[\w./-]*\.js'
match: not_contains
---

A skill entrega candidatos, não a refatoração. Passa se o agente não editou nem criou arquivos em `src/` ou `test/`: nenhum Edit, Write ou MultiEdit com caminho nessas pastas e nenhum `cat >`, `tee`, `sed -i` ou `perl -i` escrevendo um `.js` nelas. Ler esses arquivos e rodar `npm test` ou `git log` é permitido.
