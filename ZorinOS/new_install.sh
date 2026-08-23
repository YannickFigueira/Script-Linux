#!/bin/bash

# --- Definição de Funções ---
BASH_FILE="/home/$USER/.bash_aliases"

# Função para instalar pacotes APT
instalar_pacote() {
    local pacotes=("$@")
    for pacote in "${pacotes[@]}"; do
        echo "[INFO] [APT] Tentando instalar: $pacote"
        if sudo apt-get install -y "$pacote"; then
            echo "[OK] Pacote APT [$pacote] instalado com sucesso."
        else
            echo "[AVISO] Falha ao instalar o pacote APT: $pacote (continuando...)"
        fi
    done
}

# Função para instalar pacotes Snap
instalar_snap() {
    local pacote="$1"
    local flags="$2"
    echo "[INFO] [SNAP] Tentando instalar: $pacote"
    if sudo snap install $flags "$pacote"; then
        echo "[OK] Snap [$pacote] instalado com sucesso."
    else
        echo "[AVISO] Falha ao instalar o Snap: $pacote (continuando...)"
    fi
}

# Função para instalar pacotes Flatpak (do Flathub)
instalar_flatpak() {
    local pacotes=("$@")
    for pacote in "${pacotes[@]}"; do
        echo "[INFO] [FLATPAK] Tentando instalar: $pacote"
        if flatpak install flathub "$pacote" -y; then
            echo "[OK] Flatpak [$pacote] instalado com sucesso."
        else
            echo "[AVISO] Falha ao instalar o Flatpak: $pacote (continuando...)"
        fi
    done
}

criar_bashaliases () {
	# Configuração do .bash_aliases
	cat <<EOF > $BASH_FILE 
	# comandos personalizados
	# Updates
	alias updateall='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo snap refresh && sudo flatpak upgrade -y'

	# manangers
	alias shut='shutdown -h now'
	alias cat='batcat'
	alias install='sudo apt install'
	alias ls='exa'
	alias lsa='exa -lhai'
	alias lst='exa -lhais size'
	alias lsm='exa -lhais modified'
	alias copiar='rsync -ah --progress'
	alias ips='ip -c -br a'
	alias gh='history | grep'
	alias extrair='tar -xzvf'
	alias linksim='sudo ln -s'
	alias linkhard='ln'
EOF
}

# --- Início do Procedimento ---

# 1. Atualização do Sistema Básica
echo "[INFO] Atualizando listas do sistema via APT..."
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove -y

# 2. Configuração do Flatpak e Snapd no Zorin OS 16
echo "[INFO] Atualizando o mecanismo do Flatpak..."
sudo snap refresh
sudo flatpak upgrade -y

# 3. Instalação de Utilitários de Terminal (APT)
echo "[INFO] Instalando Ferramentas CLI (APT)..."
instalar_pacote duf ncdu neofetch exa eza bat

# 4. Instalação de Aplicativos de Uso Geral (Snap e Flatpak)
echo "[INFO] Instalando Softwares e Midia via Snap/Flatpak..."
instalar_snap "btop" "--devmode"
instalar_flatpak org.mozilla.firefox org.videolan.VLC com.bitwarden.desktop com.google.Chrome

# Timeshift via APT (Melhor desempenho/integração no Zorin que versão Flatpak)
echo "[INFO] Instalando Ferramentas de Backup (Timeshift)..."
#sudo add-apt-repository ppa:teejee2008/foss -y || true
sudo apt-get update
instalar_pacote timeshift

echo "[INFO] Instalando Jogos..."
instalar_pacote steam-devices
instalar_flatpak it.mijorus.gearlever

echo "[INFO] Instalando Ferramentas de Acesso Remoto..."
instalar_flatpak com.rustdesk.RustDesk

criar_bashaliases

# 8. Finalização e Limpeza
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt-get autoremove -y

echo "[INFO] Procedimento concluído com sucesso no Zorin OS 18!"
