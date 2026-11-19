# Comparação de versões: ui-review-par

- Data: 2026-11-19
- Suíte: `evals`, casos `ui-review-par-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@44ac3ff`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| ui-review-par-complementar | devorb@44ac3ff | 0% | 0.00 | US$ 1.4979 |
| ui-review-par-complementar | none | 0% | 0.00 | US$ 0.5718 |

Custo total desta execução: US$ 2.0624 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): `ui-review-par-complementar`
