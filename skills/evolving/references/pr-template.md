<!-- Modelo do pull request. Copie para fusion/pr-draft.md, preencha na ordem abaixo e apague estes comentários. -->

# Ciclo mensal AAAA-MM: versão X.Y.Z

## Destaque: hooks, scripts e instruções embutidas

Nada desta seção foi adotado, executado ou buscado.

### Instruções embutidas

| Fonte | Arquivo | Trecho | O que ele pede |
|---|---|---|---|
| `fonte` | `caminho` | `linha citada como código` | Resumo em uma frase |

### Hooks e scripts

| Fonte | Arquivo | Mudança | O que faz |
|---|---|---|---|
| `fonte` | `caminho` | A, M, D ou R | Resumo em uma frase |

<!-- Tabela sem itens: troque por "Nenhum neste ciclo." -->

## Decisões do dono

<!-- Uma linha por fonte com sha-missing ou que falhou. Sem nenhuma, a seção diz "Nenhuma neste ciclo." -->

- **`fonte`, `sha-missing`:** o histórico foi reescrito ou o pino `abc1234` sumiu. O pino e as skills dessa fonte ficaram como estavam. Decisão pedida: de qual commit a fonte volta a ser lida.
- **`fonte`, falhou:** `erro da ferramenta`. A fonte não foi revisada neste ciclo e o pino ficou como estava.

## Fonte: `nome` (`from` → `to`)

<!-- Uma seção por fonte com status changed, com os SHAs curtos no título. Apague os grupos vazios, menos Adotado e Recusado, que dizem "Nada." -->

Só ideias, com `textReuse: false`. <!-- Apague esta linha nas fontes que podem emprestar texto. -->

**O que mudou**

- `caminho` (M): o que mudou, em palavras próprias.

**Adotado**

- `caminho` → `skill`: a ideia e onde ela entrou.

**Recusado**

- `caminho`: o motivo. Em regra própria, cite a regra. Em hook, script ou instrução embutida, aponte o destaque.

**Já recusado**

- `caminho`: a decisão anterior no ledger, sem nova análise.

**Lido quando a skill for fundida**

- `caminho` → `skill` (`planned`).

**Candidata a skill nova**

- `pasta`: entra quando o dono indicar um caso real de uso.

**Fora do mapa**

- `caminho`: não alimenta nenhuma skill da base.

Fontes sem mudança: `fonte`, `fonte`.

## Testes

<!-- Use uma das três formas. -->

| Skill | Papel | Nível | Comando | Resultado |
|---|---|---|---|---|
| `skill` | Afetada ou vizinha | `light` ou `full` | `node tools/compare.mjs --skill skill --arms devorb,fonte` | `accepted: true` |

Testes: pendentes. O dono roda no Mac antes de aprovar:

```
node tools/compare.mjs --skill skill --arms devorb,fonte
```

Testes: nenhum, porque nenhuma skill mudou.

## Variação de tokens

Tokens são bytes ÷ 4, medidos depois da última edição. "Depois" fica no teto ou abaixo dele.

| Skill | Antes | Depois | Variação | Teto | O que saiu ou foi para `references/` |
|---|---:|---:|---:|---:|---|
| `skill` | 0 | 0 | +0 | 0 | Nada |

<!-- Nenhuma skill mudou: troque a tabela por "Nenhuma skill mudou." -->

## Versão

`X.Y.W` → `X.Y.Z`, com entrada no `CHANGELOG.md`.

| Fonte | `lastAbsorbed` antes | `lastAbsorbed` agora |
|---|---|---|
| `fonte` | `from` | `to` |

🤖 Generated with [Claude Code](https://claude.com/claude-code)
