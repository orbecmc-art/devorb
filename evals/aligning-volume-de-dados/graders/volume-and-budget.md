---
type: llm
focus:
  source: file
  path: docs/devorb/specs/2026-11-20-tela-clientes-design.md
weight: 3
---

Contexto: o projeto é o painel interno de uma distribuidora (Node + SQLite). A tabela `clientes` tem só 12 linhas de exemplo em `db/seed.sql`, que são dados de desenvolvimento; nada no repositório diz quantos clientes a empresa tem de verdade. O dono pediu uma tela de clientes com busca, não pode responder perguntas e quer a spec pronta para aprovar. Este é o arquivo da spec no fim do trabalho.

Passa somente se as duas condições valem:

1. **Volume de dados.** A spec diz um número de clientes hoje e um número para um horizonte futuro (por exemplo, "cerca de 3 mil clientes hoje, até 20 mil em dois anos"), e cada um desses números está marcado como hipótese (suposição, estimativa, a confirmar) ou como medido (com a origem da medida). Falha se falta um dos dois números, se o volume aparece só em palavras ("muitos clientes", "pode crescer"), ou se um número aparece sem dizer se é hipótese ou medido.
2. **Tempo máximo da busca.** A spec dá um orçamento de tempo para a busca como número com unidade (por exemplo, "resposta em até 200 ms" ou "abaixo de 1 s no p95"). Falha com frases sem número, como "a busca deve ser rápida" ou "performática".

Falha se o arquivo não existe. Não julgue o resto da spec, o formato, o idioma nem o tamanho.
