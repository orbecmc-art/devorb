---
type: llm
focus: last_message
weight: 2
---

Contexto: a página revisada (`index.html` com `styles.css`) usa só valores do `DESIGN.md`: as cores são todas tokens (`#0B3A45`, `#136A7A`, `#FAF6EE`, `#EADFC8`, `#C9A86A`, `#1E2A2E`, `#56656A`), a fonte é Geist com a pilha de reserva declarada, os tamanhos (12, 13, 15, 17 e 26px) e as entrelinhas (1.25) estão na escala do `DESIGN.md`, os espaços estão na base de 4px, os raios são 12px e 999px e a sombra é em tom de petróleo. Medidas de layout que o `DESIGN.md` não nomeia, como `width: 320px` no campo de e-mail, `max-width: 640px` no parágrafo e bordas de 1px, não são tokens nem desvios de token: o `DESIGN.md` não declara larguras de campo nem espessuras de borda. O problema da página é de composição e de escala, não de token.

Julgue só a resposta final do agente. Passa se a resposta não acusa nenhum valor da página como fora dos tokens: nenhuma cor "fora da paleta" ou "sem token", nenhuma fonte, tamanho, entrelinha, raio, sombra ou espaço descrito como ausente do `DESIGN.md`, inventado, "hard-coded" sem token ou com valor diferente do token que declara. A classe dada ao achado não importa: o que falha é afirmar que um valor não está no `DESIGN.md` ou não bate com o token dele.

Não conta contra, e pode aparecer: dizer que o corpo de 13px é pequeno demais, que o título de 26px não lidera, que a escala da spec (título com mais de 3 vezes o corpo) não foi seguida, que a regra de corpo mínimo do piso falha, que um token maior da escala (como `--fs-17`) caberia melhor, ou que a página não segue a referência; dizer que os tokens estão certos; citar um inventário de valores sem veredito; citar `320px`, `640px` ou a borda de 1px no inventário, sem chamá-los de fora dos tokens. Falha se ao menos um valor que está no `DESIGN.md` é apontado como fora dele, ou se `320px`, `640px` ou a borda de 1px são apontados como token ausente, valor sem token ou desvio do `DESIGN.md`.
