#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Package info
PACKAGE_NAME="ybarojs-debian"
GITHUB_REPO="ybarojs/ybarojs-debian"

echo "=========================================="
echo "  ybarojs-debian Package Installer"
echo "=========================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Error: Please run as root (use sudo)${NC}"
    echo "Example: sudo ./install.sh"
    exit 1
fi

# Function to find .deb file
find_deb_file() {
    local deb_file=""
    
    # Search patterns
    local search_paths=(
        "."
        "./ybarojs-debian"
        "./release"
        "./dist"
        "./build"
        "./debian"
        "../"
        "../release"
    )
    
    echo "Searching for ${PACKAGE_NAME}*.deb..."
    
    # Check current directory first with pattern match
    deb_file=$(ls -1 ${PACKAGE_NAME}_*.deb 2>/dev/null | head -n 1)
    
    if [ -n "$deb_file" ]; then
        echo -e "${GREEN}Found: $deb_file${NC}"
        echo "$deb_file"
        return 0
    fi
    
    # Search in common locations
    for path in "${search_paths[@]}"; do
        if [ -d "$path" ]; then
            deb_file=$(find "$path" -maxdepth 2 -name "${PACKAGE_NAME}_*.deb" -type f 2>/dev/null | head -n 1)
            if [ -n "$deb_file" ]; then
                echo -e "${GREEN}Found: $deb_file${NC}"
                echo "$deb_file"
                return 0
            fi
        fi
    done
    
    return 1
}

# Function to download from GitHub releases
download_latest_release() {
    echo -e "${YELLOW}.deb file not found locally.${NC}"
    echo "Attempting to download from GitHub releases..."
    
    # Check if curl or wget is available
    if command -v curl >/dev/null 2>&1; then
        DOWNLOADER="curl -sL -o"
    elif command -v wget >/dev/null 2>&1; then
        DOWNLOADER="wget -q -O"
    else
        echo -e "${RED}Error: Neither curl nor wget is installed.${NC}"
        return 1
    fi
    
    # Get latest release info
    local api_url="https://api.github.com/repos/${GITHUB_REPO}/releases/latest"
    local temp_dir=$(mktemp -d)
    local release_info="${temp_dir}/release.json"
    
    echo "Fetching release information from GitHub..."
    
    if command -v curl >/dev/null 2>&1; then
        curl -sL "$api_url" -o "$release_info" 2>/dev/null || true
    else
        wget -q "$api_url" -O "$release_info" 2>/dev/null || true
    fi
    
    if [ ! -f "$release_info" ] || [ ! -s "$release_info" ]; then
        echo -e "${RED}Error: Unable to fetch release information from GitHub.${NC}"
        rm -rf "$temp_dir"
        return 1
    fi
    
    # Extract download URL for .deb file
    local download_url=$(grep -o '"browser_download_url": "[^"]*\.deb"' "$release_info" | head -n 1 | cut -d'"' -f4)
    
    if [ -z "$download_url" ]; then
        echo -e "${RED}Error: No .deb file found in the latest release.${NC}"
        rm -rf "$temp_dir"
        return 1
    fi
    
    local deb_filename=$(basename "$download_url")
    local download_path="${temp_dir}/${deb_filename}"
    
    echo "Downloading: $deb_filename"
    echo "From: $download_url"
    
    if $DOWNLOADER "$download_path" "$download_url" 2>/dev/null; then
        if [ -f "$download_path" ] && [ -s "$download_path" ]; then
            echo -e "${GREEN}Download successful!${NC}"
            mv "$download_path" "./${deb_filename}"
            rm -rf "$temp_dir"
            echo "./${deb_filename}"
            return 0
        fi
    fi
    
    echo -e "${RED}Error: Download failed.${NC}"
    rm -rf "$temp_dir"
    return 1
}

# Main installation logic
main() {
    DEB_FILE=""
    TEMP_DOWNLOAD=false
    
    # Try to find local .deb file
    DEB_FILE=$(find_deb_file)
    
    # If not found, try to download
    if [ -z "$DEB_FILE" ]; then
        DEB_FILE=$(download_latest_release) && TEMP_DOWNLOAD=true
    fi
    
    # Check if we have a .deb file
    if [ -z "$DEB_FILE" ] || [ ! -f "$DEB_FILE" ]; then
        echo ""
        echo -e "${RED}==========================================${NC}"
        echo -e "${RED}  Error: .deb file not found!${NC}"
        echo -e "${RED}==========================================${NC}"
        echo ""
        echo "The installer could not find ${PACKAGE_NAME}_*.deb"
        echo ""
        echo "You can:"
        echo "  1. Build the package: dpkg-deb --build ${PACKAGE_NAME}"
        echo "  2. Download from GitHub releases manually"
        echo "  3. Ensure the .deb file is in the current directory"
        echo ""
        exit 1
    fi
    
    echo ""
    echo "Installing: $DEB_FILE"
    echo "=========================================="
    
    # Install the package
    if dpkg -i "$DEB_FILE"; then
        echo ""
        echo -e "${GREEN}Package installed successfully!${NC}"
    else
        echo ""
        echo -e "${YELLOW}Initial install had issues, attempting to fix dependencies...${NC}"
    fi
    
    # Fix broken dependencies
    echo ""
    echo "Checking and fixing dependencies..."
    if apt --fix-broken install -y; then
        echo ""
        echo -e "${GREEN}Dependencies resolved!${NC}"
    else
        echo ""
        echo -e "${RED}Warning: Some dependencies could not be resolved.${NC}"
        echo "You may need to run: sudo apt install -f"
    fi
    
    # Configure the package if needed
    if dpkg --configure ${PACKAGE_NAME} 2>/dev/null; then
        echo -e "${GREEN}Package configured.${NC}"
    fi
    
    # Cleanup downloaded file if we downloaded it
    if [ "$TEMP_DOWNLOAD" = true ]; then
        rm -f "$DEB_FILE"
        echo ""
        echo "Cleaned up temporary download."
    fi
    
    echo ""
    echo "=========================================="
    echo -e "${GREEN}  Installation complete!${NC}"
    echo "=========================================="
    echo ""
    echo "Package: ${PACKAGE_NAME}"
    
    # Show package info
    dpkg -l ${PACKAGE_NAME} 2>/dev/null | tail -n 1 || true
    
    echo ""
    echo "To remove this package, run:"
    echo "  sudo apt remove ${PACKAGE_NAME}"
    echo "  sudo apt purge ${PACKAGE_NAME}    # to remove config files too"
    echo ""
}

# Run main function
main "$@"
