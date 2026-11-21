# Comparação de versões: implementing-sem

- Data: 2026-11-20
- Suíte: `evals`, casos `implementing-sem-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@6351aee`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| implementing-sem-print | devorb@6351aee | 33% | 0.82 | US$ 9.0921 |
| implementing-sem-print | none | 0% | 0.55 | US$ 0.8683 |

Custo total desta execução: US$ 9.9403 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `implementing-sem-print`
- Lacunas (nenhum braço passa): nenhuma
