# Comparação de versões: domain-modeling

- Data: 2026-11-11
- Suíte: `evals`, casos `domain-modeling-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@f065cf2`, `mattpocock-skills@4ae2317`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| domain-modeling-aluno-ativo | devorb@f065cf2 | 67% | 0.83 | US$ 1.1791 |
| domain-modeling-aluno-ativo | mattpocock-skills@4ae2317 | 0% | 0.25 | US$ 0.6711 (cache) |

Custo total desta execução: US$ 1.1734 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
