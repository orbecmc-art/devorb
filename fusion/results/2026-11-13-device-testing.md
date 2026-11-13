# Comparação de versões: device-testing

- Data: 2026-11-13
- Suíte: `evals`, casos `device-testing-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `none`
- Ponytail: não
- Braços: `devorb@8716393`, `none`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| device-testing-expo-perfil | devorb@8716393 | 50% | 0.63 | US$ 0.4201 |
| device-testing-expo-perfil | none | 0% | 0.25 | US$ 0.4244 |
| device-testing-kotlin-perfil | devorb@8716393 | 100% | 1.00 | US$ 0.7051 |
| device-testing-kotlin-perfil | none | 0% | 0.25 | US$ 0.5445 |

Custo total desta execução: US$ 2.0806 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma
- Rodadas que atingiram o limite de turnos do caso: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `device-testing-expo-perfil`
- Lacunas (nenhum braço passa): nenhuma
