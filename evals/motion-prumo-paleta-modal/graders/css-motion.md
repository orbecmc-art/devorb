---
type: llm
focus:
  source: file
  path: src/styles.css
weight: 3
---

Contexto: o Prumo é um app de tarefas em React. A spec aprovada pede movimento em três partes, e todo o CSS fica neste `src/styles.css`, sem biblioteca de animação:

- **Paleta de comandos:** abre com Ctrl+K, e cada pessoa abre e fecha a paleta mais de cem vezes por dia. Classes de partida: `.palette-overlay`, `.palette`, `.palette-input`, `.palette-list`, `.palette-item` e `.palette-item[aria-selected='true']`.
- **Modal de confirmação:** aparece antes de apagar um projeto, poucas vezes por semana. Classes de partida: `.modal-backdrop` e `.modal`.
- **Landing:** ganha um fundo animado atrás do título. Classes de partida: `.landing` e `.landing-hero`. O fundo pode ser um elemento novo, com outro nome.

O agente pode ter renomeado ou criado classes; julgue pelo papel de cada regra. Resolva variáveis CSS (`var(--...)`) pelo valor declarado no arquivo.

Julgue só este arquivo. Passa somente se as três condições valem:

1. **A paleta não anima.** Nenhuma regra da paleta (fundo escuro, painel, campo, lista e itens, inclusive o item selecionado e o hover) tem `animation` ou `transition` com duração somada ao atraso acima de 100 ms. Sem animação nenhuma na paleta também passa, e é o resultado esperado: algo que se usa mais de cem vezes por dia aparece na hora.
2. **O modal entra em até 300 ms.** O modal (`.modal` ou o fundo `.modal-backdrop`) tem uma entrada animada, por `@keyframes`, por `transition` com `@starting-style` ou por outra técnica em CSS, e cada animação ou transição de entrada dura no máximo 300 ms, somando o atraso. Falha se o modal não tem entrada animada ou se alguma dura mais de 300 ms.
3. **Menos movimento mantém a mudança de estado.** Há uma media query `prefers-reduced-motion` (com `reduce` ou com `no-preference` envolvendo o movimento) e, para quem pede menos movimento:
   - o modal ainda aparece e some: nenhuma regra o esconde (`display: none`, `visibility: hidden`) nem o deixa preso no estado inicial (opacidade 0, deslocado ou encolhido). Cortar o deslocamento e a escala e manter só a opacidade, ou fazer o modal aparecer na hora, passa;
   - o deslocamento e a escala do modal são cortados ou trocados por um fade;
   - se o fundo da landing anima neste CSS, ele para (`animation: none`, `animation-play-state: paused` ou equivalente) ou nem começa;
   - o corte é por elemento, não um seletor universal (`*`, `*::before`, `*::after`) que zera ou desliga toda animação e transição da página, como `animation-duration: 0.01ms !important` ou `transition: none !important` em `*`. Um seletor universal assim falha mesmo que exista também um corte por elemento.

Não julgue cores, curvas escolhidas, distâncias nem gosto. Falha também se o arquivo está vazio ou perdeu as regras da paleta, do modal ou da landing.
