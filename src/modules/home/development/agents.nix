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
  cliConfig = let
    substitutedMcpServers =
      extraLib.dotfiles.mkSubstitute {
        "@bunxPath@" = lib.getExe' pkgs.bun "bunx";
        "@uvxPath@" = lib.getExe' pkgs.uv "uvx";
      }
      (lib.importJSON (extraLib.paths.dotfile ".config/mcp/mcp.json")).mcpServers;

    claudeMcpServers = {
      mcpServers = inputs.nix-skills.lib.toClaudeMcpServers substitutedMcpServers;
    };

    agyMcpConfig = (pkgs.formats.json {}).generate "agy-mcp-config.json" {
      mcpServers = lib.mapAttrs (name: s:
        if s ? url then {
          serverUrl = s.url;
          disabled = s.disabled or false;
        } // (lib.optionalAttrs (s ? headers) {
          headers = lib.mapAttrs (hName: hVal:
            lib.replaceStrings ["{env:" "}"] ["\${" "}"] hVal
          ) s.headers;
        })
        else {
          command = s.command;
          args = s.args;
          disabled = s.disabled or false;
        }
      ) substitutedMcpServers;
    };

    codexConfig = (pkgs.formats.toml {}).generate "codex-config.toml" {
      projects = {
        "/etc/nixos" = { trust_level = "trusted"; };
        "/home/hetav" = { trust_level = "trusted"; };
      };
      mcp_servers = lib.mapAttrs (name: s:
        if s ? url then {
          url = s.url;
        } // (lib.optionalAttrs (s ? headers && s.headers ? CONTEXT7_API_KEY) {
          bearer_token_env_var = "CONTEXT7_API_KEY";
        })
        else {
          command = s.command;
          args = s.args;
          enabled = !(s.disabled or false);
        }
      ) substitutedMcpServers;
    };
  in {
    # --- Stylix & Aliases ---
    stylix.targets.opencode.enable = false;

    home.shellAliases = {
      oc = "${lib.getExe config.programs.opencode.package}";
      oc2 = "${lib.getExe pkgs.llm-agents.opencode2}";
      ag = "${lib.getExe config.programs.antigravity.package}";
      cc = "${lib.getExe pkgs.llm-agents.claude-code}";
      cdx = "${lib.getExe pkgs.llm-agents.codex}";
    };

    # --- Packages & Environment ---
    home.packages = [
      pkgs.llm-agents.antigravity-cli
      pkgs.llm-agents.claude-code
      pkgs.llm-agents.codex
      pkgs.llm-agents.coderabbit-cli
      pkgs.llm-agents.beads
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
        package = pkgs.llm-agents.opencode;
        enableMcpIntegration = true;
        settings = lib.importJSON (extraLib.paths.dotfile ".config/opencode/opencode.json");
      };

      mcp = {
        enable = true;
        servers = substitutedMcpServers;
      };

      # --- Agent Resources (Skills & Commands) ---
      agent-resources = {
        enable = true;
        targets = {
          agents = true;
          claude = true;
          codex = true;
          gemini = true;
        };
        commands = [
          pkgs.custom.subagent-catalog
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
          (inputs.nix-skills.lib.extract pkgs pkgs.custom.emilkowalski-skills "skills" {})
          (inputs.nix-skills.lib.extract pkgs pkgs.custom.mattpocock-skills "skills/engineering" {})
          (inputs.nix-skills.lib.extract pkgs pkgs.custom.mattpocock-skills "skills/productivity" {})
          (inputs.nix-skills.lib.extract pkgs pkgs.custom.mattpocock-skills "skills/misc" {})
          (inputs.nix-skills.lib.extract pkgs pkgs.custom.mattpocock-skills "skills/personal" {})
        ];
        agents = [
          (inputs.nix-skills.lib.extract pkgs pkgs.custom.agent-config "agents" {})
        ];
        hooks = [];
      };
    };

    # --- Activation Hooks ---
    # Fix for opencode-google-antigravity-auth plugin: symlink @opencode-ai/plugin from config to cache
    home.activation.linkOpencodePlugin = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p ~/.cache/opencode/node_modules/@opencode-ai
      $DRY_RUN_CMD ln -sf ~/.config/opencode/node_modules/@opencode-ai/plugin ~/.cache/opencode/node_modules/@opencode-ai/plugin
    '';

    # --- Dotfiles & Agent MCP Configuration ---
    home.file = lib.mkMerge [
      {
        ".config/opencode/oh-my-opencode-slim.json".source =
          extraLib.paths.dotfile ".config/opencode/oh-my-opencode-slim.json";
        ".config/opencode/antigravity.json".source = extraLib.paths.dotfile ".config/opencode/antigravity.json";
        ".config/opencode/command".source = extraLib.paths.dotfile ".config/opencode/command";
        ".claude/.mcp.json".source = let
          unformatted = builtins.toJSON claudeMcpServers;
        in
          pkgs.runCommand "pretty-claude-dot-mcp.json" {
            buildInputs = [pkgs.jq];
            passAsFile = ["json"];
            json = unformatted;
          } "jq . < $jsonPath > $out";

        # Declarative MCP configs for Antigravity & Codex
        ".gemini/antigravity/mcp_config.json".source = agyMcpConfig;
        ".gemini/antigravity-cli/mcp_config.json".source = agyMcpConfig;
        ".gemini/config/mcp_config.json".source = agyMcpConfig;
        ".codex/config.toml".source = codexConfig;
      }
    ];
  };
}
