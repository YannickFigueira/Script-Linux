#! /bin/bash
# Variaveis
BASH_FILE="/home/$USER/.bash_aliases"

# Programas para uso no servidor
PACOTES_APT=(
  eza
  ncdu
  # openssh-server
  neofetch
  duf
  bat
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

EOF

istalar_dependencias () {
	for programa in ${PACOTES_APT[@]}; do 
		if ! dpkg -l | grep -q $programa; then
			sudo apt install $programa -y
		else
			echo "[INFO] - O pacote $programa já está instalado."
		fi
	done
	tldr --update
	sudo apt update
}

istalar_dependencias
