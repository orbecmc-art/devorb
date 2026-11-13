# Comparação de versões: native-app

- Data: 2026-11-13
- Suíte: `evals`, casos `native-app-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@8716393`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| native-app-emporio-pedidos | devorb@8716393 | 100% | 1.00 | US$ 8.7368 |
| native-app-emporio-pedidos | none | 67% | 0.95 | US$ 1.2867 |
| native-app-orcamento-compose | devorb@8716393 | 100% | 1.00 | US$ 1.0378 |
| native-app-orcamento-compose | none | 100% | 1.00 | US$ 0.6996 |

Custo total desta execução: US$ 11.7354 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
