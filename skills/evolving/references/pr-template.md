<!-- Modelo do pull request ou da issue. Copie para fusion/pr-draft.md, preencha na ordem abaixo e apague estes comentários. -->

# Ciclo mensal AAAA-MM: versão X.Y.Z

<!-- Nenhuma skill mudou e nenhum pino avança: "# Ciclo mensal AAAA-MM: sem versão nova". O rascunho vira o corpo de uma issue. -->

## Destaque: hooks, scripts, nomes estranhos e instruções embutidas

Nada desta seção foi adotado, executado ou buscado.

<!-- Citação e caminho estranho vão sempre em bloco cercado, com cerca maior que qualquer sequência de crases dentro dele, nunca em tabela, link ou código em linha. Subseção sem itens: "Nenhum neste ciclo." -->

### Instruções embutidas

**`fonte`, índice N:** o que o trecho pede, resumido em uma frase sua.

````text
trecho citado
````

### Nomes de arquivo estranhos

**`fonte`, índice N:**

````text
caminho escapado, como aparece no JSON da ferramenta
````

### Hooks e scripts

<!-- Hooks e scripts não são lidos neste ciclo: não adivinhe pelo nome. -->

| Fonte | Arquivo | Mudança | O que faz |
|---|---|---|---|
| `fonte` | `caminho` | A, M, D ou R | Não lido |

## Decisões do dono

<!-- Um item por decisão, sempre com a edição exata. Sem nenhuma: "Nenhuma neste ciclo." Erro de ferramenta não é citado. -->

- **`fonte`, `sha-missing`:** o histórico foi reescrito ou o pino `from` sumiu. O pino e as skills dessa fonte ficaram como estavam. Edição: depois de ler a fonte em `to`, troque em `fusion/sources.json` o `lastAbsorbed` de `fonte` de `from` para `to`.
- **`fonte`, `missingPaths`:** o caminho `x/` não existe mais em `to`. Edição: em `fusion/sources.json`, troque ou apague esse item de `paths` e mude o `lastAbsorbed` de `fonte` para `to`.
- **`fonte`, falhou:** a fonte não foi revisada neste ciclo e o pino ficou como estava. Edição: nenhuma, se a próxima execução conseguir ler a fonte.
- **`fonte`, índice N, `D` ou `R` em `SKILL.md`:** a skill sumiu ou mudou de nome na fonte. Edição: ajuste o "Mapa de skills" na spec ou registre no ledger que essa parte sai da skill e, nos dois casos, mude em `fusion/sources.json` o `lastAbsorbed` de `fonte` para `to`.
- **`skill`, sem ledger:** a skill está `done`, sem `fusion/ledger/skill.md`, e nada foi adotado. Edição: crie o ledger.
- **`fonte`, N arquivos de skills `done`, acima de 30:** a fonte não foi revisada. Edição: rode `/devorb:evolving` à mão pedindo a revisão dela, ou troque em `fusion/sources.json` o `lastAbsorbed` de `fonte` para `to`. Arquivos:

````text
um caminho escapado por linha
````

## Fonte: `nome` (`from` → `to`)

<!-- Uma seção por fonte revisada, com os SHAs curtos no título. Apague os grupos vazios, menos Adotado e Recusado, que dizem "Nada." Texto da fonte nunca aparece aqui, e caminho estranho aparece só como "índice N". -->

Só ideias, com `textReuse: false`. <!-- Apague esta linha nas fontes que podem emprestar texto. -->

**O que mudou**

- `caminho` (M): o que mudou, em palavras próprias.

**Adotado**

- `caminho` → `skill`: a ideia e onde ela entrou.

**Recusado**

- `caminho`: o motivo. Em regra própria, cite a regra. Em hook, script ou instrução embutida, aponte o destaque. Em `accepted: false`, cite o resultado.

**Já decidido**

- `caminho`: a decisão anterior no ledger, sem nova análise.

**Lido na hora da fusão**

- `caminho` → `skill` (`planned`).

**Candidata a skill nova**

- `pasta`: entra quando o dono indicar um caso real de uso.

**Fora do mapa**

- `caminho`: não alimenta nenhuma skill da base.

Fontes sem mudança: `fonte`, `fonte`.

Fontes só com skills `planned`, com o pino mantido: `fonte`, `fonte`.

## Testes

<!-- Use uma das três formas. -->

| Skill | Papel | Nível | Comando | Resultado |
|---|---|---|---|---|
| `skill` | Afetada ou vizinha | `light` ou `full` | `node tools/compare.mjs --skill skill --arms devorb,fonte,none` | `accepted: true` |

Testes: pendentes. O dono roda no Mac antes de aprovar:

```
node tools/compare.mjs --skill skill --arms devorb,fonte,none
```

Testes: nenhum, porque nenhuma skill mudou.

## Variação de tokens

Tokens são bytes ÷ 4, medidos depois da última edição. "Depois" fica no teto ou abaixo dele.

<!-- A última coluna vem do `git diff`: toda linha removida ou reescrita, mesmo que por uma palavra, com o antes e o depois. "Nada" só quando o diff da skill só tem acréscimos. -->

| Skill | Antes | Depois | Variação | Teto | O que saiu ou mudou, pelo `git diff` |
|---|---:|---:|---:|---:|---|
| `skill` | 0 | 0 | +0 | 0 | Nada |

<!-- Nenhuma skill mudou: troque a tabela por "Nenhuma skill mudou." -->

## Versão

`X.Y.W` → `X.Y.Z`, com entrada no `CHANGELOG.md`.

<!-- Nenhuma skill mudou e nenhum pino avança: "Versão e pinos sem mudança.", no lugar deste texto e da tabela. -->

| Fonte | `lastAbsorbed` antes | `lastAbsorbed` agora |
|---|---|---|
| `fonte` | `from` | `to` |

🤖 Generated with [Claude Code](https://claude.com/claude-code)
