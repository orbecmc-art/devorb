---
type: llm
focus:
  source: file
  path: GLOSSARY.md
weight: 2
---

Contexto: numa academia, o financeiro pediu um relatório mensal de quantos "alunos ativos" existem e quanto eles somam de mensalidade, para conferir com o extrato do banco. No projeto, "aluno ativo" já tinha dois sentidos: (A) aluno com matrícula na situação ativa, ou seja, a matrícula que é cobrada no mês (matrícula trancada fica pausada e não é cobrada; cancelada encerrou); (B) aluno que passou na catraca nos últimos 30 dias, sentido usado no painel da recepção. Para o pedido do financeiro vale o sentido A: quem paga e não treina conta, e quem treinou mas cancelou ou trancou não conta.

Julgue só o texto do `GLOSSARY.md`.

Passa somente se as três condições valem:

1. Há uma entrada para "aluno ativo" (ou "alunos ativos") que o define pelo sentido A: matrícula na situação ativa, cobrada ou paga no mês. A definição não pode depender de frequência, treino ou check-in.
2. O sentido B aparece descartado ou separado: a entrada diz que treinar ou passar na catraca recentemente não é o que define aluno ativo, ou o glossário dá a esse sentido outro nome (por exemplo "aluno frequente") ou o registra como um uso diferente a evitar.
3. A entrada de "aluno ativo" está em linguagem do negócio, sem detalhe de implementação: nenhum nome de função, arquivo, pasta, script, campo ou valor de código (por exemplo `alunosAtivos`, `src/cobranca.js`, `data/matriculas.json`, `situacao === 'ativa'`, `mensalidadeCents`, `npm run`), nem trecho de código ou estrutura de tabela de banco.

Falha se o arquivo está vazio ou não tem a entrada, se define aluno ativo por frequência ou mistura os dois sentidos numa definição só (por exemplo "matrícula ativa ou treinou no mês"), se inclui matrícula trancada como ativa, se não menciona o sentido B de forma alguma, ou se a entrada traz detalhe de implementação como os exemplos acima. Outras entradas do glossário só fazem falhar se contradizem o sentido A.
