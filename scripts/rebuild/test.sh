#!/run/current-system/sw/bin/sh
# NixOS Test Rebuild Script
# This script tests the NixOS configuration without applying changes

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Main execution
main() {
    local setup_dir="$1"
    print_info "Starting NixOS test rebuild..."

    setup_environment "$setup_dir"
    show_diff
    run_rebuild "test"
    cleanup

    print_success "Test rebuild completed successfully!"
    print_info "Configuration is valid and ready to apply"
}

# Run main function
main "$@"
