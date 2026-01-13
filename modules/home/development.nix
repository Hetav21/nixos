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
          }
          (lib.importJSON ../../dotfiles/.config/mcp/mcp.json).mcpServers;
      };
    };

    # Fix for opencode-google-antigravity-auth plugin: symlink @opencode-ai/plugin from config to cache
    home.activation.linkOpencodePlugin = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p ~/.cache/opencode/node_modules/@opencode-ai
      $DRY_RUN_CMD ln -sf ~/.config/opencode/node_modules/@opencode-ai/plugin ~/.cache/opencode/node_modules/@opencode-ai/plugin
    '';

    # oh-my-opencode plugin configuration and Claude resources
    home.file = lib.mkMerge [
      {
        ".config/opencode/oh-my-opencode.json".source =
          ../../dotfiles/.config/opencode/oh-my-opencode.json;
        ".config/opencode/antigravity.json".source =
          ../../dotfiles/.config/opencode/antigravity.json;
        ".config/opencode/command".source =
          ../../dotfiles/.config/opencode/command;
      }

      # Claude Configuration (Oh My OpenCode structure)
      (extraLib.claude.mkEnvironment pkgs {
        commands = [
          (extraLib.claude.extract pkgs pkgs.custom.superpowers "commands")
        ];
        skills = [
          pkgs.custom.claude-skills
          (extraLib.claude.extract pkgs pkgs.custom.superpowers "skills")
        ];
        agents = [
          pkgs.custom.claude-subagents
          (extraLib.claude.extract pkgs pkgs.custom.superpowers "agents")
        ];
        hooks = [
          (extraLib.claude.extract pkgs pkgs.custom.superpowers "hooks")
        ];
      })
    ];
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
