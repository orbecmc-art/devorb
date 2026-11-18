# refs-check: primeira rodada nas 23 referências

- Data: 2026-11-18
- Código: `claude/design-quality-fase-2` em 93d8e43 (refs-check e as correções desta rodada)
- Navegador: Google Chrome 157.0.8103.79 do sistema, pelo canal `chrome` (sem Chromium do Playwright instalado), Playwright 1.49.1
- Larguras: 1440, 1024, 768, 390. Cinco processos `refs-check --only` em paralelo, cada um com 4 a 5 sites em sequência; a rodada inteira levou 5 min 16 s. O aifont saiu uma vez com 1 aos 31 s, antes de gravar a largura 1440 (o stderr guardado só traz a versão do node), e passou ao rodar de novo com `--only aifont` (37 s, na tabela); quatro execuções isoladas do shoot nele também passaram
- Critério desta task: nenhum `run failed`, `timeout`, `hidden content` ou `sections at`. `FAIL body-size` e `FAIL heading-ratio` ficam para a Task 5

## Resultado

- Nenhum `timeout`, `run failed`, `no metrics`, `sections at` ou `hidden content` nos 23 sites, em nenhuma largura.
- 4/23 PASS. Os demais FAIL são só `body-size` e `heading-ratio`, esperados até a Task 5.
- `shotErrors` restantes são só seções puladas: `skipped: empty` na seção 0 do shopify-editions e `skipped: hidden` na seção 1 do futureagi.
- A barra de zero `hiddenContent` certifica que a revelação funciona no momento da medida e do print. Print em branco de cena de rolagem fixada é limite conhecido e registrado, não item da barra.

## Tempo e seções por site

| Site | Tempo | Saída do shoot | Seções visíveis 1440 / 390 | revealed (1440) | Raiz |
|---|---|---|---|---|---|
| framer | 47s | 2 | 8 / 8 | 10 | main |
| bordo | 42s | 2 | 8 / 8 | 0 | main |
| shopify-editions | 126s | 0 | 2 / 2 | 0 | main |
| orior | 70s | 2 | 3 / 4 | 7 | main |
| interfere | 31s | 2 | 9 / 9 | 0 | main |
| aave | 31s | 0 | 8 / 8 | 6 | main |
| aifont | 37s | 2 | 5 / 5 | 0 | main |
| hoy | 50s | 2 | 4 / 4 | 5 | main |
| monocle | 36s | 2 | 5 / 5 | 164 | main |
| billow | 30s | 2 | 5 / 5 | 0 | div |
| melius | 67s | 0 | 7 / 7 | 6 | main |
| futureagi | 110s | 2 | 10 / 10 | 123 | main |
| onlines | 33s | 0 | 8 / 8 | 0 | div |
| mobbin | 34s | 2 | 9 / 9 | 12 | main |
| sol | 33s | 2 | 8 / 10 | 41 | main |
| audienceful | 54s | 2 | 23 / 20 | 0 | div |
| patensify | 99s | 2 | 8 / 8 | 58 | main |
| raycast-keyboard | 30s | 2 | 5 / 5 | 0 | main |
| parloa | 70s | 2 | 14 / 13 | 0 | div |
| accessgrid | 69s | 2 | 12 / 12 | 48 | div |
| staycloud | 76s | 2 | 10 / 10 | 3 | div |
| vercel | 25s | 2 | 4 / 4 | 2 | div |
| agenciadevalor | 35s | 2 | 6 / 6 | 0 | main |

## Relatório

