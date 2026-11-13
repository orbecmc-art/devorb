---
type: llm
focus: last_message
weight: 3
---

Contexto: o projeto é o Agenda Fácil, app Expo (SDK 52) gerado, sem `android/` nem `ios/` no git: a parte nativa sai do `app.json` no prebuild. Na 1.1.0, publicada na Play Store, o `app.json` tem `expo.android.versionCode` 7 e `android.permission.QUERY_ALL_PACKAGES` em `expo.android.permissions`. O app só usa essa permissão para saber se WhatsApp e Waze estão instalados (`Linking.canOpenURL` com `whatsapp://` e `waze://` em `App.js`). A Play Store restringe `QUERY_ALL_PACKAGES` a poucos tipos de app; o caminho é declarar os pacotes ou esquemas que o app consulta num bloco `<queries>` do `AndroidManifest.xml`, que num projeto Expo sem `android/` entra por um config plugin (por exemplo com `withAndroidManifest`) registrado em `expo.plugins`. O usuário pediu `/devorb:mobile-release prepara a 1.2.0`.

Julgue só a resposta final do agente.

Passa somente se as duas condições valem:

1. **Aponta a permissão.** A resposta cita `QUERY_ALL_PACKAGES` e diz que ela está em `app.json` (em `expo.android.permissions` ou "nas permissões do Android do `app.json`") como um problema para a Play Store.
2. **Propõe trocar, não manter.** A resposta propõe, ou diz que já fez, declarar os pacotes ou esquemas que o app consulta (WhatsApp e Waze, ou `com.whatsapp` e `com.waze`, ou os esquemas `whatsapp` e `waze`) num bloco `<queries>` por meio de um config plugin, junto com tirar a permissão do `app.json` (ou deixando isso para o dono decidir). Tirar a permissão sem declarar os `<queries>` falha, porque as checagens de WhatsApp e Waze em `App.js` deixam de funcionar no Android 11 em diante. Falha também se a resposta mantém a permissão como está, sugere só justificar o uso no formulário da Play Console, ou manda editar `android/app/src/main/AndroidManifest.xml` à mão como solução.

Pode, e não conta contra: deixar a troca para o dono decidir, avisar que só um aparelho confirma que o WhatsApp e o Waze continuam abrindo, citar `eas build` e `eas submit` como próximos passos do dono, ou falar de outros pontos da versão (SDK do Expo, `targetSdk`).
