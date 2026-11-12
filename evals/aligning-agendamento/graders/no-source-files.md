---
type: regex
target: files
pattern: '\.(?:jsx?|mjs|cjs|tsx?|html?|css|scss|py|rb|php|go|java|kt|swift|dart|vue|svelte|sql|prisma)\b'
flags: i
match: not_contains
---

Nenhum arquivo de código foi criado durante a execução. Documento em markdown ou `package.json` não contam (`.json` não casa com `.js`).
