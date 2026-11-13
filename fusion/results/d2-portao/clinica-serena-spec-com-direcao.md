# Landing page da Clínica Serena

Aprovada pelo dono.

## Contexto

A Clínica Serena é uma clínica de odontologia em Goiânia (GO). Ela quer uma
landing page para quem procura dentista na cidade chegar à página e marcar uma
consulta.

## O que o cliente tem

- Nome: Clínica Serena.
- WhatsApp: (62) 90000-0000. É o único canal de contato e de agendamento.

Nada além disso. O cliente não tem fotos, logotipo, preços, depoimentos, nomes
ou registros da equipe, endereço confirmado nem horários de atendimento.

## Objetivo da página

Quem visita sai com uma consulta marcada pelo WhatsApp.

## Escopo

- Uma página só: `index.html` com `styles.css`, HTML e CSS puros, sem build e
  sem dependências.
- Em português do Brasil.
- Funciona bem no celular, onde chega a maior parte das visitas, e no
  computador.

## Fora do escopo

- Blog, área do paciente e agenda online.

## Direção visual

Decidida sem o dono (ele não podia responder em 2026-11-13); as escolhas abaixo
são suposições registradas.

- **Modo:** Persuadir (trabalho do visitante: marcar consulta).
  **Invenção:** mundo novo; o projeto não tem identidade.
- **Fontes consultadas:** Minimal Gallery (só miniaturas em texto, pouco
  aproveitável). Puladas: shadcn/ui, Base UI, Radix e os especialistas, porque a
  spec proíbe dependências e não há componente que precise deles; Land-book,
  Lapa Ninja, SiteInspire e Recent pedem navegador; Mobbin pede conta. O pedido
  não traz palavras de estilo para casar com a lista. Fundação: nenhuma (HTML e
  CSS puros). Componente de destaque: o cartão de consulta, feito à mão. Nenhuma
  biblioteca nova.
- **Cena:** alguém em Goiânia, no celular, de dia, procurando dentista e
  querendo resolver por mensagem. A página de sempre: fundo branco e azul-
  turquesa, foto de banco de sorriso, ícone de dente, três cards de
  tratamentos, depoimentos. O contrário óbvio: luxo escuro. Nenhum dos dois.
- **Candidatos:** cartão de retorno do dentista (vira o próprio agendamento;
  pode parecer papelaria); Art Déco do centro de Goiânia (letreiro geométrico
  com identidade local; pode soar arquitetura, não saúde); ipê-amarelo da seca
  goiana (cor da cidade; vira enfeite botânico se for desenho); conversa de
  WhatsApp (é a ferramenta, seria cópia); azulejo de banheiro (genérico).
- **Direção:** o cartão de consulta. A ideia única: a página é um cartão de
  retorno ainda em branco, e o botão é o que preenche. Não terá foto de banco,
  ícone de dente nem cards de tratamento. **Teste do espelho:** qualquer
  dentista caberia no cartão; muda para Goiânia com o amarelo do ipê como única
  cor forte (o botão e o realce do cartão) e letra geométrica de espírito Art
  Déco. Fundo claro e frio, tinta verde-escura: não é papel quente, neon,
  jornal, kit de cards nem azul de framework.
- **Tipografia:** só fontes do sistema (a spec proíbe dependências). Títulos:
  geométrica, pilha Avenir Next, Futura, Century Gothic e, por fim, a do
  sistema; confirmadas como fontes de sistema em macOS/iOS e no Office do
  Windows, sem custo de licença para a página. Texto: system-ui. Algarismos: os
  da fonte do texto.
- **Primeira tela:** cabeçalho com o nome e "Marcar consulta"; título, uma
  frase e o botão "Marcar consulta" com o número escrito ao lado; à direita (no
  celular, logo abaixo) o cartão de consulta com os campos dia e horário "a
  combinar no WhatsApp".
- **Seções:** 1. primeira tela; 2. como marcar (uma sequência real: abrir o
  WhatsApp, dizer o melhor dia, combinar o horário), sem botão próprio: o número está no passo 1;
  3. onde e quando: endereço e horário como lacunas visíveis; 4. fecho: o
  número grande e o botão. Rodapé com o nome e o número.
- **Material:** dado: nome, cidade (Goiânia, GO), odontologia, WhatsApp (62)
  90000-0000 como único canal. A mostrar: nada de foto; o cartão desenhado em
  HTML com dados reais. Faltando: fotos, logotipo, tratamentos, preços,
  depoimentos, equipe e registros no CRO, endereço, horário. Lacunas visíveis:
  "Endereço a confirmar" e "Horário a confirmar"; o resto vai para a entrega.
- **Texto:** ação principal "Marcar consulta" no cabeçalho, na primeira tela e no
  fecho, sempre abrindo `https://wa.me/5562900000000` com mensagem pronta. Voz:
  direta, de vizinho, em "você", sem elogiar a clínica.
- **Estados:** a página não carrega dados nem envia formulário. O link do
  WhatsApp abre o app ou o WhatsApp Web; se nenhum abrir, o número está escrito
  ao lado de cada botão para discar ou copiar. Sem JavaScript, nada muda.
- **Piso:** `floor.md` vale inteiro. Reflexo mantido: a numeração 1-2-3 em "como
  marcar", porque é uma sequência real que o visitante segue.
