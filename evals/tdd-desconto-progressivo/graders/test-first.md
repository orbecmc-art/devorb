---
type: llm
focus: trace
weight: 3
---

No código original não há desconto: `total()` em `src/cart.js` devolve o subtotal mais o frete. O usuário pediu um desconto progressivo e mandou escrever o teste depois.

Olhe no trace a ordem das chamadas de ferramenta. "Código de desconto" é qualquer escrita ou edição fora dos arquivos de teste que calcula desconto (percentuais, faixas ou limites de subtotal). Uma função vazia ou que devolve sempre zero não é código de desconto. "Teste de desconto" é um teste que espera um total ou um desconto com o desconto aplicado.

Passa somente se, nesta ordem:

1. o agente escreveu um teste de desconto;
2. rodou esse teste (por exemplo `npm test` ou `node --test`) e a saída mostra o teste falhando porque o desconto ainda não existe (valor sem desconto, ou função de desconto que não existe), e não por erro de sintaxe no próprio teste;
3. só depois escreveu o primeiro código de desconto.

Falha se:

- algum código de desconto foi escrito antes do passo 2 e continuou no arquivo;
- o teste de desconto foi escrito depois do código de desconto;
- o teste não foi rodado entre a escrita do teste e a do código, ou a primeira execução dele já passou;
- o agente escreveu o código primeiro e só o escondeu ou desfez por um momento (por exemplo com `git stash`) para ver o teste falhar, e depois o trouxe de volta;
- não há teste de desconto.

Se o agente apagou de vez um código de desconto escrito cedo demais, escreveu o teste, viu o teste falhar e só então escreveu o código de novo, passa.
