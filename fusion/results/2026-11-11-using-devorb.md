# Comparação de versões: using-devorb

- Data: 2026-11-11
- Suíte: `evals`, casos `using-devorb-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@7f0e4bf`, `superpowers@22f0b46`, `mattpocock-skills@4ae2317`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| using-devorb-legacy-names | devorb@7f0e4bf | 100% | 1.00 | US$ 0.5161 |
| using-devorb-legacy-names | superpowers@22f0b46 | 0% | 0.00 | US$ 0.5185 (cache) |
| using-devorb-legacy-names | mattpocock-skills@4ae2317 | 0% | 0.00 | US$ 0.3481 (cache) |
| using-devorb-legacy-names | none | 0% | 0.00 | US$ 0.3195 |
| using-devorb-triggers-bug | devorb@7f0e4bf | 100% | 1.00 | US$ 0.5638 |
| using-devorb-triggers-bug | superpowers@22f0b46 | 100% | 1.00 | US$ 0.5248 (cache) |
| using-devorb-triggers-bug | mattpocock-skills@4ae2317 | 0% | 0.00 | US$ 0.3886 (cache) |
| using-devorb-triggers-bug | none | 0% | 0.00 | US$ 0.3589 |
| using-devorb-triggers-feature | devorb@7f0e4bf | 100% | 1.00 | US$ 0.5054 |
| using-devorb-triggers-feature | superpowers@22f0b46 | 100% | 1.00 | US$ 0.5246 (cache) |
| using-devorb-triggers-feature | mattpocock-skills@4ae2317 | 0% | 0.00 | US$ 0.4550 (cache) |
| using-devorb-triggers-feature | none | 0% | 0.00 | US$ 0.4285 |

Custo total desta execução: US$ 2.6922 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
