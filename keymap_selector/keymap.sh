#!/usr/bin/env bash
#
# minimal Keyboard Layout Selector for Linux
# Allows users to interactively change their keyboard layout using localectl
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log() {
    echo -e "${GREEN}[INFO]${NC} $*" >&2
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

info() {
    echo -e "${BLUE}[INFO]${NC} $*" >&2
}

# Cleanup function
cleanup() {
    if [[ -f "/tmp/keymaps.txt" ]]; then
        rm -f "/tmp/keymaps.txt"
    fi
}

# Set up trap for cleanup
trap cleanup EXIT

# Check dependencies (different requirements for different operations)
check_dependencies() {
    local operation="${1:-full}"
    local missing_deps=()
    
    # localectl is always required
    if ! command -v localectl >/dev/null 2>&1; then
        missing_deps+=("localectl")
    fi
    
    # dialog is only required for interactive operations
    if [[ "$operation" == "full" ]] && ! command -v dialog >/dev/null 2>&1; then
        missing_deps+=("dialog")
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        error "Missing required dependencies: ${missing_deps[*]}"
        echo "Please install missing packages:"
        for dep in "${missing_deps[@]}"; do
            case "$dep" in
                "dialog")
                    echo "  sudo pacman -S dialog"
                    ;;
                "localectl")
                    echo "  sudo pacman -S systemd"
                    ;;
            esac
        done
        exit 1
    fi
}

# Get current keyboard layout
get_current_keymap() {
    local current
    current=$(localectl status | grep "X11 Layout" | awk '{print $3}' 2>/dev/null)
    if [[ -z "$current" ]]; then
        current=$(localectl status | grep "VC Keymap" | awk '{print $3}' 2>/dev/null)
    fi
    echo "${current:-unknown}"
}

# Show current keyboard layout
show_current_layout() {
    local current_keymap
    current_keymap=$(get_current_keymap)
    info "Current keyboard layout: ${current_keymap}"
}

# Generate keymap list for dialog
generate_keymap_list() {
    local temp_file="/tmp/keymaps.txt"
    
    log "Fetching available keyboard layouts..."
    if ! localectl list-keymaps > "$temp_file" 2>/dev/null; then
        error "Failed to fetch keyboard layouts"
        return 1
    fi
    
    local count
    count=$(wc -l < "$temp_file")
    log "Found $count available keyboard layouts"
    
    return 0
}

# Create dialog menu from keymap list
show_keymap_dialog() {
    local temp_file="/tmp/keymaps.txt"
    local dialog_args=()
    local current_keymap
    
    current_keymap=$(get_current_keymap)
    
    # Build dialog arguments
    dialog_args=(
        --title "Keyboard Layout Selector"
        --cancel-label "Cancel"
        --ok-label "Select"
        --default-item "$current_keymap"
        --menu "Choose a keyboard layout:\nCurrent: $current_keymap"
        20 60 10
    )
    
    # Add keymap options
    while IFS= read -r keymap; do
        [[ -n "$keymap" ]] && dialog_args+=("$keymap" "$keymap")
    done < "$temp_file"
    
    # Show dialog and capture result
    local selected_keymap
    if selected_keymap=$(dialog "${dialog_args[@]}" 2>&1 >/dev/tty); then
        echo "$selected_keymap"
        return 0
    else
        return 1
    fi
}

# Apply the selected keymap
apply_keymap() {
    local keymap="$1"
    local current_keymap
    
    current_keymap=$(get_current_keymap)
    
    if [[ "$keymap" = "$current_keymap" ]]; then
        info "Keymap '$keymap' is already active"
        return 0
    fi
    
    log "Applying keyboard layout: $keymap"
    
    if sudo localectl set-keymap "$keymap"; then
        log "Successfully changed keyboard layout to: $keymap"
        info "The new layout will take effect immediately for new applications"
        info "You may need to restart existing applications to use the new layout"
        return 0
    else
        error "Failed to apply keyboard layout: $keymap"
        return 1
    fi
}

# Interactive confirmation
ask_confirmation() {
    local response
    echo
    echo -e "${BLUE}Would you like to modify the keyboard layout?${NC} [y/N]: "
    read -r response
    
    case "$response" in
        [Yy]|[Yy][Ee][Ss])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Show help
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Interactive keyboard layout selector for Linux systems using localectl.

Options:
    -h, --help          Show this help message
    -l, --list          List all available keymaps
    -c, --current       Show current keymap only
    -s, --set KEYMAP    Set keymap directly without dialog
    
Examples:
    $(basename "$0")                    # Interactive mode
    $(basename "$0") --list             # List available layouts
    $(basename "$0") --set us           # Set US layout directly
    $(basename "$0") --current          # Show current layout
    
EOF
}

# List all available keymaps
list_keymaps() {
    log "Available keyboard layouts:"
    if localectl list-keymaps; then
        return 0
    else
        error "Failed to list keyboard layouts"
        return 1
    fi
}

# Set keymap directly
set_keymap_direct() {
    local keymap="$1"
    
    # Validate keymap exists
    if ! localectl list-keymaps | grep -q "^$keymap$"; then
        error "Invalid keymap: $keymap"
        info "Use --list to see available keymaps"
        return 1
    fi
    
    apply_keymap "$keymap"
}

# Main function
main() {
    # Parse command line arguments first (help doesn't need dependencies)
    case "${1:-}" in
        -h|--help)
            show_help
            exit 0
            ;;
    esac
    
    # Continue parsing other arguments
    case "${1:-}" in
        -l|--list)
            check_dependencies "minimal"
            list_keymaps
            exit $?
            ;;
        -c|--current)
            check_dependencies "minimal"
            show_current_layout
            exit 0
            ;;
        -s|--set)
            if [[ -z "${2:-}" ]]; then
                error "Keymap argument required for --set option"
                echo "Usage: $0 --set KEYMAP"
                exit 1
            fi
            check_dependencies "minimal"
            set_keymap_direct "$2"
            exit $?
            ;;
        "")
            # Interactive mode needs full dependencies
            check_dependencies "full"
            ;;
        *)
            error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
    
    # Interactive mode
    clear
    echo -e "${BLUE}=== Keyboard Layout Selector ===${NC}"
    echo
    
    show_current_layout
    echo
    
    if ! ask_confirmation; then
        info "Keyboard layout change cancelled"
        exit 0
    fi
    
    if ! generate_keymap_list; then
        exit 1
    fi
    
    local selected_keymap
    if selected_keymap=$(show_keymap_dialog); then
        echo  # Clear dialog
        apply_keymap "$selected_keymap"
    else
        echo  # Clear dialog
        info "Keyboard layout change cancelled"
    fi
}

# Run main function
main "$@"
