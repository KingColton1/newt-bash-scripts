#!/bin/bash
wget -O newt "https://github.com/fosrl/newt/releases/download/1.2.1/newt_linux_amd64" && chmod +x ./newt && sudo mv ./newt /usr/local/bin

read -p "Enter Newt ID: " NEWT_ID
read -sp "Enter Newt Secret: " NEWT_SECRET
echo
read -p "Enter Newt Endpoint (your pangolin's domain): " NEWT_ENDPOINT
echo

tee /etc/systemd/system/newt.service > /dev/null <<EOF
[Unit]
Description=Newt VPN Client
After=network.target

[Service]
ExecStart=/usr/local/bin/newt --id $NEWT_ID --secret $NEWT_SECRET --endpoint $NEWT_ENDPOINT
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

chmod 600 /etc/systemd/system/newt.service
systemctl daemon-reload
systemctl enable newt.service
systemctl start newt.service
systemctl status newt.service
