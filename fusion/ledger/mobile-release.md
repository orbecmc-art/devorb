# Ledger: `mobile-release`

Skill manual de nível leve, da Task M3 do plano mobile (`"sector": "mobile"`), chamada só pelo usuário com `/devorb:mobile-release <versão>`, depois de `devorb:finishing`. Espinha: Expo (`expo-upgrade`, `expo-dev-client`, MIT) e Android (`agp-9-upgrade`, `play-policy-insights`, Apache-2.0). As duas fontes têm `textReuse: false`: só ideias, escritas com palavras próprias, com a fonte fechada, e creditadas aqui. Nenhum texto, lista ou abertura delas entrou, e `LICENSES/NOTICE.md` não muda.

Pinos lidos, buscados rasos (`--depth 1 --no-tags --filter=blob:limit=2m`, hooks desligados, `core.symlinks=false`), uma pasta por fonte, só nos caminhos que o Mapa de skills do mobile atribui a esta skill, sem rodar nada:

- `expo-skills@a9e5bd3fa00b4e61f632e43f85da73aee1942582`: `plugins/expo/skills/expo-upgrade/SKILL.md`, `plugins/expo/skills/expo-dev-client/SKILL.md`.
- `android-skills@5815d27fda564aa9f07ebdcb5e57ed3e8d904e0d`: `build-system/agp/agp-9-upgrade/SKILL.md`, `play/play-policy-insights/resources/goal_permissions_and_apis.md`, `play/play-policy-insights/resources/goal_user_account.md`.

As referências internas que essas páginas citam (`references/react-19.md`, o guia de migração do AGP 9, `ksp-kapt.md`, `buildconfig.md`) não estão em `fusion/sources.json` e não foram buscadas.

A skill foi escrita sem abrir `evals/mobile-release-*`, `evals-reserved/` nem `fusion/results/`. O caso só é conhecido pelo texto da Task M3 no plano.

`SKILL.md` tem 6.216 bytes (cerca de 1.554 tokens, teto 2.500). Por ser manual, a descrição não entra no custo fixo do setor.

## Origem por parte

