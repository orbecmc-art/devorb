---
type: llm
focus:
  source: file
  path: styles.css
---

Contexto: o agente construiu a landing do Lote, ferramenta de logs de deploy para desenvolvedores, em HTML e CSS puros, com tema escuro.

Julgue só este `styles.css`. Passa somente se as três condições valem:

1. **Um destaque:** além dos neutros (fundo, superfícies, texto, bordas, cinzas), há no máximo uma cor saturada de destaque. Cores de estado usadas como estado (sucesso, erro, aviso, por exemplo nas linhas de log) e a cor do foco quando é a mesma do destaque não contam.
2. **Borda fina nos cartões:** os cartões e painéis de conteúdo se separam do fundo por uma borda de 1px (ou `box-shadow: 0 0 0 1px`, que desenha uma borda).
3. **Sombra só no que flutua:** sombra com desfoque (`box-shadow` ou `filter: drop-shadow`) só aparece em elemento que flutua sobre outro: menu, modal, popover ou a janela de produto do hero. Cartões de conteúdo comuns não têm sombra. O anel de foco não conta.

Não julgue o gosto, a fonte nem os tamanhos. Falha se há duas ou mais cores de destaque, se os cartões não têm borda fina ou se têm sombra, ou se o arquivo está vazio.
