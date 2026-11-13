---
type: regex
target:
  source: file
  path: src/cli.js
pattern: '^(?=[\s\S]*^import \{[^}]*\bresgatarCafe\b[^}]*\} from [''"]\./pontos(?:\.js)?[''"])(?=[\s\S]*^import \{[^}]*\bextrato\b[^}]*\} from [''"]\./pontos(?:\.js)?[''"])(?=[\s\S]*\bcase [''"]resgatar[''"]:)(?=[\s\S]*\bcase [''"]extrato[''"]:)'
flags: m
match: contains
---

As duas tasks chegaram ao fim, até a linha de comando: o `src/cli.js` final importa `resgatarCafe` e `extrato` de `./pontos.js`, como o plano define, e tem os comandos `case 'resgatar':` e `case 'extrato':`. Falta de qualquer um dos quatro falha.
