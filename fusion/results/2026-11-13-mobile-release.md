# Comparação de versões: mobile-release

- Data: 2026-11-13
- Suíte: `evals`, casos `mobile-release-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@da1b97e`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| mobile-release-agenda-facil | devorb@da1b97e | 100% | 1.00 | US$ 1.0174 |
| mobile-release-agenda-facil | none | 50% | 0.75 | US$ 0.3948 |

Custo total desta execução: US$ 1.4069 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