```
- framer (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL heading-ratio at 768; FAIL body-size at 768; FAIL heading-ratio at 390; FAIL body-size at 390
  WARN: measure at 1440, font-sizes at 1440, button-styles at 1440, text-colors at 1440, photo-repeat at 1440, font-sizes at 1024, button-styles at 1024, text-colors at 1024, font-sizes at 768, button-styles at 768, font-sizes at 390, button-styles at 390
- bordo (persuade): FAIL — FAIL heading-ratio at 768; FAIL body-size at 768; FAIL heading-ratio at 390; FAIL body-size at 390
  WARN: measure at 1440, spacing-grid at 1440, font-sizes at 1440, button-styles at 1440, text-colors at 1440, photo-repeat at 1440, measure at 1024, font-sizes at 1024, button-styles at 1024, text-colors at 1024, photo-repeat at 1024, measure at 768, font-sizes at 768, button-styles at 768, text-colors at 768, photo-repeat at 768, measure at 390, font-sizes at 390, button-styles at 390, text-colors at 390, photo-repeat at 390
- shopify-editions (experience): PASS
  WARN: measure at 1440, font-sizes at 1440, button-styles at 1440, photo-repeat at 1440, font-sizes at 1024, button-styles at 1024, photo-repeat at 1024, measure at 768, font-sizes at 768, button-styles at 768, photo-repeat at 768, font-sizes at 390, button-styles at 390, photo-repeat at 390
  shotErrors: 1440/section-0: skipped: empty, 1024/section-0: skipped: empty, 768/section-0: skipped: empty, 390/section-0: skipped: empty
- orior (persuade): FAIL — FAIL heading-ratio at 768; FAIL heading-ratio at 390; FAIL body-size at 390
  WARN: photo-repeat at 1440, photo-repeat at 1024, photo-repeat at 768, photo-repeat at 390
- interfere (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL body-size at 768; FAIL heading-ratio at 390; FAIL body-size at 390
  WARN: measure at 1440, button-styles at 1440, photo-repeat at 1440, measure at 1024, button-styles at 1024, photo-repeat at 1024, measure at 768, font-sizes at 768, button-styles at 768, photo-repeat at 768, measure at 390, button-styles at 390, photo-repeat at 390
- aave (persuade): PASS
  WARN: measure at 1440, font-sizes at 1440, button-styles at 1440, text-colors at 1440, photo-repeat at 1440, measure at 1024, font-sizes at 1024, button-styles at 1024, text-colors at 1024, photo-repeat at 1024, measure at 768, font-sizes at 768, button-styles at 768, text-colors at 768, photo-repeat at 768, font-sizes at 390, button-styles at 390, text-colors at 390, photo-repeat at 390
- aifont (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL heading-ratio at 768; FAIL body-size at 768; FAIL heading-ratio at 390; FAIL body-size at 390
  WARN: measure at 1440, button-styles at 1440, photo-repeat at 1440, measure at 1024, button-styles at 1024, photo-repeat at 1024, measure at 768, button-styles at 768, photo-repeat at 768, button-styles at 390, photo-repeat at 390
- hoy (persuade): FAIL — FAIL body-size at 1440; FAIL heading-ratio at 1024; FAIL body-size at 1024; FAIL heading-ratio at 768; FAIL body-size at 768; FAIL heading-ratio at 390; FAIL body-size at 390
  WARN: measure at 1440, spacing-grid at 1440, button-styles at 1440, photo-repeat at 1440, measure at 1024, spacing-grid at 1024, button-styles at 1024, photo-repeat at 1024, measure at 768, spacing-grid at 768, button-styles at 768, photo-repeat at 768, measure at 390, spacing-grid at 390, button-styles at 390, photo-repeat at 390
- monocle (persuade): FAIL — FAIL body-size at 1440; FAIL heading-ratio at 1024; FAIL body-size at 1024; FAIL heading-ratio at 768; FAIL body-size at 768; FAIL heading-ratio at 390; FAIL body-size at 390
  WARN: measure at 1440, spacing-grid at 1440, font-sizes at 1440, button-styles at 1440, text-colors at 1440, measure at 1024, spacing-grid at 1024, font-sizes at 1024, button-styles at 1024, text-colors at 1024, measure at 768, spacing-grid at 768, font-sizes at 768, button-styles at 768, text-colors at 768, measure at 390, spacing-grid at 390, font-sizes at 390, button-styles at 390, text-colors at 390
- billow (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL body-size at 768; FAIL body-size at 390
  WARN: measure at 1440, font-sizes at 1440, button-styles at 1440, text-colors at 1440, photo-repeat at 1440, measure at 1024, font-sizes at 1024, text-colors at 1024, photo-repeat at 1024, measure at 768, font-sizes at 768, text-colors at 768, photo-repeat at 768, measure at 390, font-sizes at 390, text-colors at 390, photo-repeat at 390
- melius (persuade): PASS
  WARN: font-sizes at 1440, button-styles at 1440, photo-repeat at 1440, font-sizes at 1024, button-styles at 1024, photo-repeat at 1024, font-sizes at 768, button-styles at 768, photo-repeat at 768, font-sizes at 390, button-styles at 390, photo-repeat at 390
- futureagi (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL body-size at 768; FAIL heading-ratio at 390; FAIL body-size at 390
  WARN: measure at 1440, font-sizes at 1440, button-styles at 1440, text-colors at 1440, measure at 1024, font-sizes at 1024, button-styles at 1024, text-colors at 1024, measure at 768, font-sizes at 768, button-styles at 768, text-colors at 768, measure at 390, font-sizes at 390, button-styles at 390, text-colors at 390
  shotErrors: 1440/section-1: skipped: hidden, 1024/section-1: skipped: hidden, 768/section-1: skipped: hidden, 390/section-1: skipped: hidden
- onlines (experience): PASS
  WARN: measure at 1440, spacing-grid at 1440, font-sizes at 1440, photo-repeat at 1440, measure at 1024, spacing-grid at 1024, font-sizes at 1024, photo-repeat at 1024, measure at 768, spacing-grid at 768, font-sizes at 768, photo-repeat at 768, spacing-grid at 390, font-sizes at 390, photo-repeat at 390
- mobbin (persuade): FAIL — FAIL heading-ratio at 768; FAIL heading-ratio at 390
  WARN: font-sizes at 1440, button-styles at 1440, photo-repeat at 1440, button-styles at 1024, photo-repeat at 1024, button-styles at 768, photo-repeat at 768, button-styles at 390, photo-repeat at 390
- sol (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL body-size at 768; FAIL body-size at 390
  WARN: measure at 1440, spacing-grid at 1440, font-sizes at 1440, button-styles at 1440, text-colors at 1440, photo-repeat at 1440, measure at 1024, spacing-grid at 1024, font-sizes at 1024, button-styles at 1024, text-colors at 1024, photo-repeat at 1024, measure at 768, spacing-grid at 768, font-sizes at 768, button-styles at 768, text-colors at 768, photo-repeat at 768, measure at 390, spacing-grid at 390, font-sizes at 390, button-styles at 390, text-colors at 390, photo-repeat at 390
- audienceful (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL body-size at 768; FAIL body-size at 390
  WARN: measure at 1440, font-sizes at 1440, button-styles at 1440, text-colors at 1440, photo-repeat at 1440, measure at 1024, font-sizes at 1024, button-styles at 1024, text-colors at 1024, photo-repeat at 1024, font-sizes at 768, button-styles at 768, text-colors at 768, photo-repeat at 768, font-sizes at 390, button-styles at 390, text-colors at 390, photo-repeat at 390
- patensify (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL body-size at 768; FAIL heading-ratio at 390; FAIL body-size at 390
  WARN: measure at 1440, spacing-grid at 1440, font-sizes at 1440, button-styles at 1440, text-colors at 1440, photo-repeat at 1440, measure at 1024, spacing-grid at 1024, font-sizes at 1024, button-styles at 1024, text-colors at 1024, photo-repeat at 1024, measure at 768, font-sizes at 768, button-styles at 768, text-colors at 768, photo-repeat at 768, measure at 390, font-sizes at 390, button-styles at 390, text-colors at 390, photo-repeat at 390
- raycast-keyboard (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL body-size at 768; FAIL body-size at 390
  WARN: photo-repeat at 1440, photo-repeat at 1024, photo-repeat at 768, photo-repeat at 390
- parloa (persuade): FAIL — FAIL heading-ratio at 390
  WARN: measure at 1440, button-styles at 1440, measure at 1024, button-styles at 1024, measure at 768, button-styles at 768, button-styles at 390
- accessgrid (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL body-size at 768; FAIL heading-ratio at 390; FAIL body-size at 390
  WARN: measure at 1440, font-sizes at 1440, button-styles at 1440, text-colors at 1440, photo-repeat at 1440, measure at 1024, font-sizes at 1024, button-styles at 1024, text-colors at 1024, photo-repeat at 1024, measure at 768, font-sizes at 768, button-styles at 768, text-colors at 768, photo-repeat at 768, font-sizes at 390, button-styles at 390, text-colors at 390, photo-repeat at 390
- staycloud (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL heading-ratio at 768; FAIL body-size at 768; FAIL body-size at 390
  WARN: font-sizes at 1440, button-styles at 1440, text-colors at 1440, photo-repeat at 1440, font-sizes at 1024, button-styles at 1024, text-colors at 1024, photo-repeat at 1024, measure at 768, font-sizes at 768, button-styles at 768, text-colors at 768, photo-repeat at 768, font-sizes at 390, button-styles at 390, text-colors at 390, photo-repeat at 390
- vercel (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL body-size at 768; FAIL body-size at 390
  WARN: button-styles at 1440, button-styles at 1024, measure at 768, button-styles at 768, measure at 390, button-styles at 390
- agenciadevalor (persuade): FAIL — FAIL heading-ratio at 1440; FAIL heading-ratio at 1024; FAIL heading-ratio at 768; FAIL heading-ratio at 390
  WARN: measure at 1440, font-sizes at 1440, text-colors at 1440, photo-repeat at 1440, measure at 1024, font-sizes at 1024, text-colors at 1024, photo-repeat at 1024, measure at 768, font-sizes at 768, text-colors at 768, photo-repeat at 768, font-sizes at 390, text-colors at 390, photo-repeat at 390
refs-check: 4/23 PASS
```

