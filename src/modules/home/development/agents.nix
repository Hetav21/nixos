{
  extraLib,
  lib,
  pkgs,
  inputs,
  config,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.development.agents";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    # --- Stylix & Aliases ---
    stylix.targets.opencode.enable = false;

    home.shellAliases = {
      oc = "${lib.getExe config.programs.opencode.package}";
      oc2 = "${lib.getExe inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode2}";
      ag = "${lib.getExe config.programs.antigravity.package}";
      cc = "${lib.getExe inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code}";
      cdx = "${lib.getExe inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex}";
    };

    # --- Packages & Environment ---
    home.packages = [
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.beads
      pkgs.unstable.agent-browser
    ];

    # Enable Claude Code auto mode (Bedrock, Vertex, Foundry Opus 4.7/4.8 sessions)
    home.sessionVariables = {
      CLAUDE_CODE_ENABLE_AUTO_MODE = "1";
      AGENT_BROWSER_EXECUTABLE_PATH = lib.getExe pkgs.unstable.chromium;
    };

    programs = {
      # --- OpenCode & MCP ---
      opencode = {
        enable = true;
        package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
        enableMcpIntegration = true;
        settings = lib.importJSON (extraLib.paths.dotfile ".config/opencode/config.json");
      };

      mcp = {
        enable = true;
        servers =
          extraLib.dotfiles.mkSubstitute {
            "@bunxPath@" = lib.getExe' pkgs.bun "bunx";
            "@uvxPath@" = lib.getExe' pkgs.uv "uvx";
          }
          (lib.importJSON (extraLib.paths.dotfile ".config/mcp/mcp.json")).mcpServers;
      };

      # --- Agent Resources (Skills & Commands) ---
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

    # --- Activation Hooks ---
    # Fix for opencode-google-antigravity-auth plugin: symlink @opencode-ai/plugin from config to cache
    home.activation.linkOpencodePlugin = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p ~/.cache/opencode/node_modules/@opencode-ai
      $DRY_RUN_CMD ln -sf ~/.config/opencode/node_modules/@opencode-ai/plugin ~/.cache/opencode/node_modules/@opencode-ai/plugin
    '';

    # --- Dotfiles & Claude Configuration ---
    home.file = lib.mkMerge [
      {
        ".config/opencode/oh-my-opencode-slim.json".source =
          extraLib.paths.dotfile ".config/opencode/oh-my-opencode-slim.json";
        ".config/opencode/antigravity.json".source = extraLib.paths.dotfile ".config/opencode/antigravity.json";
        ".config/opencode/command".source = extraLib.paths.dotfile ".config/opencode/command";
        ".claude/settings.json".source = extraLib.paths.dotfile ".claude/settings.json";
        ".claude/plugins/known_marketplaces.json".source =
          extraLib.paths.dotfile ".claude/plugins/known_marketplaces.json";
        ".claude/.mcp.json".source = let
          claudeMcpServers = {
            mcpServers = inputs.nix-skills.lib.toClaudeMcpServers (
              extraLib.dotfiles.mkSubstitute {
                "@bunxPath@" = lib.getExe' pkgs.bun "bunx";
                "@uvxPath@" = lib.getExe' pkgs.uv "uvx";
              }
              (lib.importJSON (extraLib.paths.dotfile ".config/mcp/mcp.json")).mcpServers
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
}
