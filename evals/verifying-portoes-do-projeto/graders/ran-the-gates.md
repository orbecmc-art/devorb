---
type: regex
target: trace
pattern: '"name":"Bash","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"command":"(?:[^"\\]|\\.)*?(?<=(?:"command":"|\\n|[;&|(]|\bthen|\bdo)\s*(?:[A-Za-z_]\w*=[^\s"\\]*\s+)*(?:(?:time|node|exec)\s+)?)(?:(?:npx|bunx)(?:\s+-[-\w=]+)*\s+knip|(?:pnpm|yarn)(?:\s+(?:exec|dlx|run))?\s+knip|npm\s+(?:exec|x|run)(?:\s+-[-\w=]+)*\s+(?:--\s+)?knip|(?:[^\s"\;&|]*/)?node_modules/\.bin/knip)(?![\w.-])'
match: contains
weight: 2
---

Rodou o portão de código morto: o projeto tem `knip` nas `devDependencies`, um `knip.json` na raiz e o executável em `node_modules/.bin/knip`, mas nenhum script `knip` no `package.json`; só ele falha. Passa se o agente rodou no Bash um comando que executa o `knip`, no começo do comando ou depois de `;`, `&&`, `||`, `|`, `(`, quebra de linha, `then` ou `do` (com variáveis de ambiente antes, como `CI=1`, e opcionalmente depois de `time`, `node` ou `exec`): `npx knip` (com flags como `--no-install`), `bunx knip`, `npm exec knip`, `npm x knip`, `npm run knip` (se o agente criou o script), `pnpm knip`, `yarn knip`, ou o caminho `node_modules/.bin/knip` (com `./` ou caminho absoluto). Ler a configuração (`cat knip.json`), listar os executáveis (`ls node_modules/.bin`), procurar no `package.json` (`grep knip package.json`) ou citar o comando dentro de um texto (`echo "npx knip"`) não conta. Limite conhecido, mantido: o padrão olha o texto do comando, não se ele rodou até o fim.
