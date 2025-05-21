{
  description = "Hetav's flake";

  # Flake Inputs
  inputs = {
    stablePkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Flake Outputs
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import inputs.stablePkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # disableGpuWrap = {appName}:
    #   nixpkgs.symlinkJoin {
    #     name = appName;
    #     paths = [nixpkgs.${appName}];
    #     buildInputs = [nixpkgs.makeWrapper];
    #     postBuild = lib.strings.concatStrings [
    #       "wrapProgram $out/bin/"
    #       appName
    #       " --add-flags \"--disable-gpu\""
    #     ];
    #   };

    overlay = final: prev: {
      megacmd = pkgs.megacmd;
      megasync = pkgs.megasync;
      ollama = pkgs.ollama;
      auto-cpufreq = pkgs.auto-cpufreq;
    };
  in {
    nixosConfigurations = {
      nixbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/nixbook/configuration.nix
          inputs.chaotic.nixosModules.default
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.home-manager
          inputs.nix-index-database.nixosModules.nix-index
          {
            nixpkgs = {
              overlays = [
                overlay
              ];
            };
          }
        ];
      };
    };
  };
}
