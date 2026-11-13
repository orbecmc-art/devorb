---
type: regex
target:
  source: file
  path: package.json
pattern: '"sonner"\s*:\s*"'
match: contains
---

O aviso da newsletter vem do especialista da lista, não de um componente feito à mão. Passa se `package.json` declara a dependência `sonner` (o toast que o shadcn/ui usa). O ambiente não tem rede, então basta a dependência estar escrita em `package.json`.
