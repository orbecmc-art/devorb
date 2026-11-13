# Comparação de versões: improve-architecture

- Data: 2026-11-13
- Suíte: `evals`, casos `improve-architecture-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@da1b97e`, `mattpocock-skills@4ae2317`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| improve-architecture-calculo-preco | devorb@da1b97e | 100% | 1.00 | US$ 1.4286 |
| improve-architecture-calculo-preco | mattpocock-skills@4ae2317 | 0% | 0.33 | US$ 0.4612 |

Custo total desta execução: US$ 1.8819 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
