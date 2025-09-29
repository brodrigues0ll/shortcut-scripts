# Evita problemas de execução
try {
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force -ErrorAction Stop
    Write-Output "Iniciando configuracao de Politicas de Restricao de Software (SRP)..."
} catch {
    Write-Output "Erro ao definir politica de execucao: ${_}"
    exit
}

# Verificar se é administrador
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Output "Este script precisa ser executado como Administrador."
    exit
}

# Caminho base
$srpBase = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"

# Criar chave principal
if (-not (Test-Path $srpBase)) {
    try {
        New-Item -Path $srpBase -Force -ErrorAction Stop | Out-Null
        Write-Output "Diretorio de SRP criado no Registro"
    } catch {
        Write-Output "Erro ao criar diretorio SRP: ${_}"
        exit
    }
} else {
    Write-Output "Diretorio de SRP ja existe"
}

# Definir "Disallowed" como padrão (sem sobrescrever se já existir)
try {
    if (-not (Get-ItemProperty -Path $srpBase -Name "DefaultLevel" -ErrorAction SilentlyContinue)) {
        Set-ItemProperty -Path $srpBase -Name "DefaultLevel" -Value 0x00001000
    }
    if (-not (Get-ItemProperty -Path $srpBase -Name "PolicyScope" -ErrorAction SilentlyContinue)) {
        Set-ItemProperty -Path $srpBase -Name "PolicyScope" -Value 0
    }
    if (-not (Get-ItemProperty -Path $srpBase -Name "TransparentEnabled" -ErrorAction SilentlyContinue)) {
        Set-ItemProperty -Path $srpBase -Name "TransparentEnabled" -Value 1
    }
    if (-not (Get-ItemProperty -Path $srpBase -Name "AuthenticodeEnabled" -ErrorAction SilentlyContinue)) {
        Set-ItemProperty -Path $srpBase -Name "AuthenticodeEnabled" -Value 0
    }
    Write-Output "Padrao definido como 'Nao permitido'"
} catch {
    Write-Output "Erro ao definir o padrao: ${_}"
    exit
}

# Regras adicionais
$additionalRules = @(
    "C:\Windows\",
    "C:\Program Files\",
    "C:\Program Files (x86)\",
    "C:\Program Files (x86)\Microsoft Intune Management Extension\",
    "C:\INFOMET\",
    "C:\ProgramData\TSAWEB\",
    "$PWD\"
)
$rulesPath = "$srpBase\0\Paths"
if (-not (Test-Path $rulesPath)) {
    New-Item -Path $rulesPath -Force | Out-Null
    Write-Output "Diretorio de regras de caminho criado"
}

$i = 1
foreach ($path in $additionalRules) {
    $ruleKey = "$rulesPath\{0000000${i}}"
    if (-not (Test-Path $ruleKey)) {
        try {
            New-Item -Path $ruleKey -Force | Out-Null
            Set-ItemProperty -Path $ruleKey -Name "ItemData" -Value $path
            Set-ItemProperty -Path $ruleKey -Name "SaferFlags" -Value 0
            Set-ItemProperty -Path $ruleKey -Name "LastModified" -Value ([datetime]::Now.ToFileTimeUtc())
            Set-ItemProperty -Path $ruleKey -Name "Level" -Value 0x00040000
            Write-Output "Regra criada: ${path}"
        } catch {
            Write-Output "Erro ao criar regra para ${path}: ${_}"
        }
    } else {
        Write-Output "Regra ja existente: ${path}"
    }
    $i++
}

# Bloquear extensões adicionais (menos .ps1)
$fileTypesPath = "$srpBase\FileTypes"
if (-not (Test-Path $fileTypesPath)) {
    New-Item -Path $fileTypesPath -Force | Out-Null
    Write-Output "Diretorio de extensoes criado"
}
$blockedExtensions = @(".msi", ".msp", ".bat", ".cmd", ".vbs", ".js", ".appinstaller")
foreach ($ext in $blockedExtensions) {
    $extKey = "$fileTypesPath\${ext}"
    if (-not (Test-Path $extKey)) {
        try {
            New-Item -Path $extKey -Force | Out-Null
            Write-Output "Extensao bloqueada: ${ext}"
        } catch {
            Write-Output "Erro ao bloquear extensao ${ext}: ${_}"
        }
    } else {
        Write-Output "Extensao ja bloqueada: ${ext}"
    }
}
Write-Output "A extensao .LNK nao foi bloqueada para evitar quebra de atalhos"

# Aviso de reinicio
Write-Output "Politicas configuradas com sucesso! Reinicie o computador para aplicar as alteracoes."

# Pausa no final
if ($PSVersionTable.PSVersion.Major -ge 3) {
    Read-Host -Prompt "Finalizado. Pressione ENTER para sair"
} else {
    Write-Output "Finalizado. Pressione qualquer tecla para sair..."
    $null = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}
