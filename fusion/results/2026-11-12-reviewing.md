# Comparação de versões: reviewing

- Data: 2026-11-12
- Suíte: `evals`, casos `reviewing-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@2c67ed9`, `superpowers@22f0b46`, `mattpocock-skills@4ae2317`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| reviewing-cupom-desconto | devorb@2c67ed9 | 100% | 1.00 | US$ 1.3175 |
| reviewing-cupom-desconto | superpowers@22f0b46 | 0% | 0.25 | US$ 0.5319 (cache) |
| reviewing-cupom-desconto | mattpocock-skills@4ae2317 | 50% | 0.63 | US$ 0.9746 (cache) |

Custo total desta execução: US$ 1.3138 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
