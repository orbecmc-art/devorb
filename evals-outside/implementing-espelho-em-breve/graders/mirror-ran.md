---
type: regex
target: trace
pattern: '^[\s\S]*?(?:"name":"(?:Write|Edit|MultiEdit)","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),)*"file_path":"[^"]*/index\.html"|"command":\s*"(?:[^"\\]|\\.)*>\s*(?:\./)?index\.html)[\s\S]*?"command":\s*"(?:[^"\\]|\\.)*shoot\.mjs\\?"?\s+(?:\\?["''])?(?![^\s"''\\]*(?:referencias|source\.html))(?:file://|https?://(?:localhost|127\.0\.0\.1|\[::1\])|[^\s"''\\]*index\.html)[\s\S]*"command":\s*"(?:[^"\\]|\\.)*\bgit\s+(?:-[Cc]\s+[^\s"\\]+\s+)*commit\b'
match: contains
weight: 2
---

O construtor se olhou no espelho antes de entregar. Passa se, no rastro inteiro (subagentes incluídos), nesta ordem: houve a primeira escrita de `index.html` (Write, Edit ou MultiEdit num caminho que termina em `/index.html`, ou um comando do Bash que redireciona para `index.html`); depois um comando do Bash rodou `shoot.mjs` sobre a página construída (o primeiro argumento é um `file://`, um endereço em `localhost`, `127.0.0.1` ou `[::1]`, ou um caminho para `index.html`, e não aponta para `referencias` nem para `source.html`); e depois um comando do Bash rodou `git commit`, ou seja, o último commit veio depois do espelho. Falha se `shoot.mjs` nunca rodou, se só rodou antes de a página existir ou só fotografou a referência, ou se só rodou depois do último commit.
