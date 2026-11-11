---
type: llm
focus: trace
---

Regra pedida: o vencimento do boleto continua sendo a data de emissão mais o prazo em dias corridos; se essa data cair em sábado, domingo ou num feriado da lista de `src/feriados.js`, passa para o próximo dia que não é nenhum desses. Datas que já caem em dia útil não mudam. Há feriados colados em fins de semana (por exemplo, Carnaval na segunda 16/02/2026 e na terça 17/02/2026, logo depois de um fim de semana).

Olhe no trace as edições do agente em `src/` e a última execução da suíte de testes.

Passa somente se, no estado final, valem as quatro coisas:
- `calcularVencimento`, diretamente ou por uma função auxiliar que ela chama, avança a data num laço ou recursão (por exemplo `while`) até achar um dia que não é sábado, não é domingo e não é feriado, conferindo as três condições a cada volta;
- os feriados vêm da lista de `src/feriados.js`, direto ou por `ehFeriado` de `src/calendario.js`, e não de datas copiadas para dentro do código novo;
- o prazo continua contado em dias corridos: só a data final é ajustada, a contagem do prazo não passou a pular dias não úteis; e
- a última execução de `npm test` ou `node --test` no trace vem depois da última edição em `src/` e termina sem nenhum teste falhando.

Falha se o ajuste faz um número fixo de saltos sem voltar a conferir a data (por exemplo `+2` no sábado, `+1` no domingo e `+1` se for feriado, uma vez cada); se ignora os feriados; se a contagem do prazo mudou; se os testes que já existiam foram apagados ou alterados para passar; ou se a suíte não foi rodada depois da última edição em `src/`, ou terminou com falha.
