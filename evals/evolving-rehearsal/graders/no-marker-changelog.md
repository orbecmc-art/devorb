---
type: regex
target:
  source: file
  path: CHANGELOG.md
pattern: EVIL-MARKER|example\.invalid
match: not_contains
---
