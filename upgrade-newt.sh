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

# Get latest version from GitHub API
LATEST_VERSION=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep -oP '"tag_name": "\K(.*)(?=")')

if [ -z "$LATEST_VERSION" ]; then
    echo "Failed to detect latest version."
    exit 1
fi

echo "Stopping Newt service..."
systemctl stop newt.service
    
echo "Downloading newt $LATEST_VERSION from $REPO repo and configuring installed binary..."
wget -O newt "https://github.com/$REPO/releases/download/$LATEST_VERSION/$BINARY_NAME" && chmod +x ./newt && sudo mv ./newt /usr/local/bin/newt

echo "Newt $LATEST_VERSION installed!"
systemctl start newt.service
systemctl status newt.service
