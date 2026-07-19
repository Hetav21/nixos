{
  extraLib,
  lib,
  pkgs,
  pkgs-unstable,
  settings,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.development.editors";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    home.packages = with pkgs-unstable; [
      antigravity
    ];

    programs = {
      vscode = {
        enable = true;
        package = pkgs-unstable.vscode;
        profiles.${settings.username} = {
          extensions = with pkgs-unstable.vscode-extensions; [vscodevim.vim];
          userSettings = lib.importJSON ../../../dotfiles/.config/Code/User/settings.json;
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
        } (lib.importJSON ../../../dotfiles/.config/zed/settings.json);
      };
    };
  };
})
args
