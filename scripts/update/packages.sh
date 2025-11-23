#!/run/current-system/sw/bin/sh
# Nix-Optimized Package Update Script
# This script uses Nix tools for maximum performance and reliability

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/common.sh"

# Configuration
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nixos-package-updater"
API_CACHE_FILE="$CACHE_DIR/api_cache.txt"
HASH_CACHE_FILE="$CACHE_DIR/hash_cache.txt"
NIX_CACHE_FILE="$CACHE_DIR/nix_cache.txt"
MAX_CONCURRENT_JOBS=4
API_RATE_LIMIT_DELAY=1

# Create cache directory
mkdir -p "$CACHE_DIR"

# Function to get cached API response (simple text-based cache)
get_cached_api_response() {
    local cache_key="$1"
    local cache_file="$2"
    
    if [ -f "$cache_file" ]; then
        grep "^${cache_key}:" "$cache_file" 2>/dev/null | cut -d: -f2-
    fi
}

# Function to cache API response (simple text-based cache)
cache_api_response() {
    local cache_key="$1"
    local response="$2"
    local cache_file="$3"
    
    # Remove old entry if exists
    if [ -f "$cache_file" ]; then
        grep -v "^${cache_key}:" "$cache_file" > "${cache_file}.tmp" 2>/dev/null || touch "${cache_file}.tmp"
        mv "${cache_file}.tmp" "$cache_file"
    else
        touch "$cache_file"
    fi
    
    # Add new entry
    echo "${cache_key}:${response}" >> "$cache_file"
}

