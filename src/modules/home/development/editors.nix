{
  extraLib,
  lib,
  pkgs,
  pkgs-unstable,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.development.editors";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Standalone GUI Editors ---
    home.packages = [
      pkgs-unstable.antigravity-ide
    ];

    programs = {
      # --- VS Code ---
      vscode = {
        enable = true;
        package = pkgs-unstable.vscode;
      };

      # --- Zed Editor ---
      zed-editor = {
        enable = true;
        package = pkgs-unstable.zed-editor;
        installRemoteServer = true;
        extraPackages = [pkgs.alejandra];
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
        } (lib.importJSON (extraLib.paths.dotfile ".config/zed/settings.json"));
      };
    };
  };
}
