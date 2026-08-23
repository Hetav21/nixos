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
}
