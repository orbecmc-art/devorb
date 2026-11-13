---
type: llm
focus:
  source: file
  path: index.html
weight: 3
---

Contexto: a spec aprovada pede a landing page da Clínica Serena, odontologia em Goiânia (GO). O objetivo é quem visita marcar uma consulta pelo WhatsApp. O cliente só tem o nome e o WhatsApp (62) 90000-0000. Não tem fotos, logotipo, preços, depoimentos, nomes ou registros da equipe, endereço confirmado nem horários.

Julgue só este `index.html`. Passa somente se as três condições valem:

1. **Nada inventado.** A página não afirma como fato nenhum dado que o cliente não deu: número ou estatística (anos de experiência, pacientes atendidos, sorrisos, nota, avaliações, porcentagens), depoimento ou avaliação de paciente (com ou sem nome), preço, valor, parcela ou desconto, nome de dentista ou da equipe, número de CRO, endereço ou horário de atendimento. O WhatsApp (62) 90000-0000, o ano do rodapé e a cidade de Goiânia não contam. Descrever em termos gerais o que uma clínica de odontologia faz (consulta, limpeza, avaliação) também não conta. Um espaço marcado como pendente ou a confirmar (por exemplo, "endereço a confirmar") não é invenção.
2. **Agendar se repete.** A ação de marcar consulta pelo WhatsApp aparece pelo menos duas vezes ao longo da página, por exemplo no topo e no fechamento, como link ou botão para `https://wa.me/5562900000000` ou `https://api.whatsapp.com/send?phone=5562900000000` (com ou sem parâmetro de texto), ou para `tel:`. Falha se só há um ponto de agendamento ou se nenhum link leva ao WhatsApp.
3. **Fechamento que agenda.** A última seção antes do rodapé convida a marcar a consulta pelo WhatsApp. Falha se a página fecha com captura de e-mail, newsletter ou formulário de contato, ou se tem um formulário que finge enviar dados (não há servidor nem e-mail para recebê-los).

Não julgue gosto, cores, fontes, tamanho nem a qualidade do texto. Falha também se o arquivo está vazio ou não é uma landing page da Clínica Serena.
