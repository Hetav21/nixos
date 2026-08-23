#!/run/current-system/sw/bin/sh
set -e

# --- Initialization ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/common.sh"

# --- Main Execution ---
main() {
  print_info "Starting NixOS update (all inputs)..."

  local setup_dir="$1"

  if [ -z "$setup_dir" ]; then
    print_error "Missing required argument for update all"
    print_info "Usage: $0 <setup_dir>"
    print_info "Example: $0 '/etc/nixos'"
    exit 1
  fi

  print_info "Updating all flake inputs..."
  nix flake update --flake "$setup_dir"

  print_success "All flake inputs updated successfully!"
}

main "$@"