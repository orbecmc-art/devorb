# Comparação de versões: evolving

- Data: 2026-11-11
- Suíte: `evals`, casos `evolving-*`, 2 rodadas por caso, modelo `claude-opus-5-5`, ablação `with-without`
- Ponytail: não
- Braços: `devorb@7b1bd32`

| Caso | Braço | Aprovação | Pontuação | Custo |
|---|---|---|---|---|
| evolving-no-change | devorb@7b1bd32 | 100% | 1.00 | US$ 0.9366 |
| evolving-planned-only | devorb@7b1bd32 | 100% | 1.00 | US$ 1.3044 |
| evolving-rehearsal | devorb@7b1bd32 | 50% | 0.97 | US$ 2.3690 |
| evolving-rewritten | devorb@7b1bd32 | 100% | 1.00 | US$ 1.4034 |
| evolving-source-failed | devorb@7b1bd32 | 50% | 0.83 | US$ 1.6269 |

Custo total desta execução: US$ 7.3803 (linhas de base em cache não contam).

- Casos ausentes (não carregaram ou não rodaram): nenhum
- Rodadas parciais (teto de custo atingido): nenhuma
- Rodadas com erro da ferramenta: nenhuma

## Decisão

- Aprovado: não
- Regressões (pior que a melhor linha de base por mais de uma rodada): nenhuma
- Abaixo da barra de 2/3: `evolving-rehearsal`, `evolving-source-failed`
- Lacunas (nenhum braço passa): nenhuma

## Anotação do coordenador (escrita à mão)

O relatório da ferramenta mostra só o braço com o plugin. No `--json` desta execução, o braço sem o plugin (`without`) ficou assim:

| Caso | Com o plugin | Sem o plugin |
|---|---|---|
| evolving-no-change | 100%, 1.00 | 0%, 0.00 |
| evolving-planned-only | 100%, 1.00 | 0%, 0.17 |
| evolving-rehearsal | 50%, 0.97 | 0%, 0.75 |
| evolving-rewritten | 100%, 1.00 | 0%, 0.00 |
| evolving-source-failed | 50%, 0.83 | 0%, 0.17 |

- `evolving-rehearsal`: a rodada que falhou perdeu só `pr-format` (12 de 13 graders). O ensaio da Task 19 no Windows também teve uma rodada com 12 de 13.
- `evolving-source-failed`: a rodada que falhou não começou a resposta com `STATUS: PARCIAL`. Repetido com 2 rodadas, passou nas duas (US$ 0,32).
- Esta execução usou os graders do commit `7b1bd32`. Depois, `01e3a90` trocou o grader de tamanho por um `regex` e separou graders do caso reservado. Os casos não reservados daqui só mudaram em `within-ceiling`.
- Uma execução anterior, no mesmo dia, deu 0% em tudo porque o git não rodava dentro do sandbox. O relatório dela foi descartado.
