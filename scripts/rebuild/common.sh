#!/run/current-system/sw/bin/sh
# Common functions for NixOS rebuild scripts

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to setup environment
setup_environment() {
    local setup_dir="$1"
    print_status "Setting up environment..."
    pushd "$setup_dir" > /dev/null
    alejandra . &>/dev/null
    print_status "Code formatted with alejandra"
}

# Function to backup and show changes
show_diff() {
    print_status "Showing changes..."
    git diff -U0 *.nix
}

# Function to run nixos-rebuild with error handling
run_rebuild() {
    local rebuild_type="$1"
    local log_file="build.log"

    print_status "NixOS rebuilding with '$rebuild_type'..."
    sudo nixos-rebuild "$rebuild_type" --sudo --accept-flake-config &> "$log_file" || {
        print_error "Rebuild failed. Showing errors:"
        cat "$log_file" | grep --color error
        return 1
    }
    print_status "Rebuild completed successfully"
}

# Function to cleanup and exit
cleanup() {
    print_status "Cleaning up..."
    popd > /dev/null
}
