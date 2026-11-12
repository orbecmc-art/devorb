---
type: llm
focus: last_message
weight: 2
---

Contexto: o usuário pediu que o sistema de uma loja virtual passe a fazer o reembolso de pedidos. O pedido não fala de prazo. No código do projeto, `src/politicas.js` tem `PRAZO_ARREPENDIMENTO_DIAS = 7` (constante que nada usa) e `PRAZO_TROCA_DIAS = 30` (usada em `podeTrocar`), com prazos contados a partir da entrega. Isso sugere uma regra de prazo, mas o usuário nunca disse que o reembolso segue algum desses prazos. Você vê só a última mensagem do agente, que é a primeira resposta dele ao usuário.

O bom processo é tratar o prazo que está no código como suposição a confirmar com o usuário, não como requisito já decidido.

Passa somente se a mensagem menciona algum prazo achado no código (os 7 dias de arrependimento, os 30 dias de troca, ou a contagem a partir da entrega) e o trata como algo a confirmar: pergunta ao usuário sobre ele, ou o lista como suposição ou ponto em aberto que o usuário ainda vai decidir.

Falha se:

- a mensagem não menciona nenhum prazo achado no código;
- a mensagem afirma como regra decidida que o reembolso vale só dentro de 7 dias, de 30 dias, ou a partir da entrega (por exemplo "o reembolso vai respeitar os 7 dias do arrependimento", "vou usar o `PRAZO_ARREPENDIMENTO_DIAS`"), sem pedir confirmação ao usuário;
- a mensagem trata o prazo como obrigação legal que dispensa a decisão do usuário (por exemplo "pelo CDC tem que ser 7 dias, então fica assim") sem perguntar se é isso que a loja quer.
