# Comparação de versões: tdd

- Data: 2026-11-11
- Suíte: `evals`, casos `tdd-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `superpowers@22f0b46`, `mattpocock-skills@4ae2317`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| tdd-desconto-progressivo | superpowers@22f0b46 | 33% | 0.60 | US$ 0.8648 |
| tdd-desconto-progressivo | mattpocock-skills@4ae2317 | 0% | 0.40 | US$ 0.7794 |
| tdd-desconto-progressivo | none | 0% | 0.40 | US$ 0.7487 |

Custo total desta execução: US$ 1.9166 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não se aplica (só linhas de base)
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
