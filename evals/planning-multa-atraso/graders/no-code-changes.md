---
type: regex
target: trace
pattern: '"name":"(?:Edit|Write|MultiEdit|NotebookEdit)","input":\{[^}]{0,80}?"(?:file_path|notebook_path)":"[^"]*/(?:src|test|bin)/|\b(?:cat(?: <<-?\\?[''"]?\w+\\?[''"]?)? ?>>?|tee(?: -a)?) ?\\?[''"]?[^\s''"\\<>|;&]*\b(?:src|test|bin)/[\w./-]*\.js'
match: not_contains
---

O pedido era só o plano. Passa se o agente não editou nem criou arquivos em `src/`, `test/` ou `bin/`: nenhum Edit, Write ou MultiEdit com caminho nessas pastas e nenhum `cat >`, `cat <<EOF >` ou `tee` escrevendo um `.js` nelas. Ler esses arquivos (`cat src/cli.js`) é permitido.
