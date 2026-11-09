# Changelog

## 0.1.2

- Quatro fontes novas em `fusion/sources.json`, acompanhando só as pastas escolhidas: Karpathy, `webapp-testing` da Anthropic, Trail of Bits e Spartan.
- `textReuse: false` marca as fontes das quais só entram ideias, escritas com palavras próprias. Fonte que empresta texto precisa de `licenseFile`, e a licença Apache 2.0 do `webapp-testing` entrou em `LICENSES/`.
- Skill `browser-testing` no registro, ainda planejada. A base passa de 17 para 18 skills.
- `using-devorb` ganha essa skill na tabela de etapas e fica com a descrição mais curta. Pular etapa agora depende de o nível 1 da precedência dizer isso explicitamente, o que inclui instruções do projeto.

## 0.1.1

- Verificador de skills (`tools/check-skills.mjs`), que roda dentro de `npm test`.
- Hook de início de sessão, compatível com Mac e Windows, que injeta a skill `using-devorb` em toda sessão.
- Skill `using-devorb`: a regra de checar skills antes de responder, a precedência, a tabela de etapas e as referências de nomes antigos, fronteiras de fase e notas do Claude Code.

## 0.1.0

- Estrutura inicial do repositório: manifestos do plugin e do marketplace, registro das 17 skills da base, fontes fixadas por commit e licenças MIT do Superpowers e das skills do Matt Pocock.
