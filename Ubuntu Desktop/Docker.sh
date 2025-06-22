#! /bin/bash

# Pastas
KEYRIGS="/etc/apt/keyrings"
PASTA_INSTALACAO="/home/$USER/Downloads"

# URLs
URL_DOCKER="https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64&_gl=1*1cqxlth*_gcl_au*Nzc2Mjk4NDg2LjE3NTA0NjY2MjY.*_ga*MTI5Njc3NTgyOS4xNzUwNDY2NjI2*_ga_XJWPQMJYHQ*czE3NTA0NjY2MjYkbzEkZzEkdDE3NTA0NjgyOTIkajU0JGwwJGgw"

atualiazar_repositorios () {
	sudo apt update
}

instalar_pacotes_apt () {
	for pkga in qemu-system-x86 pass ca-certificates curl gnupg lsb-release uidmap; do sudo apt install -y $pkga || true; done
}

preparar_ambiente () {
	[[ ! -d $KEYRIGS ]] && sudo mkdir -p $KEYRIGS
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o $KEYRIGS/docker.gpg --yes

	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=$KEYRIGS/docker.gpg] \
	  https://download.docker.com/linux/ubuntu \
	  $(lsb_release -cs) stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	  atualiazar_repositorios
  	  for pkgdkr in docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; do sudo apt install -y $pkgdkr || true; done
}

instalar_pacotes_debs () {
	wget -c "$URL_DOCKER" -O $PASTA_INSTALACAO/docker-desktop-amd64.deb 
	sudo dpkg -i $PASTA_INSTALACAO/docker-desktop-amd64.deb
	rm $PASTA_INSTALACAO/docker-desktop-amd64.deb
	sudo apt -f install -y
}

upgrade_limpeza () {
	sudo apt full-upgrade -y
	sudo apt autoclean
	sudo apt autoremove -y
}

teste_ambiente () {
	sudo docker run hello-world
	docker --version
	docker
}

desenvolvedores () {
	echo "P.S. E AGRADECIMENTO"
	echo "Feito Por HBLlogan e YannickFigueira"
}

atualiazar_repositorios
instalar_pacotes_apt
preparar_ambiente
instalar_pacotes_debs
upgrade_limpeza
teste_ambiente
desenvolvedores