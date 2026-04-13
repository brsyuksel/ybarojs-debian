#!/bin/bash

# ybarojs-debian installer
# Downloads and installs the latest release from GitHub

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
GITHUB_USER="brsyuksel"
REPO="ybarojs-debian"
PACKAGE_NAME="ybarojs-debian"

echo "=========================================="
echo "  ybarojs-debian Installer"
echo "=========================================="
echo ""

# Check for curl or wget
if command -v curl >/dev/null 2>&1; then
    DOWNLOADER="curl"
    echo "Using curl for downloads"
elif command -v wget >/dev/null 2>&1; then
    DOWNLOADER="wget"
    echo "Using wget for downloads"
else
    echo -e "${RED}Error: Neither curl nor wget is installed.${NC}"
    echo "Please install curl or wget and try again."
    exit 1
fi

# Get latest release URL
echo ""
echo "Fetching latest release information..."
API_URL="https://api.github.com/repos/${GITHUB_USER}/${REPO}/releases/latest"

if [ "$DOWNLOADER" = "curl" ]; then
    DOWNLOAD_URL=$(curl -sL "$API_URL" | grep -o '"browser_download_url": "[^"]*\.deb"' | head -n 1 | cut -d'"' -f4)
else
    DOWNLOAD_URL=$(wget -qO- "$API_URL" | grep -o '"browser_download_url": "[^"]*\.deb"' | head -n 1 | cut -d'"' -f4)
fi

if [ -z "$DOWNLOAD_URL" ]; then
    echo -e "${RED}Error: Could not find .deb file in latest release.${NC}"
    exit 1
fi

echo "Found: $DOWNLOAD_URL"

# Download the file (always overwrite if exists)
DEB_FILE="${PACKAGE_NAME}_latest_amd64.deb"
echo ""
echo "Downloading to ${DEB_FILE}..."

if [ "$DOWNLOADER" = "curl" ]; then
    curl -sL "$DOWNLOAD_URL" -o "$DEB_FILE"
else
    wget -q "$DOWNLOAD_URL" -O "$DEB_FILE"
fi

if [ ! -f "$DEB_FILE" ] || [ ! -s "$DEB_FILE" ]; then
    echo -e "${RED}Error: Download failed.${NC}"
    exit 1
fi

echo -e "${GREEN}Download complete!${NC}"

# Install the package
echo ""
echo "Installing package..."
echo "=========================================="

sudo apt install -y "./${DEB_FILE}"

# Cleanup
rm -f "$DEB_FILE"

echo ""
echo "=========================================="
echo -e "${GREEN}Installation complete!${NC}"
echo "=========================================="
echo ""
echo "To remove this package, run:"
echo "  sudo apt remove ${PACKAGE_NAME}"
echo ""
