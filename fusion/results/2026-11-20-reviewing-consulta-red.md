# Comparação de versões: reviewing-consulta

- Data: 2026-11-20
- Suíte: `evals`, casos `reviewing-consulta-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@182823b`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| reviewing-consulta-sem-limite | devorb@182823b | 0% | 0.25 | US$ 0.5265 |
| reviewing-consulta-sem-limite | none | 50% | 0.63 | US$ 0.4303 |

Custo total desta execução: US$ 0.9488 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `reviewing-consulta-sem-limite`
- Lacunas (nenhum braço passa): nenhuma
