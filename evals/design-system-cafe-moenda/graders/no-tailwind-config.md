---
type: regex
target: trace
pattern: '"name":"(?:Write|Edit|MultiEdit)","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"file_path":"(?:[^"]*/)?tailwind\.config\.[cm]?[jt]s"|(?:(?<![=-])>>?|\btee(?: -a)?) ?(?:\\?["''])?(?:[^\s"''\\<>|;&]*/)?tailwind\.config\.[cm]?[jt]s'
match: not_contains
---

Nenhum `tailwind.config` novo. No Tailwind 4 os tokens ficam em `@theme` no CSS, e o arquivo de configuração é coisa da v3. Falha se o trace mostra um Write, Edit ou MultiEdit em um arquivo `tailwind.config.js`, `.cjs`, `.mjs`, `.ts`, `.cts` ou `.mts`, ou um `>`, `>>` ou `tee` para um desses arquivos no Bash. Ler, listar ou procurar o arquivo não conta.
