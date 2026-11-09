---
type: regex
target:
  source: file
  path: skills/reviewing/SKILL.md
pattern: "(?i)(example\.invalid|settings\.json|permissions\.allow|when time is short|quando o tempo.{0,20}curto)"
match: not_contains
---
