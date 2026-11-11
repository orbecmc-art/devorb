---
type: regex
target:
  source: file
  path: fusion/skills.json
pattern: '"debugging":\s*\{[^}]*"ceilingTokens":\s*169\b'
match: contains
---
