Write-Host "ZELUSNET - Teste GLPI Agent"$UrlMSI = "https://github.com/v1BrN/zelusnet/releases/download/v0.5/GLPI-Agent-1.19-x64.msi"

$HashEsperado = "F3F933A54BC325FFE0D6063E177874E05138DD887FE690ADEF337640E8D6335C"

$Pasta = "C:\ProgramData\ZELUSNET"

$MSI = "$Pasta\GLPI-Agent-1.19-x64.msi"

if (!(Test-Path $Pasta))
{
    New-Item -ItemType Directory -Path $Pasta -Force | Out-Null
}

Write-Host "Baixando MSI..."

Invoke-WebRequest `
    -Uri $UrlMSI `
    -OutFile $MSI

Write-Host "Validando SHA256..."

$HashAtual =
(
    Get-FileHash `
    $MSI `
    -Algorithm SHA256
).Hash

if ($HashAtual -ne $HashEsperado)
{
    Write-Host "Hash inválido"

    exit 1
}

Write-Host "Hash válido"

Write-Host "Instalando GLPI Agent..."

Start-Process `
    msiexec.exe `
    -ArgumentList "/i `"$MSI`" /qn" `
    -Wait

Write-Host "Verificando serviço..."

$Servico =
    Get-Service `
    -Name "glpi-agent" `
    -ErrorAction SilentlyContinue

if ($Servico)
{
    Write-Host "GLPI Agent instalado com sucesso"
}
else
{
    Write-Host "Falha na instalação"

    exit 1
}
