<p align="center">
  <img src="https://i.imgur.com/YMCepIi.png" alt="Shortcut Scripts Logo" width="200">
</p>

<h1 align="center">Shortcut Scripts</h1>

<p align="center">
  Uma coleção de scripts para Windows que automatizam tarefas comuns, testes e verificações rápidas usando PowerShell e Batch.
</p>

<p align="center">
  <a href="#instalação">Instalação</a> •
  <a href="#funcionalidades">Funcionalidades</a> •
  <a href="#aviso">Aviso</a> •
  <a href="#licença">Licença</a>
</p>

---

## 🚀 Instalação

Os scripts podem ser executados diretamente via PowerShell. Certifique-se de ter permissões administrativas quando necessário e revise o código antes de executar.

1. **Abra o PowerShell como administrador**:
   - Clique no **Menu Iniciar**, digite `PowerShell` e selecione **Executar como administrador**.
2. **Execute os comandos fornecidos** nas seções abaixo.

---

## 🔧 Funcionalidades

### 🌐 Teste de Sites Bloqueados

Verifica rapidamente se sites populares (streaming, redes sociais, música, etc.) estão acessíveis ou bloqueados.

#### Como usar
1. Abra o PowerShell (não precisa de privilégios administrativos para este script).
2. Execute o comando abaixo:
   ```powershell
   irm "https://bit.ly/3VHWr3C" | iex
   ```

#### Detalhes
- **O que faz**: Testa a conectividade com sites comuns.
- **Saída**: Exibe se cada site está acessível ou bloqueado.
- **Requisitos**: Conexão com a internet.

---

### 🔒 Bloqueio de Aplicativos por SRP

Aplica regras de **Software Restriction Policies (SRP)** para bloquear tipos de arquivo e pastas específicas, aumentando a segurança do sistema.

#### Como usar
1. Abra o PowerShell **como administrador**.
2. Execute o comando abaixo:
   ```powershell
   irm "https://bit.ly/4gQ26i0" | iex
   ```

#### Detalhes
- **O que faz**: Configura políticas para bloquear extensões de arquivos (ex.: `.msi`, `.bat`, `.ps1`) e permitir apenas pastas confiáveis.
- **Atenção**: Este script é independente do teste de sites. Requer reinicialização do sistema para aplicar as mudanças.
- **Requisitos**: Permissões administrativas.

#### 🔓 Como Desfazer as Regras SRP

<details>
<summary><strong> Clique para expandir: Instruções para reverter as regras SRP </strong></summary>

Se precisar reverter as políticas de Restrição de Software (SRP), siga este guia passo a passo para restaurar as configurações padrão. Isso remove os bloqueios e restaura a execução normal de arquivos.

##### PASSO 1: Abrir PowerShell como Administrador
É essencial executar com privilégios elevados para modificar o Registro e políticas.

1. Abra o menu Iniciar e digite **PowerShell**.
2. Clique com o botão direito em **Windows PowerShell** e selecione **Executar como administrador**.
3. Você verá uma janela com o título *Administrator: Windows PowerShell*.
4. Execute os comandos abaixo para remover a chave SRP e restaurar a política de execução padrão:
   ```powershell
   Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers" -Recurse -Force; Write-Output "Chave de SRP removida."
   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force;
   Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force; Write-Output "Políticas de execução restauradas."
   ```
5. Feche o PowerShell após a execução.

> ⚠️ **Atenção**: Certifique-se de entender os riscos antes de modificar políticas de execução e registros do Windows.

##### PASSO 2: Atualizar Políticas de Grupo
Atualize as políticas para aplicar as mudanças imediatamente.

1. Abra novamente o PowerShell como Administrador.
2. Execute o comando abaixo:
   ```powershell
   gpupdate /force; Write-Output "Políticas de grupo atualizadas."
   ```
3. **Reinício opcional**: Para aplicar completamente, reinicie o computador. Se quiser reiniciar automaticamente, execute:
   ```powershell
   Restart-Computer -Force
   ```

##### Informações Adicionais
- O SRP bloqueia arquivos por hash, caminho ou tipo. Ao remover a chave, todos os bloqueios são desativados.
- As políticas de execução do PowerShell (*ExecutionPolicy*) definem quais scripts podem ser executados. O padrão **RemoteSigned** permite scripts locais, mas exige assinatura para scripts baixados.
- O reinício garante que serviços e políticas sejam recarregados.
- Use este procedimento apenas em ambientes confiáveis ou máquinas de teste.

##### Resumo dos Comandos
```powershell
# Remove SRP
Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers" -Recurse -Force
# Restaurar políticas de execução
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force
# Atualizar políticas de grupo
gpupdate /force
# Reinício opcional
Restart-Computer -Force
```

> **Aviso Final**: A manipulação de políticas pode impactar a segurança. Execute apenas com conhecimento pleno.

</details>

---

## ⚠️ Aviso

- **Use por sua conta e risco**: Sempre revise o código dos scripts antes de executá-los.
- **Privilégios**: O script de SRP exige execução como administrador.
- **Backup**: Faça backup do Registro do Windows antes de aplicar mudanças no SRP.
- **Links**: Os comandos usam URLs encurtadas (Bitly). Verifique o destino final dos links para garantir segurança.

---

## 📜 Licença

Este projeto é distribuído sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

<p align="center">
  Desenvolvido com ❤️ para facilitar sua vida no Windows!
</p>
