# refs-check: primeira rodada nas 23 referências

- Data: 2026-11-18
- Código: `claude/design-quality-fase-2` em a926d66 (refs-check, mais as três correções desta rodada)
- Navegador: Google Chrome 157.0.8103.79 do sistema, pelo canal `chrome` (sem Chromium do Playwright instalado), Playwright 1.49.1
- Larguras: 1440, 1024, 768, 390. Cinco processos `refs-check --only` em paralelo, cada um com 4 a 5 sites em sequência; a rodada inteira levou 5 min 18 s
- Critério desta task: nenhum `run failed`, `timeout`, `hidden content` ou `sections at`. `FAIL body-size` e `FAIL heading-ratio` ficam para a Task 5

## Resultado

- Nenhum `timeout`, `run failed`, `no metrics` ou `sections at`: todo site deu ao menos 2 seções visíveis em cada largura.
- `hidden content` sobra em 3 sites: shopify-editions, sol e patensify (ver "O que ainda falha").
- 3/23 PASS. Os demais FAIL são `body-size` e `heading-ratio`, esperados até a Task 5.

## Tempo e seções por site

| Site | Tempo | Saída do shoot | Seções visíveis 1440 / 390 | revealed (1440) | Raiz |
|---|---|---|---|---|---|
| framer | 48s | 2 | 8 / 8 | 18 | main |
| bordo | 42s | 2 | 8 / 8 | 0 | main |
| shopify-editions | 126s | 0 | 2 / 2 | 9 | main |
| orior | 71s | 2 | 3 / 4 | 7 | main |
| interfere | 32s | 2 | 9 / 9 | 0 | main |
| aave | 30s | 0 | 8 / 8 | 6 | main |
| aifont | 44s | 2 | 5 / 5 | 0 | main |
| hoy | 51s | 2 | 4 / 4 | 5 | main |
| monocle | 29s | 2 | 5 / 5 | 164 | main |
| billow | 31s | 2 | 5 / 5 | 0 | div |
| melius | 65s | 0 | 7 / 7 | 6 | main |
| futureagi | 110s | 2 | 10 / 10 | 123 | main |
| onlines | 34s | 0 | 8 / 8 | 0 | div |
| mobbin | 29s | 2 | 9 / 9 | 16 | main |
| sol | 34s | 2 | 8 / 10 | 37 | main |
| audienceful | 55s | 2 | 23 / 20 | 0 | div |
| patensify | 88s | 2 | 8 / 8 | 58 | main |
| raycast-keyboard | 30s | 2 | 5 / 5 | 0 | main |
| parloa | 70s | 2 | 14 / 13 | 0 | div |
| accessgrid | 69s | 2 | 12 / 12 | 48 | div |
| staycloud | 78s | 2 | 10 / 10 | 3 | div |
| vercel | 25s | 2 | 4 / 4 | 2 | div |
| agenciadevalor | 35s | 2 | 6 / 6 | 0 | main |

## Relatório

