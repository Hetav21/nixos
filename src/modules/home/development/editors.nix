{
  extraLib,
  lib,
  pkgs,
  inputs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.development.editors";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Standalone GUI Editors ---
    home.packages = [
      # pkgs.unstable.antigravity-ide # AI-assisted coding environment / IDE
      pkgs.nur.repos.hetav21.px0
      inputs.t3code.packages.${pkgs.stdenv.hostPlatform.system}.t3code-nightly
    ];

    home.shellAliases = {
      t3code = "SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt t3code-desktop";
    };

    programs = {
      # --- VS Code ---
      vscode = {
        enable = true;
        package = pkgs.unstable.vscode;
      };

      # --- Zed Editor ---
      zed-editor = {
        enable = true;
        package = pkgs.unstable.zed-editor;
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
