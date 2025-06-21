sudo apt update

sudo apt upgrade -y

sudo apt install qemu-system-x86 pass uidmap -y

sudo apt install -y ca-certificates curl gnupg lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt install docker-ce docker-ce-cli containerd.io -y

wget -c /home/junior/Downloads/docker-desktop-amd64.deb "https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64&_gl=1*1cqxlth*_gcl_au*Nzc2Mjk4NDg2LjE3NTA0NjY2MjY.*_ga*MTI5Njc3NTgyOS4xNzUwNDY2NjI2*_ga_XJWPQMJYHQ*czE3NTA0NjY2MjYkbzEkZzEkdDE3NTA0NjgyOTIkajU0JGwwJGgw"

sudo dpkg -i /home/junior/Downloads/docker-desktop-amd64.deb

sudo apt update 

sudo apt upgrade -y

sudo apt autoclean

sudo apt autoremove -y

sudo docker run hello-world

docker --version

docker