```
- framer (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL heading-ratio at 768; FAIL body-size at 768; FAIL heading-ratio at 390; FAIL body-size at 390
  WARN: measure at 1440, font-sizes at 1440, button-styles at 1440, text-colors at 1440, photo-repeat at 1440, font-sizes at 1024, button-styles at 1024, text-colors at 1024, font-sizes at 768, button-styles at 768, font-sizes at 390, button-styles at 390
- bordo (persuade): FAIL — FAIL heading-ratio at 768; FAIL body-size at 768; FAIL heading-ratio at 390; FAIL body-size at 390
  WARN: measure at 1440, spacing-grid at 1440, font-sizes at 1440, button-styles at 1440, text-colors at 1440, photo-repeat at 1440, measure at 1024, font-sizes at 1024, button-styles at 1024, text-colors at 1024, photo-repeat at 1024, measure at 768, font-sizes at 768, button-styles at 768, text-colors at 768, photo-repeat at 768, measure at 390, font-sizes at 390, button-styles at 390, text-colors at 390, photo-repeat at 390
- shopify-editions (experience): FAIL — hidden content 27 at 1440; hidden content 26 at 1024; hidden content 9 at 768; hidden content 9 at 390
  WARN: button-styles at 1440, photo-repeat at 1440, button-styles at 1024, photo-repeat at 1024, measure at 768, button-styles at 768, photo-repeat at 768, button-styles at 390, photo-repeat at 390
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
  shotErrors: 1440/section-1: skipped: hidden, 1024/section-1: skipped: hidden, 768/section-1: skipped: hidden, 768/section-10: page.screenshot: Clipped area is either empty or outside the resulting image, 390/section-1: skipped: hidden, 390/section-8: page.screenshot: Clipped area is either empty or outside the resulting image, 390/section-9: page.screenshot: Clipped area is either empty or outside the resulting image, 390/section-10: page.screenshot: Clipped area is either empty or outside the resulting image
- onlines (experience): PASS
  WARN: measure at 1440, spacing-grid at 1440, font-sizes at 1440, photo-repeat at 1440, measure at 1024, spacing-grid at 1024, font-sizes at 1024, photo-repeat at 1024, measure at 768, spacing-grid at 768, font-sizes at 768, photo-repeat at 768, spacing-grid at 390, font-sizes at 390, photo-repeat at 390
- mobbin (persuade): FAIL — FAIL heading-ratio at 768; FAIL heading-ratio at 390
  WARN: button-styles at 1440, photo-repeat at 1440, button-styles at 1024, photo-repeat at 1024, button-styles at 768, photo-repeat at 768, button-styles at 390, photo-repeat at 390
- sol (persuade): FAIL — FAIL body-size at 1440; hidden content 11 at 1440; FAIL body-size at 1024; FAIL body-size at 768; hidden content 24 at 768; FAIL body-size at 390
  WARN: measure at 1440, spacing-grid at 1440, font-sizes at 1440, button-styles at 1440, text-colors at 1440, photo-repeat at 1440, measure at 1024, spacing-grid at 1024, font-sizes at 1024, button-styles at 1024, text-colors at 1024, photo-repeat at 1024, measure at 768, spacing-grid at 768, font-sizes at 768, button-styles at 768, text-colors at 768, photo-repeat at 768, measure at 390, spacing-grid at 390, font-sizes at 390, button-styles at 390, text-colors at 390, photo-repeat at 390
- audienceful (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL body-size at 768; FAIL body-size at 390
  WARN: measure at 1440, font-sizes at 1440, button-styles at 1440, text-colors at 1440, photo-repeat at 1440, measure at 1024, font-sizes at 1024, button-styles at 1024, text-colors at 1024, photo-repeat at 1024, font-sizes at 768, button-styles at 768, text-colors at 768, photo-repeat at 768, font-sizes at 390, button-styles at 390, text-colors at 390, photo-repeat at 390
- patensify (persuade): FAIL — hidden content 77 at 1440; hidden content 77 at 1024; FAIL body-size at 768; hidden content 77 at 768; FAIL heading-ratio at 390; FAIL body-size at 390
  WARN: spacing-grid at 1440, font-sizes at 1440, button-styles at 1440, photo-repeat at 1440, spacing-grid at 1024, font-sizes at 1024, button-styles at 1024, photo-repeat at 1024, button-styles at 768, photo-repeat at 768, measure at 390, font-sizes at 390, button-styles at 390, text-colors at 390, photo-repeat at 390
- raycast-keyboard (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL body-size at 768; FAIL body-size at 390
  WARN: photo-repeat at 1440, photo-repeat at 1024, photo-repeat at 768, photo-repeat at 390
- parloa (persuade): FAIL — FAIL heading-ratio at 390
  WARN: measure at 1440, button-styles at 1440, measure at 1024, button-styles at 1024, measure at 768, button-styles at 768, button-styles at 390
- accessgrid (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL body-size at 768; FAIL heading-ratio at 390; FAIL body-size at 390
  WARN: measure at 1440, font-sizes at 1440, button-styles at 1440, text-colors at 1440, photo-repeat at 1440, measure at 1024, font-sizes at 1024, button-styles at 1024, text-colors at 1024, photo-repeat at 1024, measure at 768, font-sizes at 768, button-styles at 768, text-colors at 768, photo-repeat at 768, font-sizes at 390, button-styles at 390, text-colors at 390, photo-repeat at 390
- staycloud (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL heading-ratio at 768; FAIL body-size at 768; FAIL body-size at 390
  WARN: font-sizes at 1440, button-styles at 1440, text-colors at 1440, photo-repeat at 1440, font-sizes at 1024, button-styles at 1024, text-colors at 1024, photo-repeat at 1024, measure at 768, font-sizes at 768, button-styles at 768, text-colors at 768, photo-repeat at 768, font-sizes at 390, button-styles at 390, text-colors at 390, photo-repeat at 390
- vercel (persuade): FAIL — FAIL body-size at 1440; FAIL body-size at 1024; FAIL body-size at 768; FAIL body-size at 390
  WARN: button-styles at 1440, button-styles at 1024, measure at 768, measure at 390, button-styles at 390
- agenciadevalor (persuade): FAIL — FAIL heading-ratio at 1440; FAIL heading-ratio at 1024; FAIL heading-ratio at 768; FAIL heading-ratio at 390
  WARN: measure at 1440, font-sizes at 1440, text-colors at 1440, photo-repeat at 1440, measure at 1024, font-sizes at 1024, text-colors at 1024, photo-repeat at 1024, measure at 768, font-sizes at 768, text-colors at 768, photo-repeat at 768, font-sizes at 390, text-colors at 390, photo-repeat at 390
refs-check: 3/23 PASS
```

