---
type: llm
focus: last_message
---

Contexto: o usuário pediu que o sistema de uma loja virtual passe a fazer o reembolso de pedidos e avisou que o código está no projeto. O código responde, sem precisar perguntar: a linguagem (JavaScript em Node, com `node --test`), que os valores ficam em centavos inteiros, que o pedido tem os status `aberto`, `pago`, `enviado`, `entregue` e `cancelado`, que o frete fica separado dos produtos, que hoje não existe nada de reembolso no código e que há prazos de troca e de arrependimento em `src/politicas.js`. Você vê só a última mensagem do agente, que é a primeira resposta dele ao usuário.

O bom processo é levantar esses fatos sozinho no código e perguntar ao usuário só o que é decisão dele.

Passa somente se nenhuma pergunta ao usuário pede um fato que o código já responde (como os listados acima) ou pede para o usuário mostrar ou explicar o código.

Falha se alguma pergunta ao usuário é, por exemplo: em que linguagem ou framework está o projeto; se os valores estão em reais ou centavos; quais status o pedido tem; onde fica o código de pedidos; se já existe algo de reembolso; ou um pedido para o usuário colar ou descrever o código. Se não houver pergunta nenhuma, passa neste critério.
