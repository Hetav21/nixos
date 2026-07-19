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
  name = "home.development.agents";
  hasCli = true;
  hasGui = false;
  cliConfig = _: {
    stylix.targets.opencode.enable = false;

    home.packages = [
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.beads
      pkgs-unstable.agent-browser
    ];

    # Enable Claude Code auto mode (Bedrock, Vertex, Foundry Opus 4.7/4.8 sessions)
    home.sessionVariables = {
      CLAUDE_CODE_ENABLE_AUTO_MODE = "1";
      AGENT_BROWSER_EXECUTABLE_PATH = lib.getExe pkgs-unstable.chromium;
    };

    programs = {
      opencode = {
        enable = true;
        package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
        enableMcpIntegration = true;
        settings = lib.importJSON ../../../dotfiles/.config/opencode/config.json;
      };

      mcp = {
        enable = true;
        servers =
          extraLib.dotfiles.mkSubstitute {
            "@bunxPath@" = lib.getExe' pkgs.bun "bunx";
            "@uvxPath@" = lib.getExe' pkgs.uv "uvx";
          }
          (lib.importJSON ../../../dotfiles/.config/mcp/mcp.json).mcpServers;
      };

      agent-resources = {
        enable = true;
        commands = [
          pkgs.custom.subagent-catalog
          (inputs.nix-skills.lib.extract pkgs pkgs.custom.superpowers "commands" {})
        ];
        skills = [
          (inputs.nix-skills.lib.extract pkgs pkgs.custom.anthropic-skills "skills" {
            includes = [
              "docx"
              "pdf"
              "pptx"
              "xlsx"
            ];
          })
          (inputs.nix-skills.lib.extract pkgs pkgs.custom.agent-config "skills" {
            includes = [
              "agent-browser"
              "deslop"
              "simplify"
              "workflow"
              "find-skills"
              "reclaude"
            ];
          })
          (inputs.nix-skills.lib.extract pkgs pkgs.custom.superpowers "skills" {})
          (inputs.nix-skills.lib.extract pkgs pkgs.custom.mattpocock-skills "skills/engineering" {
            includes = [
              "resolving-merge-conflicts"
              "wayfinder"
              "triage"
              "domain-modeling"
              "codebase-design"
              "improve-codebase-architecture"
              "research"
              "prototype"
            ];
          })
        ];
        agents = [
          (inputs.nix-skills.lib.extract pkgs pkgs.custom.agent-config "agents" {})
          (inputs.nix-skills.lib.extract pkgs pkgs.custom.superpowers "agents" {})
        ];
        hooks = [
          (inputs.nix-skills.lib.extract pkgs pkgs.custom.superpowers "hooks" {})
        ];
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
        ".config/opencode/oh-my-opencode-slim.json".source =
          ../../../dotfiles/.config/opencode/oh-my-opencode-slim.json;
        ".config/opencode/antigravity.json".source =
          ../../../dotfiles/.config/opencode/antigravity.json;
        ".config/opencode/command".source =
          ../../../dotfiles/.config/opencode/command;
        ".claude/settings.json".source =
          ../../../dotfiles/.claude/settings.json;
        ".claude/.mcp.json".source = let
          claudeMcpServers = {
            mcpServers = inputs.nix-skills.lib.toClaudeMcpServers (
              extraLib.dotfiles.mkSubstitute {
                "@bunxPath@" = lib.getExe' pkgs.bun "bunx";
                "@uvxPath@" = lib.getExe' pkgs.uv "uvx";
              }
              (lib.importJSON ../../../dotfiles/.config/mcp/mcp.json).mcpServers
            );
          };

          unformatted = builtins.toJSON claudeMcpServers;
        in
          pkgs.runCommand "pretty-claude-dot-mcp.json" {
            buildInputs = [pkgs.jq];
            passAsFile = ["json"];
            json = unformatted;
          } "jq . < $jsonPath > $out";
      }
    ];
  };
})
args
