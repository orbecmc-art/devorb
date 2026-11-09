# DevOrb

Plugin pessoal para o Claude Code. Funde o melhor de várias fontes, listadas em `fusion/sources.json`, em um fluxo único: alinhar, planejar, implementar, verificar, revisar e finalizar.

## Instalação

Em cada máquina, rode `gh auth status`. Se não houver login, rode `gh auth login` antes de continuar.

```
gh auth setup-git
claude plugin marketplace add orbecmc-art/devorb
claude plugin install devorb@devorb
claude plugin disable superpowers@claude-plugins-official
```

Depois, no Claude Code, abra `/plugin` > Marketplaces, escolha `devorb` e ligue a atualização automática.

O Superpowers e o DevOrb nunca ficam ligados ao mesmo tempo. O ponytail continua sendo um plugin separado.

## Voltar ao Superpowers

```
claude plugin disable devorb@devorb
claude plugin enable superpowers@claude-plugins-official
```

## Ciclo mensal

A skill `evolving` compara cada fonte de `fusion/sources.json` com o último commit absorvido, só nas pastas acompanhadas. Sem mudança, ela não gera commit. Com mudança, abre um pull request em português dizendo o que adotou, o que recusou e por quê. Só o dono faz o merge, e nada de terceiros entra sozinho.

- **Rodar à mão:** `/devorb:evolving`, ou peça um ensaio para parar no rascunho `fusion/pr-draft.md`.
- **Rodar sozinho:** a tarefa agendada usa o prompt de `fusion/routine-prompt.md`.
- **Testes:** enquanto `tools/compare.mjs` não existir, ou se ele não rodar na nuvem, o pull request chega com "Testes: pendentes". Rode os comandos indicados nele no Mac antes de aprovar.

## Desenvolvimento

`npm test` roda os testes de estrutura em `tests/`. A versão do plugin fica só em `.claude-plugin/plugin.json`. O design está em `docs/specs/` e o plano em `docs/plans/`.
