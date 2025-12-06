{
  inputs,
  settings,
  ...
}: {
  # Overlay custom derivations into nixpkgs so you can use pkgs.<name>
  additions = final: _prev: {
    custom = import ../pkgs {
      pkgs = final;
      settings = settings;
    };
  };

  # https://wiki.nixos.org/wiki/Overlays
  modifications = final: _prev: let
    nixpkgsConfig = import ../config/nixpkgs-config.nix;
  in {
    nur = inputs.nur.overlays.default;
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config = nixpkgsConfig;
    };
    master = import inputs.nixpkgs-master {
      system = final.stdenv.hostPlatform.system;
      config = nixpkgsConfig;
    };
    kernel = import inputs.nixpkgs-kernel {
      system = final.stdenv.hostPlatform.system;
      config = nixpkgsConfig;
    };
  };
}