| Parte | Origem |
|---|---|
| Frontmatter: `disable-model-invocation: true`, descrição de uma linha, `argument-hint` | DevOrb, pela regra das skills manuais (`writing-skills/references/SKILL-MECHANICS.md`) e pelo formato de `skills/handoff/SKILL.md` |
| Abertura: muda só o que a versão pede; a ida à loja fica com o dono | DevOrb, pela fronteira da spec ("Setor mobile": SDK, AGP, `targetSdk`, versão e política) |
| Versão no argumento; sem argumento, perguntar e, sem resposta, parar | Própria |
| Passo 1, saber o projeto: Expo, Kotlin ou nenhum dos dois | Ideia do plano (M1 e M3) e da spec, com palavras próprias |
| Projeto sem `android/` e `ios/` no git é gerado: nativo só por `app.json` e config plugin | Ideia do Expo (`expo-upgrade`, seção de prebuild: checar se as pastas existem antes de mexer no nativo), reescrita como verificação por `git ls-files` |
| Usar a documentação da versão do SDK do projeto, nunca a mais recente | Ideia do Expo (`expo-upgrade`, links versionados em `docs.expo.dev/versions/`), pela Task M3. Estendida às notas de versão do AGP do projeto |
| Passo 2, tabela de versão: `expo.version` e `expo.android.versionCode` no Expo; `versionName` e `versionCode` no `defaultConfig` do Kotlin; número de build sobe um | DevOrb, pelo pedido do coordenador e pelo caso da Task M3. `expo.ios.buildNumber` é próprio |
| `appVersionSource: "remote"` no `eas.json`: o EAS é dono do número de build | Ideia do Expo (`expo-dev-client`, configuração do EAS) |
| Passo 3, subir `targetSdk`, SDK do Expo ou AGP é decisão anunciada, com versões e motivo | Regra própria 1 |
| Sequência de atualização do SDK: `npx expo install expo@^<alvo>`, `npx expo install --fix`, `npx expo-doctor` | Ideia do Expo (`expo-upgrade`, passo a passo), com o alvo fixado na versão anunciada em vez de `latest` |
| Rodar `npx expo install --fix` e `npx expo-doctor` depois de cada mudança; pacote novo entra com `npx expo install` | Ideia do Expo (`expo-upgrade`, rodar o doctor depois de remover dependência), estendida a toda mudança pela Task M3 |
| Ler o changelog de cada SDK atravessado | Ideia do Expo (`expo-upgrade`, revisar as notas da versão alvo) |
| AGP abaixo de 9: parar e pedir ao dono o Upgrade Assistant do Android Studio; subir à mão só se ele mandar | Ideia do Android (`agp-9-upgrade`, requisitos), pela Task M3 |
| No AGP 9: tirar `kotlin-android`, kapt para KSP, kapt legado quando o processador não tem KSP | Ideia do Android (`agp-9-upgrade`, passos 2 e 4), pela Task M3 |
| Conferir com `./gradlew help` e `./gradlew build --dry-run` | Ideia do Android (`agp-9-upgrade`, verificação) |
| Projetos Kotlin Multiplatform ficam fora | Ideia do Android (`agp-9-upgrade`) |
| Passo 4, onde moram as permissões no Expo e no Kotlin, e `<queries>` por config plugin | Própria, pela regra do setor (projeto gerado muda por config plugin) e pelo caso da Task M3 |
| Corrigir o que o código mostra; propor quando a correção depende do propósito do app | Própria |
| Passo 5, build local é grátis e EAS custa e pede conta; nunca `eas login`, `eas build` nem `eas submit`; nomear o passo do EAS como próximo passo do dono, sem escrever o comando, para o agente não rodá-lo | Ideia do Expo (`expo-dev-client`, aviso de custo), pela regra global do plano mobile |
| Chave de assinatura fora do git e do relatório | Própria, no padrão de `handoff` (dizer onde o segredo vive) |
| Sem SDK, emulador nem aparelho: dizer o que ficou sem conferir | Regra global do plano mobile e da spec |
| Passo 6, relatório em cinco itens e "nunca pronto com achado de política aberto" | Própria, no padrão de `browser-testing` |
| `Connects to` | DevOrb, pelas interfaces da Task M3 e pela fronteira da spec |
| `references/play-policy.md`: `QUERY_ALL_PACKAGES` só quando listar todos os apps é o produto; o resto declara `<queries>` | Ideia do Android (`goal_permissions_and_apis`, visibilidade de pacotes), pela Task M3 |
| As chamadas de código que revelam quais pacotes o app consulta, e o laço que caça apps concorrentes | Ideia do Android (mesma seção, heurística de busca indireta), estendida com as APIs do React Native |
| Exemplo de `<queries>` em XML e o config plugin `with-android-queries` com `withAndroidManifest` | Próprio. O plugin foi conferido com um teste de mesa em Node, com `withAndroidManifest` simulado |
| `blockedPermissions` quando uma biblioteca traz a permissão de volta | Próprio |
| `foregroundServiceType` em todo serviço, `specialUse` com propriedade e motivo concreto, notificação visível, declaração no Console com vídeo | Ideia do Android (`goal_permissions_and_apis`, serviços em primeiro plano), pela Task M3. A permissão `FOREGROUND_SERVICE_<TYPE>` a partir da API 34 é própria |
| Trabalho que o usuário não acompanha vai para WorkManager | Ideia do Android (mesma seção) |
| Exclusão de conta dentro do app, achável, que apaga no servidor; sair da conta não é excluir | Ideia do Android (`goal_user_account`, exclusão de conta e a armadilha da exclusão parcial), pela Task M3 |
| Link público de exclusão e login de revisor no Console, com o dono | Ideia do Android (`goal_user_account`, requisitos do Console) |
| Tabela de permissões sensíveis: mídia, armazenamento, localização, contatos, alarme exato, SMS, áudio, acessibilidade | Ideias do Android (`goal_permissions_and_apis`), condensadas numa tabela própria de três colunas |
| Permissão sem uso sai; permissão pedida antes da hora ganha tela de explicação | Própria |

