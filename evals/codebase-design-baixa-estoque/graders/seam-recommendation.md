---
type: llm
focus: last_message
weight: 2
---

Contexto: numa loja virtual, `src/estoque.js` expõe cinco funções pequenas (`carregarEstoque`, `temSaldo`, `baixar`, `registrarMovimento`, `salvarEstoque`), com os caminhos de `data/estoque.json` e `data/movimentos.json` fixos no código. Cada chamador precisa chamá-las na ordem certa: carregar, conferir todos os itens, só então baixar e registrar cada um, e salvar no fim. `src/checkout.js` segue essa ordem; `src/troca.js` repete os passos do jeito dele e não registra movimento. `src/arquivo.js` só repassa para `readFileSync`/`writeFileSync` com `JSON.parse`/`JSON.stringify`. Só `temSaldo` e `baixar` têm teste, porque os fluxos gravam em `data/` de verdade. O usuário vai criar um job que importa pedidos do marketplace e dá baixa no estoque, e quer testar o caso em que um item de um pedido com vários itens está sem saldo e nada pode ser baixado. Um colega sugeriu uma interface `EstoqueProvider` com um adaptador para a API de um ERP que talvez seja adotado no ano que vem. O usuário pediu só a recomendação, sem código.

Julgue só a resposta final do agente.

Passa somente se as quatro condições valem:

1. **Módulo mais fundo.** Recomenda trocar as cinco funções expostas por uma interface menor, em geral uma operação só (por exemplo `baixarEstoque(itens, motivo)`, `reservar(pedido)` ou um objeto com um ou dois métodos assim), que esconde dentro do módulo de estoque a ordem carregar, conferir tudo, baixar, registrar e salvar. Checkout, troca e o job do marketplace passam a chamar essa operação em vez de repetir os passos. Não basta dizer "extrair uma função auxiliar" sem dizer que a ordem sai dos chamadores.
2. **Seam onde chamadores e testes precisam.** Diz onde fica o seam e põe esse ponto na fronteira do módulo de estoque: o teste do marketplace chama a mesma operação que os chamadores usam, e o que se troca no teste é o armazenamento (estado em memória, diretório temporário ou funções de ler e gravar passadas ao criar o módulo). Falha se a recomendação para o teste é mockar `fs`, mockar cada uma das cinco funções ou testar só `temSaldo` e `baixar` de novo.
3. **Justificativa por profundidade ou pelo teste de exclusão.** Explica por que o módulo atual é raso com uma destas ideias, citando algo concreto deste código: a interface é quase do tamanho da implementação, ou seja, pouco comportamento por trás de muita superfície; ou o teste de exclusão, isto é, se `src/estoque.js` ou `src/arquivo.js` fossem apagados, quase nada de complexidade reapareceria, porque a ordem já vive nos chamadores e o wrapper só repassa ao `fs`. Basta uma das duas ideias, com outras palavras se o sentido for o mesmo.
4. **Sem adaptador especulativo.** Não recomenda criar agora o `EstoqueProvider` com adaptador de ERP nem outra abstração que teria um único adaptador hipotético (outro banco, outra API, "para o futuro"). Passa se recusa ou adia essa ideia, por exemplo dizendo que um adaptador só é hipótese e que a interface surge quando houver dois usos reais. Um seam de armazenamento com duas implementações usadas de fato, a de arquivo em produção e a de memória no teste, é aceitável e não conta como especulativo.

Falha se a resposta não diz onde fica o seam, se mantém as cinco funções expostas e só pede mais disciplina dos chamadores, se recomenda o adaptador de ERP agora, ou se fica em conselhos genéricos sem apontar `src/estoque.js` e os chamadores deste projeto.
