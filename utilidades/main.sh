#!/bin/bash

ips = ip -c -br a

start() {
    
    clear

    echo '--------------------'
    echo '|     Welcome      |'
    echo '--------------------'
}

usuario() {

    read -p "Digite o Login: " nome
    read -s -p "Digite a senha: " senha

    echo "$nome - $senha"
}

pesquisa() {

    #clear

    echo '--------------------'
    echo '|   Informações    |'
    echo '--------------------'

    echo 'Escolha uma das opções'
    echo '[1] - Verificar redes'
    echo '[2] - Verificar placas de vídeo'
    read -p "Digite uma opção: " pesquisar

    if [[ $pesquisar -eq "1" ]]; then redes; fi
    if [[ $pesquisar -eq "2" ]]; then videos; fi
}

redes() {

    clear

    echo '--------------------'
    echo '|      Redes        |'
    echo '--------------------'

    echo 'Escolha uma das opções'
    echo '[1] - Listar ips'
    echo '[2] - Verificar rota do site'
    echo '[v] - Voltar'
    read -p "Digite uma opção: " rede

    if [[ $rede -eq "1" ]]; then ip -c -br a; fi
    if [[ $rede -eq "2" ]]; then read -p "Digite ou cole o site aqui: " site && traceroute $site; fi
    if [[ $rede -eq "v" ]]; then start && pesquisa; fi
}

videos() {

    clear

    echo '--------------------'
    echo '|      Vídeos       |'
    echo '--------------------'

    echo 'Escolha uma das opções'
    echo '[1] - Identificar placa de vídeo'
    echo '[2] - Verificar driver instalado'
    echo '[v] - Voltar'
    read -p "Digite uma opção: " video

    if [[ $video -eq "1" ]]; then 
        echo '----------------------------------------'
        lspci | grep -i -E 'vga|3d|display';
        echo '----------------------------------------'
        echo 'Selecione a sua placa identificada'
        echo '[1] - Nvidia'
        read -p "Digite a opção: " video

        if [[ $video -eq "1" ]]; then nvidia-smi; fi
    fi
    if [[ $video -eq "v" ]]; then start && pesquisa; fi
}


start

#usuario

pesquisa