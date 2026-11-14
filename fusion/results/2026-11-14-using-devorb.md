# Comparação de versões: using-devorb

- Data: 2026-11-14
- Suíte: `evals`, casos `using-devorb-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@d15aa2b`, `superpowers@22f0b46`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| using-devorb-auto-diagram | devorb@d15aa2b | 100% | 1.00 | US$ 0.6193 |
| using-devorb-auto-diagram | superpowers@22f0b46 | 0% | 0.00 | US$ 0.3740 |
| using-devorb-auto-evolving | devorb@d15aa2b | 100% | 1.00 | US$ 0.5201 |
| using-devorb-auto-evolving | superpowers@22f0b46 | 0% | 0.00 | US$ 0.4385 |
| using-devorb-auto-handoff | devorb@d15aa2b | 100% | 1.00 | US$ 0.5461 |
| using-devorb-auto-handoff | superpowers@22f0b46 | 0% | 0.00 | US$ 0.5237 |
| using-devorb-auto-improve-architecture | devorb@d15aa2b | 100% | 1.00 | US$ 1.1273 |
| using-devorb-auto-improve-architecture | superpowers@22f0b46 | 0% | 0.00 | US$ 0.5352 |
| using-devorb-auto-mobile-release | devorb@d15aa2b | 100% | 1.00 | US$ 0.7868 |
| using-devorb-auto-mobile-release | superpowers@22f0b46 | 0% | 0.00 | US$ 0.4930 |
| using-devorb-auto-prototype | devorb@d15aa2b | 100% | 1.00 | US$ 1.3056 |
| using-devorb-auto-prototype | superpowers@22f0b46 | 0% | 0.00 | US$ 0.6441 |
| using-devorb-auto-retro | devorb@d15aa2b | 100% | 1.00 | US$ 0.5013 |
| using-devorb-auto-retro | superpowers@22f0b46 | 0% | 0.00 | US$ 0.5416 |
| using-devorb-auto-security-audit | devorb@d15aa2b | 100% | 1.00 | US$ 1.7042 |
| using-devorb-auto-security-audit | superpowers@22f0b46 | 0% | 0.00 | US$ 0.4457 |
| using-devorb-design-triggers-motion | devorb@d15aa2b | 100% | 1.00 | US$ 0.8039 |
| using-devorb-design-triggers-motion | superpowers@22f0b46 | 0% | 0.00 | US$ 0.6810 |
| using-devorb-design-triggers-visual | devorb@d15aa2b | 100% | 1.00 | US$ 0.7761 |
| using-devorb-design-triggers-visual | superpowers@22f0b46 | 0% | 0.00 | US$ 0.7416 |
| using-devorb-legacy-names | devorb@d15aa2b | 100% | 1.00 | US$ 0.8165 |
| using-devorb-legacy-names | superpowers@22f0b46 | 0% | 0.00 | US$ 0.5078 |
| using-devorb-mobile-triggers-device | devorb@d15aa2b | 100% | 1.00 | US$ 0.7120 |
| using-devorb-mobile-triggers-device | superpowers@22f0b46 | 0% | 0.00 | US$ 0.6111 |
| using-devorb-mobile-triggers-native | devorb@d15aa2b | 67% | 0.67 | US$ 1.5382 |
| using-devorb-mobile-triggers-native | superpowers@22f0b46 | 0% | 0.00 | US$ 1.1035 |
| using-devorb-style-first-bug | devorb@d15aa2b | 100% | 1.00 | US$ 0.6237 |
| using-devorb-style-first-bug | superpowers@22f0b46 | 100% | 1.00 | US$ 0.5633 |
| using-devorb-style-first-feature | devorb@d15aa2b | 100% | 1.00 | US$ 0.6227 |
| using-devorb-style-first-feature | superpowers@22f0b46 | 67% | 0.67 | US$ 0.5455 |
| using-devorb-triggers-bug | devorb@d15aa2b | 100% | 1.00 | US$ 0.6045 |
| using-devorb-triggers-bug | superpowers@22f0b46 | 100% | 1.00 | US$ 0.5329 |
| using-devorb-triggers-feature | devorb@d15aa2b | 100% | 1.00 | US$ 0.5072 |
| using-devorb-triggers-feature | superpowers@22f0b46 | 100% | 1.00 | US$ 0.5256 |

Custo total desta execução: US$ 23.9237 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: `devorb@d15aa2b: using-devorb-auto-improve-architecture (1)`

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
