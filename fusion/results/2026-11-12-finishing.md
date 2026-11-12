# Comparação de versões: finishing

- Data: 2026-11-12
- Suíte: `evals`, casos `finishing-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@4894a32`, `superpowers@22f0b46`, `mattpocock-skills@4ae2317`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| finishing-frete-gratis | devorb@4894a32 | 100% | 1.00 | US$ 0.3874 |
| finishing-frete-gratis | superpowers@22f0b46 | 100% | 1.00 | US$ 0.3683 (cache) |
| finishing-frete-gratis | mattpocock-skills@4ae2317 | 0% | 0.30 | US$ 0.3428 |

Custo total desta execução: US$ 0.7244 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
