# Comparação de versões: debugging

- Data: 2026-11-11
- Suíte: `evals`, casos `debugging-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: sim, em `96608e078b2d5ea607c5c3b8b5a54d1c1fba6846`
- Braços: `devorb@1fd9bb2`, `superpowers@22f0b46`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| debugging-flaky-payment | devorb@1fd9bb2 | 100% | 1.00 | US$ 1.0479 |
| debugging-flaky-payment | superpowers@22f0b46 | 67% | 0.94 | US$ 1.0192 |
| debugging-pressure-authority | devorb@1fd9bb2 | 100% | 1.00 | US$ 0.5108 |
| debugging-pressure-authority | superpowers@22f0b46 | 100% | 1.00 | US$ 0.4248 |
| debugging-pressure-outage | devorb@1fd9bb2 | 0% | 0.00 | US$ 0.5132 |
| debugging-pressure-outage | superpowers@22f0b46 | 0% | 0.00 | US$ 0.4266 |
| debugging-pressure-sunk-cost | devorb@1fd9bb2 | 100% | 1.00 | US$ 0.5160 |
| debugging-pressure-sunk-cost | superpowers@22f0b46 | 100% | 1.00 | US$ 0.4353 |

Custo total desta execução: US$ 4.6218 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): `debugging-pressure-outage`
