#!/run/current-system/sw/bin/sh
# NixOS Complete Update Script
# This script updates both packages and all flake inputs

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/common.sh"

# Main execution
main() {
    print_status "Starting NixOS complete update..."
    
    # Get the inputs from command line arguments
    local latest_inputs="$1"
    local standard_inputs="$2"
    local setup_dir="$3"
    
    if [ -z "$latest_inputs" ] || [ -z "$standard_inputs" ] || [ -z "$setup_dir" ]; then
        print_error "Missing required arguments for complete update"
        print_status "Usage: $0 <latest_inputs> <standard_inputs> <setup_dir>"
        print_status "Example: $0 'nixpkgs-unstable nixpkgs-master' 'stylix home-manager' '/etc/nixos'"
        exit 1
    fi
    
    # Update packages first
    print_status "Step 1: Updating packages..."
    run_package_updates "$setup_dir"
    
    # Update latest inputs
    print_status "Step 2: Updating latest inputs..."
    run_flake_update "$latest_inputs" "$setup_dir"
    
    # Update standard inputs
    print_status "Step 3: Updating standard inputs..."
    run_flake_update "$standard_inputs" "$setup_dir"
    
    print_success "Complete update finished successfully!"
    print_status "All packages and flake inputs have been updated"
}

# Run main function
main "$@"