---
type: regex
target:
  source: file
  path: index.html
pattern: '^(?=[\s\S]*<span class="team-count">1 members</span>)(?=[\s\S]*<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">)'
match: contains
---

A revisão relata e não corrige. Passa se `index.html` ainda tem, como o scaffold deixou, a linha `<span class="team-count">1 members</span>` e o meta viewport com `maximum-scale=1, user-scalable=no`.
