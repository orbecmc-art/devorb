---
type: regex
target: trace
pattern: '"name":"(?:Write|Edit)","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),)*"file_path":"[^"]*task-\d+-report\.md"(?:,"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?))*?,"(?:content|new_string)":"(?:[^"\\]|\\.)*?Mirror: rounds \d+/3|"command":\s*"(?:[^"\\]|\\.)*?>>?\s*[^\s"\\]*task-\d+-report\.md(?:[^"\\]|\\.)*?Mirror: rounds \d+/3'
match: contains
---

O relatório do implementador traz o campo do espelho. Passa se, no rastro inteiro (subagentes incluídos), uma escrita de um arquivo `task-<n>-report.md` traz `Mirror: rounds <número>/3`: um Write cujo `content`, ou um Edit cujo `new_string`, tem a linha, ou um comando do Bash que redireciona para esse arquivo com a linha no texto. A linha só citada no prompt, no texto de uma skill ou numa leitura do relatório não conta, e o modelo `Mirror: rounds <n>/3`, sem número, também não. `Mirror: not run (` não passa: o espelho tem de rodar (decisão do dono, 2026-11-18). Falha se nenhum relatório escrito tem o campo.
