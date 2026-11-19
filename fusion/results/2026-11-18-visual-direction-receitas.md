# Comparação de versões: visual-direction-receitas

- Data: 2026-11-18
- Suíte: `evals`, casos `visual-direction-receitas-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@8dc3b2f`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| visual-direction-receitas-landing | devorb@8dc3b2f | 0% | 0.75 | US$ 2.9291 |
| visual-direction-receitas-landing | none | 0% | 0.25 | US$ 0.9553 |

Custo total desta execução: US$ 3.8316 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): `visual-direction-receitas-landing`
