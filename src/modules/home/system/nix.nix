{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.system.nix";
  hasCli = true;
  hasGui = false;

  cliConfig = {
    # --- Packages & Tools ---
    home.packages = [
      pkgs.alejandra
      pkgs.nixd
      pkgs.nil
      pkgs.nh
    ];

    # --- Nix Index & Database ---
    programs.nix-index.enable = true;
    programs.nix-index-database.comma.enable = true;

    # --- Nushell NixOS Helper (nx) ---
    programs.nushell.extraConfig = ''
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
              print "  nx rebuild [type]\t- Rebuild NixOS with nh (default: test)"
              print "\t\t\t  Types: test, switch, boot"
              print "  nx rollback [gen]\t- Rollback to previous generation with nh"
              print "  nx search <query>\t- Search Nix packages (via nh search)"
              print "  nx update [type]\t- Update flake inputs (default: all)"
              print "\t\t\t  Types: latest, standard"
              print "  nx flake [cmd] [host]\t- Flake operations"
              print "\t\t\t  Commands: check, build, eval"
              print $"\t\t\t  Hosts: (host-completions | str join ', ')"
              print "  nx clean [keep]\t- Remove old generations with nh (default: keep 1)"
              print "  nx gc [keep_since]\t- Run garbage collection with nh (default: 7d)"
              print "  nx optimise\t\t- Optimise nix store (deduplicate identical files)"
              print "  nx doctor\t\t- Run maintenance tasks with nh (clean + gc + optimise)"
              print "  nx pull\t\t- Pull latest changes from git"
              print "  nx log\t\t- View rebuild log\n"
              return
          }

          let type_arg = (if ($rest | is-empty) { null } else { $rest | first })
          let second_arg = (if ($rest | length) > 1 { $rest | get 1 } else { null })

          match $subcommand {
              "config" => { nx-config }
              "rebuild" => { nx-rebuild $type_arg }
              "rollback" => { nx-rollback $type_arg }
              "search" => { nx-search ...$rest }
              "update" => { nx-update $type_arg }
              "flake" => { nx-flake $type_arg $second_arg }
              "clean" => { nx-clean $type_arg }
              "gc" => { nx-gc $type_arg }
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
              "search"
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

      # Search Nix packages via nh
      def nx-search [...query: string] {
          if ($query | is-empty) {
              print "Error: Please specify a search query"
              print "Usage: nx search <query...>"
              return 1
          }
          ^nh search ...$query
      }

      # Rebuild NixOS configuration
      def nx-rebuild [
          rebuild_type?: string@rebuild-completions  # Optional rebuild type: test, switch, boot
      ] {
          let setup_dir = ($env.NIXOS_SETUP_DIR? | default "/etc/nixos" | str trim -r -c '/')
          let rebuild_type = (if ($rebuild_type | is-empty) { "test" } else { $rebuild_type })

          match $rebuild_type {
              "test" => {
                  run-external bash $"($setup_dir)/assets/scripts/rebuild/test.sh" $setup_dir
              }
              "switch" => {
                  run-external bash $"($setup_dir)/assets/scripts/rebuild/live.sh" $setup_dir
              }
              "boot" => {
                  run-external bash $"($setup_dir)/assets/scripts/rebuild/boot.sh" $setup_dir
              }
              _ => {
                  print $"Unknown rebuild type: ($rebuild_type)"
                  print "Available types: test, switch, boot"
                  return 1
              }
          }
      }

      # Rollback to previous NixOS generation with nh
      def nx-rollback [to_gen?: string] {
          print "\n-> Rolling back NixOS generation with nh..."
          if ($to_gen | is-empty) {
              ^nh os rollback
          } else {
              ^nh os rollback --to $to_gen
          }
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
                  print $"\n-> Dry-run build for ($target_host) with nh..."
                  print "   [Checks: full evaluation + derivation validity]"
                  print "   [Catches: missing packages, broken derivations, build errors]\n"
                  ^nh os build $setup_dir -H $target_host --dry
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

      # Completion function for hosts (derived from hosts/, so it cannot go stale)
      def host-completions [] {
          let setup_dir = ($env.NIXOS_SETUP_DIR? | default "/etc/nixos" | str trim -r -c '/')
          try {
              ls ($setup_dir | path join "hosts")
              | where type == dir
              | get name
              | path basename
              | where $it != "_common"
          } catch {
              ["nixbook" "nixwslbook" "nixworkbook"]
          }
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
              run-external sh $"($setup_dir)/assets/scripts/update/all.sh" $setup_dir
          } else {
              match $update_type {
                  "latest" => {
                      let combined_inputs = ($update_latest + " " + $update_standard)
                      run-external sh $"($setup_dir)/assets/scripts/update/latest.sh" $combined_inputs $setup_dir
                  }
                  "standard" => {
                      run-external sh $"($setup_dir)/assets/scripts/update/standard.sh" $update_standard $setup_dir
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

      # Remove old generations with nh
      def nx-clean [keep?: string] {
          print "\n-> Removing old generations with nh..."
          if ($keep | is-empty) {
              ^nh clean all
          } else {
              ^nh clean all --keep $keep
          }
          print "\n-> Cleanup completed."
      }

      # Run garbage collection with nh
      def nx-gc [keep_since?: string] {
          let duration = (if ($keep_since | is-empty) { "7d" } else { $keep_since })
          print $"\n-> Running garbage collection [keeping last ($duration)] with nh..."
          ^nh clean all --keep-since $duration
          print "\n-> Garbage collection completed."
      }

      # Optimise nix store (deduplicate identical files)
      def nx-optimise [] {
          print "\n-> Optimising nix store..."
          ^sudo nix-store --optimise
          print "\n-> Store optimisation completed."
      }

      # Run maintenance tasks (clean + gc + optimise) with nh
      def nx-doctor [] {
          print "\n-> Running maintenance tasks (clean + gc + optimise) with nh..."
          ^nh clean all --optimise
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
    '';
  };
}
