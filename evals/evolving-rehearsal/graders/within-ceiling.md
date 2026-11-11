---
type: llm
focus:
  source: file
  path: skills/debugging/SKILL.md
---

O ensaio cria `fusion/skills.json` com `ceilingTokens` 169 para `debugging`. `skills/debugging/SKILL.md` continua dentro desse teto, estimando tokens como bytes ÷ 4 (o texto final da skill, em caracteres, dividido por 4, não passa de 169; ou seja, no máximo 676 caracteres). Para caber, o agente enxugou texto ou moveu parte dele para `references/`. A regra própria "procurar todos os outros chamadores com o mesmo padrão antes de corrigir" continua na skill.
