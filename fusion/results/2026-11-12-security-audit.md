# Comparação de versões: security-audit

- Data: 2026-11-12
- Suíte: `evals`, casos `security-audit-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@1042b9a`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| security-audit-pedidos | devorb@1042b9a | 100% | 1.00 | US$ 1.9944 |
| security-audit-pedidos | none | 0% | 0.67 | US$ 0.3587 |

Custo total desta execução: US$ 2.3443 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
