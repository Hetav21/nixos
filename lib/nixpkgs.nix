# Nixpkgs channel helpers
#
# Provides utilities for importing and managing multiple nixpkgs channels
# with consistent configuration across all of them.
inputs: let
  # Centralized nixpkgs config from inputs-config.nix
  nixpkgsConfig =
    (import ../config/inputs-config.nix {
      inherit inputs;
      outputs = {};
    }).nixpkgs;
in {
  # mkPkgsFor: Import a nixpkgs source with shared configuration
  #
  # Usage:
  #   mkPkgsFor "x86_64-linux" inputs.nixpkgs-unstable
  #
  # Returns a pkgs set with the centralized nixpkgs config applied
  mkPkgsFor = system: nixpkgsSrc:
    import nixpkgsSrc {
      inherit system;
      config = nixpkgsConfig;
    };

  # mkChannelsFor: Create all alternate channel pkgs for a given system
  #
  # Usage:
  #   specialArgs = { ... } // nixpkgsLib.mkChannelsFor "x86_64-linux";
  #
  # Returns:
  #   { pkgs-unstable, pkgs-master }
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
