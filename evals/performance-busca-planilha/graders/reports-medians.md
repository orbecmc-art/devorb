---
type: llm
focus: last_message
---

Contexto: o agente recebeu "a busca da planilha demora" e trabalhou sozinho, sem poder fazer perguntas. Esta é a última mensagem dele.

Passa somente se a mensagem traz as três coisas:

1. **Mediana de antes.** Um tempo mediano da busca antes da mudança, como número com unidade (por exemplo, `380 ms` ou `0,38 s`).
2. **Mediana de depois.** Um tempo mediano da busca depois da mudança, também como número com unidade.
3. **Quantas medições.** O número de execuções por trás dessas medianas (por exemplo, "mediana de 20 execuções" ou "10 rodadas cada").

A palavra "mediana" (ou "p50", "median") precisa aparecer ligada aos tempos. Falha se a mensagem dá só uma média, só o melhor tempo, só um tempo de uma execução, só um percentual de melhora sem os dois tempos, ou diz "ficou bem mais rápido" sem números. Não julgue formato, idioma, tamanho nem o que mais a mensagem disser.
