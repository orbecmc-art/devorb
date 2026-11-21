# Comparação de versões: visual-direction-arquitetura

- Data: 2026-11-20
- Suíte: `evals`, casos `visual-direction-arquitetura-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@2502b5c`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| visual-direction-arquitetura-clean | devorb@2502b5c | 67% | 0.94 | US$ 15.0274 |
| visual-direction-arquitetura-clean | none | 0% | 0.18 | US$ 1.1060 |

Custo total desta execução: US$ 16.1029 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: `devorb@2502b5c: visual-direction-arquitetura-clean (1)`
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não (rodadas com erro da ferramenta)
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
