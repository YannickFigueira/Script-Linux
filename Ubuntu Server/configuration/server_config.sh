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
  bat
  tldr
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

EOF

instalar_pacotes_apt () {
	for programa in ${PROGRAMAS_PARA_INSTALAR_APT[@]}; do 
		if ! dpkg -l | grep -q $programa; then
			sudo apt install $programa -y
		else
			echo "[INFO] - O pacote $programa já está instalado."
		fi
	done
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
