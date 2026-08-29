{
  pkgs,
  inputs ? {},
  ...
}: {
  # --- Standalone Tools ---
  gitignore = pkgs.callPackage ./gitignore {};

  # --- Agent & AI Resources ---
  subagent-catalog = pkgs.callPackage ./subagent-catalog {
    claude-subagents-src = inputs.agent-sources.claude-subagents or null;
  };
  superpowers = pkgs.callPackage ./superpowers {
    superpowers-src = inputs.agent-sources.superpowers or null;
  };
  anthropic-skills = pkgs.callPackage ./anthropic-skills {
    anthropic-skills-src = inputs.agent-sources.anthropic-skills or null;
  };
  mattpocock-skills = pkgs.callPackage ./mattpocock-skills {
    mattpocock-skills-src = inputs.agent-sources.mattpocock-skills or null;
  };
  agent-config = pkgs.callPackage ./agent-config {
    agent-config-src = inputs.agent-sources.agent-config or null;
  };

  # --- System & Editor Integrations ---
  wsl-notify-send = pkgs.callPackage ./wsl-notify-send {};
  antigravity-wsl-shim = pkgs.callPackage ./antigravity-wsl-shim {};
  direnv-nvim = pkgs.callPackage ./direnv-nvim {};
}
