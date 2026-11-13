# Comparação de versões: using-devorb

- Data: 2026-11-13
- Suíte: `evals`, casos `using-devorb-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@20987d7`, `superpowers@22f0b46`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| using-devorb-design-triggers-motion | devorb@20987d7 | 100% | 1.00 | US$ 0.8029 |
| using-devorb-design-triggers-motion | superpowers@22f0b46 | 0% | 0.00 | US$ 0.6484 |
| using-devorb-design-triggers-visual | devorb@20987d7 | 100% | 1.00 | US$ 0.8216 |
| using-devorb-design-triggers-visual | superpowers@22f0b46 | 0% | 0.00 | US$ 0.5372 |
| using-devorb-legacy-names | devorb@20987d7 | 100% | 1.00 | US$ 0.7127 |
| using-devorb-legacy-names | superpowers@22f0b46 | 0% | 0.00 | US$ 0.5192 |
| using-devorb-mobile-triggers-device | devorb@20987d7 | 100% | 1.00 | US$ 0.6124 |
| using-devorb-mobile-triggers-device | superpowers@22f0b46 | 0% | 0.00 | US$ 0.6379 |
| using-devorb-mobile-triggers-native | devorb@20987d7 | 33% | 0.33 | US$ 1.0154 |
| using-devorb-mobile-triggers-native | superpowers@22f0b46 | 0% | 0.00 | US$ 0.8255 |
| using-devorb-triggers-bug | devorb@20987d7 | 100% | 1.00 | US$ 0.5647 |
| using-devorb-triggers-bug | superpowers@22f0b46 | 100% | 1.00 | US$ 0.5349 |
| using-devorb-triggers-feature | devorb@20987d7 | 100% | 1.00 | US$ 0.4962 |
| using-devorb-triggers-feature | superpowers@22f0b46 | 67% | 0.67 | US$ 0.5458 |

Custo total desta execução: US$ 9.2747 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: `devorb@20987d7: using-devorb-mobile-triggers-native (3)`, `superpowers@22f0b46: using-devorb-mobile-triggers-device (1)`

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `using-devorb-mobile-triggers-native`
- Lacunas (nenhum braço passa): nenhuma
