# Comparação de versões: evolving

- Data: 2026-11-12
- Suíte: `evals`, casos `evolving-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `with-without`
- Ponytail: não
- Braços: `devorb@16bd400`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| evolving-no-change | devorb@16bd400 | 100% | 1.00 | US$ 1.4793 |
| evolving-planned-only | devorb@16bd400 | 33% | 0.67 | US$ 1.8671 |
| evolving-rehearsal | devorb@16bd400 | 0% | 0.94 | US$ 3.8942 |
| evolving-rewritten | devorb@16bd400 | 100% | 1.00 | US$ 1.9363 |
| evolving-source-failed | devorb@16bd400 | 67% | 0.89 | US$ 2.4334 |

Custo total desta execução: US$ 10.9461 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `evolving-planned-only`, `evolving-rehearsal`
- Lacunas (nenhum braço passa): nenhuma
