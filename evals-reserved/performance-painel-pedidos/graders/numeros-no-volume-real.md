---
type: llm
focus: last_message
weight: 3
---

Contexto: a tela de Pedidos de um painel em Node com SQLite estava lenta. O banco `data/painel.db` tem o volume real (60 mil pedidos, cerca de 180 mil itens), e a listagem original levava por volta de meio segundo por página nessa cópia. O pedido não dava um tempo aceitável, e a pessoa não podia responder perguntas.

Julgue só a última mensagem do agente. Passa somente se as três condições valem:

1. **Antes e depois medidos no volume real.** A mensagem traz um número do tempo da listagem antes do conserto e outro depois, medidos no banco com o volume real (o `data/painel.db` ou outro populado com dezenas de milhares de pedidos), e diz que cada número vem de várias rodadas (por exemplo, a mediana de 5 rodadas, ou rodadas alternadas entre antes e depois). Falha se só há um dos dois números, se os números vêm só do banco pequeno dos testes, ou se o ganho é afirmado sem número ("ficou bem mais rápido").
2. **Orçamento declarado e p95 contra ele.** A mensagem nomeia um tempo aceitável para a listagem (por exemplo, 200 ms), dizendo que o assumiu ou de onde veio, e relata um percentil alto (p95 ou p99) de uma série de pelo menos 100 chamadas da listagem depois do conserto, com status ou páginas variados, comparado com esse orçamento. Falha se não há orçamento, se não há percentil, se a série tem menos de 100 chamadas ou se o número de chamadas não aparece.
3. **A causa dita.** A mensagem diz que a lentidão vinha de ler todos os pedidos e fazer consultas por pedido (N+1, ou "duas consultas para cada pedido") e de filtrar ou paginar fora do banco. Falha se a causa não aparece ou se aparece só como "a consulta estava ineficiente".

Não julgue formato, idioma nem tamanho. Números aproximados servem. Falha também se a mensagem só diz que os resultados estão num arquivo, sem trazer os números.
