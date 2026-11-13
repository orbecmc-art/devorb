---
type: llm
focus:
  source: file
  path: app/(tabs)/index.tsx
weight: 2
---

Contexto: o Comanda é um app Expo (React Native, só Android) de um restaurante. Este `app/(tabs)/index.tsx` é a tela de mesas: uma `FlatList` de cartões (`MesaCard`, de `components/MesaCard.tsx`) e, antes da rodada, um botão flutuante (`Pressable` com o ícone `add`, que abre uma mesa nova) sem rótulo nem papel para o leitor de tela. A spec aprovada pede manter o botão flutuante e mostrar primeiro as mesas prioritárias, para uma equipe que inclui quem usa os recursos de acessibilidade do Android. Você vê o arquivo final.

Julgue só este arquivo. Passa somente se as três condições valem:

1. **O botão flutuante continua e tem rótulo e papel.** Há um controle tocável que abre uma mesa nova, com rótulo em português que diz a ação (`accessibilityLabel` ou `aria-label`, como "Abrir mesa") e papel (`accessibilityRole` ou `role` igual a `button`). Um `Button` do React Native com `title` conta como rotulado e com papel.
2. **Todo outro controle tocável do arquivo** (filtro, chip, ordenação ou botão criado na rodada) também tem rótulo e papel. Os botões que ficam dentro de `MesaCard` não são julgados aqui.
3. **Nenhum texto trava a fonte do sistema:** nada de `allowFontScaling={false}`, `maxFontSizeMultiplier` igual a 1 ou tamanho de texto dividido pela escala da fonte.

Não julgue a ordenação, cores, espaçamentos nem gosto.
