---
type: llm
focus:
  source: file
  path: app/(tabs)/_layout.tsx
weight: 3
---

Contexto: o Comanda é um app Expo com expo-router, só para Android. Antes da rodada, este `app/(tabs)/_layout.tsx` usava `<Tabs>` do expo-router com as quatro seções (Mesas `index`, Pedidos `pedidos`, Cardápio `cardapio`, Ajustes `ajustes`) numa barra embaixo em qualquer aparelho. A equipe usa celulares (alguns com fonte do sistema bem grande), um tablet de 11 polegadas deitado no balcão e um celular dobrável que o gerente abre e fecha com o app aberto. A spec aprovada pede que cada aparelho receba a navegação que combina com o tamanho da tela e que ela mude sozinha quando o dobrável abre ou fecha, sem reabrir o app, com toda a navegação neste arquivo e sem dependência nova. Larguras em React Native já vêm em dp (pontos independentes de densidade). Você vê o arquivo final.

Julgue só este arquivo. Passa somente se as quatro condições valem:

1. **A escolha vem da largura da janela, ao vivo.** O arquivo decide a navegação pela largura atual da janela, lida de um jeito que acompanha mudanças: `useWindowDimensions()`, `onLayout`, um ouvinte de `Dimensions` (`Dimensions.addEventListener('change', ...)`) ou equivalente. Falha se decide por tipo de aparelho (`Platform.isPad`, `isTablet`, modelo, diagonal da tela), só pela orientação, pela altura, ou por `Dimensions.get(...)` lido uma vez fora de um ouvinte (por exemplo, no topo do módulo), porque aí o dobrável aberto não muda a navegação.
2. **Barra embaixo só abaixo de 600 dp.** Com largura menor que 600, as quatro seções ficam numa barra embaixo. Com 600 ou mais, a barra embaixo não aparece.
3. **Trilho lateral de 600 a 839 dp.** Com largura de 600 a 839, as quatro seções ficam num trilho vertical na lateral da tela (por exemplo `tabBarPosition: 'left'`, com ou sem `tabBarVariant: 'material'`, ou uma barra lateral desenhada neste arquivo). De 840 em diante, vale trilho lateral ou gaveta lateral fixa, nunca a barra embaixo. Um limiar diferente de 600 entre a barra e o trilho (por exemplo 768, ou só em paisagem) falha.
4. **Toda seção continua acessível em todo formato.** As quatro seções aparecem em todos os formatos, cada item da navegação tem rótulo em texto ou rótulo de acessibilidade em português (o `title` de cada `Tabs.Screen` basta quando a barra ou o trilho são os do expo-router) e, se o trilho ou a barra lateral são desenhados à mão, cada item tem papel (`accessibilityRole`/`role` como `tab` ou `button`) e expõe qual seção está ativa (`accessibilityState={{ selected }}`, `aria-selected` ou equivalente). Nenhum rótulo trava a fonte do sistema (`allowFontScaling={false}`, `tabBarAllowFontScaling: false` ou `maxFontSizeMultiplier` igual a 1).

Falha também se o arquivo perdeu alguma das quatro seções ou continua com a mesma barra embaixo em toda largura.

Não julgue cores, ícones, animação nem gosto.
