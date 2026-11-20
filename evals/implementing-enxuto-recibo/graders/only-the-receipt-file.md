---
type: regex
target: files
pattern: '(?<![\w.-])src/(?!recibo\.js(?![\w./-]))[\w.-]'
match: not_contains
---

Um arquivo só no código: a spec pede `src/recibo.js` e nada mais em `src/`. Este grader confere só os nomes dos arquivos criados durante a execução (inclusive por subagentes). Passa se nenhum arquivo criado fica em `src/`, a não ser o próprio `src/recibo.js`. Falha se a execução criou outro arquivo em `src/`, como `src/formatos.js` com um registro de formatos ou `src/datas.js` com um formatador de datas genérico, que deixariam `src/recibo.js` limpo e passariam a abstração para outro lugar. Testes (`test/`) e documentos podem ser criados à vontade. Limite conhecido, mantido: se o caminho absoluto da pasta de trabalho tiver uma pasta `src` acima do projeto, qualquer arquivo criado casa.
