#! /bin/bash

RAID_MONITOR="/etc/systemd/system/raid-monitor.service"

sudo bash -c "cat <<EOF > $RAID_MONITOR
[Unit]
Description=Monitor de RAID via Telegram
After=network.target

[Service]
# Substitua 'kronos' pelo seu usuário real se for diferente
User=kronos
WorkingDirectory=/home/kronos
ExecStart=/usr/bin/python3 /home/kronos/raid_monitor.py
Restart=always
RestartSec=60

[Install]
WantedBy=multi-user.target
EOF"

# Recarrega as configurações do sistema
sudo systemctl daemon-reload

# Ativa para iniciar automaticamente no boot
sudo systemctl enable raid-monitor

# Inicia o monitor agora
sudo systemctl start raid-monitor