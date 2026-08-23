#!/run/current-system/sw/bin/sh
set -e

# --- Initialization ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/common.sh"

# --- Main Execution ---
main() {
  print_info "Starting NixOS standard update..."

  local inputs="$1"
  local setup_dir="$2"

  if [ -z "$inputs" ] || [ -z "$setup_dir" ]; then
    print_error "Missing required arguments for standard update"
    print_info "Usage: $0 <inputs> <setup_dir>"
    print_info "Example: $0 'stylix home-manager lanzaboote sops-nix nix-flatpak' '/etc/nixos'"
    exit 1
  fi

  run_flake_update "$inputs" "$setup_dir"

  print_success "Standard update completed successfully!"
}

main "$@"