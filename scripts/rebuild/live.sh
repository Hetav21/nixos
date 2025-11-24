#!/run/current-system/sw/bin/sh
# NixOS Live Rebuild Script
# This script rebuilds NixOS and applies changes immediately

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Main execution
main() {
    local setup_dir="$1"
    print_status "Starting NixOS live rebuild..."
    
    setup_environment "$setup_dir"
    backup_and_diff
    run_rebuild "switch"
    sync_zed_settings
    cleanup
    
    print_status "Live rebuild completed successfully!"
}

# Run main function
main "$@"