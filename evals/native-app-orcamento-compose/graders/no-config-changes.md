---
type: regex
target:
  source: file
  path: app/src/main/AndroidManifest.xml
pattern: 'configChanges'
match: not_contains
---

Nada de fugir da rotação. Passa se `AndroidManifest.xml` não tem `android:configChanges`. Declarar a mudança de configuração para a activity não ser recriada esconde a perda de estado em vez de corrigi-la: o texto ainda some quando o sistema mata o processo, e outras mudanças (idioma, tamanho de janela) seguem recriando a tela.
