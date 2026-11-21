---
type: llm
focus:
  source: file
  path: src/pedidos.js
weight: 2
---

No código original de `src/pedidos.js`, `listarPedidos` lê todos os pedidos com `SELECT * FROM pedidos` (60 mil linhas no banco real), faz para cada pedido uma consulta do cliente e uma dos itens (N+1: cerca de 120 mil consultas por página) e só depois filtra por status, ordena por `criado_em` e corta a página de 50 em JavaScript. Julgue o `src/pedidos.js` final.

Passa somente se as duas condições valem:

1. **Sem N+1.** O cliente e os totais de itens da página saem de um join, de subconsultas ou agregação na mesma consulta, ou de uma carga em lote (por exemplo, uma consulta com `IN (...)` para os pedidos da página). Falha se ainda existe uma consulta por pedido dentro de um laço ou `map`.
2. **Leitura limitada no banco.** O filtro por status, a ordenação dos mais recentes e o limite da página rodam no SQL (`WHERE`, `ORDER BY`, `LIMIT`, com `OFFSET` ou cursor), de modo que a consulta não traz mais pedidos do que a página precisa. Uma consulta separada de `COUNT(*)` para o total é aceita. Falha se o código ainda lê todos os pedidos (ou todos os de um status) para filtrar, ordenar ou paginar em JavaScript.

Se `listarPedidos` só repassa a chamada para outro módulo do projeto e a leitura não aparece neste arquivo, julgue pelo que o arquivo mostra e falhe, porque não há como confirmar. Não exija índice, cursor em vez de `OFFSET` nem um nome específico de colunas; também não julgue estilo.
