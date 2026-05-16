#! /bin/bash
# Variaveis
BASH_FILE="/home/$USER/.bash_aliases"

# Programas para uso no servidor
PROGRAMAS_PARA_INSTALAR_APT=(
  eza
  ncdu
  # openssh-server
  neofetch
  duf
)

PROGRAMAS_PARA_INSTALAR_SNAP=(
	btop
	tldr
)

# Configuração do .bash_aliases
cat <<EOF > $BASH_FILE 
# comandos personalizados
# Updates
alias update='sudo apt update'
alias upgrade='sudo apt upgrade -y'
alias updateall='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo snap refresh'

# manangers
alias shut='shutdown -h now'
alias cat='batcat'
alias install='sudo apt install'
alias ls='eza'
alias lsa='eza -lhai'
alias lst='eza -lhais size'
alias lsm='eza -lhais modified'
alias copiar='rsync -ah --progress'
alias ips='ip -c -br a'
alias gh='history | grep'
alias manual='tldr'
alias extrair='tar -xzvf'
alias linksim='sudo ln -s'
alias linkhard='ln'

# 1. Identifica a interface de rede física principal
INTERFACE=$(ls /sys/class/net | grep -v lo | head -n 1)

# 2. Encontra o arquivo .yaml do Netplan
ARQUIVO_NETPLAN=$(ls /etc/netplan/*.yaml | head -n 1)

# 3. Descobre o IP do Gateway atual (ex: 192.168.2.1)
IP_GATEWAY=$(ip route | grep default | awk '{print $3}' | head -n 1)

# 4. Extrai a faixa de IP (os 3 primeiros octetos, ex: 192.168.2.)
FAIXA_IP=$(echo $IP_GATEWAY | cut -d. -f1-3)

# 5. Define o IP final do servidor usando a faixa encontrada + o final .150
IP_SERVER="${FAIXA_IP}.150"

# Validação de segurança
if [ -z "$INTERFACE" ] || [ -z "$ARQUIVO_NETPLAN" ] || [ -z "$IP_GATEWAY" ]; then
    echo "Erro: Não foi possível identificar todos os parâmetros de rede automaticamente."
    echo "Interface: ${INTERFACE:-Não encontrada}"
    echo "Arquivo Netplan: ${ARQUIVO_NETPLAN:-Não encontrado}"
    echo "Gateway: ${IP_GATEWAY:-Não encontrado}"
else
    echo "=== Parâmetros Detectados ==="
    echo "Placa de Rede:  $INTERFACE"
    echo "Arquivo Config: $ARQUIVO_NETPLAN"
    echo "Gateway Atual:  $IP_GATEWAY"
    echo "Novo IP Fixo:   $IP_SERVER/24"
    echo "----------------------------------------"

    # 6. Substitui o conteúdo do Netplan com as variáveis descobertas
    sudo bash -c "cat <<EOF > $ARQUIVO_NETPLAN
	network:
	ethernets:
		$INTERFACE:
		dhcp4: no
		addresses:
			- $IP_SERVER/24
		routes:
			- to: default
			via: $IP_GATEWAY
		nameservers:
			addresses:
			- 8.8.8.8
			- 1.1.1.1
	version: 2
	EOF"

    echo "Configuração gerada com sucesso!"
    echo "Para aplicar e testar, execute: sudo netplan apply"
fi

instalar_pacotes_apt () {
	for programa in ${PROGRAMAS_PARA_INSTALAR_APT[@]}; do 
		if ! dpkg -l | grep -q $programa; then
			sudo apt install $programa -y
		else
			echo "[INFO] - O pacote $programa já está instalado."
		fi
	done
	sudo apt install bat -y
	sudo apt update
}

instalar_pacotes_snap () {
	#for pkgs in btop bashtop gimp gnome-boxes nvtop copilot-desktop tldr firefox; do sudo snap install "$pkgs" || true; done
	for programa in ${PROGRAMAS_PARA_INSTALAR_SNAP[@]}; do
		if ! snap list | grep -q $programa; then
			sudo snap install $programa
		else
			echo "[INFO] - O pacote $programa já está instalado."
		fi
	done
	tldr --update
	sudo snap refresh
}

instalar_pacotes_apt
instalar_pacotes_snap
