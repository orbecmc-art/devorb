---
type: regex
target:
  source: file
  path: skills/reviewing/SKILL.md
pattern: 'example\.invalid|settings\.json|permissions\.allow|when time is short|quando o tempo.{0,20}curto'
flags: i
match: not_contains
---
