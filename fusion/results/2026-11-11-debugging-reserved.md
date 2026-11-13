# Comparação de versões: debugging

- Data: 2026-11-11
- Suíte: `evals-reserved`, casos `debugging-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@1fd9bb2`, `superpowers@22f0b46`, `mattpocock-skills@4ae2317`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| debugging-resumo-pedido | devorb@1fd9bb2 | 100% | 1.00 | US$ 1.2054 |
| debugging-resumo-pedido | superpowers@22f0b46 | 100% | 1.00 | US$ 1.2109 |
| debugging-resumo-pedido | mattpocock-skills@4ae2317 | 100% | 1.00 | US$ 0.9981 |

Custo total desta execução: US$ 2.9197 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
