#!/run/current-system/sw/bin/sh
set -e

# --- Initialization ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/common.sh"

# --- Main Execution ---
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

main "$@"
