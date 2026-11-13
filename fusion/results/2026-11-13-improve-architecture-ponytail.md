# Comparação de versões: improve-architecture

- Data: 2026-11-13
- Suíte: `evals`, casos `improve-architecture-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: sim, em `96608e078b2d5ea607c5c3b8b5a54d1c1fba6846`
- Braços: `devorb@56aaefd`, `superpowers@22f0b46`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| improve-architecture-calculo-preco | devorb@56aaefd | 100% | 1.00 | US$ 1.8511 |
| improve-architecture-calculo-preco | superpowers@22f0b46 | 0% | 0.33 | US$ 0.7419 |

Custo total desta execução: US$ 2.5818 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
