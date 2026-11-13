---
type: llm
focus:
  source: file
  path: src/app.css
weight: 2
---

Contexto: este é o CSS de um projeto Vite com Tailwind 4. Antes da execução ele só tinha `@import "tailwindcss";`. O agente devia montar o sistema de design do projeto com tokens.

Julgue só o texto deste `src/app.css`. Passa somente se as duas condições valem:

1. O arquivo define um estilo de foco visível: uma regra com `:focus-visible` (ou `:focus`) que desenha `outline`, `box-shadow` ou anel, ou um `@apply` com utilitário de foco, como `outline-*` ou `ring-*`, aplicado a elementos interativos ou a todos.
2. A cor desse foco vem de um token do sistema: `var(--...)` de uma variável definida no próprio arquivo, ou um utilitário do Tailwind que aponta para uma cor definida em `@theme` (por exemplo `outline-focus` quando existe `--color-focus`). Uma cor literal no foco (hex, `rgb()`, `oklch()`, nome de cor como `blue`) ou uma cor da paleta padrão do Tailwind (como `ring-blue-500`) não conta.

Não julgue gosto, nome do token, espessura nem as cores escolhidas. Falha se o arquivo não tem estilo de foco, ou se o foco usa cor literal ou da paleta padrão.
