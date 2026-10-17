set shell := ["bash", "-uc"]

# Show available commands and documentation
default:
    @just --list

# Display defined flake input classification groups
groups:
    @echo "Flake Input Update Groups:"
    @echo "  stable   : nixpkgs, home-manager, stylix"
    @echo "  unstable : nixpkgs-unstable, helium-flake, vicinae-extensions"
    @echo "  apps     : nixvim, llm-agents, t3code"
    @echo "  system   : sops-nix, lanzaboote, nixos-wsl, nix-flatpak, nix-index-database"
    @echo "  manual   : nur, nix-skills (excluded from automated group updates)"

# Update flake inputs by group ('stable', 'unstable', 'apps', 'system', 'all') or single input
update group="all":
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{group}}" in
        stable)
            echo "Updating stable inputs (nixpkgs, home-manager, stylix)..."
            nix flake update nixpkgs home-manager stylix
            ;;
        unstable)
            echo "Updating unstable inputs (nixpkgs-unstable, helium-flake, vicinae-extensions)..."
            nix flake update nixpkgs-unstable helium-flake vicinae-extensions
            ;;
        apps)
            echo "Updating apps inputs (nixvim, llm-agents, t3code)..."
            nix flake update nixvim llm-agents t3code
            ;;
        system)
            echo "Updating system inputs (sops-nix, lanzaboote, nixos-wsl, nix-flatpak, nix-index-database)..."
            nix flake update sops-nix lanzaboote nixos-wsl nix-flatpak nix-index-database
            ;;
        all)
            echo "Updating all managed groups (stable, unstable, apps, system)..."
            nix flake update nixpkgs home-manager stylix nixpkgs-unstable helium-flake vicinae-extensions nixvim llm-agents t3code sops-nix lanzaboote nixos-wsl nix-flatpak nix-index-database
            ;;
        *)
            echo "Updating individual input '{{group}}'..."
            nix flake update "{{group}}"
            ;;
    esac

# Update all flake inputs unconditionally (including manual / personal inputs)
update-all:
    nix flake update

# Build and activate configuration, optionally updating a group first
switch group="":
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -z "{{group}}" ]; then
        nh os switch
    else
        case "{{group}}" in
            stable)
                nh os switch -U nixpkgs -U home-manager -U stylix
                ;;
            unstable)
                nh os switch -U nixpkgs-unstable -U helium-flake -U vicinae-extensions
                ;;
            apps)
                nh os switch -U nixvim -U llm-agents -U t3code
                ;;
            system)
                nh os switch -U sops-nix -U lanzaboote -U nixos-wsl -U nix-flatpak -U nix-index-database
                ;;
            all)
                nh os switch --update
                ;;
            *)
                nh os switch -U "{{group}}"
                ;;
        esac
    fi

# Build and activate temporarily without bootloader entry (test workflow)
test group="":
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -z "{{group}}" ]; then
        nh os test
    else
        case "{{group}}" in
            stable)
                nh os test -U nixpkgs -U home-manager -U stylix
                ;;
            unstable)
                nh os test -U nixpkgs-unstable -U helium-flake -U vicinae-extensions
                ;;
            apps)
                nh os test -U nixvim -U llm-agents -U t3code
                ;;
            system)
                nh os test -U sops-nix -U lanzaboote -U nixos-wsl -U nix-flatpak -U nix-index-database
                ;;
            all)
                nh os test --update
                ;;
            *)
                nh os test -U "{{group}}"
                ;;
        esac
    fi

# Build and add bootloader entry without activating now
boot:
    nh os boot

# Dry-run build for a host (default: current host)
dry host="$(hostname)":
    nh os build -H {{host}} --dry

# Build system toplevel derivation for a host (default: current host)
build host="$(hostname)":
    nh os build -H {{host}}

# Fast evaluation and syntax check without building (default: current host)
eval host="$(hostname)":
    nix eval .#nixosConfigurations.{{host}}.config.system.build.toplevel --apply 'x: "ok"'

# Validate flake syntax, inputs, and all host configurations
check:
    nix flake check

# Format Nix files using Alejandra (default: current directory)
format path=".":
    alejandra {{path}}

alias fmt := format

# Show detailed evaluation error trace (default: current host)
trace host="$(hostname)":
    nix eval .#nixosConfigurations.{{host}}.config.system.build.toplevel --show-trace

# Roll back system to previous generation or specific generation number
rollback gen="":
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -z "{{gen}}" ]; then
        nh os rollback
    else
        nh os rollback --to "{{gen}}"
    fi

# Remove old generations (default keep: 5)
clean keep="5":
    nh clean all --keep {{keep}}

# Clean old generations and deduplicate/optimise the Nix store
optimise:
    nh clean all --optimise

# Search packages on search.nixos.org via nh
search pkg:
    nh search {{pkg}}