# Function to get latest release version from GitHub API with caching
get_latest_release() {
    local owner="$1"
    local repo="$2"
    local cache_key="release_${owner}_${repo}"
    
    # Check cache first
    local cached_response
    cached_response=$(get_cached_api_response "$cache_key" "$API_CACHE_FILE")
    if [ -n "$cached_response" ]; then
        echo "$cached_response"
        return 0
    fi
    
    local api_url="https://api.github.com/repos/${owner}/${repo}/releases/latest"
    
    print_status "Fetching latest release for $owner/$repo..." >&2
    local response
    response=$(curl -s --max-time 10 "$api_url" 2>/dev/null)
    
    if [ -z "$response" ]; then
        print_warning "Failed to fetch from GitHub API for $owner/$repo" >&2
        return 1
    fi
    
    if echo "$response" | grep -q "rate limit exceeded"; then
        print_warning "GitHub API rate limit exceeded for $owner/$repo" >&2
        return 1
    fi
    
    local version
    version=$(echo "$response" | grep '"tag_name"' | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/' | sed 's/^v//')
    
    if [ -n "$version" ] && [ "$version" != "null" ]; then
        # Cache the response
        cache_api_response "$cache_key" "$version" "$API_CACHE_FILE"
        echo "$version"
    else
        print_warning "Could not extract version from API response for $owner/$repo" >&2
        return 1
    fi
}

# Function to get latest commit hash from GitHub API with caching
get_latest_commit() {
    local owner="$1"
    local repo="$2"
    local branch="${3:-main}"
    local cache_key="commit_${owner}_${repo}_${branch}"
    
    # Check cache first
    local cached_response
    cached_response=$(get_cached_api_response "$cache_key" "$API_CACHE_FILE")
    if [ -n "$cached_response" ]; then
        echo "$cached_response"
        return 0
    fi
    
    local api_url="https://api.github.com/repos/${owner}/${repo}/commits/${branch}"
    
    print_status "Fetching latest commit for $owner/$repo@$branch..." >&2
    local response
    response=$(curl -s --max-time 10 "$api_url" 2>/dev/null)
    
    if [ -z "$response" ]; then
        print_warning "Failed to fetch from GitHub API for $owner/$repo@$branch" >&2
        return 1
    fi
    
    if echo "$response" | grep -q "rate limit exceeded"; then
        print_warning "GitHub API rate limit exceeded for $owner/$repo@$branch" >&2
        return 1
    fi
    
    local sha
    sha=$(echo "$response" | grep '"sha"' | sed 's/.*"sha": *"\([^"]*\)".*/\1/')
    
    if [ -n "$sha" ] && [ "$sha" != "null" ]; then
        # Cache the response
        cache_api_response "$cache_key" "$sha" "$API_CACHE_FILE"
        echo "$sha"
    else
        print_warning "Could not extract SHA from API response for $owner/$repo@$branch" >&2
        return 1
    fi
}

# Function to calculate SHA256 hash using Nix tools with caching
calculate_sha256_nix() {
    local url="$1"
    local cache_key="sha256_$(echo "$url" | sha256sum | cut -d' ' -f1)"
    
    # Check cache first
    local cached_hash
    cached_hash=$(get_cached_api_response "$cache_key" "$HASH_CACHE_FILE")
    if [ -n "$cached_hash" ]; then
        print_status "Using cached hash for $(basename "$url")" >&2
        echo "$cached_hash"
        return 0
    fi
    
    print_status "Calculating hash for $(basename "$url") using Nix..." >&2
    
    # Use nix-prefetch-url with better error handling
    local hash
    hash=$(nix-prefetch-url --unpack "$url" 2>/dev/null) || {
        print_warning "Hash calculation failed for URL: $url" >&2
        return 1
    }
    
    if [ -n "$hash" ]; then
        # Cache the hash
        cache_api_response "$cache_key" "$hash" "$HASH_CACHE_FILE"
        echo "$hash"
    else
        print_warning "Failed to calculate hash for URL: $url" >&2
        return 1
    fi
}

# Function to calculate GitHub hash using nix-prefetch-github with caching
calculate_github_hash_nix() {
    local owner="$1"
    local repo="$2"
    local rev="$3"
    local cache_key="github_${owner}_${repo}_${rev}"
    
    # Check cache first
    local cached_hash
    cached_hash=$(get_cached_api_response "$cache_key" "$NIX_CACHE_FILE")
    if [ -n "$cached_hash" ]; then
        print_status "Using cached Nix hash for $owner/$repo@$rev" >&2
        echo "$cached_hash"
        return 0
    fi
    
    print_status "Calculating hash for $owner/$repo@$rev using nix-prefetch-github..." >&2
    
    # Use nix-prefetch-github for better performance and reliability
    local result
    result=$(nix-shell -p nix-prefetch-github --run "nix-prefetch-github '$owner' '$repo' --rev '$rev' --json" 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$result" ]; then
        # Extract hash from JSON output
        local hash
        hash=$(echo "$result" | grep '"hash"' | sed 's/.*"hash": *"\([^"]*\)".*/\1/')
        
        if [ -n "$hash" ] && [ "$hash" != "null" ]; then
            # Cache the hash
            cache_api_response "$cache_key" "$hash" "$NIX_CACHE_FILE"
            echo "$hash"
            return 0
        fi
    fi
    
    # Fallback: use nix-prefetch-url with tarball URL
    print_status "Falling back to nix-prefetch-url for $owner/$repo@$rev..." >&2
    local tarball_url="https://github.com/${owner}/${repo}/archive/${rev}.tar.gz"
    local hash
    hash=$(nix-prefetch-url --unpack "$tarball_url" 2>/dev/null)
    
    if [ -n "$hash" ]; then
        # Cache the hash
        cache_api_response "$cache_key" "$hash" "$NIX_CACHE_FILE"
        echo "$hash"
    else
        print_warning "Failed to calculate hash for $owner/$repo@$rev" >&2
        return 1
    fi
}

# Function to update a package file atomically
update_package_file() {
    local file="$1"
    local version_field="$2"
    local rev_field="$3"
    local hash_field="$4"
    local version_prefix="$5"
    local new_version="$6"
    local new_rev="$7"
    local new_hash="$8"
    
    # Create backup
    cp "$file" "${file}.backup"
    
    # Create temporary file for atomic update
    local temp_file=$(mktemp)
    cp "$file" "$temp_file"
    
    # Update version field
    if [ -n "$version_field" ] && [ -n "$new_version" ]; then
        local version_value="${version_prefix}${new_version}"
        # Use awk for safer replacement
        awk -v field="$version_field" -v value="$version_value" '
            $0 ~ "^[[:space:]]*" field "[[:space:]]*=" {
                gsub(/"[^"]*"/, "\"" value "\"")
            }
            { print }
        ' "$temp_file" > "${temp_file}.tmp" && mv "${temp_file}.tmp" "$temp_file"
    fi
    
    # Update rev field
    if [ -n "$rev_field" ] && [ -n "$new_rev" ]; then
        # Use awk for safer replacement
        awk -v field="$rev_field" -v value="$new_rev" '
            $0 ~ "^[[:space:]]*" field "[[:space:]]*=" {
                gsub(/"[^"]*"/, "\"" value "\"")
            }
            { print }
        ' "$temp_file" > "${temp_file}.tmp" && mv "${temp_file}.tmp" "$temp_file"
    fi
    
    # Update hash field
    if [ -n "$hash_field" ] && [ -n "$new_hash" ]; then
        # Use awk for safer replacement
        awk -v field="$hash_field" -v value="$new_hash" '
            $0 ~ "^[[:space:]]*" field "[[:space:]]*=" {
                gsub(/"[^"]*"/, "\"" value "\"")
            }
            { print }
        ' "$temp_file" > "${temp_file}.tmp" && mv "${temp_file}.tmp" "$temp_file"
    fi
    
    # Atomic move
    mv "$temp_file" "$file"
}

