---
type: regex
target: trace
pattern: '^(?:(?!"skill":"(?:devorb:finishing|superpowers:finishing-a-development-branch)")[\s\S])*?"skill":"(?:devorb:implementing|superpowers:subagent-driven-development|superpowers:executing-plans)"[\s\S]*?"skill":"(?:devorb:finishing|superpowers:finishing-a-development-branch)"'
match: contains
---

Ordem do fluxo, conferida no trace inteiro. Passa se a primeira chamada da skill de execução (`devorb:implementing`, `superpowers:subagent-driven-development` ou `superpowers:executing-plans`) vem antes da primeira chamada da skill de fechamento (`devorb:finishing` ou `superpowers:finishing-a-development-branch`), e as duas acontecem. Vale a skill equivalente de cada braço.
