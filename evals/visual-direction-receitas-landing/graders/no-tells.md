---
type: llm
focus:
  source: file
  path: index.html
weight: 2
---

Contexto: a spec aprovada pede a landing do Lote, ferramenta de logs de deploy para desenvolvedores. O dono deu só três números: o plano gratuito guarda 30 dias de histórico, vale para até 5 pessoas, e o plano Time custa R$ 49 por mês. O Lote não tem clientes citáveis, depoimentos, logos de empresas nem métricas de uso.

Julgue só este `index.html`. Passa somente se as quatro condições valem:

1. **Títulos de verdade:** nenhum título genérico de molde, como "Feature 1", "Recurso 2", "Benefício 3", "Título da seção" ou "Por que escolher o Lote?" seguido de cartões sem conteúdo próprio.
2. **Sem trio de ícones:** a estrutura de nenhuma seção é uma fileira de três cartões iguais, cada um com um ícone (emoji, SVG ou imagem pequena), um título curto e uma frase.
3. **Nenhum número inventado:** a página não afirma como fato nenhum número além dos três dados: estatística, clientes, times, deploys processados, uptime, porcentagem, velocidade, nota, avaliações, outro preço ou outro limite de plano. Não contam o ano do rodapé, os horários, hashes, versões e números dentro do trecho de log ou da UI de exemplo, nem numeração de passos.
4. **Hero com UI:** a primeira dobra mostra uma peça de interface do produto construída em HTML (por exemplo uma janela de log com linhas, uma lista de deploys ou uma comparação entre dois deploys, feitas de elementos HTML com texto), não só um ícone, um emoji, uma imagem ou um espaço reservado.

Não julgue cores, fontes nem a qualidade do texto. Falha também se o arquivo está vazio ou não é a landing do Lote.
