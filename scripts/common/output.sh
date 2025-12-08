#!/run/current-system/sw/bin/sh
# Common output functions for NixOS scripts
# Provides consistent colored output across all scripts

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print informational message (blue)
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Print success message (green)
print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Print warning message (yellow)
print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Print error message (red)
print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

