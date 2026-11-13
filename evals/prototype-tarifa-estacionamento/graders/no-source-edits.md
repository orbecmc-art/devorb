---
type: regex
target: trace
pattern: '"name":"(?:Edit|Write|MultiEdit|NotebookEdit)","input":\{[^}]{0,80}?"(?:file_path|notebook_path)":"[^"]*/(?:src|test)/(?![^"]*[Pp]rototyp)[^"]*\.(?:js|mjs|cjs|json)"|\b(?:cat(?: <<-?\\?[''"]?\w+\\?[''"]?)? ?>>?|tee(?: -a)?) ?\\?[''"]?[^\s''"\\<>|;&]*\b(?:src|test)/(?![\w./-]*[Pp]rototyp)[\w./-]*\.js|\b(?:sed|perl) -[a-zA-Z]*i[^|;&]*\b(?:src|test)/(?![\w./-]*[Pp]rototyp)[\w./-]*\.js'
match: not_contains
---

O protótipo fica fora do código de verdade. Passa se o agente não mexeu no código nem nos testes: nenhum Edit, Write ou MultiEdit num `.js`, `.mjs`, `.cjs` ou `.json` em `src/` ou `test/`, e nenhum `cat >`, `tee`, `sed -i` ou `perl -i` escrevendo um `.js` nelas. Arquivo com "prototype" no nome é o protótipo, que a skill põe perto do módulo, numa branch `prototype/`, e não conta. Um `.html` também não conta. Ler `src/tarifa.js` e rodar `npm test` é permitido.
