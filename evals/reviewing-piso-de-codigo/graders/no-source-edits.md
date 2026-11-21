---
type: regex
target: trace
pattern: '"name":"(?:Edit|Write|MultiEdit|NotebookEdit)","input":\{[^}]{0,80}?"(?:file_path|notebook_path)":"[^"]*/(?:src|test|node_modules)/|\b(?:cat(?: <<-?\\?[''"]?\w+\\?[''"]?)? ?>>?|tee(?: -a)?) ?\\?[''"]?[^\s''"\\<>|;&]*\b(?:src|test|node_modules)/[\w./-]*\.js|\b(?:sed|perl) -[a-zA-Z]*i[^|;&]*\b(?:src|test|node_modules)/[\w./-]*\.js'
match: not_contains
---

Uma revisão não muda o código. Passa se o agente não editou nem criou arquivos em `src/`, `test/` ou `node_modules/` (onde fica o `dayjs` instalado): nenhum Edit, Write ou MultiEdit com caminho nessas pastas e nenhum `cat >`, `cat <<EOF >`, `tee`, `sed -i` ou `perl -i` escrevendo um `.js` nelas. Ler esses arquivos (`cat src/recibo.js`, `git diff`) e rodar `npm test` é permitido.
