#!/usr/bin/env bash
#
# Keyboard Layout Selector using dialog
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

# Test keymap temporarily -- this part is still WIP! 
test_keymap() {
    local keymap="$1"
    local current_keymap="$2"
    
    log "Testing keyboard layout: $keymap"
    info "This will temporarily change your keyboard layout for testing"
    warn "If you can't type properly, wait 30 seconds and it will revert automatically"
    echo
    
    # Apply the keymap temporarily
    if ! sudo localectl set-keymap "$keymap"; then
        error "Failed to apply test keymap: $keymap"
        return 1
    fi
    
    log "Test layout '$keymap' applied temporarily"
    echo
    echo -e "${BLUE}=== KEYBOARD LAYOUT TEST ===${NC}"
    echo -e "${YELLOW}Please test your keyboard by typing below:${NC}"
    echo -e "${YELLOW}Try typing: abcdefghijklmnopqrstuvwxyz 1234567890 !@#\$%^&*()${NC}"
    echo
    echo -n "Type here: "
    
    # Read user input with timeout
    local user_input
    local choice
    
    if read -t 30 -r user_input; then
        echo
        echo -e "${GREEN}You typed: $user_input${NC}"
        echo
        echo -e "${BLUE}Does the keyboard work correctly?${NC} [y/N/r]"
        echo "  y = Yes, keep this layout"
        echo "  n = No, revert to previous layout (default)"
        echo "  r = Revert and choose a different layout"
        echo
        echo -n "Your choice: "
        
        if read -t 15 -r choice; then
            echo
            case "$choice" in
                [Yy]|[Yy][Ee][Ss])
                    return 0  # Keep the layout
                    ;;
                [Rr]|[Rr][Ee][Tt][Uu][Rr][Nn])
                    return 2  # Return to selection
                    ;;
                *)
                    return 1  # Revert layout
                    ;;
            esac
        else
            warn "No response received, reverting to previous layout for safety"
            return 1
        fi
    else
        warn "Timeout reached, reverting to previous layout for safety"
        return 1
    fi
}

# Apply the selected keymap with optional testing
apply_keymap() {
    local keymap="$1"
    local test_mode="${2:-true}"  # Default to testing mode
    local current_keymap
    
    current_keymap=$(get_current_keymap)
    
    if [[ "$keymap" = "$current_keymap" ]]; then
        info "Keymap '$keymap' is already active"
        return 0
    fi
    
    # If testing is enabled, test first
    if [[ "$test_mode" == "true" ]]; then
        local test_result
        test_keymap "$keymap" "$current_keymap"
        test_result=$?
        
        case $test_result in
            0)
                # User confirmed layout works, keep it
                log "User confirmed layout works, keeping '$keymap'"
                log "Successfully changed keyboard layout to: $keymap"
                info "The new layout is now permanently active"
                return 0
                ;;
            1)
                # User wants to revert or timeout
                log "Reverting to previous layout: $current_keymap"
                if sudo localectl set-keymap "$current_keymap"; then
                    log "Successfully reverted to: $current_keymap"
                else
                    error "Failed to revert to previous layout!"
                    warn "You may need to manually reset your keyboard layout"
                fi
                return 1
                ;;
            2)
                # User wants to choose different layout
                log "Reverting to previous layout: $current_keymap"
                if sudo localectl set-keymap "$current_keymap"; then
                    log "Successfully reverted to: $current_keymap"
                else
                    error "Failed to revert to previous layout!"
                fi
                return 2  # Signal to return to selection
                ;;
        esac
    else
        # Direct application without testing
        log "Applying keyboard layout directly: $keymap"
        
        if sudo localectl set-keymap "$keymap"; then
            log "Successfully changed keyboard layout to: $keymap"
            info "The new layout will take effect immediately for new applications"
            info "You may need to restart existing applications to use the new layout"
            return 0
        else
            error "Failed to apply keyboard layout: $keymap"
            return 1
        fi
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
    -h, --help              Show this help message
    -l, --list              List all available keymaps
    -c, --current           Show current keymap only
    -s, --set KEYMAP        Set keymap directly without dialog
    -t, --test KEYMAP       Test keymap before applying (with safety timeout)
    -f, --force KEYMAP      Force keymap without testing (use with caution)
    
Examples:
    $(basename "$0")                    # Interactive mode with testing
    $(basename "$0") --list             # List available layouts
    $(basename "$0") --current          # Show current layout
    $(basename "$0") --set us           # Set US layout with testing
    $(basename "$0") --test us          # Test US layout with confirmation
    $(basename "$0") --force us         # Force US layout without testing
    
Safety Features:
    - Testing mode applies layout temporarily with 30-second timeout
    - Automatic reversion if no confirmation received
    - Manual reversion option during testing
    - Option to return to selection menu after testing
    
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
        -t|--test)
            if [[ -z "${2:-}" ]]; then
                error "Keymap argument required for --test option"
                echo "Usage: $0 --test KEYMAP"
                exit 1
            fi
            check_dependencies "minimal"
            # Validate keymap exists
            if ! localectl list-keymaps | grep -q "^$2$"; then
                error "Invalid keymap: $2"
                info "Use --list to see available keymaps"
                exit 1
            fi
            apply_keymap "$2" "true"  # Force testing mode
            exit $?
            ;;
        -f|--force)
            if [[ -z "${2:-}" ]]; then
                error "Keymap argument required for --force option"
                echo "Usage: $0 --force KEYMAP"
                exit 1
            fi
            check_dependencies "minimal"
            # Validate keymap exists
            if ! localectl list-keymaps | grep -q "^$2$"; then
                error "Invalid keymap: $2"
                info "Use --list to see available keymaps"
                exit 1
            fi
            warn "Applying keymap without testing - use with caution!"
            apply_keymap "$2" "false"  # Force no testing
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
    
    # Main selection loop
    while true; do
        local selected_keymap
        if selected_keymap=$(show_keymap_dialog); then
            echo  # Clear dialog
            
            # Ask about testing mode
            echo -e "${BLUE}How would you like to apply the layout?${NC}"
            echo "  t = Test first (recommended) - allows you to verify the layout works"
            echo "  d = Apply directly without testing"
            echo
            echo -n "Your choice [T/d]: "
            
            local apply_mode
            read -r apply_mode
            
            local test_mode="true"
            case "$apply_mode" in
                [Dd]|[Dd][Ii][Rr][Ee][Cc][Tt])
                    test_mode="false"
                    ;;
            esac
            
            # Apply the keymap
            local apply_result
            apply_keymap "$selected_keymap" "$test_mode"
            apply_result=$?
            
            case $apply_result in
                0)
                    # Success - exit
                    break
                    ;;
                1)
                    # Failed or reverted - exit
                    break
                    ;;
                2)
                    # Return to selection - continue loop
                    echo
                    info "Returning to layout selection..."
                    echo
                    continue
                    ;;
            esac
        else
            echo  # Clear dialog
            info "Keyboard layout change cancelled"
            break
        fi
    done
}

# Run main function
main "$@"
