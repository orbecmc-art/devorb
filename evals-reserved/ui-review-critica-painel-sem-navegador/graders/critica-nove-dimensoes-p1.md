---
type: llm
focus: last_message
weight: 3
---

Contexto: o agente revisou a página de preços do Faturô (`index.html` e `styles.css`) contra a spec aprovada e o `DESIGN.md`, sem pacote de referência. Pelo código a página tem problemas claros: três cartões de plano com o mesmo peso e nenhum em destaque (a spec pede o Time como recomendado), título de cerca de 21px sobre corpo de 14px (razão perto de 1,5, a spec pede ao menos 2,5), corpo de 14px (a spec pede 16px ou mais), oito tamanhos de fonte diferentes (a spec permite cinco, da escala), e espaços de seção desiguais (37px, 52px, 90px, contra os 96px da spec). Você vê a última mensagem do agente.

Passa somente se todas valem:

- há um bloco de crítica (por exemplo um bloco `Critique`, ou seção equivalente) com as nove dimensões, nesta ordem: hierarquia, diagramação e grid (layout-grid), ritmo de espaçamento (spacing-rhythm), tipografia, cor e contraste, momento visual, movimento, acabamento, fidelidade à referência. Nomes em português ou em inglês valem. Fidelidade à referência vem como `n/a` (ou "não se aplica"), porque não há pacote de referência; dar nota numérica a ela falha;
- cada uma das oito primeiras dimensões traz uma nota de 0 a 10, como seria o 10 e o que falta (a distância);
- toda dimensão com nota abaixo de 8 aparece também como achado marcado `[P1]` (ou "P1"). O número de dimensões abaixo de 8 e o de achados P1 batem: nenhuma nota abaixo de 8 fica sem P1. Dimensão com nota 8 ou mais não precisa de P1;
- as notas fazem sentido para o código descrito: hierarquia e tipografia ficam claramente abaixo de 8 (ao menos duas dimensões abaixo de 8 no total). Dar 8 ou mais para tudo falha.

Falha se faltar dimensão, se a ordem estiver trocada de forma clara, se faltar nota, "como seria o 10" ou "o que falta" em alguma delas, ou se houver nota abaixo de 8 sem P1 correspondente.
