# Claude Code Prompt — Setup Netlify para painel-trao.html

Use este prompt no Claude Code quando precisar configurar ou reconfigurar o site Netlify da TRAÇÃO MKT.

---

## Contexto

O projeto tem 4 painéis HTML estáticos publicados no Netlify via GitHub:

| Painel | Subpasta do repo | Netlify site |
|---|---|---|
| Controle MKT | `controle-mkt/` | controle-mkt.netlify.app |
| ADFly Semanal | `painel-semanal/` | painel-semanal.netlify.app |
| TRAÇÃO MKT | `tracao-comercial/` | tracao-comercial.netlify.app |
| Marcela GF | `marcela-gf/` | marcela-gf.netlify.app |

Repo GitHub privado: `paineis-mkt`
Branch: `main`
Arquivo de deploy: `paineis-deploy/deploy-paineis.ps1`

---

## Prompt para Claude Code

```
Preciso validar e garantir que o painel da TRAÇÃO MKT esteja corretamente publicado no Netlify.

Contexto:
- Repo GitHub privado: paineis-mkt (branch main)
- Painel TRAÇÃO: arquivo painel-trao.html em "Agência MKT — Clientes\CLIENTE-TRAO-TRAC\"
- O script deploy-paineis.ps1 copia esse arquivo para a subpasta tracao-comercial/ do repo
- O site Netlify "tracao-comercial" aponta para publish dir = "tracao-comercial"

Por favor:
1. Verifique se a subpasta "tracao-comercial/" existe no repo paineis-mkt
2. Se não existir, crie o arquivo "tracao-comercial/index.html" copiando o conteúdo de:
   C:\Users\aleta\OneDrive\Documentos\Claude\Projects\Projeto Área de MKT\Agência MKT — Clientes\CLIENTE-TRAO-TRAC\painel-trao.html
3. Faça commit e push para o branch main
4. Confirme que o push foi realizado com sucesso

Se o site Netlify ainda não existir, me instrua a criar manualmente em app.netlify.com:
- Conectar ao repo paineis-mkt
- Publish directory: tracao-comercial
- Branch: main
- Nome do site: tracao-comercial (ou tracao-mkt se já estiver em uso)
```

---

## Como fazer deploy manual agora

No terminal (Windows PowerShell):

```powershell
cd "C:\Users\aleta\OneDrive\Documentos\Claude\Projects\Projeto Área de MKT\paineis-deploy"
powershell -ExecutionPolicy Bypass -File ".\deploy-paineis.ps1"
```

---

## Regras de atualização — painel-trao.html

| Quando atualizar | O quê |
|---|---|
| **Toda quinta** | Radar atualiza automaticamente via scheduled task → rodar deploy |
| **A cada nova semana de conteúdo** | Adicionar nova entrada em `const SEMANAS = [...]`, rodar deploy |
| **Novos concorrentes monitorados** | Atualizar `const RADAR = { concorrentes: [...] }` |
| **Nova execução do radar** | Atualizar `ultimaExecucao`, `proximaExecucao`, `radarFile`, dados dos concorrentes e oportunidades |

**Toggle automático:**
- Seg–Qua: aba "📊 Semana em curso" ativa por padrão
- Qui–Dom: aba "🔮 Próxima semana" ativa por padrão (radar acabou de rodar)

---

## Histórico de deploys

| Data | O que mudou |
|---|---|
| 16/06/2026 | Criação do painel S01 — primeira semana da TRAÇÃO |
| 18/06/2026 | Radar atualizado (18/06) + toggle adicionado + 5 concorrentes reais (C-01 a C-05) + paths corrigidos |
