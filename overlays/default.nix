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

  # --- NUR (Nix User Repository) Overlay ---
  nur = inputs.nur.overlays.default;
}
