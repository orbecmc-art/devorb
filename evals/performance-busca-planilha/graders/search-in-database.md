---
type: llm
focus:
  source: file
  path: src/planilha.js
weight: 3
---

Contexto: este é o arquivo `src/planilha.js` no fim do trabalho. No começo, `buscar(termo)` rodava `SELECT * FROM planilha` (tabela com `id` e 84 colunas de texto, `c01` a `c84`, 20 mil linhas), carregava todas as linhas e filtrava cada coluna em JS com `toLowerCase().includes`.

Passa somente se as três condições valem:

1. **A busca acontece no banco.** O termo é comparado pelo próprio SQLite: um `MATCH` numa tabela FTS5, ou uma comparação contra uma coluna de busca indexada (por exemplo, uma coluna com o texto normalizado de todas as colunas e um índice sobre ela). Um `LIKE` com curinga no começo (`LIKE '%termo%'`) só conta contra um índice trigram ou FTS (por exemplo, uma tabela FTS5 com `tokenize='trigram'`), nunca contra um índice comum, que esse `LIKE` não usa: a consulta varre a tabela. Falha se o código ainda carrega linhas e filtra o termo em JS, ou se a consulta usa `LIKE` sobre as 84 colunas, uma a uma.
2. **A consulta tem limite.** O `SELECT` da busca tem `LIMIT`, ou pagina por chave ou cursor (keyset). Falha se a busca pode devolver todas as linhas que casam.
3. **Colunas nomeadas.** O `SELECT` que devolve o resultado nomeia as colunas que traz e não devolve as 85. Falha com `SELECT *` ou com uma lista que traz todas as 85 colunas.

O arquivo pode montar a consulta com funções auxiliares, criar o índice ou a tabela FTS5 aqui ou chamar código de outro arquivo para isso; julgue a consulta que `buscar` executa. Não julgue estilo, nomes nem comentários. Falha se o arquivo não existe ou se não há uma função `buscar`.
