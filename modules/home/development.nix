{
  extraLib,
  lib,
  pkgs,
  pkgs-unstable,
  settings,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.development";
  hasGui = true;

  cliConfig = _: let
    memoryDir = "/home/${settings.username}/.memory";
  in {
    home.packages =
      (with pkgs; [awscli2 distrobox])
      ++ (with pkgs-unstable; [lazygit lazydocker cursor-cli]);

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
        lfs.enable = true;
        lfs.package = pkgs-unstable.git-lfs;
        includes = [{path = "${../../dotfiles/.config/git/config}";}];
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
        settings = lib.importJSON ../../dotfiles/.config/opencode/config.json;
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
  };

  guiConfig = _: {
    home.packages =
      (with pkgs; [mongodb-compass])
      ++ (with pkgs-unstable; [code-cursor antigravity hoppscotch bruno]);

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
