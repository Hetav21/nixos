#!/usr/bin/env bash
set -e

# --- Initialization ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/common.sh"

# --- Main Execution ---
main() {
  local setup_dir="$1"
  print_info "Starting NixOS live rebuild..."

  setup_environment "$setup_dir"
  show_diff
  run_rebuild "switch" "$setup_dir"
  cleanup

  print_success "Live rebuild completed successfully!"
}

main "$@"
