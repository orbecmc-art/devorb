---
type: regex
target: trace
pattern: '^(?:(?!"skill":"(?:devorb:planning|superpowers:writing-plans)")[\s\S])*?"skill":"(?:devorb:aligning|superpowers:brainstorming)"[\s\S]*?"skill":"(?:devorb:planning|superpowers:writing-plans)"'
match: contains
---

Ordem do fluxo, conferida no trace inteiro. Passa se a primeira chamada da skill de alinhamento (`devorb:aligning` ou `superpowers:brainstorming`) vem antes da primeira chamada da skill de plano (`devorb:planning` ou `superpowers:writing-plans`), e as duas acontecem. Vale a skill equivalente de cada braço.
