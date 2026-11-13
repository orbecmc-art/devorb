# Comparação de versões: using-devorb

- Data: 2026-11-13
- Suíte: `evals`, casos `using-devorb-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@a5777b6`, `superpowers@22f0b46`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| using-devorb-legacy-names | devorb@a5777b6 | 100% | 1.00 | US$ 0.8292 |
| using-devorb-legacy-names | superpowers@22f0b46 | 0% | 0.00 | US$ 0.5190 |
| using-devorb-triggers-bug | devorb@a5777b6 | 100% | 1.00 | US$ 0.5857 |
| using-devorb-triggers-bug | superpowers@22f0b46 | 100% | 1.00 | US$ 0.5309 |
| using-devorb-triggers-feature | devorb@a5777b6 | 100% | 1.00 | US$ 0.4781 |
| using-devorb-triggers-feature | superpowers@22f0b46 | 100% | 1.00 | US$ 0.5261 |

Custo total desta execução: US$ 3.4690 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
