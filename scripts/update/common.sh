#!/run/current-system/sw/bin/sh
# Common functions for NixOS update scripts

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to run nix flake update with specific inputs
run_flake_update() {
    local inputs="$1"
    local flake_path="$2"
    
    print_status "Updating flake inputs: $inputs"
    
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

# Function to run package updates
run_package_updates() {
    local setup_dir="$1"
    local config_file="${setup_dir}pkgs/packages.conf"
    
    if [ ! -f "$config_file" ]; then
        print_error "Configuration file $config_file not found"
        return 1
    fi
    
    print_status "Starting package updates..."
    
    # Source the package update script
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    . "$SCRIPT_DIR/packages.sh"
    
    # Run the package update main function
    update_packages_main "$setup_dir"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  packages - Update packages from packages.conf"
    echo "  latest   - Update latest flake inputs (nixpkgs-unstable, etc.)"
    echo "  standard - Update standard flake inputs (stylix, home-manager, etc.)"
    echo "  all      - Update both packages and all flake inputs"
    echo "  help     - Show this help message"
    echo ""
    echo "Examples:"
    echo "  scripts/update/update packages  # Update packages only"
    echo "  scripts/update/update latest    # Update latest inputs"
    echo "  scripts/update/update standard  # Update standard inputs"
    echo "  scripts/update/update all       # Update everything"
}