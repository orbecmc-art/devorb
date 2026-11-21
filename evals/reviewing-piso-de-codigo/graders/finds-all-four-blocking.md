---
type: llm
focus: last_message
weight: 3
---

Contexto: o projeto é uma loja em Node. A branch `feature/recibo-pedido` implementa a spec aprovada `docs/devorb/specs/2026-11-12-recibo-pedido-design.md` (`gerarRecibo(pedido)` devolve o texto do recibo; `salvarRecibo(pedido, pasta)` grava `<pasta>/<id>.txt` e devolve o caminho). A funcionalidade está certa e `npm test` passa. A spec não fala de nenhum dos pontos abaixo. A branch planta quatro sinais de código júnior, nenhum deles um bug de regra de negócio:

- **(a) Erro engolido.** Em `src/recibo.js`, `salvarRecibo` põe o `mkdirSync` e o `writeFileSync` dentro de um `try` com `catch {}` vazio e devolve o caminho mesmo assim: se a gravação falha, quem chama recebe o caminho de um arquivo que não existe, como se tivesse dado certo.
- **(b) Abstração de uso único.** Em `src/recibo.js`, um mapa `formatadores` com uma entrada só (`texto`) e uma fábrica `criarFormatador(formato)` com um único chamador (`gerarRecibo`, que sempre passa `'texto'`): indireção sem segundo caso.
- **(c) Dependência para uma linha.** O `package.json` ganha a dependência `dayjs`, usada uma vez só, para formatar a data como dd/mm/aaaa, coisa que a plataforma faz em uma linha (`Intl.DateTimeFormat('pt-BR')`, `toLocaleDateString`, ou fatiar a string ISO).
- **(d) Código morto.** `src/recibo.js` exporta `reciboResumido`, que nada no projeto chama nem testa.

Julgue só esta última mensagem do agente. Passa somente se a revisão aponta os quatro, com as próprias palavras, como problema (não só como pergunta), e dá a cada um uma severidade explícita que bloqueia o merge: Critical ou Important, ou um equivalente como crítica, alta, bloqueante ou "precisa corrigir antes do merge". Vale apontar dois deles num mesmo item, desde que os dois fiquem identificáveis e com severidade que bloqueia; vale a severidade dada pelo título da seção onde o achado está.

Falha se qualquer um dos quatro falta, se aparece só como pergunta, sem severidade, ou com severidade Minor, baixa, nit, sugestão, opcional, "pode ficar para depois" ou só em "Needs checking"/"A verificar". Não julgue formato, idioma, tamanho, o veredito final nem achados extras. Não exija que o agente tenha corrigido o código. Falha também se a mensagem só diz que a revisão está num arquivo, sem trazer os achados.
