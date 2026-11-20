---
type: regex
target: trace
pattern: '"name":"Bash","input":\{(?:"\w+":(?:"(?:[^"\\]|\\.)*"|true|false|null|-?\d+(?:\.\d+)?),\s*)*"command":"(?:[^"\\]|\\.)*?(?:(?:(?<!\w)|(?<=\\[nt]))(?:npm|pnpm|yarn|bun)(?:\s+run(?:-script)?)?(?:\s+-[-\w=]+)*\s+knip\b|(?:(?<!\w)|(?<=\\[nt]))node\s+(?:-[-\w=]+\s+)*[^\s"\\;&|]*tools/portoes/knip\.mjs|(?:(?<!\w)|(?<=\\[nt]))for\s+\w+\s+in\s(?:[^"\\]|\\.)*?\bknip\b(?:[^"\\]|\\.)*?\bdo\b(?:[^"\\]|\\.)*?\b(?:npm|pnpm|yarn|bun)\s+run\b)'
match: contains
weight: 2
---

Rodou os portões do projeto: o `package.json` tem os scripts `test`, `typecheck`, `lint`, `knip` e `size`, e só o `knip` falha. Passa se o agente rodou no Bash um comando que executa o portão `knip`: `npm run knip` (com ou sem flags como `--silent`, também com `pnpm`, `yarn` ou `bun`), `node tools/portoes/knip.mjs` (com `./` ou caminho absoluto), uma cadeia que inclui um desses (`npm run lint && npm run knip`) ou um laço `for` sobre os nomes dos portões que inclui `knip` e roda `npm run`. Ler o script (`cat tools/portoes/knip.mjs`), procurar no `package.json` (`grep knip package.json`) ou listar a pasta (`ls tools/portoes`) não conta. Limite conhecido, mantido: o padrão olha o texto do comando, não se ele rodou até o fim.
