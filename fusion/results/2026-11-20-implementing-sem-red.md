# Comparação de versões: implementing-sem

- Data: 2026-11-20
- Suíte: `evals`, casos `implementing-sem-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@71404d4`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| implementing-sem-print | devorb@71404d4 | 0% | 0.67 | US$ 7.2261 |
| implementing-sem-print | none | 0% | 0.67 | US$ 0.5865 |

Custo total desta execução: US$ 7.7988 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): `implementing-sem-print`
