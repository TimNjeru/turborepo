#!/bin/bash

# Migration script to move project from Windows filesystem to Linux filesystem
# This helps avoid WSL permission issues

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
WINDOWS_PATH="/mnt/c/Users/TimNjeru/CODING/turborepo"
LINUX_PATH="$HOME/dev/turborepo"
BACKUP_PATH="$HOME/dev/turborepo-backup-$(date +%Y%m%d-%H%M%S)"

echo -e "${GREEN}🚀 WSL Project Migration Script${NC}"
echo "=================================="

# Check if running in WSL
if ! grep -q Microsoft /proc/version; then
    echo -e "${YELLOW}⚠️  Warning: This script is designed for WSL environments${NC}"
fi

# Function to check if path exists
check_path() {
    if [ ! -d "$1" ]; then
        echo -e "${RED}❌ Error: Path '$1' does not exist${NC}"
        exit 1
    fi
}

# Function to create backup
create_backup() {
    echo -e "${YELLOW}📦 Creating backup at $BACKUP_PATH${NC}"
    if [ -d "$LINUX_PATH" ]; then
        cp -r "$LINUX_PATH" "$BACKUP_PATH"
        echo -e "${GREEN}✅ Backup created successfully${NC}"
    fi
}

# Function to migrate project
migrate_project() {
    echo -e "${YELLOW}🔄 Migrating project from Windows to Linux filesystem...${NC}"
    
    # Create target directory
    mkdir -p "$(dirname "$LINUX_PATH")"
    
    # Copy project files (excluding node_modules)
    echo -e "${YELLOW}📁 Copying project files...${NC}"
    rsync -av --exclude='node_modules' --exclude='.git' "$WINDOWS_PATH/" "$LINUX_PATH/"
    
    # Copy .git directory separately to preserve git history
    if [ -d "$WINDOWS_PATH/.git" ]; then
        echo -e "${YELLOW}📁 Copying .git directory...${NC}"
        cp -r "$WINDOWS_PATH/.git" "$LINUX_PATH/"
    fi
    
    echo -e "${GREEN}✅ Project files copied successfully${NC}"
}

# Function to install dependencies
install_dependencies() {
    echo -e "${YELLOW}📦 Installing dependencies in Linux filesystem...${NC}"
    cd "$LINUX_PATH"
    
    # Clean any existing node_modules
    if [ -d "node_modules" ]; then
        rm -rf node_modules
    fi
    
    # Install dependencies
    if command -v pnpm &> /dev/null; then
        echo -e "${YELLOW}Using pnpm...${NC}"
        pnpm install
    elif command -v yarn &> /dev/null; then
        echo -e "${YELLOW}Using yarn...${NC}"
        yarn install
    elif command -v npm &> /dev/null; then
        echo -e "${YELLOW}Using npm...${NC}"
        npm install
    else
        echo -e "${RED}❌ No package manager found (pnpm, yarn, or npm)${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Dependencies installed successfully${NC}"
}

# Function to verify installation
verify_installation() {
    echo -e "${YELLOW}🔍 Verifying installation...${NC}"
    cd "$LINUX_PATH"
    
    # Check if node_modules exists
    if [ ! -d "node_modules" ]; then
        echo -e "${RED}❌ node_modules directory not found${NC}"
        return 1
    fi
    
    # Try running a basic command
    if command -v pnpm &> /dev/null; then
        pnpm --version > /dev/null 2>&1
    elif command -v yarn &> /dev/null; then
        yarn --version > /dev/null 2>&1
    elif command -v npm &> /dev/null; then
        npm --version > /dev/null 2>&1
    fi
    
    echo -e "${GREEN}✅ Installation verified successfully${NC}"
}

# Main execution
main() {
    echo -e "${YELLOW}Source (Windows): $WINDOWS_PATH${NC}"
    echo -e "${YELLOW}Target (Linux): $LINUX_PATH${NC}"
    echo ""
    
    # Check if source path exists
    check_path "$WINDOWS_PATH"
    
    # Create backup if target exists
    if [ -d "$LINUX_PATH" ]; then
        create_backup
    fi
    
    # Migrate project
    migrate_project
    
    # Install dependencies
    install_dependencies
    
    # Verify installation
    verify_installation
    
    echo ""
    echo -e "${GREEN}🎉 Migration completed successfully!${NC}"
    echo -e "${GREEN}📁 Your project is now available at: $LINUX_PATH${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. cd $LINUX_PATH"
    echo "2. Start development: pnpm dev (or npm run dev)"
    echo "3. Update your IDE/editor to use the new path"
    echo ""
    echo -e "${YELLOW}Note: You can now safely delete the Windows version if everything works correctly${NC}"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --windows-path)
            WINDOWS_PATH="$2"
            shift 2
            ;;
        --linux-path)
            LINUX_PATH="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --windows-path PATH    Source path on Windows filesystem (default: /mnt/c/Users/TimNjeru/CODING/turborepo)"
            echo "  --linux-path PATH      Target path on Linux filesystem (default: ~/dev/turborepo)"
            echo "  --help                 Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Run main function
main