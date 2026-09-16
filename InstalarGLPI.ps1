# =========================================
# ZELUSNET - Instalar GLPI Agent
# Versão 0.6
# =========================================

$UrlMSI = "https://github.com/v1BrN/zelusnet/releases/download/v0.5/GLPI-Agent-1.19-x64.msi"

$HashEsperado = "F3F933A54BC325FFE0D6063E177874E05138DD887FE690ADEF337640E8D6335C"

$Pasta = "C:\ProgramData\ZELUSNET"

$MSI = "$Pasta\GLPI-Agent-1.19-x64.msi"

# Cria pasta

if (!(Test-Path $Pasta))
{
    New-Item `
        -ItemType Directory `
        -Path $Pasta `
        -Force | Out-Null
}

Write-Host ""
Write-Host "Baixando MSI..."

Invoke-WebRequest `
    -Uri $UrlMSI `
    -OutFile $MSI

if (!(Test-Path $MSI))
{
    Write-Host "Falha no download"

    exit 1
}

Write-Host "Download concluído"

Write-Host ""
Write-Host "Validando SHA256..."

$HashAtual =
(
    Get-FileHash `
        $MSI `
        -Algorithm SHA256
).Hash

if ($HashAtual -ne $HashEsperado)
{
    Write-Host ""
    Write-Host "HASH INVALIDO"

    exit 1
}

Write-Host ""
Write-Host "HASH VALIDO"

Write-Host ""
Write-Host "Instalando GLPI Agent..."

Start-Process `
    msiexec.exe `
    -ArgumentList "/i `"$MSI`" /qn" `
    -Wait

Start-Sleep 10

$Servico =
Get-Service `
    -Name "glpi-agent" `
    -ErrorAction SilentlyContinue

if ($Servico)
{
    Write-Host ""
    Write-Host "GLPI Agent instalado com sucesso"

    $Servico
}
else
{
    Write-Host ""
    Write-Host "Falha ao localizar servico"

    exit 1
}
