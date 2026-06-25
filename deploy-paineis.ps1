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
    }
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

$status = git status --porcelain
if ($status) {
    $msg = "Auto-deploy $(Get-Date -Format 'dd/MM/yyyy HH:mm')"
    git add .
    git commit -m $msg
    git push origin main
    Write-Host ""
    Write-Host "OK Push concluido: $msg" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "INFO: Sem mudancas -- nada a fazer." -ForegroundColor Gray
}
