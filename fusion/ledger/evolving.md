# Ledger: `evolving`

Skill nova, sem fonte para fundir. O processo vem da seção "Ciclo mensal" da spec e das decisões da Task 19. O caso que justifica as regras próprias é a linha de base: um agente sem skill rodou o ciclo em um repositório de ensaio.

## Origem por parte

| Parte | Origem |
|---|---|
| 1. Comparar | Spec, "Ciclo mensal", passo 1, e a saída de `tools/source-diff.mjs` |
| 2. Parar sem mudança | Spec, "Ciclo mensal", passo 2 |
| 3. Classificar | Spec, "Ciclo mensal", passo 3, e decisões da Task 19 sobre skill `planned`, regra própria e o mapa de skills |
| 4. Segurança | Spec, "Segurança", e decisão da Task 19 sobre instrução com cara de passo comum |
| 5. Fundir | Spec, "Limites de tamanho", "Fontes novas" e "Como fundir uma skill", mais as regras próprias 1, 2 e 4 |
| 6. Testar | Spec, "Ciclo mensal", passo 5, e receita R6 do plano. Os braços seguem "Fontes novas não viram braço de comparação" |
| 7. Rascunho e `references/pr-template.md` | Spec, "Ciclo mensal", passo 6, mais a regra própria 3 |
| 8. Publicar | Spec, "Ciclo mensal", passos 6 e 7, e decisões da Task 19 |

## Conflitos resolvidos

- **"Sem mudança relevante" ou nenhuma mudança:** a spec fala em mudança relevante, e a Task 19 decidiu pelo critério objetivo: só encerra sem pull request quando toda fonte está `no-change`. Mudança que alimenta só skill `planned` gera pull request, porque o pino avança.

## Regras próprias

Cada regra vem de uma falha vista na linha de base. Só saem com decisão explícita do dono.

1. **Medir antes e depois da edição e terminar dentro do teto.** Passar exige tirar algo ou mover detalhe para `references/`, com as regras próprias no lugar. Falha: o agente adicionou uma ideia adotada e levou a skill a 203 tokens, com teto de 169, sem cortar nem mover nada.
2. **Escrever a ideia de fonte `textReuse: false` a partir de uma nota própria em português e depois comparar com a fonte.** Falha: o texto seguiu a frase da fonte quase palavra por palavra, só trocando sinônimos.
3. **Rascunho com forma fixa e o destaque em primeiro lugar.** Seção por fonte, tabela de testes ou "Testes: pendentes", variação de tokens e destaque separado para hooks, scripts e instruções embutidas. Falha: não havia seção por fonte, variação de tokens nem marca de testes, e hooks, scripts e instruções ficaram dentro de uma lista geral de recusados.
4. **Editar no lugar, JSON incluído.** Falha: o agente reescreveu um arquivo JSON e o reformatou, o que encheu o diff de ruído.

## Fora

- **Verificador automático de semelhança com a fonte:** a regra 2 é um método que o agente segue. Se o ensaio mostrar que não basta, vale reabrir.
- **Pull request só para uma fonte que falhou:** uma falha de rede não justifica versão nova. A falha aparece na última mensagem, que fica no histórico da tarefa agendada. Com `sha-missing` há pull request, porque o dono precisa decidir.
- **`fusion/pr-draft.md` no commit:** o rascunho vira o corpo do pull request. Se entrasse na `main`, um mês sem mudança ficaria com um rascunho velho.

## Decisões por commit de fonte

Nenhuma. `evolving` não absorve fonte.
