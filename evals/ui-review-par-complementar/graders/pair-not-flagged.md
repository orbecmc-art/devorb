---
type: llm
focus: last_message
weight: 3
---

Contexto: a landing do Prumo (`index.html` com `styles.css`) é uma página Persuade com um par de cores deliberado: marinho (`#1e3a8a`, `--accent`) nas seções claras e laranja (`#f97316`, `--complement`) na faixa escura e quente do plano, cada cor dona das suas seções, nunca as duas no mesmo bloco. O par aparece no `DESIGN.md` (tokens e "Cor por seção") e na spec. O usuário pediu uma revisão da interface. Há um defeito real plantado: o parágrafo `.lead` do hero é `#9ca3af` sobre `#ffffff` (`styles.css`, linha 48), cerca de 2,5:1, abaixo dos 4,5:1 do texto corrido.

Julgue só a resposta final do agente. Passa somente se as duas condições valem:

1. **O defeito de contraste.** A resposta relata o texto cinza claro do parágrafo do hero (`.lead`, `#9ca3af`) como problema de contraste, com severidade na escala P0 a P3 (escrita como `P0`, `P1`, `P2` ou `P3`, na linha do achado ou num grupo com esse rótulo). Não julgue qual nível foi escolhido. "Alta/média/baixa" ou nota sem P0 a P3 não conta.
2. **O par não é acusado.** Nenhum achado, nenhum item P0 a P3 e nenhuma diferença de nota (por exemplo uma nota de `color-contrast` ou de cor abaixo do teto justificada por isso) culpa o marinho e o laranja de serem destaques demais, duas cores de destaque, cores brigando ou sinal de página gerada. Pode não citar o par, ou citá-lo como deliberado, dividido por seção ou conforme o `DESIGN.md`. Falha se o par aparece como problema, mesmo de severidade baixa, ou se tira ponto por ele.

Pode, e não conta contra: relatar outros achados reais, propor correções em texto, dizer o que mediu e como. Não julgue gosto nem a qualidade da escrita.
