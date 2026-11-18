# Comparação de versões: visual-direction

- Data: 2026-11-18
- Suíte: `evals`, casos `visual-direction-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@35cdc27`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| visual-direction-arquitetura-clean | devorb@35cdc27 | 0% | 0.73 | US$ 6.3373 |
| visual-direction-arquitetura-clean | none | 0% | 0.18 | US$ 0.8897 |
| visual-direction-clinica-serena | devorb@35cdc27 | 100% | 1.00 | US$ 3.2545 |
| visual-direction-clinica-serena | none | 0% | 0.69 | US$ 0.8361 |
| visual-direction-receitas-landing | devorb@35cdc27 | 100% | 1.00 | US$ 3.5770 |
| visual-direction-receitas-landing | none | 0% | 0.38 | US$ 1.0338 |

Custo total desta execução: US$ 15.8626 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): `visual-direction-arquitetura-clean`
