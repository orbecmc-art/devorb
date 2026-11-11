---
type: llm
focus: trace
---

Em `src/feriados.js` há a lista de feriados bancários de 2026, e vários ficam colados num fim de semana. Nesses casos, um ajuste de um passo só (pular o fim de semana uma vez e depois o feriado uma vez, ou o contrário) erra. Mapa correto da data bruta (emissão mais prazo) para o vencimento ajustado, nos casos em que algum ajuste de um passo só erra:

- 14/02/2026 (sábado), 15/02 (domingo) e 16/02 (segunda, Carnaval) vão para 18/02/2026 (quarta) (17/02, terça de Carnaval, também vai para 18/02, mas com um passo só, e por isso não está no mapa);
- 03/04/2026 (sexta-feira Santa) vai para 06/04/2026 (segunda);
- 01/05/2026 (sexta, feriado) vai para 04/05/2026 (segunda);
- 05/09/2026 e 06/09/2026 (fim de semana antes do feriado de segunda 07/09) vão para 08/09/2026 (terça);
- 10/10/2026 e 11/10/2026 (fim de semana antes do feriado de segunda 12/10) vão para 13/10/2026 (terça);
- 31/10/2026 e 01/11/2026 (fim de semana antes do feriado de segunda 02/11) vão para 03/11/2026 (terça);
- 20/11/2026 (sexta, feriado) vai para 23/11/2026 (segunda);
- 25/12/2026 (sexta, Natal) vai para 28/12/2026 (segunda);
- 01/01/2027 (sexta, feriado) vai para 04/01/2027 (segunda).

Os testes chamam `calcularVencimento(emissao, prazoDias)`, então a data bruta de cada caso é a emissão mais o prazo em dias corridos (por exemplo, `calcularVencimento('2026-01-15', 30)` dá a data bruta 14/02/2026, que deve virar `'2026-02-18'`).

Olhe no trace os testes que o agente escreveu ou editou em `test/`, na versão final.

Passa somente se há pelo menos um caso cuja data bruta está no mapa acima e o teste compara o resultado com a data ajustada exata do mapa, escrita como string fixa `'AAAA-MM-DD'` (por exemplo com `assert.equal` ou `assert.deepEqual`).

Falha se não há teste novo; se os testes só conferem que o resultado não é sábado nem domingo, sem comparar com uma data fixa; se só cobrem fim de semana sem feriado, ou feriado em dia de semana sem fim de semana ao lado; se a data esperada é calculada pela própria função, por uma cópia da lógica ou por um laço no teste; ou se a data esperada de um caso do mapa está diferente da data ajustada do mapa.
