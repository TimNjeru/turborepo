# WSL Development Setup

This document provides solutions for common WSL development issues, particularly permission problems with package managers.

## Quick Start

### 1. If you're having permission issues:

```bash
# Fix permissions for current project
pnpm run fix-permissions

# Or install dependencies with alternative method
pnpm run install:alt
```

### 2. If you want to migrate from Windows to Linux filesystem:

```bash
# Migrate your project to Linux filesystem (recommended)
pnpm run migrate-to-linux
```

## Available Scripts

| Script | Description |
|--------|-------------|
| `pnpm run install:fix` | Install dependencies with permission fixes |
| `pnpm run install:clean` | Clean install (removes node_modules first) |
| `pnpm run install:alt` | Alternative installation using npm with ignore-scripts |
| `pnpm run fix-permissions` | Fix file permissions for the project |
| `pnpm run migrate-to-linux` | Migrate project from Windows to Linux filesystem |

## Common Issues and Solutions

### Permission Denied Errors

**Problem**: `EACCES: permission denied` when installing packages

**Solutions**:
1. **Use the fix script**: `pnpm run fix-permissions`
2. **Clean install**: `pnpm run install:clean`
3. **Alternative package manager**: `pnpm run install:alt`
4. **Migrate to Linux filesystem**: `pnpm run migrate-to-linux`

### Windows Filesystem Issues

**Problem**: Slow performance or permission issues on `/mnt/c/`

**Solution**: Migrate to Linux filesystem
```bash
pnpm run migrate-to-linux
```

### Package Manager Conflicts

**Problem**: Different package managers causing conflicts

**Solution**: Use consistent package manager
```bash
# Remove all lock files and node_modules
rm -rf node_modules package-lock.json yarn.lock pnpm-lock.yaml

# Install with preferred package manager
pnpm install
```

## Manual Commands

### Fix Permissions
```bash
# Fix ownership
sudo chown -R $(whoami):$(whoami) .

# Fix permissions
chmod -R 755 .

# Fix node_modules specifically
chmod -R 755 node_modules
```

### Clean Installation
```bash
# Remove existing files
rm -rf node_modules package-lock.json yarn.lock pnpm-lock.yaml

# Install fresh
pnpm install
```

### Alternative Installation Methods
```bash
# Using npm with ignore-scripts
npm install --ignore-scripts

# Using yarn
yarn install

# Using pnpm with different settings
pnpm install --no-optional --ignore-scripts
```

## Best Practices

1. **Use Linux filesystem** for development (not `/mnt/c/`)
2. **Consistent package manager** - stick to one per project
3. **Regular cleanup** - periodically clean node_modules
4. **WSL2** - use WSL2 for better performance
5. **Proper permissions** - avoid using sudo for package installation

## Troubleshooting

### Check WSL Version
```bash
wsl --list --verbose
```

### Check File Permissions
```bash
ls -la
```

### Check Package Manager
```bash
pnpm --version
npm --version
yarn --version
```

### Restart WSL
```bash
wsl --shutdown
# Then restart your terminal
```

## Additional Resources

- [WSL Setup Guide](.wsl-setup-guide.md) - Detailed WSL configuration
- [Migration Script](scripts/migrate-to-linux-fs.sh) - Move project to Linux filesystem
- [Install Script](scripts/install-deps.sh) - Alternative dependency installation
- [Permission Fix Script](scripts/fix-permissions.sh) - Fix file permissions

## Getting Help

If you continue to have issues:

1. Check the [WSL Setup Guide](.wsl-setup-guide.md) for detailed configuration
2. Try the migration script to move to Linux filesystem
3. Use the alternative installation methods
4. Check file permissions and ownership

Remember: The best solution is to develop on the Linux filesystem rather than the Windows filesystem to avoid most permission issues.