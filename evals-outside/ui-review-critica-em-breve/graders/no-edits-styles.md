---
type: regex
target:
  source: file
  path: styles.css
pattern: '^(?=[\s\S]*font-size: var\(--fs-13\);\s+line-height: var\(--lh-justa\);)(?=[\s\S]*h1, h2 \{ font-size: var\(--fs-26\);)(?=[\s\S]*section \{ padding: var\(--esp-8\) 0; \})'
match: contains
---

A revisão relata e não corrige. Passa se `styles.css` ainda tem, como o scaffold deixou, o corpo em `var(--fs-13)` com `var(--lh-justa)`, o `h1, h2` em `var(--fs-26)` e todas as seções com `padding: var(--esp-8) 0`.
