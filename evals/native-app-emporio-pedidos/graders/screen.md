---
type: llm
focus:
  source: file
  path: app/(tabs)/orders.tsx
weight: 3
---

Contexto: o Jatobá Equipe é um app Expo (SDK 53, Expo Router) para iPhone e Android. A spec aprovada pede, neste `app/(tabs)/orders.tsx`, a lista de pedidos da `fetchOrders()` de `lib/orders.ts` (uma chamada `fetch` que pode falhar ou voltar vazia), com puxar para atualizar, e o detalhe do pedido numa sheet por cima da lista. O detalhe pode ficar em outro arquivo. Todas as cores, espaçamentos, raios e fontes vêm de `constants/theme.ts`, importado como `theme` (por exemplo `theme.colors.text`, `theme.colors.status[order.status]`). O projeto não ganha dependência nova; já tem `expo-router`, `react-native-screens`, `react-native-gesture-handler`, `react-native-reanimated` e `react-native-safe-area-context`.

Julgue só este arquivo. Passa somente se as três condições valem:

1. **Quatro estados, sem branco na primeira carga.** O arquivo trata:
   - **carregando:** antes da primeira resposta aparece um indicador (`ActivityIndicator`, esqueleto ou texto de carregamento). Falha se a primeira carga devolve `null`, uma `View` vazia ou a lista vazia sem aviso;
   - **vazio:** com zero pedidos aparece uma mensagem própria (por exemplo em `ListEmptyComponent` ou num ramo do componente), e não uma lista em branco;
   - **erro:** quando `fetchOrders()` falha, aparece uma mensagem e uma ação para tentar de novo (botão ou `Pressable` que chama a busca outra vez). Só puxar para atualizar não basta como ação de tentar de novo; o erro só no `console` falha;
   - **sucesso:** a lista mostra os pedidos.
   Estados vindos de uma biblioteca de dados contam se o arquivo trata cada um.
2. **Sheet nativa, não sobreposição feita à mão.** O detalhe abre de um destes jeitos:
   - neste arquivo, por um componente de sheet da plataforma ou de biblioteca: `Modal` do React Native com `presentationStyle` `pageSheet` ou `formSheet`, `BottomSheet`/`BottomSheetModal` de `@gorhom/bottom-sheet`, ou outra sheet de biblioteca;
   - navegando para uma rota de detalhe (`router.push`, `router.navigate` ou `Link`) que o layout apresenta como sheet. Nesse caso este critério passa aqui, e outro grader confere a sheet.
   Falha se o detalhe é uma `View` com `position: 'absolute'` (ou `StyleSheet.absoluteFill`) por cima da lista fazendo papel de sheet, um painel animado à mão com `Animated`/Reanimated `translateY`, ou um `Modal` com `transparent` que desenha a sheet com `View` posicionada. Também falha se o detalhe não abre de jeito nenhum.
3. **Nenhuma cor fora do tema.** Toda cor do arquivo vem de `theme.colors` (inclusive `color` de `ActivityIndicator`, `tintColor` e `colors` de `RefreshControl`, cor de status e de borda). Falha com qualquer cor literal: hexadecimal (`'#fff'`), `rgb(...)`, `rgba(...)`, `hsl(...)`, nome de cor (`'white'`, `'black'`, `'red'`, `'gray'` e parecidos) ou `PlatformColor(...)`. `'transparent'` vale. Componente sem cor nenhuma, usando o padrão da plataforma, também vale.

Não julgue tipografia, espaçamento, textos nem gosto. Falha também se o arquivo está vazio ou não renderiza a lista de pedidos.
