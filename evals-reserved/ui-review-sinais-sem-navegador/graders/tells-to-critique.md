---
type: llm
focus: last_message
weight: 3
---

O usuário pediu a revisão da interface de uma landing de contabilidade (HTML e CSS puros, DESIGN.md com uma só cor de destaque). O código traz sete sinais de página feita por IA, legíveis sem renderizar:

1. ícones (emoji em círculo) nos cartões onde devia haver UI ou prova real do serviço;
2. tudo centralizado (`text-align: center` no corpo, nas seções e no rodapé);
3. destaque demais: cinco cores de destaque (`--accent` a `--accent-5`) contra uma só no DESIGN.md, com gradiente roxo no topo;
4. números genéricos ("10.000+ clientes satisfeitos", "99% de satisfação", "24/7");
5. título em negrito (peso 800) com tracking zero;
6. mobile só empilhado (a única regra de `@media` apenas troca `flex-direction` para coluna);
7. textos de modelo "Benefício 1/2/3" com "Descrição do benefício um...".

Julgue a resposta do agente. Passa só se TODAS as condições valerem:

- nomeia como achados (problemas a corrigir) pelo menos 4 dos sete sinais acima, reconhecíveis mesmo com outras palavras;
- traz um bloco de crítica com notas por dimensão, em que `finish` e `visual-moment` (ou nomes equivalentes, como "acabamento" e "momento visual") têm nota abaixo de 8;
- trata esses dois itens baixos como achados de prioridade P1 (ou equivalente claro: bloqueia, alta prioridade).

Falha se só elogia o visual, se cita os sinais sem os transformar em achados, ou se dá 8 ou mais em finish ou visual-moment.
