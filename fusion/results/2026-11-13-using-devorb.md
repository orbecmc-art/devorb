# Comparação de versões: using-devorb

- Data: 2026-11-13
- Suíte: `evals`, casos `using-devorb-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@da1b97e`, `superpowers@22f0b46`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| using-devorb-auto-diagram | devorb@da1b97e | 100% | 1.00 | US$ 0.6019 |
| using-devorb-auto-diagram | superpowers@22f0b46 | 0% | 0.00 | US$ 0.3766 |
| using-devorb-auto-evolving | devorb@da1b97e | 100% | 1.00 | US$ 0.5203 |
| using-devorb-auto-evolving | superpowers@22f0b46 | 0% | 0.00 | US$ 0.4284 |
| using-devorb-auto-handoff | devorb@da1b97e | 100% | 1.00 | US$ 0.5453 |
| using-devorb-auto-handoff | superpowers@22f0b46 | 0% | 0.00 | US$ 0.5510 |
| using-devorb-auto-improve-architecture | devorb@da1b97e | 100% | 1.00 | US$ 1.1255 |
| using-devorb-auto-improve-architecture | superpowers@22f0b46 | 0% | 0.00 | US$ 0.5290 |
| using-devorb-auto-mobile-release | devorb@da1b97e | 100% | 1.00 | US$ 0.8253 |
| using-devorb-auto-mobile-release | superpowers@22f0b46 | 0% | 0.00 | US$ 0.4957 |
| using-devorb-auto-prototype | devorb@da1b97e | 100% | 1.00 | US$ 1.2922 |
| using-devorb-auto-prototype | superpowers@22f0b46 | 0% | 0.00 | US$ 0.5459 |
| using-devorb-auto-retro | devorb@da1b97e | 100% | 1.00 | US$ 0.5101 |
| using-devorb-auto-retro | superpowers@22f0b46 | 0% | 0.00 | US$ 0.6125 |
| using-devorb-auto-security-audit | devorb@da1b97e | 100% | 1.00 | US$ 1.5910 |
| using-devorb-auto-security-audit | superpowers@22f0b46 | 0% | 0.00 | US$ 0.4460 |
| using-devorb-design-triggers-motion | devorb@da1b97e | 100% | 1.00 | US$ 0.7960 |
| using-devorb-design-triggers-motion | superpowers@22f0b46 | 0% | 0.00 | US$ 0.6641 |
| using-devorb-design-triggers-visual | devorb@da1b97e | 100% | 1.00 | US$ 1.0325 |
| using-devorb-design-triggers-visual | superpowers@22f0b46 | 0% | 0.00 | US$ 0.5903 |
| using-devorb-legacy-names | devorb@da1b97e | 100% | 1.00 | US$ 0.7356 |
| using-devorb-legacy-names | superpowers@22f0b46 | 0% | 0.00 | US$ 0.5110 |
| using-devorb-mobile-triggers-device | devorb@da1b97e | 100% | 1.00 | US$ 0.7017 |
| using-devorb-mobile-triggers-device | superpowers@22f0b46 | 0% | 0.00 | US$ 0.6244 |
| using-devorb-mobile-triggers-native | devorb@da1b97e | 100% | 1.00 | US$ 1.3833 |
| using-devorb-mobile-triggers-native | superpowers@22f0b46 | 0% | 0.00 | US$ 1.1016 |
| using-devorb-triggers-bug | devorb@da1b97e | 100% | 1.00 | US$ 0.5877 |
| using-devorb-triggers-bug | superpowers@22f0b46 | 100% | 1.00 | US$ 0.5262 |
| using-devorb-triggers-feature | devorb@da1b97e | 100% | 1.00 | US$ 0.4973 |
| using-devorb-triggers-feature | superpowers@22f0b46 | 100% | 1.00 | US$ 0.5209 |

Custo total desta execução: US$ 21.2691 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: `devorb@da1b97e: using-devorb-design-triggers-visual (1)`, `devorb@da1b97e: using-devorb-mobile-triggers-device (1)`

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
