# Comparação de versões: verifying

- Data: 2026-11-11
- Suíte: `evals-reserved`, casos `verifying-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@17baeec`, `superpowers@22f0b46`, `mattpocock-skills@4ae2317`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| verifying-parcelamento | devorb@17baeec | 67% | 0.94 | US$ 0.9356 |
| verifying-parcelamento | superpowers@22f0b46 | 67% | 0.94 | US$ 0.8859 |
| verifying-parcelamento | mattpocock-skills@4ae2317 | 100% | 1.00 | US$ 0.7597 |

Custo total desta execução: US$ 2.1123 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
