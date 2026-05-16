#! /bin/bash

RAID_MONITOR="/etc/systemd/system/raid-monitor.service"

sudo mv raid_monitor.py /home/$USER/

sudo bash -c "cat <<EOF > $RAID_MONITOR
[Unit]
Description=Monitor de RAID via Telegram
After=network.target

[Service]
User=$USER
WorkingDirectory=/home/$USER
ExecStart=/usr/bin/python3 /home/$USER/raid_monitor.py
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