# Comparação de versões: improve-architecture

- Data: 2026-11-12
- Suíte: `evals`, casos `improve-architecture-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: sim, em `96608e078b2d5ea607c5c3b8b5a54d1c1fba6846`
- Braços: `devorb@16bd400`, `superpowers@22f0b46`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| improve-architecture-calculo-preco | devorb@16bd400 | 33% | 0.89 | US$ 1.5706 |
| improve-architecture-calculo-preco | superpowers@22f0b46 | 0% | 0.33 | US$ 0.7668 (cache) |

Custo total desta execução: US$ 1.5661 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `improve-architecture-calculo-preco`
- Lacunas (nenhum braço passa): nenhuma
