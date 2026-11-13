---
type: llm
focus: last_message
weight: 3
---

Contexto: o projeto é o checkout de uma loja em Node. A branch `feature/cupom-desconto` implementa a spec aprovada `docs/devorb/specs/2026-11-05-cupom-desconto-design.md` (cupom percentual sobre o subtotal dos itens, com validade e pedido mínimo). Comparada com a `main` pelo merge-base, a branch tem três problemas plantados:

- **Bug.** Em `src/cupons.js`, `valorDosItens` soma só o preço de cada item e ignora `quantidade`. O desconto e a checagem de pedido mínimo usam essa base errada: 3 canecas (R$ 135,00) são recusadas por "pedido mínimo de R$ 100,00", e 2 camisetas mais 1 pôster (R$ 208,00) levam R$ 11,90 de desconto em vez de R$ 20,80. Já existe `subtotal()` em `src/pedidos.js`, que multiplica pela quantidade, e a spec manda usar esse subtotal. Os testes passam porque só usam quantidade 1.
- **Comportamento não pedido.** Em `src/pedidos.js`, `criarPedido` dá 5% de desconto automático ("fidelidade") a pedidos de R$ 300,00 ou mais sem cupom (`FIDELIDADE_MINIMO`, `FIDELIDADE_PERCENTUAL`). A spec não pede isso e diz que pedidos sem cupom não mudam.
- **Validação removida.** O commit "refactor: simplifica validação de itens (o front já limita a quantidade)" tira de `validarItens` a checagem de que `quantidade` é inteiro de 1 a 99 e apaga o teste dela. A entrada vem do corpo de `POST /pedidos` (`src/servidor.js`), que o cliente controla: quantidade negativa, zero, fracionária ou texto passa, e o total pode ficar negativo ou ser manipulado.

Julgue só esta última mensagem do agente. Passa somente se as três condições valem:

1. **Acha os três.** A revisão aponta, com as próprias palavras, (a) que o desconto ou o pedido mínimo do cupom ignoram a quantidade dos itens; (b) que o desconto de fidelidade ou automático sem cupom não foi pedido pela spec; e (c) que a validação de quantidade foi removida. Falha se qualquer um dos três falta, ou se aparece só como pergunta, sem ser apontado como problema.
2. **Eixos separados.** A revisão separa os achados em dois eixos, em seções ou rótulos distintos: um de padrões, qualidade ou correção do código, e outro de conformidade com a spec. O bug da quantidade aparece no eixo de padrões ou correção, e pode aparecer também no eixo da spec. O desconto de fidelidade aparece no eixo da spec, como algo além da spec, que sobrou ou que não foi pedido. Falha se os achados vêm numa lista única sem eixo, se o bug aparece só no eixo da spec, ou se o desconto de fidelidade só aparece como problema de código, sem dizer que a spec não o pede.
3. **A validação removida vira risco com severidade.** A remoção da checagem de quantidade é tratada como risco de segurança ou de entrada não confiável (por exemplo: o cliente manda quantidade negativa e baixa o total, ou o "front já valida" não protege a API), numa revisão ou nota de risco ou de segurança, e recebe severidade explícita alta: Critical ou Important, ou um equivalente como crítica, alta ou bloqueante. Falha se a remoção aparece só como refatoração ou limpeza, se não tem severidade, ou se a severidade é Minor ou baixa.

Não julgue formato, idioma, tamanho nem achados extras, desde que estes três estejam lá. Não exija que o agente tenha corrigido o código. Falha também se a mensagem só diz que a revisão está num arquivo, sem trazer os achados.
