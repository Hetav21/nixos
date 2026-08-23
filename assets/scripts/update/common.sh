#!/run/current-system/sw/bin/sh
set -e

# --- Initialization ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/../common/output.sh"

# --- Update Execution ---
run_flake_update() {
  local inputs="$1"
  local flake_path="$2"

  print_info "Updating flake inputs: $inputs"

  # shellcheck disable=SC2086
  if [ -n "$inputs" ]; then
    nix flake update --flake "$flake_path" $inputs
  else
    nix flake update --flake "$flake_path"
  fi

  print_success "Flake update completed successfully"
}

# --- Usage Help ---
show_usage() {
  cat <<EOF
Usage: $0 [COMMAND]

Commands:
  latest   - Update latest flake inputs (nixpkgs-unstable, etc.)
  standard - Update standard flake inputs (stylix, home-manager, etc.)
  all      - Update all flake inputs
  help     - Show this help message

Examples:
  scripts/update/latest.sh <inputs> <setup_dir>    # Update latest inputs
  scripts/update/standard.sh <inputs> <setup_dir>  # Update standard inputs
  scripts/update/all.sh <setup_dir>                # Update everything
EOF
}
