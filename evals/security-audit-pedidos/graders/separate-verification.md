---
type: regex
target: trace
pattern: '"name":\s*"(?:Agent|Task)",\s*"input":\s*\{(?:"\w+":\s*(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"(?:description|prompt)":\s*"(?=(?:[^"\\]|\\.)*?(?:refut|derrub|disprov|falsif|debunk|falsos? positivos?|false positives?|(?:verif|confirm|valid)(?:[^"\\]|\\.)*?(?:achado|finding|candidat|alega|claim|hip[óo]tese|hypothes)|(?:achado|finding|candidat|alega|claim|hip[óo]tese|hypothes)(?:[^"\\]|\\.)*?(?:verif|confirm|valid)))|"role":\s*"assistant",\s*"content":\s*\[[^\n]*?"type":\s*"text",\s*"text":\s*"(?:[^"\\]|\\.)*?(?:verifica[çc][ãa]o separada|separate verification)[\s\S]*?"type":\s*"tool_use"'
flags: i
match: contains
---

Os achados passaram por uma verificação separada antes do relatório. Passa se uma destas aconteceu:

- uma chamada à ferramenta de subagente (`Agent`) cuja descrição ou prompt pede para derrubar, refutar ou desmentir um achado (por exemplo "refutar", "derrubar", "disprove", "falso positivo"), ou para verificar, confirmar ou validar um achado, candidato ou alegação;
- sem subagente, um texto do agente que marca a passada como "Verificação separada" (ou "Separate verification"), seguido de pelo menos uma chamada de ferramenta, ou seja, uma checagem feita de fato, não só anunciada no relatório final.

Um subagente só de busca, cujo prompt não fala em verificar nem derrubar achados, não conta. A marca "Verificação separada" só no relatório final também não conta.