## Correções feitas durante as rodadas

1. **Shoot e capture não saíam ao terminar.** Sem o Chromium do Playwright, o shoot usa o Chrome do sistema. O GoogleUpdater e o crashpad dele herdam o pipe de stderr do navegador e vivem minutos depois dele, e o node esperava esse pipe fechar. Na primeira rodada, framer, aave, melius e audienceful bateram nos 600 s com todas as larguras já gravadas, e `capture.mjs` levou 853 s no melius. Agora os dois CLIs saem quando o stdout esvazia: o capture do melius sai com 0 em 30 s, com o pacote completo (1440, 390, `notas.md`, `secoes.md`, `tokens.json`, `url.txt`).
2. **A contagem descia em camadas que a revelação deixa escondidas de propósito.** Frase de rotator empilhada, slide inativo com camadas aria-hidden aninhadas, acordeão fechado (sem tamanho, com overflow cortando): a contagem agora para nelas. Antes, 11 sites tinham `hidden content` (accessgrid 382, futureagi 2377, orior 25, melius 12).
3. **Revelação no momento da medida.** `__devorbMetrics` aplica `__devorbReveal` de novo no mesmo tick antes de medir, porque demonstrações em laço voltavam a esconder conteúdo depois da revelação (patensify 77, sol 11 a 24). `revealed` passa a contar todo elemento marcado.
4. **Revelação inline.** Além da folha de estilo, a revelação escreve `opacity` e `visibility` inline com `!important`, que um `!important` inline do próprio site vencia (sol).
5. **`content-visibility: auto`.** A folha da revelação põe `content-visibility: visible` e zera `contain-intrinsic-size`. As seções 2 e 3 do vercel saíam em branco no print de página inteira.
6. **Opacidade própria.** A contagem olha a opacidade e a visibilidade do próprio elemento, o mesmo teste da revelação, e não o produto com os ancestrais (texto em opacidade parcial no shopify-editions).
7. **Popups de hover.** Um descendente apagado e absoluto de `a`, `button`, `[role=button]`, `[tabindex]` ou `summary` é estado inativo: nem revelado nem contado (`skill-tag-popup` no shopify-editions).
8. **Rolagem instantânea nos prints de seção.** Em página com rolagem suave (Lenis no futureagi), o `scrollY` ainda não tinha andado quando o recorte era posicionado, e toda seção além de 16000 px falhava com `Clipped area is either empty or outside the resulting image`. A rolagem agora usa `behavior: 'instant'`.
9. **Revelação antes de cada print.** O `shoot` roda `__devorbReveal` de novo logo antes de cada `page.screenshot`, para um script em laço não apagar o print depois da medida.
10. **Regra do popup mais estreita.** O dono de um popup é `a`, `button`, `[role=button]`, `summary` ou `[tabindex]` diferente de -1, e nunca um controle que é ou contém uma seção ou a raiz das seções. Um alvo de skip link (`main tabindex=-1`) ou um link em volta da página não esconde mais revelações de rolagem.

## Limites conhecidos (fora do critério)

- **Cenas de rolagem fixadas ficam em branco ou repetidas nos prints.** O hero do shopify-editions (seção 0 `skipped: empty` em todas as larguras); no parloa, as seções 5 (1092 px logo depois do bloco da plataforma), 6 e 12; no sol, a seção 0 em branco e as 1 e 2 repetindo o título do hero fixado, sem a demonstração do app; o hero alto do hoy. O conteúdo dessas cenas depende da posição de rolagem, e o print de página inteira pega uma posição só.
- billow acha 5 seções de cerca de 13.
- A revelação por `filter: blur` não é desfeita: os painéis de controle do monocle saem borrados.
- O banner de cookies do parloa e do aave aparece sobre o hero, como para qualquer visitante novo.
