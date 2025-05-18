{
  inputs,
  pkgs,
  system,
  ...
}: {
  userConfig,
  extraInputs ? {},
  extraPkgs ? null,
}: rec {
  commonArgs = {
    inherit system userConfig;
    inputs = inputs // extraInputs;
    pkgs = pkgs;
    userPkgs = extraPkgs;
  };

  nixosConfiguration = import ../hosts/nixos {inherit commonArgs;};

  inherit userConfig;

  homeConfigurations = {
    "${userConfig.username}" = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules =
        [
          ../hosts/nixos/home.nix
          inputs.nix-index-database.hmModules.nix-index
        ]
        ++ userConfig.homeModules;
      extraSpecialArgs = {
        inherit userConfig;
        inherit inputs;
      };
    };
  };
}