## Conflitos resolvidos

- **Atualizar para a mais recente ou para a versão anunciada:** o Expo instala `expo@latest`. Venceu a Task M3: o alvo é a versão anunciada, com motivo, e a documentação é a da versão do projeto.
- **Build local do dev client:** o Expo monta o build local com `eas build --local`, que ainda depende da CLI do EAS. A skill usa `npx expo run:android --variant release` e `./gradlew bundleRelease`, e deixa todo comando `eas` para o dono, pela regra global do plano.
- **AGP abaixo de 9:** a fonte para e pede o Upgrade Assistant, mas aceita pular a exigência a pedido. Mantido igual, com a decisão sempre do dono.
- **`targetSdk`:** a spec registra que a skill de edge-to-edge sobe para 35 sem perguntar. Aqui, subir é decisão anunciada (regra própria 1).
- **Regras do Android num projeto Expo:** valem pelo `app.json` e por config plugin, nunca editando `android/` gerado, pela regra do setor.

## Regras próprias

Regras próprias só saem com decisão explícita do dono. As regras abaixo foram escritas antes de qualquer rodada de comparação, a partir do plano, e ainda não há resultado que mostre se elas mudam o comportamento.

1. **Subida anunciada.** Subir `targetSdk`, SDK do Expo ou AGP só acontece nesta skill, anunciado antes com versões e motivo; "existe uma mais nova" não é motivo. Com o usuário ausente, só quando a versão trava sem a subida, e o anúncio abre o relatório. Caso: decisão própria da Task M3 e conflito do `targetSdk` na spec.
2. **Número de build sobe um, no campo certo.** `expo.android.versionCode` ou `versionCode` do `defaultConfig`, nunca reaproveitado nem baixado. Caso: o caso realista da Task M3 (`versionCode` 7 para 8 em `app.json`).

## Fora

- **Do Expo (`expo-upgrade`):** o pedido de feedback com `npx --yes @expo/agent-cli@latest`; instalar `expo@latest` e versões beta; o aviso de versões específicas do SDK com regressão de memória no Hermes (fato datado, que a documentação da versão cobre); `npx expo prebuild --clean` e a limpeza de caches de CocoaPods, Xcode e Gradle; a tabela de pacotes obsoletos, React Compiler, Postcss, Metro, `expo.install.exclude`, patches e arquitetura nova. Tudo isso é atualização de SDK em detalhe, que a documentação versionada cobre melhor e que pesaria além do teto.
- **Do Expo (`expo-dev-client`):** `eas build`, `eas build --local`, `eas build:list`, `eas credentials`, `eas update`, TestFlight e o `eas.json` de exemplo; a instalação com `adb` e `xcrun`; os parâmetros de URL para pular o menu do dev client. EAS fica com o dono, e não há aparelho no sandbox.
- **Do Android (`agp-9-upgrade`):** versões mínimas de KSP e Hilt, a nova DSL, `BuildConfig`, os sinalizadores de `gradle.properties`, Paparazzi e as regras de não escrever scripts Python. Dependem dos guias internos que não estão em `sources.json`.
- **Do Android (`play-policy-insights`):** os blocos de modelo (`{{...}}`), o esquema JSON de saída, os níveis de severidade e as matrizes de avaliação; o botão de localização da API 37 e o seletor de contatos com prazo; o botão de microfone. A skill relata em texto, e prazos de política mudam mais rápido que a skill.

## Revisões

