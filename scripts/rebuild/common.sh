#!/run/current-system/sw/bin/sh
# Common functions for NixOS rebuild scripts

set -e

# Source shared output functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../common/output.sh"

# Function to setup environment
setup_environment() {
    local setup_dir="$1"
    print_info "Setting up environment..."
    pushd "$setup_dir" > /dev/null
    alejandra . &>/dev/null
    print_info "Code formatted with alejandra"
}

# Function to backup and show changes
show_diff() {
    print_info "Showing changes..."
    git diff -U0 *.nix
}

# Function to run nixos-rebuild with error handling
run_rebuild() {
    local rebuild_type="$1"
    local log_file="build.log"

    print_info "NixOS rebuilding with '$rebuild_type'..."
    sudo nixos-rebuild "$rebuild_type" --sudo --accept-flake-config &> "$log_file" || {
        print_error "Rebuild failed. Showing errors:"
        cat "$log_file" | grep --color error
        return 1
    }
    print_success "Rebuild completed successfully"
}

# Function to cleanup and exit
cleanup() {
    print_info "Cleaning up..."
    popd > /dev/null
}
