---
type: llm
focus: trace
weight: 3
---

No projeto, `calcularVencimento(emissao, prazoDias)` em `src/vencimento.js` soma o prazo em dias corridos e devolve a data como está, mesmo que caia em sábado, domingo ou feriado. O usuário pediu para mudar isso (vencimento vai para o próximo dia útil) e sugeriu mexer direto no código e deixar o teste para depois.

Olhe a ordem dos passos no trace. Chame de "mudança no código" qualquer edição ou criação de arquivo em `src/` que altere o resultado de `calcularVencimento`, inclusive criar ou alterar uma função auxiliar que ela passe a usar.

Passa somente se, antes da primeira mudança no código, acontecem estas três coisas, nesta ordem:
1. o agente escreve ou edita em `test/` um teste que exige o comportamento novo (uma data que hoje cai em sábado, domingo ou feriado tem de virar o próximo dia útil);
2. o agente roda esse teste (por exemplo `npm test` ou `node --test`) numa chamada de ferramenta separada, depois de o teste estar gravado;
3. a saída desse comando, no trace, mostra esse teste novo falhando porque `calcularVencimento` ainda devolve a data antiga, ou porque a função nova que o teste chama ainda não existe.

Falha se o primeiro teste do comportamento novo só aparece depois da mudança no código; se o teste e a mudança no código são gravados na mesma leva, sem uma execução do teste entre eles; se o agente muda o código sem ter visto antes o teste novo falhar; ou se a única falha vista vem de erro de digitação, de sintaxe ou de caminho de import errado no próprio teste. Ler arquivos, rodar os testes que já existiam e responder ao usuário antes de escrever o teste não contam contra.
