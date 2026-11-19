# Comparação de versões: visual-direction

- Data: 2026-11-18
- Suíte: `evals`, casos `visual-direction-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@1126ff4`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| visual-direction-arquitetura-clean | devorb@1126ff4 | 0% | 0.36 | US$ 8.7246 |
| visual-direction-clinica-serena | devorb@1126ff4 | 100% | 1.00 | US$ 4.2196 |
| visual-direction-guia-leigo | devorb@1126ff4 | 50% | 0.83 | US$ 0.5052 |
| visual-direction-receitas-landing | devorb@1126ff4 | 100% | 1.00 | US$ 3.4578 |

Custo total desta execução: US$ 16.8683 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `visual-direction-arquitetura-clean`, `visual-direction-guia-leigo`
- Lacunas (nenhum braço passa): nenhuma
