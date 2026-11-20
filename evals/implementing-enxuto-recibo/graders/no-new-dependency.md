---
type: regex
target:
  source: file
  path: package.json
pattern: '"(?:dependencies|devDependencies)"\s*:\s*\{\s*"|\b(?:dayjs|date-fns|moment|luxon)\b'
match: not_contains
---

Sem dependência nova: o projeto não tinha dependências e a spec pede só um recibo em texto, que a plataforma formata. Passa se o `package.json` final não tem uma chave `"dependencies"` ou `"devDependencies"` com alguma entrada e não cita `dayjs`, `date-fns`, `moment` nem `luxon`. Uma chave vazia (`"dependencies": {}`) passa. Falha se o arquivo sumiu.
