#!/run/current-system/sw/bin/sh
# NixOS Standard Update Script
# This script updates standard flake inputs (stylix, home-manager, etc.)

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/common.sh"

# Main execution
main() {
    print_info "Starting NixOS standard update..."
    
    # Get the update-standard inputs from flake.nix
    # This will be passed as command line arguments
    local inputs="$1"
    local setup_dir="$2"
    
    if [ -z "$inputs" ] || [ -z "$setup_dir" ]; then
        print_error "Missing required arguments for standard update"
        print_info "Usage: $0 <inputs> <setup_dir>"
        print_info "Example: $0 'stylix home-manager lanzaboote sops-nix nix-flatpak zen-browser' '/etc/nixos'"
        exit 1
    fi
    
    run_flake_update "$inputs" "$setup_dir"
    
    print_success "Standard update completed successfully!"
}

# Run main function
main "$@"