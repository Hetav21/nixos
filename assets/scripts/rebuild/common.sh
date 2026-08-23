#!/usr/bin/env bash
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
  local setup_dir="$2"
  local log_file="build.log"

  print_info "NixOS rebuilding with '$rebuild_type' using nh..."
  if [ -n "$setup_dir" ]; then
    nh os "$rebuild_type" "$setup_dir" 2>&1 | tee "$log_file"
  else
    nh os "$rebuild_type" 2>&1 | tee "$log_file"
  fi
  local exit_code="${PIPESTATUS[0]}"

  if [ "$exit_code" -ne 0 ]; then
    print_error "Rebuild failed with exit code $exit_code. Showing errors from $log_file:"
    grep --color error "$log_file" || cat "$log_file"
    return "$exit_code"
  fi

  print_success "Rebuild completed successfully"
}

cleanup() {
  print_info "Cleaning up..."
  popd > /dev/null
}
