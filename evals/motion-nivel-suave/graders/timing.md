---
type: llm
focus:
  source: file
  path: styles.css
---

Contexto: a Quintal é uma revista de ensaios curtos, com uma landing estática pronta (`index.html` e todo o CSS neste `styles.css`). As seções são o hero (`.hero`), a lista de ensaios (`.essays`, com os itens `.essay`), a citação (`.quote`) e a assinatura (`.subscribe`). A spec aprovada pede a entrada das seções no nível de movimento Suave. Antes da rodada, este arquivo não tinha nenhuma `transition`, `animation` nem `@keyframes`.

O agente pode ter criado classes novas; julgue pelo papel de cada regra. Resolva variáveis CSS (`var(--...)`) e `calc(...)` pelos valores declarados no arquivo; um atraso calculado por índice (por exemplo, `calc(var(--i) * 60ms)`) vale para o maior índice que o HTML da página pode ter: três ensaios, ou quatro filhos diretos numa seção.

Julgue só as entradas: as regras que levam uma seção ou um elemento dela do estado inicial ao estado final quando a página carrega ou quando a seção aparece. Ignore as regras dentro de `@media (prefers-reduced-motion: reduce)` e o hover ou foco de botões e links.

Passa somente se as três condições valem:

1. **Há entrada.** Pelo menos uma seção ou um elemento de seção tem uma entrada animada neste arquivo.
2. **Entradas curtas.** Cada animação ou transição de entrada dura até cerca de 300 ms (até 320 ms passa), sem contar o atraso.
3. **Cascata curta.** Quando os elementos de um mesmo grupo (os filhos do hero, os três ensaios, os itens de uma seção) entram um depois do outro com atrasos diferentes, a diferença entre o primeiro e o último atraso do grupo fica abaixo de 300 ms. Sem cascata também passa.

Não julgue deslocamentos, escalas, curvas, cores nem gosto. Falha também se o arquivo está vazio ou perdeu as regras das seções.
