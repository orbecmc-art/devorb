---
type: llm
focus:
  source: file
  path: styles.css
weight: 2
---

Contexto: o agente construiu a landing do Lote, ferramenta de logs de deploy para desenvolvedores, em HTML e CSS puros. O tema da página é escuro, mas este grader não exige tema nenhum: o par pode se dividir como o destaque principal nas seções escuras e o complemento numa faixa que contrasta (clara ou de outro tom), ou o inverso.

Julgue só este `styles.css`. Passa somente se as três condições valem:

1. **Exatamente duas cores saturadas de destaque, complementares.** Além dos neutros (fundo, superfícies, texto, bordas, cinzas), há duas, e só duas, famílias de matiz saturado, e os matizes ficam de 150° a 210° de distância no círculo de cores (por exemplo azul-marinho e laranja, verde e magenta). Cores de estado usadas como estado (sucesso, erro, aviso, por exemplo nas linhas de log) e o anel de foco não contam. Uma só cor de destaque falha; três ou mais famílias de matiz falham; duas famílias a menos de 150° uma da outra (por exemplo laranja e vermelho) falham.
2. **Cada cor dona das suas seções.** Uma das cores é a do destaque em algumas seções ou faixas (títulos, números, rótulos, botões, links delas) e a outra é a do destaque em outras seções ou faixas. As regras do CSS mostram essa divisão por seção (seletores ou variáveis de cada seção), não um uso solto das duas por toda parte.
3. **Nunca as duas no mesmo bloco.** Nenhum bloco (hero, cartão, faixa, seção, painel) usa as duas cores como destaque ao mesmo tempo, por exemplo uma palavra do título numa cor e o botão ou o número do mesmo bloco na outra.

Não julgue o gosto, a fonte nem os tamanhos. Falha se há uma só cor de destaque, três ou mais, matizes fora de 150° a 210°, as duas misturadas no mesmo bloco, ou se o arquivo está vazio.
