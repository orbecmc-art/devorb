# Comparação de versões: implementing

- Data: 2026-11-12
- Suíte: `evals`, casos `implementing-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@d4d4701`, `superpowers@22f0b46`, `mattpocock-skills@4ae2317`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| implementing-resgate-extrato | devorb@d4d4701 | 100% | 1.00 | US$ 5.3397 |
| implementing-resgate-extrato | superpowers@22f0b46 | 67% | 0.92 | US$ 4.5153 (cache) |
| implementing-resgate-extrato | mattpocock-skills@4ae2317 | 0% | 0.75 | US$ 1.2618 (cache) |

Custo total desta execução: US$ 5.3397 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
