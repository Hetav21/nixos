{
  lib,
  pkgs,
  settings,
  extraLib,
  pkgs-unstable,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.development";
  hasGui = true;

  cliConfig = {config, ...}: let
    memoryDir = "${config.home.homeDirectory}/.memory";
    luaPath = ../../dotfiles/.config/nvim;

    nixCatsCategories = {pkgs, ...}: {
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          # Build tools (needed for treesitter compilation, mason, etc.)
          gcc
          gnumake
          unzip
          curl
          wget
          git
          tree-sitter # Required by nvim-treesitter

          # Search tools (used by telescope, etc.)
          ripgrep
          fd

          # System tools for neovim plugins
          lsof # For opencode.nvim
          trash-cli # For snacks.explorer (safe delete)
          wl-clipboard # Clipboard for Wayland (desktop); WSL uses clip.exe via init.lua

          # Node/Python for LSP hosts and mason
          nodejs
          nodePackages.neovim # Node provider
          (python3.withPackages (ps: [ps.pynvim])) # Python provider

          # Nix LSP (not managed by Mason)
          nil

          # Image tools (CLI) - used by snacks.image
          imagemagick
          ghostscript
          mermaid-cli
          tectonic
        ];
      };

      # No plugins - lazy.nvim will manage them
      startupPlugins = {};
      optionalPlugins = {};
      sharedLibraries = {
        general = with pkgs; [
          # For snacks.picker frecency/history
          sqlite
        ];
      };
      environmentVariables = {
        general = {
          # Fix: Warning: Missing "neovim" npm package
          # Explicitly point to the neovim-node-host binary provided by nodePackages.neovim
          NEOVIM_NODE_HOST = "${lib.getExe pkgs.nodePackages.neovim}";
        };
      };
      extraWrapperArgs = {
        # General wrapper args
        general = [
          # Fix sqlite library path for LuaJIT to find it
          "--set"
          "LIBSQLITE"
          "${pkgs.sqlite.out}/lib/libsqlite3.so"
        ];
      };
    };

    nixCatsSettings = {...}: {
      settings = {
        suffix-path = true;
        suffix-LD = true;
        wrapRc = true;
        aliases = [
          "vi"
          "vim"
          "nvim"
        ];
      };
      categories = {
        general = true;
      };
      extra = {};
    };
  in {
    stylix.targets.opencode.enable = false;

    home.packages =
      (with pkgs; [
        awscli2
        distrobox
      ])
      ++ (with pkgs-unstable; [
        lazygit
        lazydocker
        cursor-cli
      ]);

    services.ssh-agent.enable = true;

    # nixCats Neovim configuration
    # Nix handles: neovim installation + config bundling + essential build tools
    # Lua handles: plugin management (lazy.nvim) + LSP installation (mason.nvim)
    nixCats = {
      enable = true;
      packageNames = ["nixCats"];
      luaPath = "${luaPath}";

      categoryDefinitions.replace = nixCatsCategories;

      packageDefinitions.replace = {
        nixCats = nixCatsSettings;
      };
    };

    programs = {
      ssh = {
        enable = true;
        enableDefaultConfig = false;
        # Note: github.com-personal/work aliases removed - Git now uses
        # directory-based SSH key selection via core.sshCommand in git includes
        matchBlocks."*" = {
          forwardAgent = false;
          addKeysToAgent = "yes";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "auto";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "10m";
        };
      };

      git = {
        enable = true;
        package = pkgs-unstable.gitFull;
        lfs.enable = true;
        lfs.package = pkgs-unstable.git-lfs;
        includes =
          [
            # Base config (always included)
            {path = "${../../dotfiles/.config/git/config}";}
            # Default: use personal SSH key for all repos
            {
              contents.core.sshCommand = "ssh -i ${settings.ssh.personal.identityFile} -o IdentitiesOnly=yes";
            }
          ]
          # Work directory: use work SSH key (only if work identity is configured)
          ++ lib.optionals (settings.ssh.work.identityFile != "") [
            {
              condition = "gitdir:~/work/";
              contents.core.sshCommand = "ssh -i ${settings.ssh.work.identityFile} -o IdentitiesOnly=yes";
            }
          ];
      };

      jujutsu = {
        enable = true;
        package = pkgs-unstable.jujutsu;
      };

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

      opencode = {
        enable = true;
        package = pkgs-unstable.opencode;
        enableMcpIntegration = true;
        settings =
          lib.importJSON ../../dotfiles/.config/opencode/config.json;
      };

      mcp = {
        enable = true;
        servers =
          extraLib.dotfiles.mkSubstitute {
            "@bunxPath@" = lib.getExe' pkgs.bun "bunx";
            "@uvxPath@" = lib.getExe' pkgs.uv "uvx";
            "@memoryDir@" = memoryDir;
          }
          (lib.importJSON ../../dotfiles/.config/mcp/mcp.json).mcpServers;
      };
    };

    # Fix for opencode-google-antigravity-auth plugin: symlink @opencode-ai/plugin from config to cache
    home.activation.linkOpencodePlugin = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p ~/.cache/opencode/node_modules/@opencode-ai
      $DRY_RUN_CMD ln -sf ~/.config/opencode/node_modules/@opencode-ai/plugin ~/.cache/opencode/node_modules/@opencode-ai/plugin
    '';

    # oh-my-opencode plugin configuration
    home.file.".config/opencode/oh-my-opencode.json".source =
      ../../dotfiles/.config/opencode/oh-my-opencode.json;

    # opencode commands
    home.file.".config/opencode/command".source =
      ../../dotfiles/.config/opencode/command;

    # Superpowers plugin for OpenCode (activation script for mutable copy)
    # Source: https://github.com/obra/superpowers
    # Uses activation script to copy to mutable location (required for npm module resolution)
    # The plugin imports @opencode-ai/plugin which must be resolved from ~/.config/opencode/node_modules
    home.activation.setupSuperpowers = lib.hm.dag.entryAfter ["writeBoundary"] ''
      SUPERPOWERS_SRC="${pkgs.custom.superpowers}"
      SUPERPOWERS_DST="$HOME/.config/opencode/superpowers"
      PLUGIN_DIR="$HOME/.config/opencode/plugin"

      # Clean up any existing version (symlink or directory)
      $DRY_RUN_CMD rm -rf "$SUPERPOWERS_DST"

      # Copy superpowers to mutable location (allows npm module resolution to work)
      $DRY_RUN_CMD cp -r "$SUPERPOWERS_SRC" "$SUPERPOWERS_DST"
      $DRY_RUN_CMD chmod -R u+w "$SUPERPOWERS_DST"

      # Create plugin symlink pointing to the mutable copy
      $DRY_RUN_CMD mkdir -p "$PLUGIN_DIR"
      $DRY_RUN_CMD ln -sf "$SUPERPOWERS_DST/.opencode/plugin/superpowers.js" "$PLUGIN_DIR/superpowers.js"
    '';

    # Claude Code subagents (125+ specialized AI agents)
    # Source: https://github.com/VoltAgent/awesome-claude-code-subagents
    home.file.".claude/agents".source = pkgs.custom.claude-subagents;
  };

  guiConfig = _: {
    home.packages =
      (with pkgs; [
        mongodb-compass
        hoppscotch
        bruno
      ])
      ++ (with pkgs-unstable; [
        code-cursor
        antigravity
      ]);

    programs = {
      vscode = {
        enable = true;
        package = pkgs-unstable.vscode;
        profiles.${settings.username} = {
          extensions = with pkgs-unstable.vscode-extensions; [vscodevim.vim];
          userSettings = lib.importJSON ../../dotfiles/.config/Code/User/settings.json;
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
        userSettings = extraLib.dotfiles.mkSubstitute {
          "@nodePath@" = lib.getExe pkgs.nodejs;
          "@npmPath@" = lib.getExe' pkgs.nodejs "npm";
          "@clangdPath@" = lib.getExe' pkgs.clang-tools "clangd";
        } (lib.importJSON ../../dotfiles/.config/zed/settings.json);
      };
    };
  };
})
args
