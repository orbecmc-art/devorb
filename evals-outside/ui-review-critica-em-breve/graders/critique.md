---
type: llm
focus: last_message
weight: 3
---

Contexto: o usuário pediu a revisão da página "Em breve" da Agenda do Prumo contra um pacote de referência e o `DESIGN.md`. A spec aprovada pede uma réplica da referência: mesma estrutura, mesma ordem de seis seções, título principal com mais de 3 vezes o corpo e o hero com um mockup do produto. A referência tem título de 56px sobre corpo de 17px, um mockup flutuante, uma faixa escura com um número grande e seis seções. A página feita usa só tokens do `DESIGN.md`, mas é fraca: faixa chapada com título de 26px, corpo de 13px, uma seção de duas colunas com três linhas curtas e um vazio à esquerda, nenhum momento visual, todas as seções no mesmo ritmo, quatro seções em vez de seis e nenhum mockup.

Julgue só a resposta final do agente. Passa somente se as quatro condições valem:

1. **Bloco Critique.** A resposta tem um bloco identificado como `Critique` (o rótulo pode vir com complemento, como "Critique (fresh reviewer)") com uma linha por dimensão, e cada linha traz uma nota de 0 a 10.
2. **As nove dimensões, nesta ordem:** `hierarchy`, `layout-grid`, `spacing-rhythm`, `typography`, `color-contrast`, `visual-moment`, `motion`, `finish`, `reference-fidelity`. Os nomes podem vir traduzidos ou com outra grafia (por exemplo "hierarquia", "layout/grid", "ritmo de espaçamento", "fidelidade à referência"), desde que cada dimensão seja reconhecível e a ordem seja essa. Uma dimensão pode ter `n/a` só se a resposta disser por quê; `reference-fidelity` com `n/a` falha, porque há pacote de referência.
3. **Notas baixas onde a página é fraca.** A nota de `hierarchy` é menor que 8 e a nota de `reference-fidelity` é menor que 8.
4. **Viram achados.** A resposta lista, entre os achados com severidade, uma linha `[P1]` (ou `P1`) sobre a hierarquia (título pequeno demais para o corpo, nada que lidere a página, ou equivalente) e uma linha `[P1]` (ou `P1`) sobre a distância da referência (seções faltando, sem mockup, ordem ou composição diferente da referência, ou equivalente).

Não julgue as notas das outras dimensões, os outros achados, a qualidade da escrita nem a correção proposta. Falha se não há bloco Critique com notas, se faltam dimensões ou a ordem é outra, se `hierarchy` ou `reference-fidelity` tem 8 ou mais, ou se uma das duas não aparece como P1.
