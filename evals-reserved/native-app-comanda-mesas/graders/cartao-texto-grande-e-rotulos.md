---
type: llm
focus:
  source: file
  path: components/MesaCard.tsx
weight: 3
---

Contexto: o Comanda é um app Expo (React Native, só Android) de um restaurante. Antes da rodada, este `components/MesaCard.tsx` desenhava o cartão de uma mesa com altura fixa (`height: 120` no cartão, `height: 28` na linha de cima, `height: 20` na linha da situação e `overflow: 'hidden'`), o número da mesa à esquerda, o total à direita, a situação e o garçom embaixo e três `Pressable` só com ícone (adicionar item, pedir a conta, chamar o garçom), sem rótulo nem papel para o leitor de tela. Com a fonte do sistema no máximo, o texto encavalava e os botões sumiam para fora do cartão. A spec aprovada pede: corrigir isso mantendo a cara do cartão, manter os três botões e acrescentar um botão de estrela que liga e desliga a prioridade da mesa (estrela cheia quando prioritária), para uma equipe que inclui quem usa os recursos de acessibilidade do Android. Tudo do cartão fica neste arquivo. Você vê o arquivo final.

Julgue só este arquivo. Passa somente se as três condições valem:

1. **O texto cresce com a fonte do sistema.** Nenhum `Text` tem `allowFontScaling={false}` nem `maxFontSizeMultiplier` igual a 1, e o tamanho do texto não é corrigido pela escala da fonte (dividir por `PixelRatio.getFontScale()` ou `fontScale`, ou trocar `fontSize` por valor menor quando a fonte do sistema é grande). Um limite de escala de 1,5 ou mais é tolerado.
2. **O cartão cresce com o texto.** O contêiner do cartão e os blocos de texto não têm mais `height` fixa em número (pode haver `minHeight`, `padding`, `flexWrap` ou quebra de linha), e nada que corte o conteúdo (como `overflow: 'hidden'` junto com altura fixa) esconde os botões. Cortar com `numberOfLines` o número da mesa ou o total, a ponto de esconder o valor, falha; quebrar o número e o total em duas linhas, ou deixar a situação quebrar, passa.
3. **Todo controle tem rótulo e papel.** Os quatro botões (adicionar item, pedir a conta, chamar o garçom e a estrela de prioridade), e qualquer outro controle tocável do arquivo, têm rótulo em português que diz a ação (`accessibilityLabel` ou `aria-label`; o rótulo pode citar a mesa, como "Adicionar item na mesa 12") e papel (`accessibilityRole` ou `role`, como `button`, `switch`, `checkbox` ou `togglebutton`). A estrela, além disso, expõe se está ligada: `accessibilityState` com `checked` ou `selected`, `aria-checked`/`aria-selected`/`aria-pressed`, ou um rótulo que muda com o estado ("Marcar como prioritária" e "Tirar prioridade"). Um `Button` do React Native com `title` conta como rotulado e com papel. O ícone dentro do botão pode ficar sem rótulo próprio.

Falha também se o arquivo perdeu algum dos três botões de antes ou não tem a estrela de prioridade.

Não julgue cores, tamanhos de ícone, espaçamentos nem gosto.
