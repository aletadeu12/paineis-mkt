# deploy-paineis.ps1
# Copia os paineis para o repo Git e faz push para o GitHub
# GitHub Pages serve automaticamente em: https://aletadeu12.github.io/paineis-mkt/
#   - Marcela : .../marcela-gf/
#   - TRACAO  : .../tracao-comercial/
#   - Controle: .../controle-mkt/
#   - Semanal : .../painel-semanal/

$REPO_DIR  = $PSScriptRoot
$WORKSPACE = Split-Path $REPO_DIR -Parent
$ARTIFACTS = "C:\Users\aleta\OneDrive\Documentos\Claude\Artifacts"

# Localiza a pasta de clientes sem hardcodar caracteres especiais
$CLIENTES = (Get-ChildItem $WORKSPACE -Directory | Where-Object { $_.Name -like "*Clientes*" }).FullName

Write-Host "Deploy Paineis MKT -- $(Get-Date -Format 'dd/MM/yyyy HH:mm')" -ForegroundColor Cyan
Write-Host "WORKSPACE : $WORKSPACE"
Write-Host "CLIENTES  : $CLIENTES"
Write-Host ""

# -- COPIA DOS PAINEIS -------------------------------------------------------
$copies = @(
    @{
        label = "Controle MKT"
        src   = "$ARTIFACTS\painel-controle-mkt\index.html"
        dst   = "$REPO_DIR\controle-mkt\index.html"
    },
    @{
        label = "Painel Semanal"
        src   = "$ARTIFACTS\adfly-painel-semana\index.html"
        dst   = "$REPO_DIR\painel-semanal\index.html"
    },
    @{
        label = "TRACAO Comercial"
        src   = "$CLIENTES\CLIENTE-TRAO-TRAC\painel-trao.html"
        dst   = "$REPO_DIR\tracao-comercial\index.html"
    },
    @{
        label = "Marcela Pinheiro GF"
        src   = "$CLIENTES\Marcela-Pinheiro-GF\painel-marcela-pinheiro.html"
        dst   = "$REPO_DIR\marcela-gf\index.html"
    },
    @{
        label = "ADFly"
        src   = "$CLIENTES\ADFly\painel-adfly.html"
        dst   = "$REPO_DIR\adfly\index.html"
    },
    @{
        label = "AleChef"
        src   = "$CLIENTES\AleChef\painel-alechef.html"
        dst   = "$REPO_DIR\alechef\index.html"
    },
    @{
        label = "BPMF"
        src   = "$CLIENTES\BPMF\painel-bpmf.html"
        dst   = "$REPO_DIR\bpmf\index.html"
    },
    @{
        label = "Raio-X TRACAO (link da bio)"
        src   = "$CLIENTES\CLIENTE-TRAO-TRAC\00 - Base Estrategica\PAGINA-RAIO-X-TRAC.html"
        dst   = "$REPO_DIR\raio-x\index.html"
    },
    # Cartao digital do Alexandre (QR Code de eventos) -- fonte: BPMF\CARTAO-DIGITAL
    @{ label = "Cartao digital (pagina)"; src = "$CLIENTES\BPMF\CARTAO-DIGITAL\index.html";          dst = "$REPO_DIR\alexandre\index.html" },
    @{ label = "Cartao digital (contato)"; src = "$CLIENTES\BPMF\CARTAO-DIGITAL\alexandre-tadeu.vcf"; dst = "$REPO_DIR\alexandre\alexandre-tadeu.vcf" },
    @{ label = "Cartao digital (foto)";    src = "$CLIENTES\BPMF\CARTAO-DIGITAL\foto-alexandre.jpg";  dst = "$REPO_DIR\alexandre\foto-alexandre.jpg" },
    @{ label = "Cartao digital (logo ADFly)";   src = "$CLIENTES\BPMF\CARTAO-DIGITAL\logo-adfly.png";   dst = "$REPO_DIR\alexandre\logo-adfly.png" },
    @{ label = "Cartao digital (logo TRACAO)";  src = "$CLIENTES\BPMF\CARTAO-DIGITAL\logo-tracao.png";  dst = "$REPO_DIR\alexandre\logo-tracao.png" },
    @{ label = "Cartao digital (logo AleChef)"; src = "$CLIENTES\BPMF\CARTAO-DIGITAL\logo-alechef.png"; dst = "$REPO_DIR\alexandre\logo-alechef.png" },
    @{ label = "Cartao digital (logo BPMF)";    src = "$CLIENTES\BPMF\CARTAO-DIGITAL\logo-bpmf.png";    dst = "$REPO_DIR\alexandre\logo-bpmf.png" }
    # -- NOVOS CLIENTES: adicionar aqui ------------------------------------
    # Padrao: @{ label="[Nome]"; src="$CLIENTES\[SIGLA]\painel-[sigla].html"; dst="$REPO_DIR\[sigla]\index.html" }
    # Depois criar novo site Netlify apontando para publish dir = "[sigla]"
    # ----------------------------------------------------------------------
)

foreach ($c in $copies) {
    if (Test-Path $c.src) {
        $dir = Split-Path $c.dst -Parent
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        Copy-Item -Path $c.src -Destination $c.dst -Force
        Write-Host "  OK $($c.label)" -ForegroundColor Green
    } else {
        Write-Host "  AVISO: nao encontrado -- $($c.label)" -ForegroundColor Yellow
        Write-Host "         $($c.src)" -ForegroundColor DarkYellow
    }
}

# -- GIT PUSH ----------------------------------------------------------------
Set-Location $REPO_DIR

# Travas de execucoes anteriores (.lock) impedem o git de rodar
$locks = Get-ChildItem -Path ".git" -Recurse -Force -Filter "*.lock*" -ErrorAction SilentlyContinue
if ($locks) {
    Write-Host ""
    Write-Host "ERRO: existem arquivos de trava do git (.lock). Feche outros programas que usam o git e apague:" -ForegroundColor Red
    $locks | ForEach-Object { Write-Host "  $($_.FullName)" -ForegroundColor Red }
    exit 1
}

# Sincroniza antes (evita rejeicao quando o repositorio mudou pelo site)
git pull --no-rebase --no-edit origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERRO no git pull. Resolva o conflito antes de publicar (nada foi enviado)." -ForegroundColor Red
    exit 1
}

$status = git status --porcelain
if ($status) {
    $msg = "Auto-deploy $(Get-Date -Format 'dd/MM/yyyy HH:mm')"
    git add .
    git commit -m $msg
    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "ERRO no git commit. Nada foi enviado." -ForegroundColor Red
        exit 1
    }
}

git push origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERRO no git push: NADA foi publicado. Veja a mensagem acima (login, permissao ou conflito)." -ForegroundColor Red
    exit 1
}
Write-Host ""
Write-Host "OK Publicado no GitHub Pages (aguarde 1-3 min): https://aletadeu12.github.io/paineis-mkt/" -ForegroundColor Green
