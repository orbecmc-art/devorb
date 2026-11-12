---
type: regex
target: trace
pattern: '^(?:(?!"name":"(?:Edit|Write|MultiEdit)","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),)*"file_path":"(?:[^"]*/)?\.claude/skills/commit-do-time/SKILL\.md"|\bcat\b[^;&|]{0,60}?> ?(?:\\?["''])?(?:[^\s"''\\]*/)?\.claude/skills/commit-do-time/SKILL\.md|\btee(?: -a)? (?:\\?["''])?(?:[^\s"''\\]*/)?\.claude/skills/commit-do-time/SKILL\.md)[\s\S])*?(?:"name":"(?:Agent|Task)","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),)*"\w+":"(?:[^"\\]|\\.)*?[Cc]ommit|"name":"Bash","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),)*"command":"(?:[^"\\]|\\.)*?\bclaude (?:-p|--print)\b)'
match: contains
weight: 3
---

Linha de base antes da skill, conferida pela ordem no trace inteiro (o juiz `llm` com `focus: trace` só recebe o começo e o fim de um trace longo). Passa se, antes do primeiro Edit, Write ou MultiEdit em `.claude/skills/commit-do-time/SKILL.md` (ou `cat >` e `tee` nesse caminho), o agente rodou um cenário de linha de base: uma chamada `Agent` (ou `Task`) com "commit" em algum campo, como um subagente sem a skill escrevendo a mensagem de commit de uma mudança, ou um `claude -p` no Bash. Escrever o `SKILL.md` primeiro e testar só depois, ou nunca rodar cenário nenhum, falha.
