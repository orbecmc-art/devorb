---
type: llm
focus:
  source: file
  path: app/globals.css
weight: 3
---

Contexto: projeto Next com shadcn/ui. Antes da execução, este `app/globals.css` tinha o tema padrão neutro do shadcn/ui, em que toda cor, menos `--destructive`, é um cinza sem croma (`oklch(L 0 0)`). Os valores padrão eram:

- Em `:root`: `--background: oklch(1 0 0)`, `--foreground: oklch(0.145 0 0)`, `--card: oklch(1 0 0)`, `--card-foreground: oklch(0.145 0 0)`, `--popover: oklch(1 0 0)`, `--popover-foreground: oklch(0.145 0 0)`, `--primary: oklch(0.205 0 0)`, `--primary-foreground: oklch(0.985 0 0)`, `--secondary`, `--muted` e `--accent: oklch(0.97 0 0)`, `--secondary-foreground` e `--accent-foreground: oklch(0.205 0 0)`, `--muted-foreground: oklch(0.556 0 0)`, `--border` e `--input: oklch(0.922 0 0)`, `--ring: oklch(0.708 0 0)`.
- Em `.dark`: `--background: oklch(0.145 0 0)`, `--foreground: oklch(0.985 0 0)`, `--card` e `--popover: oklch(0.205 0 0)`, `--primary: oklch(0.922 0 0)`, `--primary-foreground: oklch(0.205 0 0)`, `--secondary`, `--muted` e `--accent: oklch(0.269 0 0)`, `--muted-foreground: oklch(0.708 0 0)`, `--border: oklch(1 0 0 / 10%)`, `--input: oklch(1 0 0 / 15%)`, `--ring: oklch(0.556 0 0)`.

A spec aprovada pede uma direção própria (papel amarelado, tinta azul-escura de carimbo, tecido verde desbotado), tema claro e escuro, e manda montar o sistema de design.

Julgue só o texto deste `app/globals.css`. Passa somente se as três condições valem:

1. **Claro trocado.** No tema claro (`:root`, ou onde o arquivo agora define o tema claro), `--primary` não tem mais o valor padrão, e a maioria das outras variáveis de cor listadas acima também mudou de valor. Valor escrito em outro formato (hex, `hsl()`, `var()` para um token do projeto) conta como mudado quando a cor resultante não é o mesmo cinza padrão; um `var()` para um token do projeto conta como mudado.
2. **Escuro trocado.** Se o arquivo tem tema escuro (`.dark` ou `prefers-color-scheme: dark`), o `--primary` dele também não é o padrão `oklch(0.922 0 0)` e a maioria das outras cores dele mudou. Se o arquivo não tem mais tema escuro nenhum, falha.
3. **Componentes não quebram.** As variáveis que os componentes do shadcn/ui usam (`--background`, `--foreground`, `--primary`, `--primary-foreground`, `--muted-foreground`, `--border`, `--input`, `--ring` e as `--color-*` do `@theme inline`) continuam existindo, com o valor novo ou apontando para os tokens novos.

Não julgue as cores escolhidas nem se combinam com a direção. Falha se o arquivo continua com o tema padrão, se só o `--radius` ou a fonte mudaram, ou se só uma ou duas cores mudaram e o resto ficou no cinza padrão.
