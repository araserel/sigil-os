#!/bin/bash
# Prism OS Installer
# Usage: curl -sSL https://prism-os.dev/install.sh | sh
# Or: ./install.sh [--version X.X.X] [--verify] [--local /path] [--help]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installer version
INSTALLER_VERSION="1.0.0"
REPO_URL="https://github.com/araserel/prism-os"
BRANCH="main"

# Default options
TARGET_VERSION=""
VERIFY_ONLY=false
LOCAL_PATH=""

# Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --version)
            TARGET_VERSION="$2"
            shift 2
            ;;
        --verify)
            VERIFY_ONLY=true
            shift
            ;;
        --local)
            LOCAL_PATH="$2"
            shift 2
            ;;
        --help|-h)
            show_help
            exit 0
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
    echo "Prism OS Installer v${INSTALLER_VERSION}"
    echo ""
    echo "Usage: ./install.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --version X.X.X   Install a specific version (e.g., --version 1.0.0)"
    echo "  --verify          Verify installation completeness (no install)"
    echo "  --local /path     Install from local directory instead of downloading"
    echo "  --help, -h        Show this help message"
    echo ""
    echo "Examples:"
    echo "  curl -sSL https://prism-os.dev/install.sh | sh"
    echo "  ./install.sh --version 1.0.0"
    echo "  ./install.sh --local ~/projects/prism-os"
    echo "  ./install.sh --verify"
    echo ""
}

# Handle help flag early (before banner)
for arg in "$@"; do
    if [ "$arg" = "--help" ] || [ "$arg" = "-h" ]; then
        show_help
        exit 0
    fi
done

echo ""
echo -e "${BLUE}Prism OS Installer v${INSTALLER_VERSION}${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if we're in a git repository
check_git() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo -e "${RED}Error: Not a git repository${NC}"
        echo "Prism OS should be installed in a git repository."
        echo "Initialize one with: git init"
        exit 1
    fi
    echo -e "${GREEN}✓${NC} Git repository detected"
}

# Check for Claude Code CLI
check_claude_code() {
    if command -v claude &> /dev/null; then
        CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "unknown")
        echo -e "${GREEN}✓${NC} Claude Code CLI found (${CLAUDE_VERSION})"
    else
        echo -e "${YELLOW}!${NC} Claude Code CLI not found"
        echo "  Install it with: npm install -g @anthropic-ai/claude-code"
        echo "  Or follow instructions at: https://claude.ai/code"
        echo ""
        echo "  Prism OS will still be installed, but you'll need Claude Code to use it."
    fi
}

# Verify installation completeness
verify_installation() {
    echo ""
    echo "Verifying Prism OS installation..."

    local all_ok=true
    local required_files=(
        ".claude/commands/prism.md"
        ".claude/commands/spec.md"
        ".claude/commands/status.md"
        ".claude/agents/orchestrator.md"
        ".claude/skills/workflow/spec-writer.md"
        "templates/spec-template.md"
        "memory/constitution.md"
    )

    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            echo -e "${GREEN}✓${NC} $file"
        else
            echo -e "${RED}✗${NC} $file (missing)"
            all_ok=false
        fi
    done

    echo ""
    if [ "$all_ok" = true ]; then
        echo -e "${GREEN}Installation verified successfully!${NC}"

        # Show version info if available
        if [ -f ".prism-os-version" ]; then
            echo ""
            echo "Version info:"
            cat ".prism-os-version"
        fi
        return 0
    else
        echo -e "${RED}Installation incomplete. Some files are missing.${NC}"
        echo "Try reinstalling with: ./install.sh"
        return 1
    fi
}

# Track installed version
write_version_file() {
    local version="$1"
    local source="$2"

    cat > .prism-os-version << EOF
version=${version}
installed=$(date -u +%Y-%m-%dT%H:%M:%SZ)
source=${source}
EOF
    echo -e "${GREEN}✓${NC} Created .prism-os-version"
}

# Create directory structure
create_directories() {
    echo ""
    echo "Creating directory structure..."

    mkdir -p .claude/commands
    mkdir -p .claude/agents
    mkdir -p .claude/skills/workflow
    mkdir -p .claude/skills/qa
    mkdir -p .claude/skills/research
    mkdir -p .claude/skills/review
    mkdir -p .claude/chains
    mkdir -p templates/prompts
    mkdir -p memory
    mkdir -p specs
    mkdir -p docs

    echo -e "${GREEN}✓${NC} Created .claude/ directory structure"
    echo -e "${GREEN}✓${NC} Created templates/ directory"
    echo -e "${GREEN}✓${NC} Created memory/ directory"
    echo -e "${GREEN}✓${NC} Created specs/ directory"
    echo -e "${GREEN}✓${NC} Created docs/ directory"
}

