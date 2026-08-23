# Nixpkgs Channel Helpers
inputs: let
  nixpkgsConfig =
    (import ../config/inputs.nix {
      inherit inputs;
      outputs = {};
    }).nixpkgs;
in {
  # --- Package Set Factory ---
  mkPkgsFor = system: nixpkgsSrc:
    import nixpkgsSrc {
      inherit system;
      config = nixpkgsConfig;
    };

  # --- Alternate Channels Factory ---
  mkChannelsFor = system: {
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config = nixpkgsConfig;
    };
    pkgs-master = import inputs.nixpkgs-master {
      inherit system;
      config = nixpkgsConfig;
    };
  };
}
