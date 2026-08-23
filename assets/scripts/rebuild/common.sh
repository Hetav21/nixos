#!/run/current-system/sw/bin/sh
set -e

# --- Initialization ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/../common/output.sh"

# --- Environment Setup & Diff ---
setup_environment() {
  local setup_dir="$1"
  print_info "Setting up environment..."
  pushd "$setup_dir" > /dev/null
  alejandra . &>/dev/null
  print_info "Code formatted with alejandra"
}

show_diff() {
  print_info "Showing changes..."
  git diff -U0 *.nix
}

# --- Rebuild Execution & Cleanup ---
run_rebuild() {
  local rebuild_type="$1"
  local log_file="build.log"

  print_info "NixOS rebuilding with '$rebuild_type'..."
  sudo nixos-rebuild "$rebuild_type" --sudo --accept-flake-config &> "$log_file" || {
    print_error "Rebuild failed. Showing errors:"
    grep --color error "$log_file" || cat "$log_file"
    return 1
  }
  print_success "Rebuild completed successfully"
}

cleanup() {
  print_info "Cleaning up..."
  popd > /dev/null
}
