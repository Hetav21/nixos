#!/run/current-system/sw/bin/sh
# Common functions for NixOS update scripts

set -e

# Source shared output functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../common/output.sh"

# Function to run nix flake update with specific inputs
run_flake_update() {
    local inputs="$1"
    local flake_path="$2"
    
    print_info "Updating flake inputs: $inputs"
    
    if [ -n "$inputs" ]; then
        nix flake update --flake "$flake_path" $inputs
    else
        nix flake update --flake "$flake_path"
    fi
    
    if [ $? -eq 0 ]; then
        print_success "Flake update completed successfully"
    else
        print_error "Flake update failed"
        return 1
    fi
}


# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  latest   - Update latest flake inputs (nixpkgs-unstable, etc.)"
    echo "  standard - Update standard flake inputs (stylix, home-manager, etc.)"
    echo "  all      - Update all flake inputs"
    echo "  help     - Show this help message"
    echo ""
    echo "Examples:"
    echo "  scripts/update/latest.sh <inputs> <setup_dir>    # Update latest inputs"
    echo "  scripts/update/standard.sh <inputs> <setup_dir>  # Update standard inputs"
    echo "  scripts/update/all.sh <setup_dir>                # Update everything"
}
