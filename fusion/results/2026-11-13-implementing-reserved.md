# Comparação de versões: implementing

- Data: 2026-11-13
- Suíte: `evals-reserved`, casos `implementing-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@20987d7`, `superpowers@22f0b46`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| implementing-cashback | devorb@20987d7 | 100% | 1.00 | US$ 2.7717 |
| implementing-cashback | superpowers@22f0b46 | 0% | 0.25 | US$ 5.3335 (cache) |

Custo total desta execução: US$ 2.7673 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
