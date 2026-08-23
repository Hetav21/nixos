{
  description = "Hetav's NixOS flake";

  # --- Flake Inputs ---
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?shallow=1&ref=nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs?shallow=1&ref=master";

    stylix = {
      url = "github:danth/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium-flake = {
      url = "gitlab:ntgn/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agent-sources.url = "path:./src/pkgs/agent-sources";
    nix-skills.url = "github:Hetav21/nix-skills";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  # --- Binary Caches ---
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://vicinae.cachix.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-substituters = [
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://vicinae.cachix.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  # --- Flake Outputs ---
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    inherit (nixpkgs) lib;

    extraLib = import ./src/lib {inherit lib inputs outputs;};
    nixpkgsLib = import ./src/lib/nixpkgs.nix inputs;

    # Host settings
    commonSettings = import ./src/config/common.nix;
    nixbookSettings = extraLib.hosts.mkHostSettings commonSettings (import ./src/config/nixbook.nix);
    nixwslbookSettings = extraLib.hosts.mkHostSettings commonSettings (import ./src/config/nixwslbook.nix);
    nixworkbookSettings = extraLib.hosts.mkHostSettings commonSettings (import ./src/config/nixworkbook.nix);

    # Hardware profiles
    hardware_asus = import ./src/config/hardware/asus.nix;
    hardware_wsl = import ./src/config/hardware/wsl.nix;

    # System builder helper
    mkSystem = {
      settings,
      hardware,
      extraModules ? [],
    }:
      lib.nixosSystem {
        system = settings.system;
        specialArgs =
          {
            inherit
              self
              inputs
              outputs
              extraLib
              settings
              hardware
              ;
          }
          // nixpkgsLib.mkChannelsFor settings.system;
        modules =
          [
            ./src/hosts/${settings.hostname}/configuration.nix
          ]
          ++ extraLib.modules.common
          ++ extraModules;
      };
  in {
    lib = extraLib;
    templates = import ./templates;
    overlays = import ./src/overlays {
      inherit inputs;
      settings = commonSettings;
    };

    # --- System Configurations ---
    nixosConfigurations = {
      nixbook = mkSystem {
        settings = nixbookSettings;
        hardware = hardware_asus;
        extraModules = extraLib.modules.desktop;
      };

      nixwslbook = mkSystem {
        settings = nixwslbookSettings;
        hardware = hardware_wsl;
        extraModules = extraLib.modules.wsl;
      };

      nixworkbook = mkSystem {
        settings = nixworkbookSettings;
        hardware = hardware_wsl;
        extraModules = extraLib.modules.wsl;
      };
    };
  };
}
