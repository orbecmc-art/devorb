---
type: llm
focus:
  source: file
  path: src/Landing.jsx
weight: 2
---

Contexto: o Prumo é um app de tarefas em React. A spec aprovada pede um fundo animado e discreto atrás do título e do botão de cadastro da landing, com tudo da landing em `src/Landing.jsx` e o CSS em `src/styles.css`, sem dependência nova. Antes da rodada, este arquivo tinha um `<main className="landing">` com uma `<section className="landing-hero">` contendo o título "Tarefas da equipe num lugar só", um parágrafo e o link "Criar conta grátis" para `/app`. Um fundo feito só em CSS (gradiente, SVG ou pseudo-elemento animado) pode não mudar nada neste arquivo, ou acrescentar um elemento decorativo.

Julgue só este arquivo. Passa somente se as duas condições valem:

1. **A landing continua inteira.** O título, o parágrafo e o link "Criar conta grátis" para `/app` seguem na página.
2. **O fundo funciona sem WebGL2.** Vale um dos dois casos:
   - **Sem WebGL:** o arquivo não usa WebGL nem shader. Não há `<canvas>` com `getContext('webgl')` ou `getContext('webgl2')`, nem import de biblioteca de WebGL ou shader (`three`, `@react-three/fiber`, `ogl`, `regl`, `pixi.js`, `@paper-design/shaders-react` ou parecida). Um `<canvas>` com contexto `2d` também conta como sem WebGL.
   - **Com WebGL:** o arquivo confere se o navegador tem WebGL2 (por exemplo, `getContext('webgl2')` dentro de `try`/`catch`, ou um teste de suporte antes de montar o shader) e, quando não tem, mostra um fundo estático em CSS no lugar do shader, sem quebrar a página. Além disso, quem pede menos movimento (`prefers-reduced-motion`) recebe o fundo parado ou o fundo estático.

Falha se o fundo usa WebGL ou shader sem esse teste de suporte e sem fundo estático, ou se o fundo vem de um componente importado de outro arquivo local, cujo código não dá para conferir aqui (a spec pede o fundo neste arquivo).

Não julgue a aparência do fundo, cores nem gosto.
