---
type: llm
focus:
  source: file
  path: app/page.tsx
weight: 2
---

Contexto: a spec aprovada pede a landing page "bem clean, sóbrio, que deixe os projetos falarem" do Atelier Linha, escritório de arquitetura, num projeto Next com Tailwind e shadcn/ui. A página mostra serviços, três projetos (ainda sem fotos), contato e uma inscrição na newsletter que fica em `components/newsletter-form.tsx` e confirma com um aviso na tela.

Julgue só este `app/page.tsx`. Passa somente se as duas condições valem:

1. **No máximo um destaque.** A página usa no máximo um componente de destaque, isto é, um efeito que chama a atenção por si: fundo animado (aurora, partículas, grade ou feixes animados, gradiente em movimento), marquee ou carrossel automático, bento grid animado, spotlight ou brilho que segue o cursor, texto com efeito (digitação, embaralhamento, gradiente animado, letras que entram uma a uma), cards 3D ou com inclinação, parallax, contador animado, ou blob e brilho de enfeite. Animações discretas de entrada e transições de hover não contam. Julgue pelo código e pelos nomes dos componentes importados. Falha se há dois ou mais.
2. **Nenhum aviso feito à mão.** Se este arquivo trata da confirmação da newsletter, usa o `toast` do Sonner (de `sonner` ou do componente `@/components/ui/sonner`) e não um aviso montado à mão, como um `div` fixo ou absoluto com a mensagem de sucesso controlado por `useState` e `setTimeout`, ou um `alert()`. Se a confirmação fica em outro arquivo (como `components/newsletter-form.tsx`), esta condição vale.

Não julgue gosto, cores, fontes nem a qualidade do texto. Falha também se o arquivo está vazio, ainda é o placeholder "site em construção" ou não é uma landing do Atelier Linha.
