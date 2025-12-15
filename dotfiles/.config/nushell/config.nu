# Nushell Custom Configuration
# This file contains custom functions and aliases for NixOS management
# Environment variables NIXOS_SETUP_DIR, NIXOS_UPDATE_STANDARD, NIXOS_UPDATE_LATEST
# are set by home-manager in shell.nix

### NixOS Management Commands (nx)
def nx [
    subcommand?: string@nx-completions  # Optional subcommand with custom completion
    ...rest: string                      # Additional arguments for nested commands
    --help(-h)                          # Show this help message
] {
    # Show help if requested, no subcommand provided, or subcommand is "help"
    if $help or ($subcommand | is-empty) or ($subcommand == "help") {
        print "\nNixOS management commands:"
        print "  nx config\t\t- Open NixOS configuration directory"
        print "  nx rebuild [type]\t- Rebuild NixOS (default: test)"
        print "\t\t\t  Types: test, switch, boot"
        print "  nx rollback\t\t- Rollback to previous generation"
        print "  nx update [type]\t- Update flake inputs (default: all)"
        print "\t\t\t  Types: latest, standard"
        print "  nx flake [cmd] [host]\t- Flake operations"
        print "\t\t\t  Commands: check, build, eval"
        print "\t\t\t  Hosts: nixbook, nixwslbook"
        print "  nx clean\t\t- Remove old generations"
        print "  nx gc\t\t\t- Run garbage collection"
        print "  nx optimise\t\t- Optimise nix store (deduplicate identical files)"
        print "  nx doctor\t\t- Run maintenance tasks (gc + clean + optimise)"
        print "  nx pull\t\t- Pull latest changes from git"
        print "  nx log\t\t- View rebuild log\n"
        return
    }

    let type_arg = (if ($rest | is-empty) { null } else { $rest | first })
    let second_arg = (if ($rest | length) > 1 { $rest | get 1 } else { null })

    match $subcommand {
        "config" => { nx-config }
        "rebuild" => { nx-rebuild $type_arg }
        "rollback" => { nx-rollback }
        "update" => { nx-update $type_arg }
        "flake" => { nx-flake $type_arg $second_arg }
        "clean" => { nx-clean }
        "gc" => { nx-gc }
        "optimise" => { nx-optimise }
        "doctor" => { nx-doctor }
        "pull" => { nx-pull }
        "log" => { nx-log }
        _ => { print $"Unknown subcommand: ($subcommand)\nRun 'nx --help' for available commands" }
    }
}

# Completion function for nx subcommands
def nx-completions [] {
    [
        "config"
        "rebuild"
        "rollback"
        "update"
        "flake"
        "clean"
        "gc"
        "optimise"
        "doctor"
        "pull"
        "log"
    ]
}

# Open NixOS configuration directory in editor
def nx-config [] {
    let setup_dir = ($env.NIXOS_SETUP_DIR? | default "/etc/nixos" | str trim -r -c '/')
    let editor = (if ($env.VISUAL? | is-empty) { $env.EDITOR? | default "vim" } else { $env.VISUAL })
    if ($editor | is-empty) {
        print "Error: EDITOR or VISUAL environment variable not set"
        return 1
    }
    run-external $editor $setup_dir
}

# Rebuild NixOS configuration
def nx-rebuild [
    rebuild_type?: string@rebuild-completions  # Optional rebuild type: test, switch, boot
] {
    let setup_dir = ($env.NIXOS_SETUP_DIR? | default "/etc/nixos" | str trim -r -c '/')
    let rebuild_type = (if ($rebuild_type | is-empty) { "test" } else { $rebuild_type })

    match $rebuild_type {
        "test" => {
            run-external sh $"($setup_dir)/scripts/rebuild/test.sh" $setup_dir
        }
        "switch" => {
            run-external sh $"($setup_dir)/scripts/rebuild/live.sh" $setup_dir
        }
        "boot" => {
            run-external sh $"($setup_dir)/scripts/rebuild/boot.sh" $setup_dir
        }
        _ => {
            print $"Unknown rebuild type: ($rebuild_type)"
            print "Available types: test, switch, boot"
            return 1
        }
    }
}

# Rollback to previous NixOS generation
def nx-rollback [] {
    print "\n-> Rolling back to previous generation..."
    ^sudo nixos-rebuild switch --rollback
    print "\n-> Rollback completed."
}

