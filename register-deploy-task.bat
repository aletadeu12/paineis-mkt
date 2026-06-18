@echo off
REM register-deploy-task.bat
REM Registra 2 tarefas no Windows Task Scheduler para deploy automático dos painéis
REM Execute como Administrador (botão direito → "Executar como administrador")

set SCRIPT_PATH=C:\Users\aleta\OneDrive\Documentos\Claude\Projects\Projeto Área de MKT\paineis-deploy\deploy-paineis.ps1

echo Registrando tarefas de deploy dos painéis MKT...
echo Script: %SCRIPT_PATH%
echo.

REM ── TAREFA 1: Segunda às 7h30 — deploy completo (todos os painéis)
REM    Clientes acordam segunda com o pacote da semana no ar.
set TASK_NAME=Deploy-Paineis-MKT
echo [1/2] Segunda 7h30 — deploy completo...

schtasks /Create /TN "%TASK_NAME%" /TR "powershell.exe -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File \"%SCRIPT_PATH%\"" /SC WEEKLY /D MON /ST 07:30 /F /RL HIGHEST

if %ERRORLEVEL% EQU 0 (
    echo ✅ Deploy-Paineis-MKT registrado ^(segunda 07:30^)
) else (
    echo ❌ Erro na tarefa SEGUNDA. Execute como Administrador.
)

echo.

REM ── TAREFA 2: Quinta às 9h30 — deploy pós-radar (só Painel Controle MKT)
REM
REM    O radar roda às 8h na quinta. Às 9h o painel-controle-mkt-quinta já atualizou
REM    o artifact com os novos dados. Este deploy publica essa versão no Netlify.
REM
REM    LÓGICA DE TEMPORALIDADE DO RADAR:
REM      Seg a Qua → radar visível = semana EM ANDAMENTO
REM      Qui em diante → radar visível = INPUT da semana SEGUINTE
REM
REM    Isso é correto: Alexandre precisa do radar atualizado na quinta para
REM    começar a montar a grade da semana seguinte (provocações + grade editorial).
REM    Clientes externos (Marcela, TRAÇÃO) só veem o painel deles — não são afetados.
REM    O pacote completo do cliente só aparece no painel deles na segunda de manhã.
set TASK_NAME_QUI=Deploy-Paineis-MKT-Quinta
echo [2/2] Quinta 9h30 — deploy pós-radar...

schtasks /Create /TN "%TASK_NAME_QUI%" /TR "powershell.exe -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File \"%SCRIPT_PATH%\"" /SC WEEKLY /D THU /ST 09:30 /F /RL HIGHEST

if %ERRORLEVEL% EQU 0 (
    echo ✅ Deploy-Paineis-MKT-Quinta registrado ^(quinta 09:30^)
) else (
    echo ❌ Erro na tarefa QUINTA. Execute como Administrador.
)

echo.
echo Para verificar: Agendador de Tarefas ^> procure:
echo   - "Deploy-Paineis-MKT"         ^(segunda 07:30^)
echo   - "Deploy-Paineis-MKT-Quinta"  ^(quinta  09:30^)

pause
