{
  lib,
  pkgs,
  pkgs-unstable,
  config,
  settings,
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
      home.packages =
        (with pkgs; [
          # CLI development tools
          awscli2
          distrobox
        ])
        ++ (with pkgs-unstable; [
          # TUI development tools
          lazygit
          lazydocker
          # CLI development tools (unstable)
          cursor-cli
          claude-code
          gemini-cli
          codex
        ]);

      services.ssh-agent.enable = true;

      programs = {
        ssh = {
          enable = true;
          enableDefaultConfig = false;
          matchBlocks = {
            "github.com-work" = {
              hostname = "github.com";
              identityFile = settings.ssh.work.identityFile;
              identitiesOnly = true;
            };

            "github.com-personal" = {
              hostname = "github.com";
              identityFile = settings.ssh.personal.identityFile;
              identitiesOnly = true;
            };

            "*" = {
              forwardAgent = false;
              addKeysToAgent = "no";
              compression = false;
              serverAliveInterval = 0;
              serverAliveCountMax = 3;
              hashKnownHosts = false;
              userKnownHostsFile = "~/.ssh/known_hosts";
              controlMaster = "no";
              controlPath = "~/.ssh/master-%r@%n:%p";
              controlPersist = "no";
            };
          };
        };

        git = {
          enable = true;
          package = pkgs-unstable.gitFull;

          lfs = {
            enable = true;
            package = pkgs-unstable.git-lfs;
          };

          settings = {
            # Additional configuration
            color.ui = "auto";
            core.editor = "vim";
            pull.rebase = false;
            init.defaultBranch = "main";
            push.autoSetupRemote = true;
            merge.conflictStyle = "diff3";
            credential.helper = "libsecret";

            # Git aliases
            alias = {
              st = "status";
              co = "checkout";
              br = "branch";
              ci = "commit -m";
              aci = "commit -am";
              unstage = "reset HEAD --";
              last = "log -1 HEAD";
              lg = "log --graph --oneline --decorate --all";
            };
          };
        };

        jujutsu = {
          enable = true;
          package = pkgs-unstable.jujutsu;
          # Settings placeholder
          # settings = {};
        };

        # Delta for better diffs
        delta = {
          enable = true;
          enableGitIntegration = true;
          enableJujutsuIntegration = true;
          package = pkgs-unstable.delta;
          options = {
            navigate = true;
            light = false;
            side-by-side = true;
          };
        };
      };
    })

    # GUI development tools
    (mkIf cfg.enableGui {
      # Auto-enable CLI tools when GUI is enabled
      home.development.enable = true;

      home.packages =
        (with pkgs; [
          mongodb-compass
        ])
        ++ (with pkgs-unstable; [
          # GUI Text editors and IDEs
          code-cursor
          antigravity
          # GUI development tools
          hoppscotch
          bruno
        ]);

      # GUI program configurations
      programs = {
        vscode = {
          enable = true;
          package = pkgs-unstable.vscode;
          profiles.${settings.username} = {
            extensions = with pkgs-unstable.vscode-extensions; [vscodevim.vim];

            userSettings = {
              # Editor settings
              editor = {
                mouseWheelZoom = true;
                cursorBlinking = "expand";
                fontVariations = true;
                wordWrap = "on";
                formatOnPaste = true;
                fontLigatures = true;
                smoothScrolling = true;
                letterSpacing = 0.4;
                lineHeight = 1.4;
                detectIndentation = false;
                guides.bracketPairs = "active";
                defaultColorDecorators = "always";
                colorDecorators = true;
                largeFileOptimizations = false;
              };

              # Workbench settings
              workbench = {
                sideBar.location = "left";
                activityBar.location = "top";
                startupEditor = "none";
                editor = {
                  enablePreview = false;
                  empty.hint = "hidden";
                };
              };

              # Terminal settings
              terminal = {
                integrated = {
                  defaultProfile = {
                    windows = "Git Bash";
                    linux = "nu";
                  };
                  env = {
                    windows = {};
                    linux = {};
                  };
                  cursorBlinking = true;
                  cursorStyle = "line";
                  cursorStyleInactive = "line";
                  experimentalInlineChat = true;
                  allowedLinkSchemes = [
                    "file"
                    "http"
                    "https"
                    "mailto"
                    "vscode"
                    "vscode-insiders"
                    "docker-desktop"
                  ];
                  profiles.windows = {
                    PowerShell = {
                      source = "PowerShell";
                      icon = "terminal-powershell";
                    };
                    "Command Prompt" = {
                      path = [
                        "\${env:windir}\\Sysnative\\cmd.exe"
                        "\${env:windir}\\System32\\cmd.exe"
                      ];
                      args = [];
                      icon = "terminal-cmd";
                    };
                    "Git Bash" = {source = "Git Bash";};
                    "Windows PowerShell" = {
                      path = "C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe";
                    };
                  };
                };
                external = {
                  windowsExec = "alacritty.exe";
                  linuxExec = "ghostty";
                  osxExec = "terminal.app";
                };
              };

              # Chat/MCP settings
              chat.mcp = {
                gallery.enabled = true;
                autostart = "never";
                discovery.enabled = {
                  "claude-desktop" = true;
                  windsurf = true;
                  "cursor-global" = true;
                  "cursor-workspace" = true;
                };
              };

              # GitHub Copilot settings
              github.copilot = {
                enable = {
                  "*" = false;
                  plaintext = true;
                  markdown = true;
                  scminput = false;
                  java = false;
                  python = false;
                  sql = false;
                  javascript = false;
                };
                advanced = {};
                chat.codesearch.enabled = true;
                nextEditSuggestions.enabled = true;
              };

              # Git settings
              git = {
                autofetch = true;
                enableSmartCommit = true;
              };

              git-blame.config.inlineBlameHoverMessage = true;

              # Language-specific settings
              "[typescript]" = {
                "editor.defaultFormatter" = "vscode.typescript-language-features";
              };

              typescript = {
                updateImportsOnFileMove.enabled = "always";
                preferences.importModuleSpecifier = "non-relative";
              };

              javascript = {
                preferences.importModuleSpecifier = "non-relative";
              };

              # Python settings
              python = {
                analysis = {
                  autoFormatStrings = true;
                  autoImportCompletions = true;
                  typeCheckingMode = "standard";
                  diagnosticSeverityOverrides = {};
                  inlayHints = {
                    callArgumentNames = "all";
                    functionReturnTypes = true;
                    pytestParameters = true;
                    variableTypes = true;
                  };
                };
                languageServer = "Pylance";
              };

              # TailwindCSS settings
              tailwindCSS = {
                experimental.classRegex = [["cva\\(([^)]*)\\)" ''["'`]([^"'`]*).*?["'`]'']];
                classFunctions = ["cva" "cx"];
              };

              # File settings
              files = {
                exclude = {
                  "**/__init__.py" = true;
                  "**/__pycache__" = true;
                };
                autoSave = "afterDelay";
              };

              # Other settings
              window.customTitleBarVisibility = "windowed";

              security.workspace.trust = {
                startupPrompt = "always";
                untrustedFiles = "open";
              };

              explorer.confirmDelete = false;
              diffEditor.ignoreTrimWhitespace = false;

              notebook.output.scrolling = true;

              "database-client.autoSync" = true;

              remote.autoForwardPortsSource = "hybrid";
            };
          };
        };

        zed-editor = {
          enable = true;
          package = pkgs-unstable.zed-editor;
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
              env = {TERM = "ghostty";};
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
                  arguments = [
                    "--function-arg-placeholders=0"
                    "--background-index"
                    "--clang-tidy"
                    "--log=verbose"
                  ];
                };
              };
              nil = {
                initialization_options = {
                  formatting = {command = ["alejandra"];};
                };
              };
            };

            languages = {
              "C++" = {
                show_edit_predictions = false;
                format_on_save = "on";
                tab_size = 2;
              };
              "Python" = {show_edit_predictions = false;};
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
