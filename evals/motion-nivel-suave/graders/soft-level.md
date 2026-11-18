---
type: llm
focus:
  source: file
  path: styles.css
weight: 3
---

Contexto: a Quintal é uma revista de ensaios curtos, com uma landing estática pronta (`index.html` e todo o CSS neste `styles.css`). As seções são o hero (`.hero`), a lista de ensaios (`.essays`, com os itens `.essay`), a citação (`.quote`) e a assinatura (`.subscribe`). A spec aprovada pede a entrada das seções no nível de movimento Suave. Antes da rodada, este arquivo não tinha nenhuma `transition`, `animation` nem `@keyframes`.

O agente pode ter criado classes novas (por exemplo, uma classe que um script põe quando a seção aparece); julgue pelo papel de cada regra. Resolva variáveis CSS (`var(--...)`) pelo valor declarado no arquivo. Converta `rem` e `em` para px a 16px.

Julgue só as entradas: as regras que levam uma seção ou um elemento dela do estado inicial ao estado final quando a página carrega ou quando a seção aparece. Ignore as regras dentro de `@media (prefers-reduced-motion: reduce)` e o hover ou foco de botões e links.

Passa somente se as quatro condições valem:

1. **Há entrada.** Pelo menos uma seção ou um elemento de seção tem uma entrada animada neste arquivo (`@keyframes`, `transition` entre um estado inicial e um final, `@starting-style` ou `animation-timeline: view()`).
2. **Toda entrada é fade com deslocamento curto.** Cada entrada muda a opacidade e desloca o elemento de 4 a 12 px no máximo, em qualquer direção (`translate`, `translateY`, `translate3d` ou a propriedade `translate`). Um deslocamento acima de 12 px ou abaixo de 4 px falha; um só fade, sem deslocamento, também falha.
3. **Sem escala nem rotação.** Nenhuma entrada usa `scale` diferente de 1, `rotate`, `skew` ou `perspective`.
4. **Sem parallax nem cena presa.** Nenhuma regra move um elemento conforme a rolagem ao longo da página (`animation-timeline: scroll()`, ou `view()` com um deslocamento acima de 12 px ou com escala), e nenhuma regra nova prende uma seção na tela enquanto se rola (`position: sticky` ou `fixed` numa seção, num bloco de seção ou num palco de cena).

Não julgue durações, curvas, atrasos, cores nem gosto. Falha também se o arquivo está vazio ou perdeu as regras das seções.
