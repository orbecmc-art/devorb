---
type: regex
target:
  source: file
  path: styles.css
pattern: '^(?=[\s\S]*color: #6b7280;)(?=[\s\S]*transition: background-color var\(--duration-fast\) ease, box-shadow var\(--duration-fast\) ease;)(?=[\s\S]*border-radius: var\(--radius-sm\);\s+font-family: inherit;\s+font-size: var\(--text-small\);)'
match: contains
---

A revisão relata e não corrige. Passa se `styles.css` ainda tem, como o scaffold deixou, `color: #6b7280;`, a transição que inclui o `box-shadow` do foco e o campo de busca com `font-size: var(--text-small);`.