- 2026-11-13, conferência frase a frase contra cada fonte, depois da primeira escrita. Reescritas por estarem perto demais: o pedido do Upgrade Assistant "e confirmar quando terminar" (`agp-9-upgrade`); a lista de apps que justificam `QUERY_ALL_PACKAGES` na ordem da fonte (`goal_permissions_and_apis`); "se pode criar a conta no app, pode excluí-la no app" (`goal_user_account`).
- 2026-11-13: virou automática por decisão do dono (dispara pelo assunto da conversa); descrição reescrita com gatilhos.

## Resultados

Opus 5.5, nível leve, 2 rodadas. Braço: sem plugin. `fusion/results/2026-11-13-mobile-release*.md`.

| Caso | DevOrb | Sem plugin |
|---|---|---|
| `mobile-release-agenda-facil` | 100% | 0% (0,50) |

- `accepted: true`. O grader de `<queries>` foi apertado antes da rodada: tirar a permissão sem declarar os pacotes reprova, porque as checagens de WhatsApp e Waze deixariam de funcionar.

## Decisões por commit de fonte

- `expo-skills@a9e5bd3fa00b4e61f632e43f85da73aee1942582:plugins/expo/skills/expo-upgrade/SKILL.md` | adotado | só ideias: documentação versionada, `npx expo install --fix` e `npx expo-doctor` a cada mudança, changelog da versão alvo, checar se `android/` e `ios/` existem antes de mexer no nativo
- `expo-skills@a9e5bd3fa00b4e61f632e43f85da73aee1942582:plugins/expo/skills/expo-upgrade/SKILL.md` | recusado | `expo@latest` e beta, pedido de feedback à Expo, prebuild e caches, tabelas de pacotes e configurações por SDK, aviso datado do Hermes
- `expo-skills@a9e5bd3fa00b4e61f632e43f85da73aee1942582:plugins/expo/skills/expo-dev-client/SKILL.md` | adotado | só ideias: build local grátis, EAS pago e com conta, número de build remoto com `appVersionSource`
- `expo-skills@a9e5bd3fa00b4e61f632e43f85da73aee1942582:plugins/expo/skills/expo-dev-client/SKILL.md` | recusado | todo comando `eas`, TestFlight, instalação no aparelho, parâmetros do dev client, pedido de feedback à Expo
- `android-skills@5815d27fda564aa9f07ebdcb5e57ed3e8d904e0d:build-system/agp/agp-9-upgrade/SKILL.md` | adotado | só ideias: parar abaixo do AGP 9 e pedir o Upgrade Assistant, Kotlin embutido no lugar de `kotlin-android`, kapt para KSP ou kapt legado, conferência com `help` e `--dry-run`, KMP fora
- `android-skills@5815d27fda564aa9f07ebdcb5e57ed3e8d904e0d:build-system/agp/agp-9-upgrade/SKILL.md` | recusado | versões mínimas de KSP e Hilt, DSL nova, `BuildConfig`, `gradle.properties`, Paparazzi, guias internos não acompanhados
- `android-skills@5815d27fda564aa9f07ebdcb5e57ed3e8d904e0d:play/play-policy-insights/resources/goal_permissions_and_apis.md` | adotado | só ideias: `<queries>` no lugar de `QUERY_ALL_PACKAGES`, `foregroundServiceType` em todo serviço e `specialUse` com motivo, WorkManager, alternativas às permissões sensíveis
- `android-skills@5815d27fda564aa9f07ebdcb5e57ed3e8d904e0d:play/play-policy-insights/resources/goal_permissions_and_apis.md` | recusado | modelo com `{{...}}`, esquema JSON, severidades, matrizes, botões de localização e microfone, prazos datados
- `android-skills@5815d27fda564aa9f07ebdcb5e57ed3e8d904e0d:play/play-policy-insights/resources/goal_user_account.md` | adotado | só ideias: exclusão de conta dentro do app que apaga no servidor, link de exclusão e login de revisor no Console
- `android-skills@5815d27fda564aa9f07ebdcb5e57ed3e8d904e0d:play/play-policy-insights/resources/goal_user_account.md` | recusado | modelo com `{{...}}`, esquema JSON, heurísticas de presença de conta por nome de arquivo
