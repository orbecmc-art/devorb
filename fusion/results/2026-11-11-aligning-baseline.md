# Comparação de versões: aligning

- Data: 2026-11-11
- Suíte: `evals`, casos `aligning-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `superpowers@22f0b46`, `mattpocock-skills@4ae2317`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| aligning-agendamento | superpowers@22f0b46 | 0% | 0.60 | US$ 0.4469 |
| aligning-agendamento | mattpocock-skills@4ae2317 | 0% | 0.53 | US$ 0.3649 |
| aligning-agendamento | none | 0% | 0.20 | US$ 1.9608 |

Custo total desta execução: US$ 2.7525 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não se aplica (só linhas de base)
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
