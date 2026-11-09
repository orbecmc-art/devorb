---
type: llm
focus: files
---

`skills/debugging/SKILL.md` continua dentro do `ceilingTokens` de `debugging` em `fusion/skills.json`, estimando tokens como bytes ÷ 4 (o texto final da skill, em caracteres, dividido por 4, não passa do teto). Para caber, o agente enxugou texto ou moveu parte dele para `references/`, sem estourar o teto nem alterar o teto para acomodar o texto. A regra própria "procurar todos os outros chamadores com o mesmo padrão antes de corrigir" continua na skill.
