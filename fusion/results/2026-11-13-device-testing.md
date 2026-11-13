# Comparação de versões: device-testing

- Data: 2026-11-13
- Suíte: `evals`, casos `device-testing-*`, 3 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@a5c91c6`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| device-testing-expo-perfil | devorb@a5c91c6 | 100% | 1.00 | US$ 0.6302 |
| device-testing-expo-perfil | none | 0% | 0.25 | US$ 0.5875 |
| device-testing-kotlin-perfil | devorb@a5c91c6 | 100% | 1.00 | US$ 1.1529 |
| device-testing-kotlin-perfil | none | 0% | 0.25 | US$ 0.9667 |

Custo total desta execução: US$ 3.3147 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: sim
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: nenhum
- Lacunas (nenhum braço passa): nenhuma