# Function to update a single package (Nix-optimized)
update_package() {
    local name="$1"
    local type="$2"
    local owner="$3"
    local repo="$4"
    local file="$5"
    local version_field="$6"
    local rev_field="$7"
    local hash_field="$8"
    local version_prefix="$9"
    local branch="${10}"
    local url_template="${11}"
    local setup_dir="${12}"
    
    # Convert relative path to absolute path
    if [ "${file#/}" = "$file" ]; then
        file="${setup_dir}$file"
    fi
    
    print_status "Updating $name using Nix tools..."
    
    if [ ! -f "$file" ]; then
        print_warning "File $file not found, skipping $name"
        return 0
    fi
    
    local new_version new_rev new_hash
    
    # Rate limiting for API calls
    sleep "$API_RATE_LIMIT_DELAY"
    
    case "$type" in
        "github-release")
            new_version=$(get_latest_release "$owner" "$repo")
            if [ $? -ne 0 ] || echo "$new_version" | grep -q "ERROR"; then
                print_warning "Could not get latest version for $name: $new_version"
                return 0
            fi
            if [ -n "$new_version" ] && [ "$new_version" != "null" ]; then
                print_status "Latest $name version: $new_version"
                local url="${url_template//\{version\}/$new_version}"
                new_hash=$(calculate_sha256_nix "$url")
            else
                print_warning "Could not get latest version for $name"
                return 1
            fi
            ;;
        "github-tag")
            new_version=$(get_latest_release "$owner" "$repo")
            if [ $? -ne 0 ] || echo "$new_version" | grep -q "ERROR"; then
                print_warning "Could not get latest version for $name: $new_version"
                return 0
            fi
            if [ -n "$new_version" ] && [ "$new_version" != "null" ]; then
                print_status "Latest $name version: $new_version"
                new_rev="v$new_version"
                new_hash=$(calculate_github_hash_nix "$owner" "$repo" "$new_rev")
            else
                print_warning "Could not get latest version for $name"
                return 1
            fi
            ;;
        "github")
            new_version="devel"
            new_rev=$(get_latest_commit "$owner" "$repo" "${branch:-main}")
            if [ $? -ne 0 ] || echo "$new_rev" | grep -q "ERROR"; then
                print_warning "Could not get latest commit for $name: $new_rev"
                return 0
            fi
            if [ -n "$new_rev" ] && [ "$new_rev" != "null" ]; then
                print_status "Latest $name commit: $new_rev"
                new_hash=$(calculate_github_hash_nix "$owner" "$repo" "$new_rev")
            else
                print_warning "Could not get latest commit for $name"
                return 1
            fi
            ;;
        *)
            print_error "Unknown package type: $type"
            return 1
            ;;
    esac
    
    if [ -n "$new_hash" ] && [ "$new_hash" != "null" ]; then
        update_package_file "$file" "$version_field" "$rev_field" "$hash_field" "$version_prefix" "$new_version" "$new_rev" "$new_hash"
        print_success "Updated $name with Nix-optimized hash calculation"
    else
        print_warning "Could not calculate hash for $name"
        return 1
    fi
}

