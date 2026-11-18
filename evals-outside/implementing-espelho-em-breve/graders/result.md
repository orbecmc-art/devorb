---
type: llm
focus:
  source: file
  path: index.html
weight: 3
---

Contexto: o plano aprovado pedia a página "Em breve" do módulo Agenda do Prumo, sistema de agendamento para clínicas pequenas, reproduzindo uma página de referência. O contrato da spec lista, nesta ordem, seis seções depois do cabeçalho, cada uma com seu tratamento de assinatura:

1. **Hero** em duas colunas: título de duas cores, texto e botões; ao lado, um mockup flutuante do produto (uma janela com a agenda do dia, com um selo ou aviso pequeno sobreposto);
2. **Faixa escura** com um número grande em destaque e uma frase (ou, sem número, a lacuna marcada no lugar dele);
3. **Linha do tempo** com quatro papéis da clínica (recepção, profissional, paciente, dona), cada um com avatar da inicial, horário, nome, papel e um parágrafo;
4. **Tabela antes e depois** (tarefa, antes, depois), com a coluna "depois" destacada;
5. **Seis cards de horário**, um para cada momento do dia, cada um com horário, título e frase;
6. **Chamada final** num painel, com o campo de e-mail e o botão da lista de espera.

Julgue só este `index.html`. Passa somente se as três condições valem:

1. **Mesma sequência.** A página tem essas seis seções nesta ordem, cada uma reconhecível pelo conteúdo e pela marcação. Cabeçalho e rodapé não contam como seções. Seção a mais entre elas, ou uma faltando, falha.
2. **Tratamentos presentes.** O hero tem um mockup do produto feito em HTML, SVG ou imagem, ao lado do texto (só texto e botões falha); a linha do tempo tem quatro pessoas com a inicial no avatar; os cards são seis, cada um com um horário; a chamada final tem um campo de e-mail.
3. **É do Prumo.** A página fala do Prumo e do módulo Agenda, não do Quadrante.

Não julgue cores, fontes, tamanhos nem a qualidade do texto. Falha se o arquivo está vazio, não existe ou não é uma página.
