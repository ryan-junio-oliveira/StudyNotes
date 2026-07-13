# Comandos Essenciais do Windows (Explicados)

## 1. Comandos via WIN + R (Executar)

### Administração e Configurações

-   **Gerenciar usuários:** `netplwiz`, `control userpasswords2` ---
    Gerencia contas e permissões.
-   **Gerenciamento do Computador:** `compmgmt.msc` --- Acessa discos,
    usuários, serviços e logs.
-   **Usuários e Grupos Locais:** `lusrmgr.msc` --- Gerencia contas e
    grupos locais.
-   **Diretiva de Grupo:** `gpedit.msc` --- Configura políticas
    avançadas do sistema.
-   **Editor de Registro:** `regedit` --- Edita configurações internas
    do sistema.
-   **Serviços:** `services.msc` --- Inicia, para e configura serviços.
-   **Monitor de Recursos:** `resmon` --- Monitoramento detalhado de
    CPU, RAM, disco e rede.
-   **Gerenciador de Dispositivos:** `devmgmt.msc` --- Gerencia drivers
    e hardware.
-   **Informações do Sistema:** `msinfo32` --- Dados completos do
    sistema e hardware.

### Ferramentas de Sistema

-   **Painel de Controle:** `control`
-   **Propriedades do Sistema:** `sysdm.cpl`
-   **Adaptadores de Rede:** `ncpa.cpl`
-   **Configurações Modernas:** `ms-settings:`
-   **Limpeza de Disco:** `cleanmgr`
-   **Diagnóstico de Memória:** `mdsched`

### Interface

-   **Explorador de Arquivos:** `explorer`
-   **Calculadora:** `calc`
-   **Bloco de Notas:** `notepad`
-   **Teclado Virtual:** `osk`

------------------------------------------------------------------------

## 2. Comandos Importantes no CMD

### Rede

-   `ipconfig /all` --- Exibe IP e detalhes da rede.
-   `ipconfig /release` --- Libera o IP atual.
-   `ipconfig /renew` --- Solicita novo IP ao DHCP.
-   `ping endereço` --- Testa conexão.
-   `tracert endereço` --- Exibe a rota até um servidor.
-   `netstat -an` --- Mostra portas abertas e conexões ativas.
-   `ipconfig /flushdns` --- Limpa o cache DNS.

### Sistema

-   `systeminfo` --- Informações completas do sistema.
-   `tasklist` --- Lista processos ativos.
-   `taskkill /IM nome.exe /F` --- Finaliza processos.
-   `query user` --- Usuários logados.
-   `sfc /scannow` --- Repara arquivos do Windows.
-   `DISM /Online /Cleanup-Image /RestoreHealth` --- Repara a imagem do
    sistema.

### Arquivos e Diretórios

-   `dir` --- Lista arquivos do diretório.
-   `cd pasta` --- Entra em diretório.
-   `copy origem destino` --- Copia arquivos.
-   `move origem destino` --- Move arquivos.
-   `del arquivo` --- Remove arquivos.
-   `mkdir nome` --- Cria nova pasta.

------------------------------------------------------------------------

## 3. Comandos Avançados

### Usuários

-   `net user nome senha /add` --- Cria usuário.
-   `net localgroup administrators nome /add` --- Torna administrador.
-   `net user` --- Lista todos os usuários.

### Energia

-   `shutdown /s /t 0` --- Desliga imediatamente.
-   `shutdown /r /t 0` --- Reinicia.
-   `shutdown /a` --- Cancela desligamento agendado.
