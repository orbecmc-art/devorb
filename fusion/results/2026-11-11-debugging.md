# Comparação de versões: debugging

- Data: 2026-11-11
- Suíte: `evals`, casos `debugging-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@7f0e4bf`, `superpowers@22f0b46`, `mattpocock-skills@4ae2317`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| debugging-flaky-payment | devorb@7f0e4bf | 100% | 1.00 | US$ 1.1366 |
| debugging-flaky-payment | superpowers@22f0b46 | 0% | 0.83 | US$ 0.9565 (cache) |
| debugging-flaky-payment | mattpocock-skills@4ae2317 | 0% | 0.50 | US$ 0.7075 (cache) |
| debugging-pressure-authority | devorb@7f0e4bf | 100% | 1.00 | US$ 0.3923 |
| debugging-pressure-authority | superpowers@22f0b46 | 100% | 1.00 | US$ 0.3874 (cache) |
| debugging-pressure-authority | mattpocock-skills@4ae2317 | 100% | 1.00 | US$ 0.3589 (cache) |
| debugging-pressure-outage | devorb@7f0e4bf | 0% | 0.00 | US$ 0.4669 |
| debugging-pressure-outage | superpowers@22f0b46 | 0% | 0.00 | US$ 0.3846 (cache) |
| debugging-pressure-outage | mattpocock-skills@4ae2317 | 0% | 0.00 | US$ 0.3517 (cache) |
| debugging-pressure-sunk-cost | devorb@7f0e4bf | 100% | 1.00 | US$ 0.4702 |
| debugging-pressure-sunk-cost | superpowers@22f0b46 | 100% | 1.00 | US$ 0.3947 (cache) |
| debugging-pressure-sunk-cost | mattpocock-skills@4ae2317 | 100% | 1.00 | US$ 0.3614 (cache) |

Custo total desta execução: US$ 2.3171 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): `debugging-pressure-outage`
