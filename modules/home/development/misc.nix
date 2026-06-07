{
  extraLib,
  lib,
  pkgs,
  pkgs-unstable,
  inputs,
  settings,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.development.misc";
  hasCli = true;
  hasGui = true;
  cliConfig = _: {
    home.packages =
      (with pkgs; [
        awscli2
        distrobox
        postgresql
      ])
      ++ (with pkgs-unstable; [
        lazygit
        lazydocker
        cursor-cli
      ])
      ++ [
        pkgs-unstable.agent-browser
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.beads
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.ralph-tui
      ];

    home.sessionVariables = {
      AGENT_BROWSER_EXECUTABLE_PATH = lib.getExe pkgs-unstable.chromium;
    };
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
