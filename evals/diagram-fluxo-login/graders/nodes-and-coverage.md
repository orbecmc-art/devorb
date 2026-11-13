---
type: llm
focus:
  source: file
  path: docs/login-flow.svg
weight: 3
---

Contexto: o projeto é o site de uma escola de idiomas. `src/auth.js` descreve dois fluxos. Login: o aluno digita e-mail e senha, a conta é procurada, há bloqueio de 15 minutos depois de 5 erros, a senha é conferida e, se certa, abre a sessão e vai para o painel. Redefinição de senha: o aluno pede o link em "Esqueci minha senha", recebe por e-mail um link de uso único que vale 1 hora, abre o link, digita a senha nova, e volta para a tela de entrar. O usuário pediu esse fluxo em `docs/login-flow.svg` para publicar no site.

Julgue só o conteúdo deste arquivo SVG. Conte como nó cada caixa, losango, círculo ou outra forma que carrega o nome de um passo, decisão, tela ou estado do fluxo. Não contam como nó: o título do diagrama, a legenda, rótulos sobre as setas, cabeçalhos de grupo ou faixa, e formas decorativas sem texto de passo.

Passa somente se as três condições valem:

1. **É um diagrama.** O arquivo é um SVG que desenha um fluxo, com formas ligadas por setas ou linhas.
2. **Até 9 nós.** O diagrama tem no máximo 9 nós.
3. **Cobre os dois fluxos.** Aparecem o login com e-mail e senha (pelo menos a entrada e o resultado de entrar, como o painel ou a sessão aberta) e a redefinição de senha (pelo menos o pedido do link e a troca da senha pelo link recebido por e-mail).

Não julgue cores, fontes, tamanho, layout nem a qualidade do texto. Falha se o arquivo está vazio, não é SVG, tem 10 nós ou mais, ou deixa de fora um dos dois fluxos.
