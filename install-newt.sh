#!/bin/bash
set -e

REPO="fosrl/newt"

UNAME_OS=$(uname -s)
case "$UNAME_OS" in
    Linux)   OS="linux" ;;
    Darwin)  OS="darwin" ;;
    FreeBSD) OS="freebsd" ;;
    MINGW*|MSYS*|CYGWIN*|Windows_NT) 
        echo "Windows detected – this script is for Unix-like systems only."
        exit 1
        ;;
    *) echo "Unsupported OS: $UNAME_OS" && exit 1 ;;
esac

UNAME_ARCH=$(uname -m)
case "$UNAME_ARCH" in
    x86_64 | amd64) ARCH="amd64" ;;
    aarch64 | arm64) ARCH="arm64" ;;
    *) echo "Unsupported architecture: $UNAME_ARCH" && exit 1 ;;
esac

BINARY_NAME="newt_${OS}_${ARCH}"

# Get latest release version from GitHub
LATEST_VERSION=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep -oP '"tag_name": "\K(.*)(?=")')
if [ -z "$LATEST_VERSION" ]; then
    echo "Failed to get latest version"
    exit 1
fi

echo "Installing newt version: $LATEST_VERSION for $OS/$ARCH"

wget -O newt "https://github.com/$REPO/releases/download/$LATEST_VERSION/$BINARY_NAME" && chmod +x ./newt && sudo mv ./newt /usr/local/bin/newt

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
