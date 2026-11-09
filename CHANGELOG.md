# Changelog

## 0.1.6

- Registro de progresso sem as linhas que ainda tratavam o setor de design como à espera do merge.

## 0.1.5

- Setor de design na spec e no plano `docs/plans/2026-11-09-devorb-design.md`: cinco skills planejadas (`visual-direction`, `design-system`, `motion`, `ui-review` e `diagram`, esta manual), marcadas com `"sector": "design"` no registro. Nenhuma foi escrita ainda.
- Nove fontes novas, só como ideias: Impeccable, Hallmark, taste-skill, `frontend-design`, as skills do Emil Kowalski, `scroll-craft`, Paper Shaders, `diagram-design` e UI UX Pro Max. ECC e gstack acompanham mais caminhos de design.
- Testes: nenhuma fonte acompanha código, a Impeccable acompanha a fonte e não as cópias geradas, e uma skill de design só entra em `using-devorb` quando estiver pronta.

## 0.1.4

- Duas fontes novas em `fusion/sources.json`, só como ideias: 7 skills do ECC (antigo `everything-claude-code`) e 8 arquivos do gstack. Elas alimentam as fusões de `aligning`, `planning`, `debugging`, `verifying`, `browser-testing`, `reviewing`, `finishing` e `handoff`. Nenhuma skill nova: o registro continua com 18.
- Testes garantem que o gstack acompanha arquivos de origem, nunca o `SKILL.md` gerado, pasta ou código, e que as duas fontes só emprestam ideias.
- Spec, plano e registro de progresso atualizados, com as candidatas ao projeto de design e sem as linhas que ainda tratavam o merge do ciclo mensal como pendente.

## 0.1.3

- `fusion/routine-prompt.md`, o prompt da execução mensal, e a explicação do ciclo no `README.md`.
- Casos `evals/evolving-*`, com uma fonte de exemplo que traz uma melhoria real, instruções embutidas, um hook novo e uma mudança que contradiz uma regra própria.
- `tools/source-diff.mjs` compara cada fonte com o último commit absorvido, só nos caminhos acompanhados, e aponta skills novas, hooks, scripts, nomes de arquivo estranhos e caminhos que sumiram. Ele só lê objetos do git, sem extrair nem executar nada da fonte, e `--show` e `--diff` leem um arquivo por índice, para o nome dele nunca chegar a um shell. Histórico reescrito aparece como `sha-missing`.
- Skill `evolving`, manual: a revisão mensal das fontes. Classifica as mudanças, funde as ideias adotadas dentro dos tetos e escreve o pull request em português pelo modelo em `references/pr-template.md`, com hooks, scripts, nomes estranhos e instruções embutidas em destaque no topo, citados em blocos cercados. A mensagem final começa com uma linha de status, e `PARCIAL` ou `FALHOU` abrem uma issue. Há uma revisão por vez, e fonte que só alimenta skills `planned` não avança o pino nem gera pull request. Versão nova e pull request só existem quando uma skill muda ou um pino avança. O agendamento ainda não está ligado.
- `fusion/pr-draft.md` no `.gitignore`.

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