# Download and install files
install_files() {
    echo ""
    echo "Installing Prism OS files..."

    local source_dir=""
    local version_installed=""
    local version_source=""

    # Handle --local flag: copy from local directory
    if [ -n "$LOCAL_PATH" ]; then
        if [ ! -d "$LOCAL_PATH" ]; then
            echo -e "${RED}Error: Local path not found: $LOCAL_PATH${NC}"
            exit 1
        fi
        echo "Installing from local directory: $LOCAL_PATH"
        source_dir="$LOCAL_PATH"
        version_installed="local"
        version_source="local:$LOCAL_PATH"
    else
        # Prevent running in prism-os repo itself
        if [ -f "CLAUDE.md" ] && grep -q "Prism OS Development Environment" CLAUDE.md 2>/dev/null; then
            echo -e "${YELLOW}!${NC} Detected Prism OS source repository"
            echo "  Use --local to install to another directory:"
            echo "  cd /your/project && /path/to/prism-os/install.sh --local /path/to/prism-os"
            exit 0
        fi
        # Also check for prism/ subdirectory (new structure)
        if [ -d "prism" ] && [ -d "prism/.claude" ]; then
            echo -e "${YELLOW}!${NC} Detected Prism OS source repository"
            echo "  Use --local to install to another directory:"
            echo "  cd /your/project && /path/to/prism-os/install.sh --local /path/to/prism-os"
            exit 0
        fi

        # Download from GitHub
        TEMP_DIR=$(mktemp -d)

        # Determine download URL based on version
        local download_url=""
        if [ -n "$TARGET_VERSION" ]; then
            download_url="${REPO_URL}/archive/refs/tags/v${TARGET_VERSION}.tar.gz"
            version_installed="$TARGET_VERSION"
            version_source="github:tag:v${TARGET_VERSION}"
            echo "Downloading version ${TARGET_VERSION} from GitHub..."
        else
            download_url="${REPO_URL}/archive/refs/heads/${BRANCH}.tar.gz"
            version_installed="${BRANCH}"
            version_source="github:branch:${BRANCH}"
            echo "Downloading latest (${BRANCH}) from GitHub..."
        fi

        if command -v curl &> /dev/null; then
            curl -sL "$download_url" -o "${TEMP_DIR}/prism-os.tar.gz"
        elif command -v wget &> /dev/null; then
            wget -q "$download_url" -O "${TEMP_DIR}/prism-os.tar.gz"
        else
            echo -e "${RED}Error: Neither curl nor wget found${NC}"
            echo "Please install curl or wget and try again."
            exit 1
        fi

        # Check if download succeeded
        if [ ! -s "${TEMP_DIR}/prism-os.tar.gz" ]; then
            echo -e "${RED}Error: Download failed${NC}"
            if [ -n "$TARGET_VERSION" ]; then
                echo "Version v${TARGET_VERSION} may not exist. Check available releases."
            fi
            rm -rf "${TEMP_DIR}"
            exit 1
        fi

        # Extract
        tar -xzf "${TEMP_DIR}/prism-os.tar.gz" -C "${TEMP_DIR}"

        # Find extracted directory (name varies by version/branch)
        source_dir=$(find "${TEMP_DIR}" -maxdepth 1 -type d -name "prism-os*" | head -1)
        if [ -z "$source_dir" ]; then
            echo -e "${RED}Error: Could not find extracted files${NC}"
            rm -rf "${TEMP_DIR}"
            exit 1
        fi
    fi

    # Copy files from prism/ subdirectory (without overwriting existing)
    local product_dir="${source_dir}/prism"

    # Fallback for older structure (before restructure)
    if [ ! -d "$product_dir" ]; then
        product_dir="$source_dir"
    fi

    # Note: CLAUDE.md is no longer copied from the product directory.
    # The preflight-check skill creates PRISM.md with enforcement rules
    # and adds a pointer to the project's CLAUDE.md on the first /prism run.

    # Copy templates
    if [ -d "${product_dir}/templates" ]; then
        cp -rn "${product_dir}/templates/"* ./templates/ 2>/dev/null || true
        echo -e "${GREEN}✓${NC} Installed templates/"
    fi

    # Copy .claude contents
    if [ -d "${product_dir}/.claude" ]; then
        cp -rn "${product_dir}/.claude/"* ./.claude/ 2>/dev/null || true
        echo -e "${GREEN}✓${NC} Installed .claude/ (commands, agents, skills)"
    fi

    # Copy docs
    if [ -d "${product_dir}/docs" ]; then
        cp -rn "${product_dir}/docs/"* ./docs/ 2>/dev/null || true
        echo -e "${GREEN}✓${NC} Installed docs/"
    fi

    # Copy memory templates (but not user data)
    if [ -d "${product_dir}/memory" ]; then
        # Only copy template files, not user content
        if [ -f "${product_dir}/memory/constitution.md" ] && [ ! -f "memory/constitution.md" ]; then
            cp "${product_dir}/memory/constitution.md" ./memory/ 2>/dev/null || true
        fi
        echo -e "${GREEN}✓${NC} Installed memory/ templates"
    fi

    # Write version tracking file
    write_version_file "$version_installed" "$version_source"

    # Cleanup temp directory if we downloaded
    if [ -z "$LOCAL_PATH" ] && [ -n "$TEMP_DIR" ]; then
        rm -rf "${TEMP_DIR}"
    fi
}

