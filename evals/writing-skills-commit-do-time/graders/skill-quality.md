---
type: llm
focus:
  source: file
  path: .claude/skills/commit-do-time/SKILL.md
weight: 2
---

Contexto: o projeto é o backoffice de uma loja em Node. O `CONTRIBUTING.md` define o padrão de commit do time:

- primeira linha `<tipo>(<área>): <resumo>`, com no máximo 60 caracteres;
- `tipo` é um de `novo`, `corrige`, `ajusta`, `testes`, `docs` ou `infra`;
- `área` é a pasta de `src/` tocada (`pedidos`, `estoque` ou `pagamentos`), ou `geral` quando a mudança toca mais de uma área ou fica fora de `src/`;
- `resumo` no imperativo, em português, com letra minúscula no começo e sem ponto final;
- linha em branco, depois um corpo que explica o porquê, com linhas de até 72 caracteres;
- última linha `Ticket: LOJA-<número>`, ou `Ticket: nenhum` sem ticket;
- sem emoji e sem `[WIP]`.

O arquivo julgado é a skill `.claude/skills/commit-do-time/SKILL.md` que o agente escreveu. Passa somente se todos estes pontos valem:

1. Tem frontmatter YAML com `name: commit-do-time` e uma `description` que começa com "Use when" e diz quando usar a skill (por exemplo, ao escrever ou revisar uma mensagem de commit neste repositório), sem resumir o passo a passo.
2. O corpo segue o padrão acima sem contradizê-lo: os seis tipos com esses nomes, a regra da área com `geral`, o limite de 60 caracteres, o resumo no imperativo e minúsculo sem ponto, o corpo com o porquê e o rodapé `Ticket:` nas duas formas. Pode remeter ao `CONTRIBUTING.md` para detalhes, desde que as regras acima apareçam ou fiquem a um ponteiro claro de distância.
3. O corpo é curto: até cerca de 400 palavras, sem repetir o `CONTRIBUTING.md` inteiro nem explicar o que é um commit.
4. O tom é positivo: as instruções dizem o que fazer. Uma ou duas proibições pontuais são aceitáveis; listas de "NUNCA", tabelas de desculpas ou avisos em caixa alta não são.

Falha se a `description` não começa com "Use when" ou só descreve o que a skill faz, se algum tipo, a área `geral`, o limite de 60 caracteres ou o rodapé `Ticket:` falta ou está errado (por exemplo, tipos do Conventional Commits como `feat` e `fix`), se o corpo é longo ou se é escrito principalmente por proibições.
