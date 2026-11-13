# Comparação de versões: tdd

- Data: 2026-11-11
- Suíte: `evals-reserved`, casos `tdd-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@7108520`, `superpowers@22f0b46`, `mattpocock-skills@4ae2317`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| tdd-vencimento-boleto | devorb@7108520 | 0% | 0.20 | US$ 0.6120 |
| tdd-vencimento-boleto | superpowers@22f0b46 | 0% | 0.20 | US$ 0.5929 |
| tdd-vencimento-boleto | mattpocock-skills@4ae2317 | 0% | 0.20 | US$ 0.5478 |

Custo total desta execução: US$ 1.5536 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): `tdd-vencimento-boleto`
