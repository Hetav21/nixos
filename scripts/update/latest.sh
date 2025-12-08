#!/run/current-system/sw/bin/sh
# NixOS Latest Update Script
# This script updates latest flake inputs (nixpkgs-unstable, etc.)

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/common.sh"

# Main execution
main() {
    print_info "Starting NixOS latest update..."
    
    # Get the update-latest inputs from flake.nix
    # This will be passed as command line arguments
    local inputs="$1"
    local setup_dir="$2"
    
    if [ -z "$inputs" ] || [ -z "$setup_dir" ]; then
        print_error "Missing required arguments for latest update"
        print_info "Usage: $0 <inputs> <setup_dir>"
        print_info "Example: $0 'nixpkgs-unstable nixpkgs-master chaotic nur' '/etc/nixos'"
        exit 1
    fi
    
    run_flake_update "$inputs" "$setup_dir"
    
    print_success "Latest update completed successfully!"
}

# Run main function
main "$@"