---
type: regex
target:
  source: file
  path: app.json
pattern: '"versionCode":\s*8(?!\d)'
match: contains
weight: 2
---

A nova versão sobe o número que a Play Store compara. Passa se `app.json` tem `"versionCode": 8` (era 7 na 1.1.0). Um valor como 80 ou 7 não passa.
