#!/run/current-system/sw/bin/sh
# NixOS Boot Rebuild Script
# This script rebuilds NixOS and applies changes on next boot

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Main execution
main() {
    local setup_dir="$1"
    print_info "Starting NixOS boot rebuild..."

    setup_environment "$setup_dir"
    show_diff
    run_rebuild "boot"
    cleanup

    print_success "Boot rebuild completed successfully!"
    print_warning "Changes will be applied on next reboot"
}

# Run main function
main "$@"
