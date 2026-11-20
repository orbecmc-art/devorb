# Tabela densa em tela de operação

Data: 2026-11-20. Branch `claude/operate`, em cima do item 1 (`c23967e`). Frente C, item 2, do brief `docs/briefs/2026-11-20-evolucao-devorb.md`. Desenho aprovado pelo dono na conversa em 2026-11-20. O merge é do dono.

## Intenção

Painel, CRM e sistema interno são a maior parte do que a Orbe entrega, e o `operate.md` é curto. O caso que motivou o brief: um sistema entregue com uma tabela de 20 mil linhas e 85 colunas. Hoje a `visual-direction` diz "tabela antes de card", põe filtro e paginação na URL e descreve os estados em geral. Não diz como se decide o que uma tabela densa mostra, nem como o usuário trabalha nela.

## Objetivos

1. `skills/visual-direction/references/operate.md` ganha uma seção de tabela densa: colunas padrão escolhidas pelo trabalho do usuário e lugar para os outros campos (detalhe da linha, seletor de colunas, visões salvas), volume (páginas ou lista virtualizada), busca e filtros, estados da tabela (carregando com esqueleto, os dois vazios, erro), edição na linha com atualização otimista e teclado.
2. Nenhuma tela mostra todos os campos de uma vez.
3. Caso novo `visual-direction-tabela-operacao`, o primeiro da `visual-direction` em tela de operação, aprovado em 2/3 ou mais com `accepted: true`.

## Fora

- Itens 3 e 4 da frente C (ciclo visual no `implementing`, o reservado `visual-direction-guia-restaurante`): o saldo do teto não paga.
- Receitas de consulta, índice e virtualização: são da frente A (`devorb:performance`, branch `claude/performance`, ainda fora da `main`). O `operate.md` decide o que o usuário vê; o como fica com ela. O ponteiro para `devorb:performance` entra depois do merge da frente A: hoje o `npm test` reprova uma skill não registrada.
- Biblioteca de tabela: a lista do dono (`ui-sources.json`) não tem especialista para isso, e a regra não nomeia nenhuma.
- Rodada `--reserved` e os outros casos da `visual-direction`: não cabem no saldo. Dito no relatório como não conferido.
- Mudar `SKILL.md`, `contract.md` ou qualquer outra skill.

## Anti-objetivo

Texto que ninguém pediu por uma falha: cada tópico da seção nova entra só se o RED mostrar o agente errando nele.

## Testes

- **RED antes do texto.** Caso `evals/visual-direction-tabela-operacao`: projeto Next com shadcn/ui, spec aprovada da tela de pedidos da Central Aurora (20.134 pedidos, 85 campos listados), sem direção visual. O prompt pede só a direção, escrita na spec, sem construir. Seis graders `llm` leem a spec depois do trabalho e julgam só a direção que o agente acrescentou: (1) colunas padrão pelo nome, no máximo 15, e lugar para o resto; (2) como os 20 mil chegam à tela; (3) os estados carregando, vazio de busca e erro, cada um com saída; (4) busca por campos nomeados; (5) teclado com tecla concreta; (6) mudança de status nos dois desfechos. Os três primeiros são os do brief; os outros três são meus, para dar uma falha gravada aos outros tópicos que o brief lista. Uma rodada só passa com os seis.
- RED: `node tools/compare.mjs --skill visual-direction-tabela --arms devorb,none --runs 2`. Pelo menos um braço falha.
- GREEN: a mesma linha com `--runs 3`. Passa com `devorb` em 2/3 ou mais e `accepted: true`.
- `npm test` verde.

## Orçamento

Teto da frente: US$ 50. Gasto no item 1: US$ 37,67. Saldo: US$ 12,33. Estimativa do item 2: RED de US$ 3 a 5, GREEN de US$ 4 a 6. Rodadas em `--concurrency 1`. Não sobra para segunda tentativa de GREEN: se falhar, paro e relato. Custo real informado depois de cada rodada.

## Hipóteses (decididas por mim, corrigíveis)

- "No máximo 15 colunas padrão" é o corte do grader, não uma regra da skill: a skill diz que a lista é curta e sai do trabalho do usuário.
- Se o RED passar inteiro, endureço o caso uma vez. Se ainda passar, relato e não escrevo regra.
- O modelo dos evals fica o `claude-opus-5-5` do `fusion/eval-config.json`.
