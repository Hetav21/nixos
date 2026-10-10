{
  extraLib,
  lib,
  pkgs,
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
      oc = "${lib.getExe pkgs.llm-agents.opencode}";
      oc2 = "${lib.getExe pkgs.llm-agents.opencode2}";
      ag = "${lib.getExe pkgs.llm-agents.antigravity-cli}";
      cc = "${lib.getExe pkgs.llm-agents.claude-code}";
      cdx = "${lib.getExe pkgs.llm-agents.codex}";
    };

    # --- Packages & Environment ---
    # Codex and Antigravity stay plain packages: their Home Manager modules would make
    # ~/.codex/config.toml and ~/.gemini/config/mcp_config.json read-only, so agent-mcp merges into them instead
    home.packages = [
      # Wrapped to launch a Nix-built browser, so it never falls back to a downloaded one
      pkgs.llm-agents.agent-browser
      pkgs.llm-agents.antigravity-cli
      pkgs.llm-agents.codex
      pkgs.llm-agents.opencode
      pkgs.llm-agents.opencode2
    ];

    # Enable Claude Code auto mode
    home.sessionVariables = {
      CLAUDE_CODE_ENABLE_AUTO_MODE = "1";
    };

    programs = {
      # --- OpenCode & MCP ---
      opencode = {
        enable = true;
        package = pkgs.llm-agents.opencode;
        settings = lib.importJSON (extraLib.paths.dotfile ".config/opencode/opencode.json");
      };

      # --- Claude Code ---
      claude-code = {
        enable = true;
        package = pkgs.llm-agents.claude-code;
      };

      # --- Shared MCP Servers ---
      # One canonical mcp.json rendered for Claude Code, OpenCode, Codex and Antigravity;
      # projects get the same via `agent-mcp sync`
      agent-mcp = {
        enable = true;
        targets = {
          claude = true;
          opencode = true;
          codex = true;
          antigravity = true;
        };
        file = extraLib.paths.dotfile ".config/mcp/mcp.json";
      };

      # --- Agent Skills ---
      agent-skills = {
        enable = true;
        targets = {
          agents = true;
          claude = true;
          codex = true;
          gemini = true;
        };
        skills = [
          # Anthropic reference skills
          {
            source = pkgs.custom.agent-sources.anthropic-skills;
            includes = [
              "docx"
              "pdf"
              "pptx"
              "xlsx"
            ];
          }

          # Curated agent tools from personal config
          {
            source = pkgs.custom.agent-sources.agent-config;
            includes = [
              "agent-browser"
              "deslop"
              "simplify"
              "workflow"
              "find-skills"
              "reclaude"
            ];
          }

          # Emil Kowalski UI & animation skills (auto-discovered & flattened)
          pkgs.custom.agent-sources.emilkowalski-skills

          # Matt Pocock engineering & productivity skills
          {
            source = pkgs.custom.agent-sources.mattpocock-skills;
            excludes = [
              "deprecated"
              "in-progress"
            ];
          }
        ];
      };
    };

    # --- Activation Hooks ---
    # Fix for opencode-google-antigravity-auth plugin: symlink @opencode-ai/plugin from config to cache
    home.activation.linkOpencodePlugin = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p ~/.cache/opencode/node_modules/@opencode-ai
      $DRY_RUN_CMD ln -sf ~/.config/opencode/node_modules/@opencode-ai/plugin ~/.cache/opencode/node_modules/@opencode-ai/plugin
    '';

    # --- Dotfiles ---
    home.file = lib.mkMerge [
      {
        ".config/opencode/oh-my-opencode-slim.json".source =
          extraLib.paths.dotfile ".config/opencode/oh-my-opencode-slim.json";
        ".config/opencode/antigravity.json".source = extraLib.paths.dotfile ".config/opencode/antigravity.json";
        ".config/opencode/command".source = extraLib.paths.dotfile ".config/opencode/command";
      }
    ];
  };
}