# Function to run package updates in parallel
update_packages_parallel() {
    local setup_dir="$1"
    local config_file="${setup_dir}pkgs/packages.conf"
    
    if [ ! -f "$config_file" ]; then
        print_error "Configuration file $config_file not found"
        return 1
    fi
    
    print_status "Starting parallel package updates with Nix tools (max $MAX_CONCURRENT_JOBS concurrent jobs)..."
    
    # Create job control
    local job_count=0
    local pids=()
    
    # Read configuration file and update packages
    while IFS= read -r line; do
        # Skip empty lines and comments
        if [ -z "$line" ] || echo "$line" | grep -q "^#"; then
            continue
        fi
        
        # Wait for available job slot
        while [ $job_count -ge $MAX_CONCURRENT_JOBS ]; do
            for i in "${!pids[@]}"; do
                if ! kill -0 "${pids[$i]}" 2>/dev/null; then
                    wait "${pids[$i]}"
                    unset "pids[$i]"
                    ((job_count--))
                fi
            done
            sleep 0.1
        done
        
        # Parse the line
        local name type owner repo file version_field rev_field hash_field version_prefix branch url_template
        
        IFS=':' read -r name type owner repo file version_field rev_field hash_field version_prefix branch rest <<EOF
$line
EOF
        
        # Handle URL template
        if [ "${rest#//}" != "$rest" ]; then
            url_template="https:$rest"
        else
            url_template="$rest"
        fi
        
        # Start background job
        (
            update_package "$name" "$type" "$owner" "$repo" "$file" "$version_field" "$rev_field" "$hash_field" "$version_prefix" "$branch" "$url_template" "$setup_dir"
        ) &
        
        pids+=($!)
        ((job_count++))
        
    done < "$config_file"
    
    # Wait for all remaining jobs
    for pid in "${pids[@]}"; do
        wait "$pid"
    done
    
    print_success "Parallel package update with Nix tools completed!"
}

# Main function for package updates
update_packages_main() {
    local setup_dir="$1"
    
    # Check if we should use parallel processing
    if [ "${PARALLEL_UPDATE:-true}" = "true" ]; then
        update_packages_parallel "$setup_dir"
    else
        # Fallback to sequential processing
        local config_file="${setup_dir}pkgs/packages.conf"
        
        if [ ! -f "$config_file" ]; then
            print_error "Configuration file $config_file not found"
            return 1
        fi
        
        print_status "Starting sequential package updates with Nix tools..."
        
        # Read configuration file and update each package
        while IFS= read -r line; do
            # Skip empty lines and comments
            if [ -z "$line" ] || echo "$line" | grep -q "^#"; then
                continue
            fi
            
            # Parse the line
            local name type owner repo file version_field rev_field hash_field version_prefix branch url_template
            
            IFS=':' read -r name type owner repo file version_field rev_field hash_field version_prefix branch rest <<EOF
$line
EOF
            
            # Handle URL template
            if [ "${rest#//}" != "$rest" ]; then
                url_template="https:$rest"
            else
                url_template="$rest"
            fi
            
            update_package "$name" "$type" "$owner" "$repo" "$file" "$version_field" "$rev_field" "$hash_field" "$version_prefix" "$branch" "$url_template" "$setup_dir" || true
        done < "$config_file"
        
        print_success "Sequential package update with Nix tools completed!"
    fi
    
    print_status "You may want to run 'nix flake update' to update the flake lock file."
}