# Initialize constitution if not exists
init_constitution() {
    if [ ! -f "memory/constitution.md" ]; then
        echo ""
        echo "Initializing project constitution..."
        cat > memory/constitution.md << 'EOF'
# Project Constitution

> These principles are immutable. All agents respect these boundaries.

## Article 1: Technology Stack
- **Language:** [To be defined]
- **Framework:** [To be defined]
- **Database:** [To be defined]
- **Rationale:** [To be defined]

## Article 2: Code Standards
- [To be defined]

## Article 3: Testing Requirements
- [To be defined]

## Article 4: Security Mandates
- [To be defined]

## Article 5: Architecture Principles
- [To be defined]

## Article 6: Approval Requirements
- [To be defined]

## Article 7: Accessibility Requirements
- **Minimum Standard:** WCAG 2.1 Level AA compliance
- **Target Standard:** WCAG 2.1 Level AAA where feasible

---
*Run `/constitution` to update these principles.*
EOF
        echo -e "${GREEN}✓${NC} Created memory/constitution.md (template)"
    fi
}

# Initialize project context if not exists
init_project_context() {
    if [ ! -f "memory/project-context.md" ]; then
        cat > memory/project-context.md << 'EOF'
# Project Context

## Current State
- **Active Features:** None
- **Last Updated:** $(date +%Y-%m-%d)

## Active Workflows
None

## Recent Changes
- Initial Prism OS installation

---
*This file is updated automatically by Prism OS workflows.*
EOF
        echo -e "${GREEN}✓${NC} Created memory/project-context.md"
    fi
}

# Show completion message
show_completion() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${GREEN}Prism OS installed successfully!${NC}"
    echo ""
    echo "Directory structure:"
    echo "  .claude/commands/  - Slash commands (/prism, /spec, etc.)"
    echo "  .claude/agents/    - Agent definitions"
    echo "  .claude/skills/    - Skill definitions"
    echo "  templates/         - Document templates"
    echo "  memory/            - Project context and constitution"
    echo "  specs/             - Feature specifications"
    echo ""
    echo "Get started:"
    echo "  ${BLUE}/prism${NC}                  - See status and get guidance"
    echo "  ${BLUE}/prism \"description\"${NC}   - Start building a feature"
    echo "  ${BLUE}/prism continue${NC}         - Resume where you left off"
    echo ""
    echo "Or just describe what you want naturally:"
    echo "  \"I want to add user authentication\""
    echo "  \"Build me a dashboard\""
    echo ""
    echo "All commands:"
    echo "  /prism      - Unified entry point (recommended)"
    echo "  /spec       - Create a feature specification"
    echo "  /clarify    - Clarify specification ambiguities"
    echo "  /plan       - Create implementation plan"
    echo "  /tasks      - Break plan into tasks"
    echo "  /validate   - Run QA validation"
    echo "  /status     - Show workflow status"
    echo "  /constitution - View/edit project principles"
    echo "  /prime      - Load project context"
    echo ""
}

# Main installation flow
main() {
    # Handle --verify flag
    if [ "$VERIFY_ONLY" = true ]; then
        verify_installation
        exit $?
    fi

    echo "Checking prerequisites..."
    check_git
    check_claude_code

    create_directories
    install_files
    init_constitution
    init_project_context

    show_completion
}

main
