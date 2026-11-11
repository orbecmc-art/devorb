# Comparação de versões: using-devorb

- Data: 2026-11-11
- Suíte: `evals`, casos `using-devorb-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `superpowers@22f0b46`, `mattpocock-skills@4ae2317`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| using-devorb-legacy-names | superpowers@22f0b46 | 0% | 0.00 | US$ 0.5185 |
| using-devorb-legacy-names | mattpocock-skills@4ae2317 | 0% | 0.00 | US$ 0.3481 |
| using-devorb-legacy-names | none | 0% | 0.00 | US$ 0.3199 |
| using-devorb-triggers-bug | superpowers@22f0b46 | 100% | 1.00 | US$ 0.5248 |
| using-devorb-triggers-bug | mattpocock-skills@4ae2317 | 0% | 0.00 | US$ 0.3886 |
| using-devorb-triggers-bug | none | 0% | 0.00 | US$ 0.3616 |
| using-devorb-triggers-feature | superpowers@22f0b46 | 100% | 1.00 | US$ 0.5246 |
| using-devorb-triggers-feature | mattpocock-skills@4ae2317 | 0% | 0.00 | US$ 0.4550 |
| using-devorb-triggers-feature | none | 0% | 0.00 | US$ 0.4364 |

Custo total desta execução: US$ 3.8775 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma

## Decisão

- Aprovado: não se aplica (só linhas de base)
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
