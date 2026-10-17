{inputs, ...}: final: prev: let
  system = prev.stdenv.hostPlatform.system;
  unstable = import inputs.nixpkgs-unstable {
    inherit system;
    inherit (final) config;
  };
  llmAgents = inputs.llm-agents.packages.${system};
  t3code = inputs.t3code.packages.${system};
in {
  # --- User-selected Unstable Overrides ---
  inherit
    (unstable)
    atuin
    bat
    brave
    carapace
    direnv
    google-chrome
    lact
    nix-direnv
    nix-your-shell
    vscode
    yazi
    zed-editor
    zoxide
    ;

  # --- LLM Agents & AI Tool Overrides ---
  inherit
    (llmAgents)
    agent-browser
    antigravity-cli
    claude-code
    coderabbit-cli
    codex
    opencode
    opencode2
    ;

  # --- T3 Code Desktop Override ---
  inherit
    (t3code)
    t3code
    ;
}
