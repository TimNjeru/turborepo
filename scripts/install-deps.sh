#!/bin/bash

# Alternative dependency installation script for WSL environments
# Handles permission issues and provides multiple installation methods

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
PACKAGE_MANAGER="auto"
CLEAN_INSTALL=false
USE_SUDO=false
IGNORE_SCRIPTS=false

echo -e "${GREEN}📦 WSL Dependency Installation Script${NC}"
echo "=========================================="

# Function to show usage
show_usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --manager MANAGER     Package manager to use (pnpm|yarn|npm|auto)"
    echo "  --clean              Clean install (remove node_modules first)"
    echo "  --sudo               Use sudo for installation (not recommended)"
    echo "  --ignore-scripts     Skip postinstall scripts"
    echo "  --help               Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --manager pnpm --clean"
    echo "  $0 --manager npm --ignore-scripts"
    echo "  $0 --clean"
}

# Function to detect package manager
detect_package_manager() {
    if command -v pnpm &> /dev/null; then
        echo "pnpm"
    elif command -v yarn &> /dev/null; then
        echo "yarn"
    elif command -v npm &> /dev/null; then
        echo "npm"
    else
        echo "none"
    fi
}

# Function to check if running on Windows filesystem
is_windows_filesystem() {
    if [[ "$PWD" == /mnt/c/* ]]; then
        return 0
    else
        return 1
    fi
}

# Function to clean installation
clean_install() {
    echo -e "${YELLOW}🧹 Cleaning existing installation...${NC}"
    
    if [ -d "node_modules" ]; then
        echo -e "${YELLOW}Removing node_modules...${NC}"
        rm -rf node_modules
    fi
    
    if [ -f "package-lock.json" ]; then
        echo -e "${YELLOW}Removing package-lock.json...${NC}"
        rm -f package-lock.json
    fi
    
    if [ -f "yarn.lock" ]; then
        echo -e "${YELLOW}Removing yarn.lock...${NC}"
        rm -f yarn.lock
    fi
    
    if [ -f "pnpm-lock.yaml" ]; then
        echo -e "${YELLOW}Removing pnpm-lock.yaml...${NC}"
        rm -f pnpm-lock.yaml
    fi
    
    echo -e "${GREEN}✅ Cleanup completed${NC}"
}

# Function to install with pnpm
install_with_pnpm() {
    echo -e "${BLUE}📦 Installing with pnpm...${NC}"
    
    local cmd="pnpm install"
    
    if [ "$IGNORE_SCRIPTS" = true ]; then
        cmd="$cmd --ignore-scripts"
    fi
    
    if [ "$USE_SUDO" = true ]; then
        cmd="sudo $cmd"
    fi
    
    echo -e "${YELLOW}Running: $cmd${NC}"
    eval $cmd
}

# Function to install with yarn
install_with_yarn() {
    echo -e "${BLUE}📦 Installing with yarn...${NC}"
    
    local cmd="yarn install"
    
    if [ "$IGNORE_SCRIPTS" = true ]; then
        cmd="$cmd --ignore-scripts"
    fi
    
    if [ "$USE_SUDO" = true ]; then
        cmd="sudo $cmd"
    fi
    
    echo -e "${YELLOW}Running: $cmd${NC}"
    eval $cmd
}

# Function to install with npm
install_with_npm() {
    echo -e "${BLUE}📦 Installing with npm...${NC}"
    
    local cmd="npm install"
    
    if [ "$IGNORE_SCRIPTS" = true ]; then
        cmd="$cmd --ignore-scripts"
    fi
    
    if [ "$USE_SUDO" = true ]; then
        cmd="sudo $cmd"
    fi
    
    echo -e "${YELLOW}Running: $cmd${NC}"
    eval $cmd
}

# Function to fix permissions
fix_permissions() {
    echo -e "${YELLOW}🔧 Fixing permissions...${NC}"
    
    if [ -d "node_modules" ]; then
        chmod -R 755 node_modules
        echo -e "${GREEN}✅ Permissions fixed${NC}"
    fi
}

# Function to verify installation
verify_installation() {
    echo -e "${YELLOW}🔍 Verifying installation...${NC}"
    
    if [ ! -d "node_modules" ]; then
        echo -e "${RED}❌ node_modules directory not found${NC}"
        return 1
    fi
    
    # Count installed packages
    local package_count=$(find node_modules -maxdepth 1 -type d | wc -l)
    echo -e "${GREEN}✅ Found $package_count packages in node_modules${NC}"
    
    # Try to run a basic command
    if [ -f "package.json" ]; then
        if command -v pnpm &> /dev/null; then
            pnpm --version > /dev/null 2>&1 && echo -e "${GREEN}✅ pnpm is working${NC}"
        elif command -v yarn &> /dev/null; then
            yarn --version > /dev/null 2>&1 && echo -e "${GREEN}✅ yarn is working${NC}"
        elif command -v npm &> /dev/null; then
            npm --version > /dev/null 2>&1 && echo -e "${GREEN}✅ npm is working${NC}"
        fi
    fi
}

# Function to show warnings
show_warnings() {
    if is_windows_filesystem; then
        echo -e "${YELLOW}⚠️  Warning: You're running on Windows filesystem (/mnt/c/)${NC}"
        echo -e "${YELLOW}   This may cause permission issues. Consider migrating to Linux filesystem.${NC}"
        echo -e "${YELLOW}   Run: ./scripts/migrate-to-linux-fs.sh${NC}"
        echo ""
    fi
    
    if [ "$USE_SUDO" = true ]; then
        echo -e "${YELLOW}⚠️  Warning: Using sudo for package installation${NC}"
        echo -e "${YELLOW}   This may cause ownership issues. Consider using --ignore-scripts instead.${NC}"
        echo ""
    fi
}

# Main execution
main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --manager)
                PACKAGE_MANAGER="$2"
                shift 2
                ;;
            --clean)
                CLEAN_INSTALL=true
                shift
                ;;
            --sudo)
                USE_SUDO=true
                shift
                ;;
            --ignore-scripts)
                IGNORE_SCRIPTS=true
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                echo -e "${RED}Unknown option: $1${NC}"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Show warnings
    show_warnings
    
    # Check if package.json exists
    if [ ! -f "package.json" ]; then
        echo -e "${RED}❌ package.json not found. Please run this script from the project root.${NC}"
        exit 1
    fi
    
    # Detect package manager if auto
    if [ "$PACKAGE_MANAGER" = "auto" ]; then
        PACKAGE_MANAGER=$(detect_package_manager)
        if [ "$PACKAGE_MANAGER" = "none" ]; then
            echo -e "${RED}❌ No package manager found. Please install pnpm, yarn, or npm.${NC}"
            exit 1
        fi
        echo -e "${BLUE}🔍 Detected package manager: $PACKAGE_MANAGER${NC}"
    fi
    
    # Clean install if requested
    if [ "$CLEAN_INSTALL" = true ]; then
        clean_install
    fi
    
    # Install dependencies
    case $PACKAGE_MANAGER in
        pnpm)
            install_with_pnpm
            ;;
        yarn)
            install_with_yarn
            ;;
        npm)
            install_with_npm
            ;;
        *)
            echo -e "${RED}❌ Unsupported package manager: $PACKAGE_MANAGER${NC}"
            exit 1
            ;;
    esac
    
    # Fix permissions
    fix_permissions
    
    # Verify installation
    verify_installation
    
    echo ""
    echo -e "${GREEN}🎉 Installation completed successfully!${NC}"
    echo -e "${GREEN}📦 Package manager used: $PACKAGE_MANAGER${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Run your development server: $PACKAGE_MANAGER dev (or npm run dev)"
    echo "2. Check if everything works as expected"
    echo "3. If you encounter issues, try: $0 --clean --ignore-scripts"
}

# Run main function
main "$@"