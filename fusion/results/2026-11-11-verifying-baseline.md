# Comparação de versões: verifying

- Data: 2026-11-11
- Suíte: `evals`, casos `verifying-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `superpowers@22f0b46`, `mattpocock-skills@4ae2317`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| verifying-nota-tudo-passou | superpowers@22f0b46 | 100% | 1.00 | US$ 0.7870 |
| verifying-nota-tudo-passou | mattpocock-skills@4ae2317 | 100% | 1.00 | US$ 0.7106 |
| verifying-nota-tudo-passou | none | 100% | 1.00 | US$ 0.6390 |

Custo total desta execução: US$ 1.8820 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não se aplica (só linhas de base)
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
