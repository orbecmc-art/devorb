# DevOrb

Plugin para o Claude Code que junta, num fluxo só, o melhor de vários plugins e guias de desenvolvimento (Superpowers, Matt Pocock, Anthropic, Trail of Bits, gstack, Impeccable, Expo, Android e outros, listados em `fusion/sources.json`). Você conversa normalmente: o DevOrb escolhe sozinho a skill certa pelo assunto.

- **Desenvolvimento:** alinhar o pedido, planejar, implementar com TDD, depurar pela causa, verificar com evidência, revisar e terminar a branch.
- **Interface:** direção visual, sistema de design com contraste calculado, movimento, revisão de UI, teste no navegador e diagramas.
- **Apps:** telas em Expo e Kotlin, teste de app e publicação na loja.
- **Extras:** auditoria de segurança (só leitura), protótipo, melhoria de arquitetura, retro, handoff entre sessões e revisão mensal das fontes.

Cada skill foi comparada com os plugins de origem em casos de teste reais. O placar está em `fusion/results/relatorio-comparativo.html`: em 49 casos, o DevOrb não perde nenhum para o Superpowers nem para o Matt Pocock.

## Instalação

```
claude plugin marketplace add orbecmc-art/devorb
claude plugin install devorb@devorb
```

Depois, no Claude Code, abra `/plugin` > Marketplaces, escolha `devorb` e ligue a atualização automática. Abra uma sessão nova para carregar.

Se você usa o Superpowers, desligue-o: os dois fazem o mesmo papel e não devem ficar ligados juntos.

```
claude plugin disable superpowers@claude-plugins-official
```

O DevOrb funciona bem junto com o ponytail.

## Desinstalar

```
claude plugin uninstall devorb@devorb
```

## Licença e créditos

MIT (`LICENSE`). O material adaptado de terceiros mantém a licença de origem, em `LICENSES/`, e cada skill tem em `fusion/ledger/` a origem de cada parte.

## Ciclo mensal

A skill `evolving` compara cada fonte de `fusion/sources.json` com o último commit absorvido, só nas pastas acompanhadas. Sem mudança, ou com mudança que só alimenta skills ainda não fundidas, ela não gera commit. Com mudança em skill pronta, abre um pull request em português dizendo o que adotou, o que recusou e por quê. Só o dono faz o merge, e nada de terceiros entra sozinho.

- **Rodar à mão:** `/devorb:evolving`, ou peça um ensaio para parar no rascunho `fusion/pr-draft.md`.
- **Rodar sozinho:** a tarefa agendada usa o prompt de `fusion/routine-prompt.md`.
- **Conferir:** um mês sem pull request não prova que o ciclo funcionou. No dia 2, veja o histórico da tarefa e a linha de status no começo da mensagem final: `OK sem mudança`, `OK com pull request`, `OK aguardando revisão`, `PARCIAL` ou `FALHOU`. Os dois últimos também abrem uma issue, se a API deixar. Uma execução sem linha de status conta como `FALHOU`, porque ela pode ter parado esperando uma confirmação na página da tarefa.
- **Depois do merge:** apague a branch `claude/evolve-*`. Enquanto ela existir, o mês seguinte para em `OK aguardando revisão`.
- **Testes:** se `tools/compare.mjs` não rodar na nuvem, o pull request chega com "Testes: pendentes". Rode os comandos indicados nele no Mac antes de aprovar.

## Desenvolvimento

`npm test` roda os testes de estrutura em `tests/`. A versão do plugin fica só em `.claude-plugin/plugin.json`. O design está em `docs/specs/` e o plano em `docs/plans/`.