## Correções feitas durante a rodada

1. **Shoot e capture não saíam ao terminar.** Sem o Chromium do Playwright, o shoot usa o Chrome do sistema. O GoogleUpdater e o crashpad dele herdam o pipe de stderr do navegador e vivem minutos depois dele, e o node esperava esse pipe fechar. Na primeira rodada, framer, aave, melius e audienceful bateram nos 600 s com todas as larguras já gravadas, e `capture.mjs` levou 853 s no melius. Agora os dois CLIs saem quando o stdout esvazia: o capture do melius sai com 0 em 30 s e o pacote completo (1440, 390, `notas.md`, `secoes.md`, `tokens.json`, `url.txt`).
2. **`hiddenContent` contava o miolo de uma frase de rotator empilhada.** A revelação deixa essa camada escondida de propósito, mas a contagem descia nela e contava cada filho. Antes da correção, 11 sites tinham `hidden content` (accessgrid 382, futureagi 2377, bordo 8, orior 25, vercel 2).
3. **`hiddenContent` contava acordeões fechados e slides aninhados.** Agora a contagem para em toda camada apagada que a revelação deixa de propósito (menu, diálogo, camada fixa, slide inativo, rotator) e em camada colapsada (sem tamanho, com overflow cortando). melius e futureagi caíram de 12 para 0.

## O que ainda falha

`hidden content` em 3 sites, de causas que a contagem não deve esconder:

- **patensify (77) e sol (11 a 24):** conteúdo que a revelação marcou e que voltou a sumir depois dela. São demonstrações em laço (o app do sol no hero, os cartões animados do patensify): no patensify, transições disparadas de novo depois da revelação (o elemento marcado tem uma animação rodando e opacidade 0); no sol, o elemento marcado fica em opacidade 0 sem animação, o que aponta para um estilo inline com `!important` posto pelo script do site (não confirmado).
- **shopify-editions (27 a 9):** popups de hover sem `role` (`skill-tag-popup`) que a revelação marca e cuja transição os mantém em opacidade 0, mais texto em opacidade parcial cujo produto com os ancestrais fica abaixo de 0,1 (a revelação só olha a opacidade do próprio elemento).

Outros achados, fora do critério:

- vercel: as duas últimas seções saem em branco nos prints com `hiddenContent` 0. O invólucro delas usa `content-visibility: auto`, e o Chromium não pinta esse conteúdo fora da janela no print de página inteira.
- parloa: a seção 5 (1092 px depois de "One platform across the AI agent lifecycle") sai em branco; não é `content-visibility` nem opacidade, parece cena de rolagem. O banner de cookies aparece sobre o hero, como para qualquer visitante novo.
- futureagi a 768 e 390: algumas seções além da imagem de página inteira dão `Clipped area is either empty or outside the resulting image` em `shotErrors`.
- Pendências já conhecidas: o hero de cena de rolagem do shopify-editions (seção 0 `skipped: empty` em todas as larguras), o billow com 5 seções, a revelação por `filter: blur` (controles borrados no monocle).
