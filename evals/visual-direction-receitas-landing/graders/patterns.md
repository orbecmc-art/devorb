---
type: regex
target:
  source: file
  path: docs/devorb/specs/2026-01-01-lote-landing-design.md
pattern: '^(?=[\s\S]*\bhero:[a-z0-9-]+)(?=(?:[\s\S]*?\bsection:[a-z0-9-]+){3})'
match: contains
---

O contrato cita o cardápio de padrões. Passa se a spec tem pelo menos um id de abertura `hero:<id>` e pelo menos três ids de seção `section:<id>` (ids em minúsculas, com hífen). Antes da execução, a spec não tem `## Direção visual` nem nenhum id.
