# Evita problemas de execução, definindo a política apenas para o processo atual
# Compatível com PowerShell 2.0+; -Scope Process é seguro e não persiste
try {
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force -ErrorAction Stop
    Write-Output "Iniciando configuracao de Politicas de Restricao de Software (SRP)..."
} catch {
    Write-Output "Erro ao definir politica de execucao: ${_}"
    exit
}

# Verificar se o script está sendo executado como administrador
# Usa método compatível com PowerShell 2.0+
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Output "Este script precisa ser executado como Administrador. Execute novamente com privilegios elevados."
    exit
}

# Caminho base do SRP no Registro
$srpBase = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"

# 1. Criar chave principal se não existir
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

# 2. Definir "Disallowed" como padrão
try {
    Set-ItemProperty -Path $srpBase -Name "DefaultLevel" -Value 0x00001000 -ErrorAction Stop
    Set-ItemProperty -Path $srpBase -Name "PolicyScope" -Value 0 -ErrorAction Stop
    Set-ItemProperty -Path $srpBase -Name "TransparentEnabled" -Value 1 -ErrorAction Stop
    Set-ItemProperty -Path $srpBase -Name "AuthenticodeEnabled" -Value 0 -ErrorAction Stop
    Write-Output "Padrao definido como 'Nao permitido'"
} catch {
    Write-Output "Erro ao definir o padrao: ${_}"
    exit
}

# 3. Criar regras adicionais (pastas permitidas)
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
    try {
        New-Item -Path $rulesPath -Force -ErrorAction Stop | Out-Null
        Write-Output "Diretorio de regras de caminho criado"
    } catch {
        Write-Output "Erro ao criar diretorio de regras: ${_}"
        exit
    }
}

# Criar regras para cada caminho
$i = 1
foreach ($path in $additionalRules) {
    $ruleKey = "$rulesPath\{0000000${i}}"
    try {
        if (-not (Test-Path $ruleKey)) {
            New-Item -Path $ruleKey -Force -ErrorAction Stop | Out-Null
        }
        Set-ItemProperty -Path $ruleKey -Name "ItemData" -Value $path -ErrorAction Stop
        Set-ItemProperty -Path $ruleKey -Name "SaferFlags" -Value 0 -ErrorAction Stop
        Set-ItemProperty -Path $ruleKey -Name "LastModified" -Value ([datetime]::Now.ToFileTimeUtc()) -ErrorAction Stop
        Set-ItemProperty -Path $ruleKey -Name "Level" -Value 0x00040000 -ErrorAction Stop
        Write-Output "Regra criada: ${path}"
    } catch {
        Write-Output "Erro ao criar regra para ${path}: ${_}"
    }
    $i++
}

# 4. Bloquear extensões adicionais
$fileTypesPath = "$srpBase\FileTypes"
if (-not (Test-Path $fileTypesPath)) {
    try {
        New-Item -Path $fileTypesPath -Force -ErrorAction Stop | Out-Null
        Write-Output "Diretorio de extensoes criado"
    } catch {
        Write-Output "Erro ao criar diretorio de extensoes: ${_}"
        exit
    }
}
$blockedExtensions = @(".msi", ".msp", ".bat", ".cmd", ".vbs", ".js", ".ps1", ".appinstaller")
foreach ($ext in $blockedExtensions) {
    $extKey = "$fileTypesPath\${ext}"
    try {
        if (-not (Test-Path $extKey)) {
            New-Item -Path $extKey -Force -ErrorAction Stop | Out-Null
        }
        Write-Output "Extensao bloqueada: ${ext}"
    } catch {
        Write-Output "Erro ao bloquear extensao ${ext}: ${_}"
    }
}
Write-Output "A extensao .LNK nao foi bloqueada para evitar quebra de atalhos"

# 5. Informar que as políticas serão aplicadas após reinicialização
Write-Output "Politicas configuradas com sucesso! Reinicie o computador para aplicar as alteracoes."

# 6. Pausar no final para ver o log, com compatibilidade para PowerShell 2.0
if ($PSVersionTable.PSVersion.Major -ge 3) {
    Read-Host -Prompt "Finalizado. Pressione ENTER para sair"
} else {
    Write-Output "Finalizado. Pressione qualquer tecla para sair..."
    $null = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}