<p align="center">
  <img src="https://i.imgur.com/YMCepIi.png" alt="Shortcut Scripts Logo" width="200">
</p>

<h1 align="center">Shortcut Scripts</h1>

<p align="center">
  Uma coleção de scripts para Windows que automatizam tarefas comuns, testes e verificações rápidas usando PowerShell e Batch.
</p>

---

## 🔧 Scripts Disponíveis

### 🌐 Teste de Sites Bloqueados
**Descrição**: Verifica rapidamente se sites populares (streaming, redes sociais, música, etc.) estão acessíveis ou bloqueados.

<details>
<summary><strong>Clique para expandir: Detalhes e instruções</strong></summary>

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

</details>

---

### 🔒 Bloqueio de Aplicativos por SRP
**Descrição**: Aplica regras de **Software Restriction Policies (SRP)** para bloquear tipos de arquivo e pastas específicas, aumentando a segurança do sistema.

<details>
<summary><strong>Clique para expandir: Detalhes e instruções</strong></summary>

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
3. **Reinício opcional**: Para
