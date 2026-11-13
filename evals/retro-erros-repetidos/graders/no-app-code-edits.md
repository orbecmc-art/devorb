---
type: regex
target: trace
pattern: '"name":"(?:Edit|Write|MultiEdit|NotebookEdit)","input":\{[^}]{0,80}?"(?:file_path|notebook_path)":"[^"]*/src/|\b(?:cat(?: <<-?\\?[''"]?\w+\\?[''"]?)? ?>>?|tee(?: -a)?) ?\\?[''"]?[^\s''"\\<>|;&]*\bsrc/[\w./-]*\.js|\b(?:sed|perl) -[a-zA-Z]*i[^|;&]*\bsrc/[\w./-]*\.js'
match: not_contains
---

A retro mexe no ambiente, não no código da aplicação. Passa se o agente não editou nem criou arquivos em `src/`: nenhum Edit, Write ou MultiEdit com caminho em `src/` e nenhum `cat >`, `tee`, `sed -i` ou `perl -i` escrevendo um `.js` nela. Criar um teste em `test/`, um hook em `.claude/`, um script de checagem ou editar `CLAUDE.md` é permitido, assim como ler `src/` e rodar `grep` nela.
