# Comparação de versões: using-devorb

- Data: 2026-11-11
- Suíte: `evals-reserved`, casos `using-devorb-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@17baeec`, `superpowers@22f0b46`, `mattpocock-skills@4ae2317`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| using-devorb-fechamento-outubro | devorb@17baeec | 100% | 1.00 | US$ 0.7671 |
| using-devorb-fechamento-outubro | superpowers@22f0b46 | 100% | 1.00 | US$ 0.7183 (cache) |
| using-devorb-fechamento-outubro | mattpocock-skills@4ae2317 | 0% | 0.50 | US$ 0.5256 (cache) |
| using-devorb-fechamento-outubro | none | 0% | 0.50 | US$ 0.4955 |

Custo total desta execução: US$ 1.2626 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
