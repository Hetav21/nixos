{
  inputs,
  settings,
  ...
}: {
  # --- Custom Packages Overlay (pkgs.custom.*) ---
  additions = final: _prev: {
    custom = import ../pkgs {
      pkgs = final;
      inherit settings inputs;
    };
  };

  # --- Package Overrides Overlay ---
  overrides = import ./overrides.nix {inherit inputs;};

  # --- NUR (Nix User Repository) Overlay (pkgs.nur.*) ---
  nur = inputs.nur.overlays.default;

  # --- LLM Agents Overlay (pkgs.llm-agents.*) ---
  llm-agents = final: _prev: {
    llm-agents = inputs.llm-agents.packages.${final.stdenv.hostPlatform.system};
  };
}
