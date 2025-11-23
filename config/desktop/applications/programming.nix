{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Text editors and IDEs
    unstable.code-cursor
    unstable.codex
    unstable.claude-code
    unstable.gemini-cli
    unstable.cursor-cli

    # Programming languages and build tools

    # Version control and development tools
    unstable.hoppscotch
    unstable.bruno
    awscli2
    mongodb-compass
    distrobox
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
      package = pkgs.gh;
      settings.git_protocol = "https";
      gitCredentialHelper = {
        enable = true;
        hosts = [
          "https://github.com"
          "https://gist.github.com"
        ];
      };
    };

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

      # This populates the userSettings "auto_install_extensions"
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

      # Everything inside of these brackets are Zed options
      # See https://zed.dev/docs
      userSettings = {
        show_edit_predictions = true;
        agent = {
          enabled = true;

          # Provider options:
          # - zed.dev models (claude-3-5-sonnet-latest) requires GitHub connected
          # - anthropic models (claude-3-5-sonnet-latest, claude-3-haiku-latest, claude-3-opus-latest) requires API_KEY
          # - copilot_chat models (gpt-4o, gpt-4, gpt-3.5-turbo, o1-preview) requires GitHub connected
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

        # Tell Zed to use direnv and direnv can use a flake.nix environment
        load_direnv = "shell_hook";
        vim_mode = true;
        # base_keymap = "VSCode";
        show_whitespaces = "selection";

        # ui_font_size = lib.mkForce 18;
        # buffer_font_size = lib.mkForce 18;

        # theme = {
        #   mode = "system";
        #   light = "One Light";
        #   dark = "One Dark";
        # };
      };
    };
  };
}
