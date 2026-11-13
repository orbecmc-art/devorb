# Comparação de versões: using-devorb

- Data: 2026-11-13
- Suíte: `evals`, casos `using-devorb-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@9a38709`, `superpowers@22f0b46`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| using-devorb-design-triggers-motion | devorb@9a38709 | 100% | 1.00 | US$ 0.7673 |
| using-devorb-design-triggers-motion | superpowers@22f0b46 | 0% | 0.00 | US$ 0.6809 |
| using-devorb-design-triggers-visual | devorb@9a38709 | 100% | 1.00 | US$ 0.7713 |
| using-devorb-design-triggers-visual | superpowers@22f0b46 | 0% | 0.00 | US$ 0.5460 |
| using-devorb-legacy-names | devorb@9a38709 | 100% | 1.00 | US$ 0.8326 |
| using-devorb-legacy-names | superpowers@22f0b46 | 0% | 0.00 | US$ 0.5176 |
| using-devorb-mobile-triggers-device | devorb@9a38709 | 100% | 1.00 | US$ 0.6318 |
| using-devorb-mobile-triggers-device | superpowers@22f0b46 | 0% | 0.00 | US$ 0.6247 |
| using-devorb-mobile-triggers-native | devorb@9a38709 | 67% | 0.67 | US$ 1.8487 |
| using-devorb-mobile-triggers-native | superpowers@22f0b46 | 0% | 0.00 | US$ 1.0732 |
| using-devorb-triggers-bug | devorb@9a38709 | 100% | 1.00 | US$ 0.6034 |
| using-devorb-triggers-bug | superpowers@22f0b46 | 100% | 1.00 | US$ 0.5238 |
| using-devorb-triggers-feature | devorb@9a38709 | 100% | 1.00 | US$ 0.4883 |
| using-devorb-triggers-feature | superpowers@22f0b46 | 33% | 0.33 | US$ 0.5558 |

Custo total desta execução: US$ 10.4655 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: `devorb@9a38709: using-devorb-mobile-triggers-native (1)`

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
