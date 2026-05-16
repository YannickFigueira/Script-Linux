```markdown
# 🚀 Configuração Inicial Automatizada - Ubuntu Server

Este repositório contém os scripts necessários para realizar a configuração inicial automatizada de um novo servidor Ubuntu, incluindo a criação de um array RAID, otimização de rede e aplicação de aliases personalizados.

---

## 📌 Pré-requisitos (Fase Local)

Antes de iniciar a automação, certifique-se de ativar o acesso remoto durante a instalação do sistema:

1. Durante a instalação do **Ubuntu Server**, marque a opção **"Install OpenSSH Server"**.
2. Após a conclusão, descubra o IP do servidor e faça o acesso via terminal do seu computador local para facilitar o processo de cópia e colagem dos comandos:
   ```bash
   ssh usuario@ip_do_servidor
   

```

---

## ⚡ Guia de Implantação (Fase SSH)

Uma vez conectado ao servidor via SSH, execute os comandos abaixo em ordem para baixar, dar permissão e rodar a esteira de configuração.

### 1. Download do Último Release (Servidor Config)

Os comandos abaixo consultam automaticamente a API do GitHub para identificar a versão mais recente do pacote `servidor_config.tar.xz`, realizam o download e descompactam os arquivos na pasta atual:

```bash
# Baixa o arquivo .tar.xz do último release lançado no GitHub
curl -s [https://api.github.com/repos/YannickFigueira/Script-Linux/releases/latest](https://api.github.com/repos/YannickFigueira/Script-Linux/releases/latest) \
| grep "browser_download_url.*servidor_config.tar.xz" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -

# Descompacta o pacote extraindo os scripts (.sh)
tar -xf servidor_config.tar.xz

```

### 2. Liberação de Permissões

Transforme os arquivos extraídos em executáveis no sistema:

```bash
chmod +x raid_config.sh
chmod +x server_config.sh

```

### 3. Execução da Esteira em Ordem

Rode os scripts um após o outro. O script de RAID preparará o armazenamento e o de servidor aplicará as redes, serviços e customizações:

```bash
./raid_config.sh
./server_config.sh

```

---

## 🔄 Pós-Execução

Após o término dos scripts, recarregue o ambiente do Bash para aplicar imediatamente os novos aliases (`manual`, `updateall`, `ls`, etc.) sem a necessidade de deslogar do servidor:

```bash
source ~/.bashrc

```

> 💡 **Nota de Segurança:** Certifique-se de validar se os discos secundários estão limpos antes de rodar o `raid_config.sh` e se o cabo de rede está conectado para que a detecção de IP dinâmico e gateway do `server_config.sh` funcione perfeitamente.

```


```