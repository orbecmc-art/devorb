---
type: regex
target: trace
pattern: '"name":\s*"(?:Agent|Task)",\s*"input":\s*\{(?:"\w+":\s*(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"\w+":\s*"(?:[^"\\]|\\.)*?critique\.md'
match: contains
---

A crítica vem de olhos novos. Passa se, no rastro, o agente chamou a ferramenta de subagente (`Agent`, ou `Task` no nome antigo) e algum campo da chamada (a descrição ou o prompt) cita o arquivo `critique.md`, a régua do crítico. Ler `critique.md` sozinho, sem despachar um subagente com ele, falha.
