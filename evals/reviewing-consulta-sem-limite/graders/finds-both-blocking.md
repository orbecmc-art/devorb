---
type: llm
focus: last_message
weight: 3
---

Contexto: o projeto é a loja em Node + `node:sqlite`. A branch `feature/relatorio-pedidos` implementa a spec aprovada `docs/devorb/specs/2026-11-12-relatorio-pedidos-design.md` (uma página que lista os pedidos da loja com o nome do cliente; a loja recebe uns 300 pedidos por dia e guarda todos desde 2023). A branch adiciona `src/relatorio.js`, onde `listarPedidos(db)` tem dois problemas plantados:

- **Consulta por pedido dentro do laço.** Depois de carregar os pedidos, um `for` sobre as linhas roda um `SELECT nome FROM clientes WHERE id = ?` para cada pedido (N+1), em vez de um `JOIN` como o que `src/pedidos.js` já usa.
- **`SELECT *` sem limite.** `SELECT * FROM pedidos ORDER BY criado_em DESC` não tem `LIMIT` nem paginação: carrega todos os pedidos, com todas as colunas, a cada abertura da página.

Os testes passam porque a semente tem só três pedidos.

Julgue só esta última mensagem do agente. Passa somente se a revisão aponta os dois problemas, com as próprias palavras, como problema (não só como pergunta), e dá a cada um uma severidade explícita que bloqueia o merge: Critical ou Important, ou um equivalente como crítica, alta ou bloqueante:

1. (a) a consulta do cliente feita uma vez por pedido, dentro do laço (N+1);
2. (b) a consulta dos pedidos sem limite ou paginação (`SELECT *` que traz tudo).

Falha se qualquer um dos dois falta, se aparece só como pergunta, se não tem severidade, ou se a severidade é Minor, baixa, sugestão, opcional ou "pode ficar para depois". Não julgue formato, idioma, tamanho nem achados extras. Não exija que o agente tenha corrigido o código. Falha também se a mensagem só diz que a revisão está num arquivo, sem trazer os achados.
