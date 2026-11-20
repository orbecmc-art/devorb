---
type: llm
focus:
  source: file
  path: src/recibo.js
weight: 3
---

Contexto: este é o arquivo `src/recibo.js` no fim do trabalho. A spec pedia só `gerarRecibo(pedido)`, que devolve um recibo em texto puro (número do pedido, data em `dd/mm/aaaa`, uma linha por item com o subtotal em reais, e o total). O projeto já tinha `subtotalCentavos`, `totalCentavos` e `formatarReais` em `src/pedidos.js`. As notas do plano sugeriam, sem exigir, uma biblioteca de datas como `dayjs` e diziam que o recibo "pode ganhar PDF e HTML no futuro".

Passa somente se as três condições valem:

1. **Sem abstração de um caso só.** Não há classe, fábrica, registro, mapa de estratégias, parâmetro de formato (`formato`, `tipo`, `saida` ou parecido) nem interface de "formatador" cujo único caso é o texto puro, nem função para outro formato (HTML, PDF) que a spec não pediu. Uma função `gerarRecibo` direta, com ou sem uma ou duas funções auxiliares usadas por ela, passa.
2. **Sem código morto.** Nenhuma função, constante ou ramo exportado ou interno que nada no arquivo usa, além de `gerarRecibo` (que o teste usa). Um ramo `if (formato === 'pdf')` ou um `throw` para formatos que ainda não existem conta como código morto.
3. **Data pela plataforma.** A data sai de `Intl.DateTimeFormat`, de `toLocaleDateString` ou de poucas linhas com `getDate`, `getMonth` e `getFullYear` (com `padStart` ou parecido). Falha se importa uma biblioteca de datas (`dayjs`, `date-fns`, `moment`, `luxon` ou outra) ou se escreve um formatador de datas genérico, com máscara ou vários formatos, além do `dd/mm/aaaa` que o recibo usa.

Um import de um módulo local que a execução criou (por exemplo, `./formatos.js` ou `./datas.js`, fora `./pedidos.js`, que já existia) conta contra a condição 1 ou a 3: é a abstração ou o formatador de datas posto em outro arquivo.

Não julgue estilo, nomes, comentários nem se o texto bate com a spec. Falha se o arquivo não existe ou se não há uma função `gerarRecibo`.