# Function to clear caches
clear_caches() {
    print_status "Clearing all caches..."
    rm -f "$API_CACHE_FILE" "$HASH_CACHE_FILE" "$NIX_CACHE_FILE"
    print_success "All caches cleared!"
}

# Function to show cache status
show_cache_status() {
    print_status "Cache status:"
    if [ -f "$API_CACHE_FILE" ]; then
        local api_count
        api_count=$(wc -l < "$API_CACHE_FILE" 2>/dev/null || echo "0")
        print_status "  API cache: $api_count entries"
    else
        print_status "  API cache: empty"
    fi
    
    if [ -f "$HASH_CACHE_FILE" ]; then
        local hash_count
        hash_count=$(wc -l < "$HASH_CACHE_FILE" 2>/dev/null || echo "0")
        print_status "  Hash cache: $hash_count entries"
    else
        print_status "  Hash cache: empty"
    fi
    
    if [ -f "$NIX_CACHE_FILE" ]; then
        local nix_count
        nix_count=$(wc -l < "$NIX_CACHE_FILE" 2>/dev/null || echo "0")
        print_status "  Nix cache: $nix_count entries"
    else
        print_status "  Nix cache: empty"
    fi
}

# Function to test Nix tools availability
test_nix_tools() {
    print_status "Testing Nix tools availability..."
    
    # Test nix-prefetch-url
    if command -v nix-prefetch-url >/dev/null 2>&1; then
        print_success "nix-prefetch-url: available"
    else
        print_error "nix-prefetch-url: not available"
        return 1
    fi
    
    # Test nix-prefetch-github
    if nix-shell -p nix-prefetch-github --run "nix-prefetch-github --version" >/dev/null 2>&1; then
        print_success "nix-prefetch-github: available"
    else
        print_warning "nix-prefetch-github: not available (will use fallback)"
    fi
    
    # Test nix-prefetch-git
    if nix-shell -p nix-prefetch-git --run "nix-prefetch-git --help" >/dev/null 2>&1; then
        print_success "nix-prefetch-git: available"
    else
        print_warning "nix-prefetch-git: not available (will use fallback)"
    fi
    
    print_success "Nix tools test completed!"
}

# Main execution
main() {
    case "${1:-packages}" in
        "packages")
            print_status "Starting NixOS package updates with Nix tools..."
            update_packages_main
            ;;
        "clear-cache")
            clear_caches
            ;;
        "cache-status")
            show_cache_status
            ;;
        "test-nix")
            test_nix_tools
            ;;
        "help")
            echo "Usage: $0 [COMMAND]"
            echo ""
            echo "Commands:"
            echo "  packages     - Update packages from packages.conf (default)"
            echo "  clear-cache  - Clear all caches"
            echo "  cache-status - Show cache status"
            echo "  test-nix     - Test Nix tools availability"
            echo "  help         - Show this help message"
            echo ""
            echo "Environment variables:"
            echo "  PARALLEL_UPDATE=true|false - Enable/disable parallel processing (default: true)"
            echo "  MAX_CONCURRENT_JOBS=N      - Maximum concurrent jobs (default: 4)"
            echo ""
            echo "This version uses Nix tools for optimal performance:"
            echo "  - nix-prefetch-github for GitHub repositories"
            echo "  - nix-prefetch-url for direct URLs"
            echo "  - Enhanced caching for all operations"
            ;;
        *)
            print_error "Unknown command: $1"
            echo "Use '$0 help' for usage information"
            return 1
            ;;
    esac
}

# Run main function if script is executed directly
if [ "$(basename "$0")" = "packages.sh" ]; then
    main "$@"
fi