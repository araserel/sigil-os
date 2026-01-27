#!/bin/bash
# Prism OS Global Installer
# Installs Prism OS to ~/.claude/ for use across all projects
#
# Usage:
#   ./install-global.sh           - Install globally
#   ./install-global.sh --verify  - Check installation status
#   ./install-global.sh --uninstall - Remove global installation
#   ./install-global.sh --convert-to-git - Convert tarball install to git-based
#   ./install-global.sh --help    - Show usage

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
INSTALLER_VERSION="1.0.0"
REPO_URL="https://github.com/araserel/prism-os"
GLOBAL_CLAUDE="$HOME/.claude"
PRISM_SOURCE="$HOME/.prism-os"
BACKUP_DIR="$GLOBAL_CLAUDE/.prism-backups"
VERSION_FILE="$GLOBAL_CLAUDE/.prism-version"
MAX_BACKUPS=3

# Detect OS for sed compatibility
detect_sed_inplace() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        SED_INPLACE="sed -i .bak"
    else
        SED_INPLACE="sed -i"
    fi
}

# Parse arguments
ACTION="install"
while [ $# -gt 0 ]; do
    case "$1" in
        --verify)
            ACTION="verify"
            shift
            ;;
        --uninstall)
            ACTION="uninstall"
            shift
            ;;
        --convert-to-git)
            ACTION="convert"
            shift
            ;;
        --help|-h)
            ACTION="help"
            shift
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help to see available options."
            exit 1
            ;;
    esac
done

# Show help
show_help() {
    echo "Prism OS Global Installer v${INSTALLER_VERSION}"
    echo ""
    echo "Installs Prism OS to ~/.claude/ for use across all projects."
    echo ""
    echo "Usage: ./install-global.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  (no options)        Install or update Prism OS globally"
    echo "  --verify            Check installation status and integrity"
    echo "  --uninstall         Remove global Prism OS installation"
    echo "  --convert-to-git    Convert tarball install to git-based (for updates)"
    echo "  --help, -h          Show this help message"
    echo ""
    echo "Installation locations:"
    echo "  ~/.prism-os/        Source code (for updates)"
    echo "  ~/.claude/          Commands, agents, skills (global config)"
    echo ""
    echo "Examples:"
    echo "  # Fresh install"
    echo "  git clone https://github.com/araserel/prism-os.git ~/.prism-os"
    echo "  ~/.prism-os/install-global.sh"
    echo ""
    echo "  # Check status"
    echo "  ~/.prism-os/install-global.sh --verify"
    echo ""
    echo "  # Update (after git pull)"
    echo "  cd ~/.prism-os && git pull && ./install-global.sh"
    echo ""
}

# Get installed version
get_installed_version() {
    if [ -f "$VERSION_FILE" ]; then
        grep "^version=" "$VERSION_FILE" 2>/dev/null | cut -d= -f2
    else
        echo "unknown"
    fi
}

# Get source version
get_source_version() {
    local source_dir="$1"
    if [ -f "$source_dir/VERSION" ]; then
        cat "$source_dir/VERSION" | tr -d '\n'
    elif [ -f "$source_dir/prism/VERSION" ]; then
        cat "$source_dir/prism/VERSION" | tr -d '\n'
    else
        echo "unknown"
    fi
}

