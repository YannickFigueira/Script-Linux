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

caixa_resultado() {
    local texto="$1"
    local titulo="${2:-"=== INFORMAÇÕES ==="}" # Título padrão caso não passe o segundo argumento
    local largura=0

    # 1. Limpa os códigos de cores ANSI (\033[...m) apenas para calcular a largura real da tela
    while IFS= read -r linha || [[ -n "$linha" ]]; do
        linha_limpa=$(echo -e "$linha" | sed 's/\x1b\[[0-9;]*m//g')
        if (( ${#linha_limpa} > largura )); then
            largura=${#linha_limpa}
        fi
    done <<< "$texto"

    # 1. Converte TABs em espaços e calcula a maior linha do texto
    texto_formatado=$(echo "$texto" | expand -t 4)

    while IFS= read -r linha || [[ -n "$linha" ]]; do
        if (( ${#linha} > largura )); then
            largura=${#linha}
        fi
    done <<< "$texto_formatado"

    # Adiciona 2 espaços de margem nas laterais
    largura=$(( largura + 2 ))

    # Se o título for maior que o texto, ajusta a largura para o título
    if (( ${#titulo} + 4 > largura )); then
        largura=$(( ${#titulo} + 4 ))
    fi

    # 2. Cria a borda baseada no tamanho visual real
    local borda=$(printf '%*s' "$largura" '' | tr ' ' '-')

    pad=$(( (largura - ${#titulo}) / 2 ))

    # 3. Imprime a caixa com cabeçalho
    echo "+${borda}+"
    #printf "| %-*s |\n" "$((largura - 2))" "=== $titulo ==="
    printf "|%*s%s%*s|\n" $pad "" "$titulo" $(( largura - pad - ${#titulo} )) ""
    echo "+${borda}+"

    # 3. Exibe a caixa preservando as cores e alinhando perfeitamente
    #echo "+${borda}+"
    while IFS= read -r linha || [[ -n "$linha" ]]; do
        # Calcula a diferença de tamanho entre o texto com cor e sem cor para não entortar o printf
        linha_limpa=$(echo -e "$linha" | sed 's/\x1b\[[0-9;]*m//g')
        local diff=$(( ${#linha} - ${#linha_limpa} ))
        local largura_ajustada=$(( largura - 2 + diff ))

        printf "| %-*s |\n" "$largura_ajustada" "$linha"
    done <<< "$texto_formatado"
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
    read -r -p "Digite uma opção: " rede

    if [[ $rede -eq "1" ]]; then
      ip_pc=$(ip -c -4 -br a | column -t)
      caixa_resultado "$(printf "%s" "$ip_pc")" "=== IPs ==="
    fi
    if [[ $rede -eq "2" ]]; then
      read -r -p "Digite ou cole o site aqui: " site
      rota=$(traceroute "$site")
      caixa_resultado "$(printf "%s" "$rota")" "=== Rota do Site ==="
    fi
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
        caixa_resultado "$resultado" "=== Placa de Vídeo Modelo ==="
        echo 'Selecione a sua placa identificada'
        echo '[1] - Nvidia'
        read -p "Digite a opção: " video

        if [[ $video -eq "1" ]]; then nvidia-smi; fi
    fi
    if [[ $video -eq 2 ]]; then
      opengl_valor=$(glxinfo | grep -i "opengl version")
      vulkan_valor=$(vulkaninfo | head -n 5)
      vulkan_suporte=$(vulkaninfo --summary | grep -A 10 "Devices:")

      caixa_resultado "$(printf "%s\n%s" "$opengl_valor" "$vulkan_valor")" "=== Codecs de Vídeo ==="
      caixa_resultado "$(printf "%s" "$vulkan_suporte")" "=== Vulkan Suporte ==="
    fi
    if [[ $video -eq "v" ]]; then start; fi

    #start
}


start

#usuario