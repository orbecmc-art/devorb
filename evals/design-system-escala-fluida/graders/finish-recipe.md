---
type: llm
focus:
  source: file
  path: DESIGN.md
---

Contexto: o agente montou o sistema de design da landing de uma ferramenta de devtools, em modo Persuade, tema escuro. Antes da execução não havia `DESIGN.md`.

Julgue só o texto deste `DESIGN.md`. Passa somente se as quatro condições valem:

1. **Um destaque:** além dos neutros (fundo, superfícies, texto, bordas, cinzas), há uma só cor de destaque. Cores de estado (sucesso, erro, aviso) e a cor do foco quando é a mesma do destaque não contam como um segundo destaque.
2. **Borda, não sombra:** os cartões se separam do fundo por uma borda fina (1px, ou uma linha de borda sem espessura maior), não por sombra. Uma sombra só em elemento flutuante (menu, modal) não conta contra.
3. **Folga de seção:** o espaço vertical entre seções, na tela larga, fica entre 96 e 160px (ou o equivalente em rem, com 1rem = 16px).
4. **Raio:** o raio dos cartões e botões fica entre 4 e 8px. Um raio cheio (pílula) só em etiqueta pequena não conta contra.

Cada valor precisa estar ligado ao seu uso (seção, cartão ou botão); um número solto numa escala, sem uso, não conta. Não julgue os nomes de token nem as cores escolhidas. Falha se há duas ou mais cores de destaque, se os cartões usam sombra no lugar da borda, se a folga de seção ou o raio não estão no arquivo ou caem fora da faixa.