# Verify installation
verify_installation() {
    echo ""
    echo -e "${BLUE}Prism OS Global Installation Status${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    local all_ok=true

    # Check source directory
    if [ -d "$PRISM_SOURCE" ]; then
        echo -e "${GREEN}✓${NC} Source directory: $PRISM_SOURCE"
        if [ -d "$PRISM_SOURCE/.git" ]; then
            echo -e "  ${GREEN}✓${NC} Git repository (can update)"
            local branch=$(cd "$PRISM_SOURCE" && git branch --show-current 2>/dev/null || echo "unknown")
            echo -e "  Branch: $branch"
        else
            echo -e "  ${YELLOW}!${NC} Not a git repository (update manually or use --convert-to-git)"
        fi
    else
        echo -e "${YELLOW}!${NC} Source directory not found: $PRISM_SOURCE"
        echo "  Run from cloned repository to install"
        all_ok=false
    fi

    # Check global claude directory
    if [ -d "$GLOBAL_CLAUDE" ]; then
        echo -e "${GREEN}✓${NC} Global config: $GLOBAL_CLAUDE"
    else
        echo -e "${RED}✗${NC} Global config missing: $GLOBAL_CLAUDE"
        all_ok=false
    fi

    # Check version file
    if [ -f "$VERSION_FILE" ]; then
        local installed=$(get_installed_version)
        echo -e "${GREEN}✓${NC} Version installed: $installed"
    else
        echo -e "${YELLOW}!${NC} Version file not found"
    fi

    echo ""

    # Check required directories
    local required_dirs=(
        "commands"
        "agents"
        "skills"
    )

    echo "Checking components..."
    for dir in "${required_dirs[@]}"; do
        if [ -d "$GLOBAL_CLAUDE/$dir" ]; then
            local count=$(find "$GLOBAL_CLAUDE/$dir" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
            echo -e "${GREEN}✓${NC} $dir/ ($count files)"
        else
            echo -e "${RED}✗${NC} $dir/ (missing)"
            all_ok=false
        fi
    done

    # Check for key files
    echo ""
    echo "Checking key files..."
    local key_files=(
        "commands/prism.md"
        "commands/spec.md"
        "commands/prism-update.md"
        "agents/orchestrator.md"
        "skills/workflow/spec-writer.md"
    )

    for file in "${key_files[@]}"; do
        if [ -f "$GLOBAL_CLAUDE/$file" ]; then
            echo -e "${GREEN}✓${NC} $file"
        else
            echo -e "${RED}✗${NC} $file (missing)"
            all_ok=false
        fi
    done

    # Check CLAUDE.md integration
    echo ""
    if [ -f "$GLOBAL_CLAUDE/CLAUDE.md" ]; then
        if grep -q "# PRISM-OS-START" "$GLOBAL_CLAUDE/CLAUDE.md" 2>/dev/null; then
            echo -e "${GREEN}✓${NC} CLAUDE.md integration active"
        else
            echo -e "${YELLOW}!${NC} CLAUDE.md exists but Prism section not found"
        fi
    else
        echo -e "${YELLOW}!${NC} No global CLAUDE.md (Prism commands still work)"
    fi

    # Check backups
    echo ""
    if [ -d "$BACKUP_DIR" ]; then
        local backup_count=$(ls -1 "$BACKUP_DIR" 2>/dev/null | wc -l | tr -d ' ')
        echo -e "${GREEN}✓${NC} Backups available: $backup_count"
    else
        echo "  No backups yet"
    fi

    echo ""
    if [ "$all_ok" = true ]; then
        echo -e "${GREEN}Installation verified successfully!${NC}"
        return 0
    else
        echo -e "${RED}Installation incomplete. Run ./install-global.sh to fix.${NC}"
        return 1
    fi
}

# Detect conflicts (non-Prism files in target directories)
detect_conflicts() {
    local has_conflicts=false
    local conflict_files=()

    # Check commands directory for non-Prism files
    if [ -d "$GLOBAL_CLAUDE/commands" ]; then
        for file in "$GLOBAL_CLAUDE/commands"/*.md; do
            [ -e "$file" ] || continue
            local basename=$(basename "$file")
            # List of Prism command files
            local is_prism=false
            local prism_commands="prism.md spec.md clarify.md plan.md tasks.md validate.md status.md constitution.md learn.md prime.md handoff.md prism-update.md"
            for cmd in $prism_commands; do
                if [ "$basename" = "$cmd" ]; then
                    is_prism=true
                    break
                fi
            done
            if [ "$is_prism" = false ]; then
                conflict_files+=("commands/$basename")
                has_conflicts=true
            fi
        done
    fi

    if [ "$has_conflicts" = true ]; then
        echo ""
        echo -e "${YELLOW}Warning: Found non-Prism files in target directories:${NC}"
        for f in "${conflict_files[@]}"; do
            echo "  - $f"
        done
        echo ""
        echo "These files will be preserved. To remove them, delete manually."
        echo ""
    fi
}

# Create backup
create_backup() {
    local backup_name="backup-$(date +%Y%m%d-%H%M%S)"
    local backup_path="$BACKUP_DIR/$backup_name"

    echo "Creating backup..."
    mkdir -p "$backup_path"

    # Backup commands, agents, skills
    for dir in commands agents skills; do
        if [ -d "$GLOBAL_CLAUDE/$dir" ]; then
            cp -r "$GLOBAL_CLAUDE/$dir" "$backup_path/" 2>/dev/null || true
        fi
    done

    # Backup version file
    if [ -f "$VERSION_FILE" ]; then
        cp "$VERSION_FILE" "$backup_path/"
    fi

    # Backup CLAUDE.md Prism section
    if [ -f "$GLOBAL_CLAUDE/CLAUDE.md" ]; then
        cp "$GLOBAL_CLAUDE/CLAUDE.md" "$backup_path/"
    fi

    echo -e "${GREEN}✓${NC} Backup created: $backup_name"

    # Rotate old backups (keep MAX_BACKUPS)
    local backup_count=$(ls -1 "$BACKUP_DIR" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$backup_count" -gt "$MAX_BACKUPS" ]; then
        local oldest=$(ls -1t "$BACKUP_DIR" | tail -1)
        rm -rf "$BACKUP_DIR/$oldest"
        echo "  Removed old backup: $oldest"
    fi
}

# Install files globally
install_global() {
    echo ""
    echo -e "${BLUE}Prism OS Global Installer v${INSTALLER_VERSION}${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Determine source directory
    local source_dir=""
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Check if we're in the source repo or have it installed
    if [ -d "$script_dir/prism" ]; then
        source_dir="$script_dir"
    elif [ -d "$PRISM_SOURCE/prism" ]; then
        source_dir="$PRISM_SOURCE"
    elif [ -d "$script_dir/.claude" ]; then
        # Old structure without prism/ subdirectory
        source_dir="$script_dir"
    else
        echo -e "${RED}Error: Cannot find Prism OS source files${NC}"
        echo ""
        echo "Please clone the repository first:"
        echo "  git clone $REPO_URL $PRISM_SOURCE"
        echo "  $PRISM_SOURCE/install-global.sh"
        exit 1
    fi

    # Check if running from PRISM_SOURCE or needs to be copied there
    if [ "$script_dir" != "$PRISM_SOURCE" ] && [ ! -d "$PRISM_SOURCE" ]; then
        echo "Installing source to $PRISM_SOURCE..."
        if [ -d "$script_dir/.git" ]; then
            # Clone to permanent location
            git clone "$script_dir" "$PRISM_SOURCE"
            echo -e "${GREEN}✓${NC} Cloned to $PRISM_SOURCE"
        else
            # Copy to permanent location
            cp -r "$script_dir" "$PRISM_SOURCE"
            echo -e "${GREEN}✓${NC} Copied to $PRISM_SOURCE"
        fi
        source_dir="$PRISM_SOURCE"
    fi

    # Find product directory
    local product_dir=""
    if [ -d "$source_dir/prism" ]; then
        product_dir="$source_dir/prism"
    else
        product_dir="$source_dir"
    fi

    local source_version=$(get_source_version "$source_dir")
    local installed_version=$(get_installed_version)

    echo "Source: $source_dir"
    echo "Source version: $source_version"
    echo "Installed version: $installed_version"
    echo ""

    # Detect conflicts
    detect_conflicts

    # Create backup if updating
    if [ -d "$GLOBAL_CLAUDE/commands" ] || [ -d "$GLOBAL_CLAUDE/agents" ]; then
        mkdir -p "$BACKUP_DIR"
        create_backup
    fi

    # Create global directories
    echo "Installing to $GLOBAL_CLAUDE..."
    mkdir -p "$GLOBAL_CLAUDE/commands"
    mkdir -p "$GLOBAL_CLAUDE/agents"
    mkdir -p "$GLOBAL_CLAUDE/skills"
    mkdir -p "$GLOBAL_CLAUDE/chains"

    # Install commands
    if [ -d "$product_dir/.claude/commands" ]; then
        local cmd_count=0
        for file in "$product_dir/.claude/commands"/*.md; do
            [ -e "$file" ] || continue
            cp "$file" "$GLOBAL_CLAUDE/commands/"
            cmd_count=$((cmd_count + 1))
        done
        echo -e "${GREEN}✓${NC} Installed $cmd_count commands"
    fi

    # Install agents
    if [ -d "$product_dir/.claude/agents" ]; then
        local agent_count=0
        for file in "$product_dir/.claude/agents"/*.md; do
            [ -e "$file" ] || continue
            cp "$file" "$GLOBAL_CLAUDE/agents/"
            agent_count=$((agent_count + 1))
        done
        echo -e "${GREEN}✓${NC} Installed $agent_count agents"
    fi

    # Install skills (recursively)
    if [ -d "$product_dir/.claude/skills" ]; then
        cp -r "$product_dir/.claude/skills/"* "$GLOBAL_CLAUDE/skills/" 2>/dev/null || true
        local skill_count=$(find "$GLOBAL_CLAUDE/skills" -name "*.md" | wc -l | tr -d ' ')
        echo -e "${GREEN}✓${NC} Installed $skill_count skills"
    fi

    # Install chains
    if [ -d "$product_dir/.claude/chains" ]; then
        cp -r "$product_dir/.claude/chains/"* "$GLOBAL_CLAUDE/chains/" 2>/dev/null || true
        echo -e "${GREEN}✓${NC} Installed chains"
    fi

    # Update/create CLAUDE.md with Prism section
    update_claude_md "$product_dir"

    # Write version file
    cat > "$VERSION_FILE" << EOF
version=$source_version
installed=$(date -u +%Y-%m-%dT%H:%M:%SZ)
source=$source_dir
EOF
    echo -e "${GREEN}✓${NC} Updated version file"

    # Show completion
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${GREEN}Prism OS installed globally!${NC}"
    echo ""
    echo "Prism commands are now available in all projects:"
    echo "  ${BLUE}/prism${NC}        - Start or check status"
    echo "  ${BLUE}/prism-update${NC} - Check for updates"
    echo ""
    echo "Per-project setup:"
    echo "  Create ${BLUE}memory/constitution.md${NC} for project principles"
    echo "  Create ${BLUE}specs/${NC} directory for feature specs"
    echo ""
    echo "Update Prism OS:"
    echo "  cd $PRISM_SOURCE && git pull && ./install-global.sh"
    echo "  Or use: ${BLUE}/prism-update${NC} from any project"
    echo ""
}

# Update CLAUDE.md with Prism section using markers
update_claude_md() {
    local product_dir="$1"
    local claude_md="$GLOBAL_CLAUDE/CLAUDE.md"

    detect_sed_inplace

    # Define the Prism section
    local prism_section='# PRISM-OS-START
# Prism OS

Prism OS is installed globally. Use `/prism` to start or check status.

## Quick Reference

| Command | Purpose |
|---------|---------|
| `/prism` | Start or show status |
| `/prism "description"` | Build a new feature |
| `/prism continue` | Resume work |
| `/prism-update` | Check for updates |

## Per-Project Files

These files are project-specific (not global):
- `memory/constitution.md` - Project principles
- `memory/project-context.md` - Current state
- `specs/` - Feature specifications

Create these in each project as needed.

# PRISM-OS-END'

    if [ -f "$claude_md" ]; then
        # Remove existing Prism section if present
        if grep -q "# PRISM-OS-START" "$claude_md"; then
            # Create temp file without Prism section
            local temp_file=$(mktemp)
            awk '/# PRISM-OS-START/{skip=1} /# PRISM-OS-END/{skip=0; next} !skip' "$claude_md" > "$temp_file"
            mv "$temp_file" "$claude_md"
        fi
        # Append fresh Prism section
        echo "" >> "$claude_md"
        echo "$prism_section" >> "$claude_md"
        echo -e "${GREEN}✓${NC} Updated CLAUDE.md with Prism section"
    else
        # Create new CLAUDE.md with Prism section
        echo "$prism_section" > "$claude_md"
        echo -e "${GREEN}✓${NC} Created CLAUDE.md with Prism section"
    fi

    # Clean up any .bak files from sed on macOS
    rm -f "$claude_md.bak" 2>/dev/null || true
}

# Uninstall global installation
uninstall_global() {
    echo ""
    echo -e "${BLUE}Prism OS Uninstaller${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    echo -e "${YELLOW}This will remove:${NC}"
    echo "  - $GLOBAL_CLAUDE/commands/ (Prism commands)"
    echo "  - $GLOBAL_CLAUDE/agents/ (Prism agents)"
    echo "  - $GLOBAL_CLAUDE/skills/ (Prism skills)"
    echo "  - $GLOBAL_CLAUDE/chains/ (Prism chains)"
    echo "  - Prism section from $GLOBAL_CLAUDE/CLAUDE.md"
    echo "  - $VERSION_FILE"
    echo ""
    echo "This will NOT remove:"
    echo "  - $PRISM_SOURCE (source code - delete manually if desired)"
    echo "  - $BACKUP_DIR (backups - delete manually if desired)"
    echo ""

    read -p "Are you sure? (y/N) " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Uninstall cancelled."
        exit 0
    fi

    # Remove Prism files (but preserve non-Prism files in commands/)
    local prism_commands="prism.md spec.md clarify.md plan.md tasks.md validate.md status.md constitution.md learn.md prime.md handoff.md prism-update.md"
    for cmd in $prism_commands; do
        rm -f "$GLOBAL_CLAUDE/commands/$cmd" 2>/dev/null || true
    done
    echo -e "${GREEN}✓${NC} Removed Prism commands"

    # Remove agents (all are Prism)
    rm -rf "$GLOBAL_CLAUDE/agents" 2>/dev/null || true
    echo -e "${GREEN}✓${NC} Removed agents"

    # Remove skills (all are Prism)
    rm -rf "$GLOBAL_CLAUDE/skills" 2>/dev/null || true
    echo -e "${GREEN}✓${NC} Removed skills"

    # Remove chains
    rm -rf "$GLOBAL_CLAUDE/chains" 2>/dev/null || true
    echo -e "${GREEN}✓${NC} Removed chains"

    # Remove Prism section from CLAUDE.md
    if [ -f "$GLOBAL_CLAUDE/CLAUDE.md" ]; then
        detect_sed_inplace
        if grep -q "# PRISM-OS-START" "$GLOBAL_CLAUDE/CLAUDE.md"; then
            local temp_file=$(mktemp)
            awk '/# PRISM-OS-START/{skip=1} /# PRISM-OS-END/{skip=0; next} !skip' "$GLOBAL_CLAUDE/CLAUDE.md" > "$temp_file"
            mv "$temp_file" "$GLOBAL_CLAUDE/CLAUDE.md"
            echo -e "${GREEN}✓${NC} Removed Prism section from CLAUDE.md"
        fi
    fi

    # Remove version file
    rm -f "$VERSION_FILE" 2>/dev/null || true
    echo -e "${GREEN}✓${NC} Removed version file"

    echo ""
    echo -e "${GREEN}Prism OS uninstalled.${NC}"
    echo ""
    echo "To completely remove, also delete:"
    echo "  rm -rf $PRISM_SOURCE"
    echo "  rm -rf $BACKUP_DIR"
    echo ""
}

# Convert tarball install to git-based
convert_to_git() {
    echo ""
    echo -e "${BLUE}Converting to Git-based Installation${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    if [ -d "$PRISM_SOURCE/.git" ]; then
        echo -e "${GREEN}✓${NC} Already a git repository"
        echo ""
        echo "To update, use:"
        echo "  cd $PRISM_SOURCE && git pull && ./install-global.sh"
        exit 0
    fi

    if [ ! -d "$PRISM_SOURCE" ]; then
        echo "No existing installation found at $PRISM_SOURCE"
        echo ""
        echo "To install fresh with git:"
        echo "  git clone $REPO_URL $PRISM_SOURCE"
        echo "  $PRISM_SOURCE/install-global.sh"
        exit 1
    fi

    echo "Current installation: $PRISM_SOURCE (not git-tracked)"
    echo ""
    echo "This will:"
    echo "  1. Backup current installation"
    echo "  2. Clone fresh from $REPO_URL"
    echo "  3. Reinstall globally"
    echo ""

    read -p "Continue? (y/N) " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Conversion cancelled."
        exit 0
    fi

    # Backup current
    local backup_path="$PRISM_SOURCE.backup-$(date +%Y%m%d-%H%M%S)"
    mv "$PRISM_SOURCE" "$backup_path"
    echo -e "${GREEN}✓${NC} Backed up to $backup_path"

    # Clone fresh
    git clone "$REPO_URL" "$PRISM_SOURCE"
    echo -e "${GREEN}✓${NC} Cloned from $REPO_URL"

    # Reinstall
    "$PRISM_SOURCE/install-global.sh"

    echo ""
    echo "Conversion complete. Old installation backed up to:"
    echo "  $backup_path"
    echo ""
    echo "You can delete the backup with:"
    echo "  rm -rf $backup_path"
    echo ""
}

# Main
case "$ACTION" in
    help)
        show_help
        ;;
    verify)
        verify_installation
        ;;
    uninstall)
        uninstall_global
        ;;
    convert)
        convert_to_git
        ;;
    install)
        install_global
        ;;
esac
