# Setup GitHub + Netlify — Painéis MKT

## Modelo de privacidade — um site Netlify por painel

Cada painel tem sua própria URL. Cliente só recebe o link do painel dele.
Nenhum cliente consegue acessar o painel de outro.

| Painel | Para quem | URL sugerida | Publish dir |
|---|---|---|---|
| Controle MKT | Alexandre (interno) | `controle-mkt-ale.netlify.app` | `controle-mkt` |
| Painel Semanal | Alexandre (interno) | `painel-semanal-ale.netlify.app` | `painel-semanal` |
| Marcela Pinheiro GF | Marcela (cliente) | `marcela-mkt.netlify.app` | `marcela-gf` |
| TRAÇÃO Comercial | TRAÇÃO (cliente) | `tracao-mkt.netlify.app` | `tracao-comercial` |

> **Um repositório GitHub, múltiplos sites Netlify.** Quando você faz git push, todos os sites
> com acesso ao repo atualizam automaticamente. Cada site só "enxerga" a pasta dele.

---

## ETAPA 1 — Criar repositório no GitHub (5 min)

1. Acesse [github.com](https://github.com) → login
2. Clique em **"New repository"**
3. Preencha:
   - **Repository name:** `paineis-mkt`
   - **Visibility:** ✅ **Private** — obrigatório (painéis de clientes são confidenciais)
   - **Initialize with README:** desmarcado
4. Clique em **"Create repository"**
5. Anote a URL: `https://github.com/seu-usuario/paineis-mkt.git`

---

## ETAPA 2 — Configurar Git local (10 min, só uma vez)

Abra o **Git Bash** e rode:

```bash
git config --global user.name "Alexandre Tadeu"
git config --global user.email "aletadeu12@gmail.com"

cd "C:/Users/aleta/OneDrive/Documentos/Claude/Projects/Projeto Área de MKT/paineis-deploy"

git init
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/paineis-mkt.git
```

---

## ETAPA 3 — Primeiro deploy (5 min)

No Git Bash ou PowerShell:

```powershell
cd "C:/Users/aleta/OneDrive/Documentos/Claude/Projects/Projeto Área de MKT/paineis-deploy"
powershell -ExecutionPolicy Bypass -File ".\deploy-paineis.ps1"
```

Se pedir autenticação GitHub: GitHub → Settings → Developer settings →
Personal access tokens → Generate new token → permissão `repo` → use como senha.

---

## ETAPA 4 — Criar os sites Netlify (15 min)

**Repita este passo para cada painel** (4 vezes no total):

1. Acesse [netlify.com](https://netlify.com) → **"Add new site"** → **"Import an existing project"**
2. Escolha **GitHub** → selecione o repo `paineis-mkt`
3. Configurações:
   - **Branch:** `main`
   - **Build command:** (vazio)
   - **Publish directory:** `controle-mkt` ← muda para cada painel (ver tabela acima)
4. Clique **"Deploy site"**
5. Após deploy: **"Site configuration"** → **"Change site name"** → coloque o nome da tabela acima
6. Repita com os demais publish directories: `painel-semanal`, `marcela-gf`, `tracao-comercial`

**Para sites de clientes (Marcela, TRAÇÃO) — proteção extra (opcional):**
- No Netlify: **Site configuration** → **Access control** → **Password protection**
- Defina uma senha simples e envie junto com o link para o cliente

---

## ETAPA 5 — Registrar deploy automático (2 min)

Clique com botão direito em `register-deploy-task.bat` → **"Executar como administrador"**.

Isso registra **2 tarefas** no Windows Task Scheduler:

| Tarefa | Dia/hora | O que publica |
|---|---|---|
| `Deploy-Paineis-MKT` | Segunda 07:30 | Todos os painéis — pacote completo da semana |
| `Deploy-Paineis-MKT-Quinta` | Quinta 09:30 | Todos os painéis — radar atualizado |

**Lógica de temporalidade do radar:**
- **Seg a Qua** → radar no painel = semana em andamento
- **Qui em diante** → radar no painel = input do pacote da semana seguinte

O radar de quinta serve para Alexandre montar a grade da semana seguinte (provocações + grade editorial). Clientes externos (Marcela, TRAÇÃO) não são afetados — o pacote completo só aparece no painel deles na segunda de manhã (visão consolidada: domingo à noite).

Netlify recebe cada push e faz deploy em < 30 segundos.

---

## ETAPA 6 — Enviar URL para cada cliente

Após o primeiro deploy funcionar:

- **Marcela Pinheiro GF:** enviar `https://marcela-mkt.netlify.app` por WhatsApp/e-mail
- **TRAÇÃO:** enviar `https://tracao-mkt.netlify.app` por WhatsApp/e-mail
- Opcional: senha de acesso se tiver ativado o Password protection do Netlify

---

## Adicionando um novo cliente no futuro

Quando entrar um novo cliente:

1. **Crie o painel HTML** seguindo o template de onboarding (seção 7)
2. **Edite `deploy-paineis.ps1`** — adicione um novo bloco `@{ label=...; src=...; dst=... }` na seção "NOVOS CLIENTES"
3. **Rode `deploy-paineis.ps1`** manualmente → vai criar a subpasta e fazer push
4. **No Netlify:** Add new site → mesmo repo `paineis-mkt` → publish directory = `[sigla-cliente]` → renomeie o site
5. **Envie o link** para o cliente

---

## Resumo das URLs (preencher após setup)

| Painel | URL | Senha (se configurada) |
|---|---|---|
| Controle MKT | `https://controle-mkt-ale.netlify.app` | — |
| Painel Semanal | `https://painel-semanal-ale.netlify.app` | — |
| Marcela GF | `https://marcela-mkt.netlify.app` | — |
| TRAÇÃO | `https://tracao-mkt.netlify.app` | — |
