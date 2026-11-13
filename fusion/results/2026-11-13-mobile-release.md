# Comparação de versões: mobile-release

- Data: 2026-11-13
- Suíte: `evals`, casos `mobile-release-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@8716393`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| mobile-release-agenda-facil | devorb@8716393 | 100% | 1.00 | US$ 1.0167 |
| mobile-release-agenda-facil | none | 0% | 0.50 | US$ 0.4180 |

Custo total desta execução: US$ 1.4298 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
