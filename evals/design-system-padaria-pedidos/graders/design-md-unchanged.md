---
type: regex
target:
  source: file
  path: DESIGN.md
pattern: '^-{3}\nname: Padaria Fermento\ncolors:\n  light:\n    surface: "#FBF7F0"\n    on-surface: "#2B2118"\n    surface-muted: "#F0E8DC"\n    on-surface-muted: "#5C4B3B"\n    brand: "#8A3B12"\n    on-brand: "#FFFFFF"\n    border: "#D9CBB8"\n    focus: "#8A3B12"\n  dark:\n    surface: "#1C1612"\n    on-surface: "#F3EBE0"\n    surface-muted: "#2A221C"\n    on-surface-muted: "#C9B8A4"\n    brand: "#E08A5A"\n    on-brand: "#1C1612"\n    border: "#4A3D33"\n    focus: "#E08A5A"\ntypography:\n  display: "Fraunces, Georgia, serif"\n  body: "Source Sans 3, system-ui, sans-serif"\nrounded:\n  card: "12px"\n  button: "999px"\nspacing:\n  unit: "4px"\n-{3}\n\n# Padaria Fermento\n\nPadaria de fermentação natural em Recife\. A identidade vem da casca do pão\nde longa fermentação e da farinha sobre a bancada: superfícies claras e\nquentes, a cor da marca é a da casca\.\n\n## Cores\n\nCada superfície tem a cor do que vai sobre ela \(`on-\*`\)\. Contraste dos pares,\ncalculado:\n\n\| Par \| Claro \| Escuro \|\n\| -{3} \| -{3} \| -{3} \|\n\| on-surface sobre surface \| 14,75:1 \| 15,15:1 \|\n\| on-surface-muted sobre surface-muted \| 6,84:1 \| 8,09:1 \|\n\| on-brand sobre brand \| 7,73:1 \| 6,78:1 \|\n\n## Tipografia\n\nFraunces nos títulos, Source Sans 3 no texto e na interface\.\n\n## Foco\n\nContorno de 2px na cor `focus`, afastado 2px do elemento\.\n?$'
match: contains
weight: 2
---

O `DESIGN.md` que já existia continua igual, byte por byte. O padrão é o arquivo inteiro do scaffold, ancorado no começo e no fim (só a quebra de linha final é opcional). Falha se o agente mudou, reordenou, apagou ou acrescentou qualquer coisa no arquivo, ou se o apagou. O sistema já existe e nada pediu para reescrevê-lo: os tokens novos entram no CSS, e o que for registrar fica fora deste arquivo ou é proposto ao dono.