# Flake operations (check, build, eval)
def nx-flake [
    flake_cmd?: string@flake-cmd-completions  # Flake command: check, build, eval
    host?: string@host-completions            # Host
] {
    let setup_dir = ($env.NIXOS_SETUP_DIR? | default "/etc/nixos" | str trim -r -c '/')
    let flake_cmd = (if ($flake_cmd | is-empty) { "check" } else { $flake_cmd })
    
    match $flake_cmd {
        "check" => {
            print "\n-> Validating flake syntax..."
            print "   [Checks: flake structure, input references]"
            print "   [Catches: syntax errors, invalid inputs]\n"
            ^nix flake check $setup_dir
        }
        "build" => {
            let target_host = (if ($host | is-empty) { "nixwslbook" } else { $host })
            print $"\n-> Dry-run build for ($target_host)..."
            print "   [Checks: full evaluation + derivation validity]"
            print "   [Catches: missing packages, broken derivations, build errors]\n"
            ^nix build $"($setup_dir)#nixosConfigurations.($target_host).config.system.build.toplevel" --dry-run
            print $"\n-> Build check for ($target_host) completed."
        }
        "eval" => {
            let target_host = (if ($host | is-empty) { "nixwslbook" } else { $host })
            print $"\n-> Evaluating config for ($target_host)..."
            print "   [Checks: Nix expression evaluation for host]"
            print "   [Catches: undefined vars, type errors, missing modules]\n"
            ^nix eval $"($setup_dir)#nixosConfigurations.($target_host).config.system.build.toplevel" --apply "x: \"ok\""
            print $"\n-> Evaluation for ($target_host) completed."
        }
        _ => {
            print $"Unknown flake command: ($flake_cmd)"
            print "Available commands: check, build, eval"
            return 1
        }
    }
}

# Completion function for flake commands
def flake-cmd-completions [] {
    ["check" "build" "eval"]
}

# Completion function for hosts
def host-completions [] {
    ["nixbook" "nixwslbook"]
}

# Completion function for rebuild types
def rebuild-completions [] {
    ["test" "switch" "boot"]
}

# Update flake inputs
def nx-update [
    update_type?: string@update-completions  # Optional update type: latest, standard
] {
    let setup_dir = ($env.NIXOS_SETUP_DIR? | default "/etc/nixos" | str trim -r -c '/')
    let update_standard = ($env.NIXOS_UPDATE_STANDARD? | default "")
    let update_latest = ($env.NIXOS_UPDATE_LATEST? | default "")

    if ($update_type | is-empty) {
        # Update all inputs if no type specified
        run-external sh $"($setup_dir)/scripts/update/all.sh" $setup_dir
    } else {
        match $update_type {
            "latest" => {
                let combined_inputs = ($update_latest + " " + $update_standard)
                run-external sh $"($setup_dir)/scripts/update/latest.sh" $combined_inputs $setup_dir
            }
            "standard" => {
                run-external sh $"($setup_dir)/scripts/update/standard.sh" $update_standard $setup_dir
            }
            _ => {
                print $"Unknown update type: ($update_type)"
                print "Available types: latest, standard"
                return 1
            }
        }
    }
    # Update flatpak packages (if flatpak is installed)
    if (which flatpak | is-not-empty) {
        run-external flatpak update "-y"
    }
}

# Completion function for update types
def update-completions [] {
    ["latest" "standard"]
}

# Remove old generations
def nx-clean [] {
    print "\n-> Removing old generations..."
    ^sudo nix-collect-garbage -d
    nix-collect-garbage -d
    print "\n-> Cleanup completed."
}

# Run garbage collection
def nx-gc [] {
    print "\n-> Running garbage collection..."
    ^sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
    print "\n-> Garbage collection completed."
}

# Optimise nix store (deduplicate identical files)
def nx-optimise [] {
    print "\n-> Optimising nix store..."
    ^sudo nix-store --optimise
    print "\n-> Store optimisation completed."
}

# Run maintenance tasks
def nx-doctor [] {
    print "\n-> Running maintenance tasks..."
    nx-gc
    nx-clean
    nx-optimise
    print "\n-> All maintenance tasks completed."
}

# Pull latest changes from git
def nx-pull [] {
    let setup_dir = ($env.NIXOS_SETUP_DIR? | default "/etc/nixos" | str trim -r -c '/')
    let original_dir = $env.PWD

    cd $setup_dir
    print "\n-> Pulling latest changes from git..."
    run-external git pull
    print "\n-> Git pull completed."
    cd $original_dir
}

# View rebuild log
def nx-log [] {
    let setup_dir = ($env.NIXOS_SETUP_DIR? | default "/etc/nixos" | str trim -r -c '/')
    let log_path = $"($setup_dir)/build.log"
    ^tail -f $log_path
}

# Git / Docker Aliases
def "gac" [message: string] {
  git add .
  git commit -m $"($message)"
}
def "docker-clean" [] {
  print "Cleaning Docker..."
  docker container prune -f
  docker image prune -f
  docker network prune -f
  docker volume prune -f
  print "Docker clean complete."
}
def "docker-rmi-all" [] {
  print "Removing all Docker images (this may take a while)..."
  let image_ids = (docker images -q)
  if ($image_ids | is-empty) {
    print "No Docker images to remove."
  } else {
    docker rmi $image_ids
  }
  print "All Docker images removed."
}

$env.config.show_banner = false
