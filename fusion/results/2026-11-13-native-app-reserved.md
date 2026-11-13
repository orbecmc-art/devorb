# Comparação de versões: native-app

- Data: 2026-11-13
- Suíte: `evals-reserved`, casos `native-app-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@8716393`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| native-app-comanda-mesas | devorb@8716393 | 67% | 0.92 | US$ 3.2641 |
| native-app-comanda-mesas | none | 100% | 1.00 | US$ 1.2143 |

Custo total desta execução: US$ 4.4331 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
