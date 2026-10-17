{
  inputs,
  settings,
  ...
}: {
  # --- Custom Packages (pkgs.custom.*) ---
  custom = final: _prev: {
    custom = import ../pkgs {
      pkgs = final;
      inherit settings inputs;
    };
  };

  # --- Package Additions Overlay ---
  additions = import ./additions.nix {inherit inputs;};

  # --- Package Overrides Overlay ---
  overrides = import ./overrides.nix {inherit inputs;};
}
