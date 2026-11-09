# DevOrb

Plugin pessoal para o Claude Code. Funde o Superpowers e as skills do Matt Pocock em um fluxo único: alinhar, planejar, implementar, verificar, revisar e finalizar.

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

## Desenvolvimento

`npm test` roda os testes de estrutura em `tests/`. A versão do plugin fica só em `.claude-plugin/plugin.json`. O design está em `docs/specs/` e o plano em `docs/plans/`.
