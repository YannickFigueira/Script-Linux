#!/bin/bash

var ips=ip -c -br a

desenhar_caixa() {
    titulo=$1
    largura=30

    # 1. Obtém o número de caracteres da variável
    if (( ${#titulo} > largura )); then
      largura=$(( ${#titulo} + 2 ))
    fi

    # 2. Cria a linha de traços correspondente ao tamanho do texto
    # Repete o caractere '-' a quantidade de vezes que consta na variável 'tam'
    #linha=$(printf '%*s' "$tam" '' | tr ' ' '-')

    # Cria a linha superior e inferior fixa
    borda=$(printf '%*s' "$largura" '' | tr ' ' '-')

    # Calcula o espaçamento para centralizar o texto
    pad=$(( (largura - ${#titulo}) / 2 ))

    # Exibe a caixa centralizada
    echo "+${borda}+"
    printf "|%*s%s%*s|\n" $pad "" "$titulo" $(( largura - pad - ${#titulo} )) ""
    echo "+${borda}+"
}

caixa_videos() {
    local texto="$1"

    # 1. Encontra a maior linha para definir o tamanho automático da caixa
    local largura=0
    while IFS= read -r linha || [[ -n "$linha" ]]; do
        if (( ${#linha} > largura )); then
            largura=${#linha}
        fi
    done <<< "$texto"

    # Adiciona 2 espaços para as margens
    largura=$(( largura + 2 ))

    # 2. Cria a borda baseada na maior linha encontrada
    local borda=$(printf '%*s' "$largura" '' | tr ' ' '-')

    # 3. Exibe a caixa formatada
    echo "+${borda}+"
    while IFS= read -r linha || [[ -n "$linha" ]]; do
        printf "| %-*s |\n" "$((largura - 2))" "$linha"
    done <<< "$texto"
    echo "+${borda}+"
}

start() {

    clear

    desenhar_caixa "Welcome"
    echo
    desenhar_caixa "Informações"

    echo 'Escolha uma das opções'
    echo '[1] - Verificar redes'
    echo '[2] - Verificar placas de vídeo'
    read -p "Digite uma opção: " pesquisar

    if [[ $pesquisar -eq "1" ]]; then redes; fi
    if [[ $pesquisar -eq "2" ]]; then videos; fi
}

usuario() {

    read -p "Digite o Login: " nome
    read -s -p "Digite a senha: " senha

    echo "$nome - $senha"
}

redes() {

    clear

    desenhar_caixa "Redes"

    echo 'Escolha uma das opções'
    echo '[1] - Listar ips'
    echo '[2] - Verificar rota do site'
    echo '[v] - Voltar'
    read -p "Digite uma opção: " rede

    if [[ $rede -eq "1" ]]; then ip -c -br a; fi
    if [[ $rede -eq "2" ]]; then read -p "Digite ou cole o site aqui: " site && traceroute $site; fi
    if [[ $rede -eq "v" ]]; then start; fi

    #start
}

videos() {

    clear

    desenhar_caixa "Vídeos"

    echo 'Escolha uma das opções'
    echo '[1] - Identificar placa de vídeo'
    echo '[2] - listar codec gráficos'
    echo '[v] - Voltar'
    read -p "Digite uma opção: " video

    if [[ $video -eq "1" ]]; then

        resultado=$(lspci | grep -i -E 'vga|3d|display';)
        desenhar_caixa "$resultado"
        echo 'Selecione a sua placa identificada'
        echo '[1] - Nvidia'
        read -p "Digite a opção: " video

        if [[ $video -eq "1" ]]; then nvidia-smi; fi
    fi
    if [[ $video -eq 2 ]]; then
      opengl_valor=$(glxinfo | grep -i "opengl version")
      vulkan_valor=$(vulkaninfo | head -n 5)

      caixa_videos "$(printf "%s\n%s" "$opengl_valor" "$vulkan_valor")"
    fi
    if [[ $video -eq "v" ]]; then start; fi

    #start
}


start

#usuario