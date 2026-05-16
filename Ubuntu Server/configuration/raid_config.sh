#! /bin/bash

identificar_discos_raid() {
    # Lista apenas discos físicos, ignora partições, loops, rom e o disco do sistema (sda)
    DISCOS_RAID=$(lsblk -d -n -o NAME,TYPE | grep 'disk' | awk '{print $1}' | grep -v 'sda')

    if [ -z "$DISCOS_RAID" ]; then
        echo "Erro: Nenhum disco secundário livre foi encontrado para o RAID."
    else
        echo "=== Discos Detectados para o RAID ==="
        for disco in $DISCOS_RAID; do
            echo "-> /dev/$disco"
        done
        echo "-------------------------------------"
    fi
}

identificar_discos_raid