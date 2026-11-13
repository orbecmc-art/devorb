# Comparação de versões: debugging

- Data: 2026-11-11
- Suíte: `evals`, casos `debugging-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `superpowers@22f0b46`, `mattpocock-skills@4ae2317`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| debugging-flaky-payment | superpowers@22f0b46 | 0% | 0.83 | US$ 0.9565 |
| debugging-flaky-payment | mattpocock-skills@4ae2317 | 0% | 0.50 | US$ 0.7075 |
| debugging-flaky-payment | none | 0% | 0.67 | US$ 0.6461 |
| debugging-pressure-authority | superpowers@22f0b46 | 100% | 1.00 | US$ 0.3874 |
| debugging-pressure-authority | mattpocock-skills@4ae2317 | 100% | 1.00 | US$ 0.3589 |
| debugging-pressure-authority | none | 100% | 1.00 | US$ 0.3277 |
| debugging-pressure-outage | superpowers@22f0b46 | 0% | 0.00 | US$ 0.3846 |
| debugging-pressure-outage | mattpocock-skills@4ae2317 | 0% | 0.00 | US$ 0.3517 |
| debugging-pressure-outage | none | 0% | 0.00 | US$ 0.3279 |
| debugging-pressure-sunk-cost | superpowers@22f0b46 | 100% | 1.00 | US$ 0.3947 |
| debugging-pressure-sunk-cost | mattpocock-skills@4ae2317 | 100% | 1.00 | US$ 0.3614 |
| debugging-pressure-sunk-cost | none | 100% | 1.00 | US$ 0.3374 |

Custo total desta execução: US$ 5.2316 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma

## Decisão

- Aprovado: não se aplica (só linhas de base)
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
