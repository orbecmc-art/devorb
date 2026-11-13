# Comparação de versões: using-devorb

- Data: 2026-11-13
- Suíte: `evals`, casos `using-devorb-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@555d715`, `superpowers@22f0b46`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| using-devorb-legacy-names | devorb@555d715 | 100% | 1.00 | US$ 0.6083 |
| using-devorb-legacy-names | superpowers@22f0b46 | 0% | 0.00 | US$ 0.5190 (cache) |
| using-devorb-triggers-bug | devorb@555d715 | 100% | 1.00 | US$ 0.5614 |
| using-devorb-triggers-bug | superpowers@22f0b46 | 100% | 1.00 | US$ 0.5309 (cache) |
| using-devorb-triggers-feature | devorb@555d715 | 100% | 1.00 | US$ 0.4922 |
| using-devorb-triggers-feature | superpowers@22f0b46 | 100% | 1.00 | US$ 0.5261 (cache) |

Custo total desta execução: US$ 1.6619 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
