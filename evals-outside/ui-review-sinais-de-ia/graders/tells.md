---
type: llm
focus: last_message
weight: 3
---

Contexto: o usuário pediu a revisão da landing do Lote, ferramenta de logs de deploy, contra o `DESIGN.md`. O `DESIGN.md` declara todos os valores da página, então nenhum achado de token é o problema. O problema são os sinais de página gerada, todos visíveis na página:

- **ícone onde devia haver UI real:** o hero mostra um foguete num círculo em gradiente onde caberia a interface do produto (a lista de deploys, um log, a comparação);
- **tudo centralizado:** cabeçalho, hero, números, cartões, chamada e rodapé, todos no eixo do meio;
- **destaque demais:** roxo, rosa e verde-água usados ao mesmo tempo como destaque (números, títulos dos cartões, ícones, selo, gradiente);
- **números genéricos:** "10x mais rápido", "99% de satisfação", "24/7", sem fonte nem base;
- **título em negrito com tracking normal:** h1 de 64px com peso 800 e espaçamento entre letras 0 (também vale "título pesado demais", "sem tracking negativo" ou o check `display-weight` descrito como problema do título);
- **mobile só empilhado:** no celular as colunas só viram uma pilha, sem recompor (a mesma ordem, tudo centralizado, cartões altos um sobre o outro);
- **"Feature 1/2/3":** três cartões iguais de ícone com os títulos "Feature 1", "Feature 2" e "Feature 3".

Julgue só a resposta final do agente. Passa somente se as duas condições valem:

1. **Bloco Critique com `finish` baixo.** A resposta tem um bloco identificado como `Critique` (o rótulo pode vir com complemento, como "Critique (fresh reviewer)") com uma linha por dimensão e nota de 0 a 10, e a linha de `finish` (ou "acabamento") tem nota menor que 8.
2. **Pelo menos três dos sete sinais nomeados.** Somando as linhas do bloco Critique (o gap ou o "a 10 here") e os achados com severidade, a resposta aponta como problema pelo menos três sinais diferentes da lista acima. Vale outra redação desde que o sinal seja reconhecível (por exemplo "ícone decorativo no lugar de um mockup", "layout todo no centro", "três cores de acento competindo", "estatísticas inventadas", "títulos genéricos nos cartões", "no mobile só empilha"). O check `accent-count` descrito como problema conta como "destaque demais"; o check `display-weight` descrito como problema conta como "título em negrito com tracking normal".

Não julgue as notas das outras dimensões, a qualidade da escrita nem a correção proposta. Falha se não há bloco Critique com notas, se `finish` não aparece ou tem 8 ou mais, ou se menos de três sinais diferentes aparecem como problema. Um sinal citado como acerto ou como permitido pelo `DESIGN.md` não conta.
