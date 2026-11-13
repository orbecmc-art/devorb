---
type: regex
target:
  source: file
  path: docs/login-flow.svg
pattern: '<title\b'
flags: i
match: contains
---

O diagrama tem nome acessível. Passa se `docs/login-flow.svg` tem um elemento `<title>`. Falha se o arquivo não existe ou não tem `<title>`.
