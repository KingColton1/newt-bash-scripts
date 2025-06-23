#!/bin/bash
set -e

REPO="fosrl/newt"

UNAME_OS=$(uname -s)
case "$UNAME_OS" in
    Linux)   OS="linux" ;;
    Darwin)  OS="darwin" ;;
    FreeBSD) OS="freebsd" ;;
    MINGW*|MSYS*|CYGWIN*|Windows_NT) OS="windows" ;;
    *) echo "Unsupported OS: $UNAME_OS" && exit 1 ;;
esac

UNAME_ARCH=$(uname -m)
case "$UNAME_ARCH" in
    x86_64 | amd64) ARCH="amd64" ;;
    aarch64 | arm64) ARCH="arm64" ;;
    *) echo "Unsupported architecture: $UNAME_ARCH" && exit 1 ;;
esac

BINARY_NAME="newt_${OS}_${ARCH}"

if [ "$OS" == "windows" ]; then
    BINARY_NAME="${BINARY_NAME}.exe"
fi

# Get latest version from GitHub API
LATEST_VERSION=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep -oP '"tag_name": "\K(.*)(?=")')

if [ -z "$LATEST_VERSION" ]; then
    echo "Failed to detect latest version."
    exit 1
fi

echo "Detected OS: $OS"
echo "Detected Architecture: $ARCH"
echo "Latest version: $LATEST_VERSION"
echo "New binary to download: $BINARY_NAME"

WIN_SERVICE_NAME="newt"

if [ "$OS" == "windows" ]; then
    echo "Stopping Windows service: $WIN_SERVICE_NAME"
    sc stop "$WIN_SERVICE_NAME" || echo "Failed to stop service (may not be installed)"

    echo "Downloading newt $LATEST_VERSION from $REPO repo..."
    wget -O newt.exe "https://github.com/$REPO/releases/download/$LATEST_VERSION/$BINARY_NAME"

    echo "Replacing installed binary"
    cp -f newt.exe "C:\\Program Files\\Newt\\newt.exe" || echo "Failed to replace binary"

    echo "Starting Windows service: $WIN_SERVICE_NAME"
    sc start "$WIN_SERVICE_NAME" || echo "Failed to start service"
else
    echo "Stopping Newt service..."
    sudo systemctl stop newt.service
    
    echo "Downloading newt $LATEST_VERSION from $REPO repo..."
    wget -O newt "https://github.com/$REPO/releases/download/$LATEST_VERSION/$BINARY_NAME"

    echo "Replacing and configuring installed binary..."
    chmod +x ./newt
    sudo mv ./newt /usr/local/bin/newt

    echo "Newt $LATEST_VERSION installed!"
    sudo systemctl start newt.service
    sudo systemctl status newt.service
fi
