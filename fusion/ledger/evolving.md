# Ledger: `evolving`

Skill nova, sem fonte para fundir. O processo vem da seção "Ciclo mensal" da spec, das decisões da Task 19 e da revisão da branch `feat/monthly-cycle`. O caso que justifica as regras próprias 1 a 4 é a linha de base: um agente sem skill rodou o ciclo em um repositório de ensaio. As demais vêm da revisão da branch e do ensaio da primeira versão, porque o ciclo roda sozinho sobre texto de terceiros.

## Origem por parte

| Parte | Origem |
|---|---|
| Mensagem final | Revisão da branch, mais a regra própria 6 |
| 0. Uma revisão por vez | Revisão da branch, mais a regra própria 7 |
| 1. Comparar | Spec, "Ciclo mensal", passo 1, a saída de `tools/source-diff.mjs` e a revisão da branch, sobre `missingPaths` e o limite de 30 arquivos |
| 2. Parar sem mudança | Spec, "Ciclo mensal", passo 2 |
| 3. Classificar | Spec, "Ciclo mensal", passo 3, decisões da Task 19 sobre regra própria e o mapa de skills, e a revisão da branch, sobre leitura por índice, pino e as regras próprias 5 e 11 |
| 4. Segurança | Spec, "Segurança", mais as regras próprias 5, 9 e 10 |
| 5. Fundir | Spec, "Limites de tamanho", "Fontes novas" e "Como fundir uma skill", mais as regras próprias 1, 2, 4 e 8 |
| 6. Testar | Spec, "Ciclo mensal", passo 5, e receita R6 do plano. Os braços seguem "Fontes novas não viram braço de comparação". O `accepted: false` vem da revisão da branch |
| 7. Rascunho e `references/pr-template.md` | Spec, "Ciclo mensal", passo 6, mais as regras próprias 3, 8 e 10 |
| 8. Publicar | Spec, "Ciclo mensal", passos 6 e 7, e a revisão da branch, sobre `gh api` e o que fazer quando a publicação falha |

## Conflitos resolvidos

- **"Sem mudança relevante" ou nenhuma mudança:** a spec fala em mudança relevante. A primeira versão avançava o pino de fonte que só alimenta skill `planned`, e a revisão da branch trocou essa regra: o pino fica, não há pull request nem versão nova, e a mensagem final traz uma linha sobre a fonte. O status é `OK sem mudança`.
- **Destaque sempre, mas sem rascunho:** `scriptsOrHooks` e `oddPaths` vão sempre para o destaque, e uma fonte sem nada a fundir não gera rascunho. Nesse caso, a linha da mensagem final traz a contagem deles. Como o pino não avança, a contagem volta todo mês até a fusão.
- **"Só `planned`" estendido:** a mesma regra vale para fonte cujas mudanças não alimentam nenhuma skill `done`, o que inclui arquivo fora do mapa e candidata a skill nova. Nenhum desses tem o que fundir.
- **`sha-missing` sozinho estendido:** a issue com o rascunho, sem versão nova, vale para toda execução que só tem decisões do dono, como `missingPaths` ou `D` em `SKILL.md`.
- **Pino com decisão aberta:** fonte com decisão do dono em aberto fica com o pino, mesmo se outra mudança dela foi adotada, para a pergunta voltar no mês seguinte. O que já foi adotado aparece então como "já decidido".

## Regras próprias

Regras próprias só saem com decisão explícita do dono.

1. **Medir antes e depois da edição e terminar dentro do teto.** Passar exige mover detalhe para `references/` ou tirar algo, com as regras próprias no lugar. Falha: o agente adicionou uma ideia adotada e levou a skill a 203 tokens, com teto de 169, sem cortar nem mover nada.
2. **Escrever a ideia de fonte `textReuse: false` a partir de uma nota própria em português e depois comparar com a fonte.** Falha: o texto seguiu a frase da fonte quase palavra por palavra, só trocando sinônimos.
3. **Rascunho com forma fixa e o destaque em primeiro lugar.** Seção por fonte, tabela de testes ou "Testes: pendentes", variação de tokens e destaque separado para hooks, scripts e instruções embutidas. Falha: não havia seção por fonte, variação de tokens nem marca de testes, e hooks, scripts e instruções ficaram dentro de uma lista geral de recusados.
4. **Editar no lugar, JSON incluído.** Falha: o agente reescreveu um arquivo JSON e o reformatou, o que encheu o diff de ruído.
5. **Caminho de fonte nunca entra em comando.** A leitura é só com `--show` e `--diff`, por índice, e `oddPaths` vão para o destaque. Motivo: na primeira versão, o nome de um arquivo de terceiros podia chegar a um shell.
6. **A mensagem final começa com uma linha de status, e `PARCIAL` ou `FALHOU` abrem uma issue.** Motivo: um mês que falhou parecia um mês quieto.
7. **Uma revisão por vez.** Pull request aberto ou branch `claude/evolve-*` existente param a execução. Motivo: revisão da branch, para o ciclo seguinte não empilhar sobre uma revisão que o dono ainda não leu.
8. **A coluna do que saiu vem do `git diff`, e reescrever um passo é mudança que se relata.** Falha: nas rodadas 2 e 3 do ensaio, "smallest experiment" virou "cheapest experiment" e a coluna disse "Nada".
9. **Instrução embutida se define pelo alvo e por estar escondida, não pela forma.** Comando comum do projeto dentro de um método ensinado não conta. Motivo: revisão da branch, para cobrir texto escondido e não marcar um passo comum.
10. **Citação inerte.** No rascunho, citação e caminho estranho ficam em bloco cercado, com cerca maior que qualquer sequência de crases. O ledger registra a recusa sem repetir o texto. Motivo: revisão da branch, para nada virar link nem célula de tabela, e para o texto malicioso não entrar em arquivo que fica no repositório.
11. **O que só o dono decide.** Skill `done` sem ledger não adota nada, e `D` ou `R` em `SKILL.md`, `missingPaths` e mais de 30 arquivos em uma fonte vão para a decisão do dono. Motivo: revisão da branch. `using-devorb` está sem ledger hoje.

## Fora

- **Verificador automático de semelhança com a fonte:** a regra 2 é um método que o agente segue. Se o ensaio mostrar que não basta, vale reabrir.
- **Pull request só para uma fonte que falhou:** uma falha de rede não justifica versão nova. O status é `PARCIAL` ou `FALHOU`, com uma issue que nomeia a fonte.
- **`fusion/pr-draft.md` no commit:** o rascunho vira o corpo do pull request e está no `.gitignore`. Se entrasse na `main`, um mês sem mudança ficaria com um rascunho velho.
- **`gh pr` e `gh issue`:** dão 403 na nuvem, então a publicação usa `gh api`.

## Decisões por commit de fonte

Nenhuma. `evolving` não absorve fonte.
