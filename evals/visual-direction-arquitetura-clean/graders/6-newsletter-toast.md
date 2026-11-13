---
type: llm
focus:
  source: file
  path: components/newsletter-form.tsx
weight: 2
---

Contexto: a spec aprovada pede, na landing do Atelier Linha (projeto Next com Tailwind e shadcn/ui), uma inscrição na newsletter em `components/newsletter-form.tsx`. O formulário pede só o e-mail e envia `{ "email": "..." }` para `POST /api/newsletter`, que já existe e responde `{ "ok": true }` quando aceita e `{ "ok": false, "error": "..." }` com status 400 quando o e-mail é inválido. Quando dá certo, a página confirma com um aviso na tela; quando dá errado, diz o motivo.

Julgue só este arquivo. Passa somente se as duas condições valem:

1. **Aviso do Sonner.** A confirmação usa o `toast` do Sonner, importado de `sonner` ou do componente `@/components/ui/sonner` (por exemplo `toast.success(...)`). Falha se o aviso é feito à mão: um `div` fixo ou absoluto com a mensagem controlado por `useState` e `setTimeout`, um componente de toast próprio, ou `alert()`.
2. **Sucesso só com resposta de verdade.** O formulário chama `fetch` em `/api/newsletter` com método `POST` e só mostra o aviso de sucesso depois de a resposta indicar sucesso (`ok` da resposta HTTP ou `ok: true` do corpo). Falha se mostra sucesso sem chamar a rota, ou antes de ter a resposta.

Não julgue gosto, cores nem a qualidade do texto. Falha também se o arquivo está vazio ou não é o formulário da newsletter.
