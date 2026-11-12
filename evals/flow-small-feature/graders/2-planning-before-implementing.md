---
type: regex
target: trace
pattern: '^(?:(?!"skill":"(?:devorb:implementing|superpowers:subagent-driven-development|superpowers:executing-plans)")[\s\S])*?"skill":"(?:devorb:planning|superpowers:writing-plans)"[\s\S]*?"skill":"(?:devorb:implementing|superpowers:subagent-driven-development|superpowers:executing-plans)"'
match: contains
---

Ordem do fluxo, conferida no trace inteiro. Passa se a primeira chamada da skill de plano (`devorb:planning` ou `superpowers:writing-plans`) vem antes da primeira chamada da skill de execução (`devorb:implementing`, `superpowers:subagent-driven-development` ou `superpowers:executing-plans`), e as duas acontecem. Vale a skill equivalente de cada braço.
