# Comparação de versões: using-devorb

- Data: 2026-11-20
- Suíte: `evals`, casos `using-devorb-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@6d16011`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| using-devorb-auto-diagram | devorb@6d16011 | 100% | 1.00 | US$ 0.3871 |
| using-devorb-auto-evolving | devorb@6d16011 | 100% | 1.00 | US$ 0.3516 |
| using-devorb-auto-handoff | devorb@6d16011 | 100% | 1.00 | US$ 0.3587 |
| using-devorb-auto-improve-architecture | devorb@6d16011 | 100% | 1.00 | US$ 0.7306 |
| using-devorb-auto-mobile-release | devorb@6d16011 | 100% | 1.00 | US$ 0.5849 |
| using-devorb-auto-prototype | devorb@6d16011 | 100% | 1.00 | US$ 0.9347 |
| using-devorb-auto-retro | devorb@6d16011 | 100% | 1.00 | US$ 0.3373 |
| using-devorb-auto-security-audit | devorb@6d16011 | 100% | 1.00 | US$ 0.9999 |
| using-devorb-design-triggers-motion | devorb@6d16011 | 100% | 1.00 | US$ 0.5267 |
| using-devorb-design-triggers-visual | devorb@6d16011 | 100% | 1.00 | US$ 0.5800 |
| using-devorb-legacy-names | devorb@6d16011 | 100% | 1.00 | US$ 0.4709 |
| using-devorb-mobile-triggers-device | devorb@6d16011 | 100% | 1.00 | US$ 0.4528 |
| using-devorb-mobile-triggers-native | devorb@6d16011 | 100% | 1.00 | US$ 0.8991 |
| using-devorb-style-first-bug | devorb@6d16011 | 100% | 1.00 | US$ 0.3985 |
| using-devorb-style-first-feature | devorb@6d16011 | 100% | 1.00 | US$ 0.3502 |
| using-devorb-triggers-bug | devorb@6d16011 | 100% | 1.00 | US$ 0.3974 |
| using-devorb-triggers-feature | devorb@6d16011 | 100% | 1.00 | US$ 0.3385 |

Custo total desta execução: US$ 9.0989 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: `devorb@6d16011: using-devorb-auto-prototype (1)`

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
