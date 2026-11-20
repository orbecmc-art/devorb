# Comparação de versões: visual-direction-arquitetura

- Data: 2026-11-20
- Suíte: `evals`, casos `visual-direction-arquitetura-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@31f827d`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| visual-direction-arquitetura-clean | devorb@31f827d | 33% | 0.73 | US$ 7.2865 |
| visual-direction-arquitetura-clean | none | 0% | 0.18 | US$ 1.3695 |

Custo total desta execução: US$ 8.6309 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `visual-direction-arquitetura-clean`
- Lacunas (nenhum braço passa): nenhuma
