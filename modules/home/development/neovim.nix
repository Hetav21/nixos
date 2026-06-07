{
  extraLib,
  lib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.development.neovim";
  hasCli = true;
  hasGui = false;
  cliConfig = _: let
    luaPath = ../../../dotfiles/.config/nvim;

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
          neovim-node-client # Node provider
          (python3.withPackages (ps: [ps.pynvim])) # Python provider
          # Python
          basedpyright
          ruff
          black

          # C/C++
          clang-tools
          lldb

          # Go
          go
          gopls
          delve

          # TypeScript/JavaScript
          typescript-language-server
          prettier
          eslint_d

          # Version Control
          jujutsu

          # Nix LSP (not managed by Mason) and formatters
          nil
          nixfmt
          ast-grep

          # Image tools (CLI) - used by snacks.image
          imagemagick
          ghostscript
          mermaid-cli
          tectonic
          postgresql
        ];
      };

      # No plugins - lazy.nvim will manage them
      startupPlugins = {};
      optionalPlugins = {};

      extraLuaPackages = {
        general = luaPkgs:
          with luaPkgs; [
            xml2lua
            mimetypes
          ];
      };

      sharedLibraries = {
        general = with pkgs; [
          # For snacks.picker frecency/history
          sqlite
        ];
      };
      environmentVariables = {
        general = {
          # Fix: Warning: Missing "neovim" npm package
          # Explicitly point to the neovim-node-host binary provided by neovim-node-client
          NEOVIM_NODE_HOST = "${lib.getExe pkgs.neovim-node-client}";
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
  };
})
args
