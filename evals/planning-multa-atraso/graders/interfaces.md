---
type: llm
focus:
  source: file
  path: docs/devorb/plans/2026-11-11-multa-atraso.md
weight: 2
---

Contexto: um projeto Node sem dependências (biblioteca comunitária pela linha de comando) tem os arquivos `src/store.js`, `src/socios.js`, `src/acervo.js`, `src/emprestimos.js`, `src/cli.js`, `bin/biblioteca.js`, `test/emprestimos.test.js` e `test/cli.test.js`, e roda os testes com `npm test` (`node --test`). Hoje `src/emprestimos.js` pega a data de hoje do relógio do sistema (`new Date()`) dentro de `emprestar` e `devolver`. A spec aprovada pede: multa de R$ 1,00 por dia de atraso na devolução, com teto de R$ 20,00 por empréstimo; multa em aberto ligada ao sócio e ao empréstimo; sócio com multa em aberto não pega livro novo; novo comando `pagar-multas <socioId>`; saídas novas em `devolver` e `socio`; o `data/biblioteca.json` antigo, sem multas, continua abrindo.

Julgue só o texto deste plano de implementação. Passa somente se as quatro condições valem:

1. **Interfaces.** Cada task diz o que consome e o que produz: funções, parâmetros e retorno, ou o formato dos dados (por exemplo, onde e com que campos a multa fica guardada). Vale um bloco de interfaces único que cubra todas as tasks, ou uma seção por task. Falha se alguma task só descreve a intenção ("implementar a multa") sem dizer quais funções ou dados cria ou muda.
2. **Caminhos e comandos concretos.** Cada task cita os arquivos que cria ou altera pelo caminho relativo completo (como `src/emprestimos.js` ou `test/multas.test.js`), e o plano traz o comando exato para rodar os testes (`npm test` ou `node --test` com o caminho). Falha se alguma task fala só "no módulo de empréstimos" ou "nos testes" sem caminho, ou se não há comando de teste.
3. **Fatias verticais em ordem linear.** Há pelo menos duas tasks no formato `### Task N:`. Cada task entrega um comportamento da spec que pode ser testado sozinho, com o código e o teste dele na mesma task. Cada task só usa o que tasks anteriores produziram. Falha se os testes ficam numa task separada no fim, se as tasks são camadas ("Task 1: todas as funções", "Task 2: toda a linha de comando", "Task 3: todos os testes"), ou se uma task depende de algo que só uma task posterior cria.
4. **Seams de teste nomeados.** Para cada comportamento, o plano diz por onde o teste entra: a função pública chamada no teste (como `devolver`, `emprestar` ou `executar` de `src/cli.js`) e o arquivo de teste. O plano também diz como o teste controla a data de hoje, já que a multa depende dela: por exemplo, a data passa como parâmetro, ou um relógio é injetado. Falha se o plano não diz como o teste fixa a data, ou se manda testar trocando o relógio global do sistema sem dizer como.

Não julgue estilo, tamanho, idioma, nem se o plano traz código pronto. Não exija nada além destas quatro condições. Falha também se o arquivo está vazio ou não é um plano para esta spec.
