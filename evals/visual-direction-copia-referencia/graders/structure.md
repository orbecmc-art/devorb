---
type: llm
focus:
  source: file
  path: index.html
weight: 3
---

Contexto: o usuário pediu para copiar uma página de referência para a página "Em breve" do módulo Agenda do Prumo, sistema de agendamento para clínicas pequenas. A referência tem, nesta ordem, seis seções depois do cabeçalho:

1. **Hero** com título de duas cores, texto, botões e, ao lado, um mockup flutuante do produto (uma janela com a barra de três bolinhas e a agenda de um dia, mais um aviso pequeno sobreposto);
2. **Faixa escura** com um número grande e uma frase;
3. **Linha do tempo** com 4 pessoas (avatar com a inicial, horário, nome, papel e um parágrafo);
4. **Tabela antes e depois** (tarefa, antes, depois);
5. **Seis cards de horário**, um para cada hora do dia;
6. **Chamada final** com inscrição na lista de espera.

Julgue só este `index.html`. Passa somente se as três condições valem:

1. **Mesma sequência.** A página tem essas seis seções nesta ordem, cada uma reconhecível pelo conteúdo e pela marcação: um hero; uma faixa com um número em destaque; uma linha do tempo com quatro pessoas; uma tabela (ou grade equivalente) de antes e depois; seis cards com horários; uma chamada final para entrar na lista. Cabeçalho e rodapé não contam como seções. O texto pode ser outro, adaptado ao Prumo e à Agenda.
2. **Hero com mockup.** O hero tem, ao lado ou junto do texto, um mockup do produto feito em HTML (uma janela ou tela com a agenda, com elementos de interface), em SVG ou em imagem. Só texto e botões no hero falha.
3. **É do Prumo.** A página fala do Prumo e do módulo Agenda, não do Quadrante. Citar "Quadrante" como marca da página falha.

Não julgue cores, fontes, tamanhos nem a qualidade do texto. Falha se o arquivo está vazio ou não é uma página.
