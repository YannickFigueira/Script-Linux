#!/bin/bash

# 1. Detecta o usuário real (mesmo se o script for rodado com sudo)
USUARIO_REAL="${SUDO_USER:-$USER}"
HOME_REAL=$(eval echo ~$USUARIO_REAL)

RAID_MONITOR="/etc/systemd/system/raid-monitor.service"

echo "Configurando o monitor para o usuário: $USUARIO_REAL"
echo "Diretório Home: $HOME_REAL"
echo "--------------------------------------------------"

# 2. Move o script Python para a Home correta e ajusta o dono do arquivo
if [ -f "raid_monitor.py" ]; then
    sudo mv raid_monitor.py "$HOME_REAL/"
    sudo mv dados.py "$HOME_REAL/"
    sudo mv dados "$HOME_REAL/"

    sudo chown "$USUARIO_REAL:$USUARIO_REAL" "$HOME_REAL/raid_monitor.py"
    sudo chown "$USUARIO_REAL:$USUARIO_REAL" "$HOME_REAL/dados.py"
    sudo chown "$USUARIO_REAL:$USUARIO_REAL" "$HOME_REAL/dados"
else
    echo "⚠️ Aviso: arquivo raid_monitor.py não encontrado no diretório atual."
fi

# 3. Cria o arquivo de serviço do Systemd injetando as rotas dinâmicas
sudo bash -c "cat <<EOF > $RAID_MONITOR
[Unit]
Description=Monitor de RAID via Telegram
After=network.target

[Service]
User=$USUARIO_REAL
WorkingDirectory=$HOME_REAL
ExecStart=/usr/bin/python3 $HOME_REAL/raid_monitor.py
Restart=always
RestartSec=60

[Install]
WantedBy=multi-user.target
EOF"

# 4. Recarrega as configurações do sistema
sudo systemctl daemon-reload

# 5. Ativa para iniciar automaticamente no boot
sudo systemctl enable raid-monitor.service

# 6. Inicia o monitor agora (apenas se o arquivo existir para evitar falha no start)
if [ -f "$HOME_REAL/raid_monitor.py" ]; then
    sudo systemctl restart raid-monitor.service
    echo "✅ Serviço raid-monitor iniciado com sucesso!"
    sudo systemctl status raid-monitor.service --no-pager -l
fi