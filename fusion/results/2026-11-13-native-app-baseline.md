# Comparação de versões: native-app

- Data: 2026-11-13
- Suíte: `evals`, casos `native-app-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| native-app-emporio-pedidos | none | 33% | 0.90 | US$ 1.3141 |
| native-app-orcamento-compose | none | 100% | 1.00 | US$ 0.6508 |

Custo total desta execução: US$ 1.9522 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não se aplica (só linhas de base)
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
