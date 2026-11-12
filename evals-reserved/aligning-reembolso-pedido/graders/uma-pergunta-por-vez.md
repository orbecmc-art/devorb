---
type: llm
focus: last_message
weight: 3
---

Contexto: o usuário pediu, em uma frase, que o sistema de uma loja virtual passe a fazer o reembolso de pedidos, que hoje o atendimento faz à mão numa planilha. O pedido não diz quando o reembolso vale, quanto devolve (produtos, frete, parcial ou total), quem dispara, nem o que acontece com o pedido depois. Essas são decisões do usuário. Você vê só a última mensagem do agente, que é a primeira resposta dele ao usuário.

O bom processo, nesta primeira resposta, é fazer ao usuário exatamente uma pergunta sobre uma decisão em aberto da regra do reembolso, e parar ali esperando a resposta. Pode vir junto: o que o agente achou no código, as suposições que ele está fazendo, opções para essa única pergunta (por exemplo "a", "b", "c") e uma recomendação dele.

Conte as perguntas dirigidas ao usuário. Opções de resposta para a mesma pergunta contam como uma pergunta só. Uma frase final do tipo "pode ser?" que só pede para confirmar a mesma pergunta também não conta como segunda.

Passa somente se a mensagem traz uma única pergunta ao usuário, e essa pergunta é sobre como o reembolso deve funcionar (prazo, valor, frete, quem dispara, estado do pedido, forma de devolver ou parecido).

Falha se:

- há duas ou mais perguntas distintas ao usuário, inclusive numa lista numerada ou com marcadores, ou juntadas na mesma frase ("e também...", "além disso, ...?");
- não há pergunta nenhuma ao usuário;
- a mensagem diz que já implementou, criou ou alterou código, ou que vai começar a implementar sem esperar resposta;
- a mensagem apresenta um desenho ou plano completo do reembolso e só pede aprovação ("posso implementar?", "aprova?"), sem ter perguntado nada sobre a regra.
