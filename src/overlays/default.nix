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
}
