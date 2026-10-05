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

  # --- Alternate Nixpkgs Channels (pkgs.unstable.*, pkgs.master.*) ---
  channels = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      inherit (final) config;
    };
    master = import inputs.nixpkgs-master {
      system = final.stdenv.hostPlatform.system;
      inherit (final) config;
    };
  };

  # --- NUR (Nix User Repository) Overlay (pkgs.nur.*) ---
  nur = inputs.nur.overlays.default;

  # --- LLM Agents Overlay (pkgs.llm-agents.*) ---
  llm-agents = final: _prev: {
    llm-agents = inputs.llm-agents.packages.${final.stdenv.hostPlatform.system};
  };
}
