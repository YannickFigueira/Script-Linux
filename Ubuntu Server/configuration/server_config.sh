#! /bin/bash

# Programas para uso no servidor
PACOTES_APT=(
  eza
  ncdu
  openssh-server
  neofetch
  duf
)

sudo apt update -y
sudo apt -f install -y
for pkgapt in ${PACOTES_APT[@]}; do
  sudo apt install $pkgapt -y
done
sudo snap install btop
sudo snap refresh

# Configuração da rede
cat <<EOF > 00-installer-config.yaml
network:
  ethernets:
    enp0s3:
      dhcp4: no
      addresses:
        - 192.168.2.150/24
      routes:
        - to: default
          via: 192.168.2.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 1.1.1.1
  version: 2
EOF
sudo mv 00-installer-config.yaml /etc/netplan/00-installer-config.yaml
sudo netplan apply
curl -fsSL https://get.casaos.io | sudo bash

sudo apt update && sudo apt full-upgrade -y
sudo apt autoclean
sudo apt autoremove -y

