#!/run/current-system/sw/bin/sh
# NixOS Update All Inputs Script
# This script updates all flake inputs without restrictions

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/common.sh"

# Main execution
main() {
    print_info "Starting NixOS update (all inputs)..."
    
    local setup_dir="$1"
    
    if [ -z "$setup_dir" ]; then
        print_error "Missing required argument for update all"
        print_info "Usage: $0 <setup_dir>"
        print_info "Example: $0 '/etc/nixos'"
        exit 1
    fi
    
    # Update all flake inputs (no restrictions)
    print_info "Updating all flake inputs..."
    nix flake update --flake "$setup_dir"
    
    if [ $? -eq 0 ]; then
        print_success "All flake inputs updated successfully!"
    else
        print_error "Flake update failed"
        return 1
    fi
}

# Run main function
main "$@"