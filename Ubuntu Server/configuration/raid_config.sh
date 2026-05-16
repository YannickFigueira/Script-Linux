#!/bin/bash

identificar_discos_raid() {
    # Criando uma ARRAY real colocando o comando entre parênteses ( )
    DISCOS_RAID=($(lsblk -d -n -o NAME,TYPE | grep 'disk' | awk '{print $1}' | grep -v 'sda'))

    # Para contar elementos de uma array usamos ${#ARRAY[@]}
    if [ ${#DISCOS_RAID[@]} -lt 2 ]; then
        echo "Erro: São necessários pelo menos 2 discos livres para o RAID 1. Encontrados: ${#DISCOS_RAID[@]}"
        return 1
    else
        echo "=== Discos Detectados para o RAID ==="
        for disco in "${DISCOS_RAID[@]}"; do
            echo "-> /dev/$disco"
        done
        echo "-------------------------------------"

        echo "Criando o RAID 1 com os discos detectados..."
        # Adicionado o parâmetro --assume-clean ou você pode deixar o mdadm sincronizar
        sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 "/dev/${DISCOS_RAID[0]}" "/dev/${DISCOS_RAID[1]}"

        # SUBSTITUTO DO WATCH: Aguarda a sincronização inicial terminar antes de formatar
        echo "Aguardando a inicialização do RAID..."
        while grep -q "resync" /proc/mdstat; do
            echo "Sincronizando discos... aguarde 5 segundos."
            sleep 5
        done
        echo "RAID pronto e sincronizado!"
        echo "-------------------------------------"

        echo "Formatando o dispositivo /dev/md0 em EXT4..."
        sudo mkfs.ext4 -F /dev/md0

        echo "Criando ponto de montagem e montando..."
        sudo mkdir -p /mnt/md0
        sudo mount /dev/md0 /mnt/md0

        echo "Salvando configuração do mdadm para o boot..."
        # Garante que o diretório do mdadm existe antes do tee
        sudo mkdir -p /etc/mdadm
        sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
        
        echo "Atualizando o initramfs..."
        sudo update-initramfs -u

        echo "Adicionando ao /etc/fstab para montagem automática..."
        # Verificação simples para não duplicar a linha se rodar o script duas vezes
        if ! grep -q "/mnt/md0" /etc/fstab; then
            echo '/dev/md0 /mnt/md0 ext4 defaults,nofail,discard 0 0' | sudo tee -a /etc/fstab
        fi

        echo "=== PROCESSO CONCLUÍDO COM SUCESSO ==="
        df -h /mnt/md0
    fi
}

identificar_discos_raid