#!/bin/bash

# Permission fixing script for WSL development environments
# Helps resolve common permission issues with node_modules and package managers

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
TARGET_PATH="."
RECURSIVE=true
FIX_OWNERSHIP=true
FIX_PERMISSIONS=true
DRY_RUN=false

echo -e "${GREEN}🔧 WSL Permission Fix Script${NC}"
echo "=============================="

# Function to show usage
show_usage() {
    echo "Usage: $0 [options] [path]"
    echo ""
    echo "Options:"
    echo "  --path PATH          Target path to fix (default: current directory)"
    echo "  --no-recursive       Don't apply changes recursively"
    echo "  --no-ownership       Don't fix file ownership"
    echo "  --no-permissions     Don't fix file permissions"
    echo "  --dry-run            Show what would be done without making changes"
    echo "  --help               Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Fix current directory"
    echo "  $0 --path /mnt/c/Users/.../project   # Fix specific path"
    echo "  $0 --dry-run                          # Preview changes"
    echo "  $0 --no-recursive                     # Fix only current directory"
}

# Function to check if path exists
check_path() {
    if [ ! -e "$1" ]; then
        echo -e "${RED}❌ Error: Path '$1' does not exist${NC}"
        exit 1
    fi
}

# Function to get current user info
get_user_info() {
    local user=$(whoami)
    local group=$(id -gn)
    echo "$user:$group"
}

# Function to fix ownership
fix_ownership() {
    local path="$1"
    local user_info=$(get_user_info)
    
    echo -e "${YELLOW}👤 Fixing ownership for: $path${NC}"
    
    if [ "$DRY_RUN" = true ]; then
        echo -e "${BLUE}Would run: chown -R $user_info \"$path\"${NC}"
    else
        if [ "$RECURSIVE" = true ]; then
            chown -R $user_info "$path"
        else
            chown $user_info "$path"
        fi
        echo -e "${GREEN}✅ Ownership fixed${NC}"
    fi
}

# Function to fix permissions
fix_permissions() {
    local path="$1"
    
    echo -e "${YELLOW}🔐 Fixing permissions for: $path${NC}"
    
    if [ "$DRY_RUN" = true ]; then
        if [ "$RECURSIVE" = true ]; then
            echo -e "${BLUE}Would run: chmod -R 755 \"$path\"${NC}"
        else
            echo -e "${BLUE}Would run: chmod 755 \"$path\"${NC}"
        fi
    else
        if [ "$RECURSIVE" = true ]; then
            chmod -R 755 "$path"
        else
            chmod 755 "$path"
        fi
        echo -e "${GREEN}✅ Permissions fixed${NC}"
    fi
}

# Function to fix node_modules specifically
fix_node_modules() {
    local path="$1"
    local node_modules_path="$path/node_modules"
    
    if [ -d "$node_modules_path" ]; then
        echo -e "${YELLOW}📦 Fixing node_modules permissions...${NC}"
        
        if [ "$DRY_RUN" = true ]; then
            echo -e "${BLUE}Would fix node_modules at: $node_modules_path${NC}"
        else
            # Fix ownership
            if [ "$FIX_OWNERSHIP" = true ]; then
                local user_info=$(get_user_info)
                chown -R $user_info "$node_modules_path"
            fi
            
            # Fix permissions
            if [ "$FIX_PERMISSIONS" = true ]; then
                chmod -R 755 "$node_modules_path"
            fi
            
            echo -e "${GREEN}✅ node_modules permissions fixed${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  No node_modules directory found${NC}"
    fi
}

# Function to check WSL environment
check_wsl_environment() {
    if grep -q Microsoft /proc/version; then
        echo -e "${BLUE}🐧 WSL environment detected${NC}"
        
        # Check if on Windows filesystem
        if [[ "$PWD" == /mnt/c/* ]]; then
            echo -e "${YELLOW}⚠️  Warning: You're on Windows filesystem (/mnt/c/)${NC}"
            echo -e "${YELLOW}   This may cause permission issues. Consider migrating to Linux filesystem.${NC}"
            echo ""
        fi
    else
        echo -e "${BLUE}🐧 Linux environment detected${NC}"
    fi
}

# Function to show current permissions
show_current_permissions() {
    local path="$1"
    
    echo -e "${BLUE}📊 Current permissions for: $path${NC}"
    echo "=========================================="
    
    if [ -d "$path" ]; then
        ls -la "$path" | head -10
        if [ $(ls -la "$path" | wc -l) -gt 10 ]; then
            echo "... (showing first 10 items)"
        fi
    else
        ls -la "$path"
    fi
    echo ""
}

# Function to show summary
show_summary() {
    local path="$1"
    
    echo -e "${GREEN}📋 Permission Fix Summary${NC}"
    echo "========================="
    echo -e "Target path: ${BLUE}$path${NC}"
    echo -e "Recursive: ${BLUE}$RECURSIVE${NC}"
    echo -e "Fix ownership: ${BLUE}$FIX_OWNERSHIP${NC}"
    echo -e "Fix permissions: ${BLUE}$FIX_PERMISSIONS${NC}"
    echo -e "Dry run: ${BLUE}$DRY_RUN${NC}"
    echo ""
}

# Main execution
main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --path)
                TARGET_PATH="$2"
                shift 2
                ;;
            --no-recursive)
                RECURSIVE=false
                shift
                ;;
            --no-ownership)
                FIX_OWNERSHIP=false
                shift
                ;;
            --no-permissions)
                FIX_PERMISSIONS=false
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            -*)
                echo -e "${RED}Unknown option: $1${NC}"
                show_usage
                exit 1
                ;;
            *)
                TARGET_PATH="$1"
                shift
                ;;
        esac
    done
    
    # Convert relative path to absolute
    TARGET_PATH=$(realpath "$TARGET_PATH")
    
    # Check if path exists
    check_path "$TARGET_PATH"
    
    # Check WSL environment
    check_wsl_environment
    
    # Show summary
    show_summary "$TARGET_PATH"
    
    # Show current permissions
    show_current_permissions "$TARGET_PATH"
    
    # Fix ownership
    if [ "$FIX_OWNERSHIP" = true ]; then
        fix_ownership "$TARGET_PATH"
    fi
    
    # Fix permissions
    if [ "$FIX_PERMISSIONS" = true ]; then
        fix_permissions "$TARGET_PATH"
    fi
    
    # Fix node_modules specifically
    fix_node_modules "$TARGET_PATH"
    
    # Show final permissions
    if [ "$DRY_RUN" = false ]; then
        echo -e "${YELLOW}📊 Final permissions:${NC}"
        show_current_permissions "$TARGET_PATH"
    fi
    
    echo ""
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}🔍 Dry run completed. No changes were made.${NC}"
        echo -e "${YELLOW}   Run without --dry-run to apply changes.${NC}"
    else
        echo -e "${GREEN}🎉 Permission fix completed successfully!${NC}"
    fi
}

# Run main function
main "$@"