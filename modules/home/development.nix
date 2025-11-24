{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.home.development;
in {
  options.home.development = {
    enable = mkEnableOption "Enable CLI/TUI development tools";
    enableGui = mkEnableOption "Enable GUI development tools";
  };

  config = mkMerge [
    # CLI/TUI development tools
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        # TUI development tools
        unstable.lazygit
        unstable.lazydocker

        # CLI development tools
        awscli2
        distrobox
        unstable.cursor-cli
        unstable.gemini-cli
        unstable.codex
      ];

      # Git configuration
      programs = {
        git = {
          enable = true;
          package = pkgs.unstable.git;
          lfs.enable = true;
        };

        gh = {
          enable = true;
          package = pkgs.unstable.gh;
          settings.git_protocol = "https";
          gitCredentialHelper = {
            enable = true;
            hosts = [
              "https://github.com"
              "https://gist.github.com"
            ];
          };
        };
      };
    })

    # GUI development tools
    (mkIf cfg.enableGui {
      # Auto-enable CLI tools when GUI is enabled
      home.development.enable = true;

      home.packages = with pkgs; [
        # GUI Text editors and IDEs
        unstable.code-cursor
        unstable.claude-code

        # GUI development tools
        unstable.hoppscotch
        unstable.bruno
        mongodb-compass
      ];

      # GUI program configurations
      programs = {
        vscode = {
          enable = true;
          package = pkgs.unstable.vscode;
          extensions = with pkgs.vscode-extensions; [
            vscodevim.vim
          ];
        };

        zed-editor = {
          enable = true;
          package = pkgs.unstable.zed-editor;
          installRemoteServer = true;
          extraPackages = with pkgs; [alejandra];

          extensions = [
            "nix"
            "CSV"
            "HTML"
            "TOML"
            "LOG"
            "SQL"
            "Prisma"
            "Git Firefly"
            "Dockerfile"
            "Docker Compose"
            "GraphQL"
            "Python LSP"
            "Basher"
            "Hyprlang"
          ];

          userSettings = {
            show_edit_predictions = true;
            agent = {
              enabled = true;
              default_model = {
                provider = "zed.dev";
                model = "claude-3-5-sonnet-latest";
              };
              inline_alternatives = [
                {
                  provider = "copilot_chat";
                  model = "gpt-3.5-turbo";
                }
              ];
            };

            node = {
              path = lib.getExe pkgs.nodejs;
              npm_path = lib.getExe' pkgs.nodejs "npm";
            };

            auto_update = false;
            tabs.file_icons = true;
            buffer_font_features = {
              liga = true;
              calt = true;
              kern = true;
            };

            terminal = {
              alternate_scroll = "off";
              blinking = "off";
              copy_on_select = false;
              dock = "bottom";
              detect_venv = {
                on = {
                  directories = [".env" "env" ".venv" "venv"];
                  activate_script = "default";
                };
              };
              env = {
                TERM = "ghostty";
              };
              line_height = "comfortable";
              option_as_meta = false;
              button = false;
              shell = "system";
              working_directory = "current_project_directory";
            };

            lsp = {
              clangd = {
                binary = {
                  path = lib.getExe' pkgs.clang-tools "clangd";
                  path_lookup = true;
                  arguments = ["--function-arg-placeholders=0" "--background-index" "--clang-tidy" "--log=verbose"];
                };
              };
              nil = {
                initialization_options = {
                  formatting = {
                    command = ["alejandra"];
                  };
                };
              };
            };

            languages = {
              "C++" = {
                show_edit_predictions = false;
                format_on_save = "on";
                tab_size = 2;
              };
              "Python" = {
                show_edit_predictions = false;
              };
            };

            load_direnv = "shell_hook";
            vim_mode = true;
            show_whitespaces = "selection";
          };
        };
      };
    })
  ];
}
