{
  description = "Hetav's flake";

  # Flake Inputs
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?shallow=1&ref=nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs?shallow=1&ref=master";

    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nixpkgs-kernel.url = "github:nixos/nixpkgs?shallow=1&ref=nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    hyprland.url = "github:hyprwm/Hyprland";
    vicinae.url = "github:vicinaehq/vicinae";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Passing extra nix config
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://vicinae.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-substituters = [
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://vicinae.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  # Flake Outputs
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    inherit (nixpkgs) lib;

    # Import library helpers
    hostLib = import ./lib/hosts.nix {inherit lib;};
    moduleLib = import ./lib/modules.nix inputs outputs;

    # Import modular configurations using mkHostSettings
    commonSettings = import ./config/common.nix;
    nixbookSettings = hostLib.mkHostSettings commonSettings (import ./config/nixbook.nix);
    nixwslbookSettings = hostLib.mkHostSettings commonSettings (import ./config/nixwslbook.nix);

    # Import hardware configurations
    hardware_asus = import ./config/hardware/asus.nix;
    hardware_wsl = import ./config/hardware/wsl.nix;
  in {
    templates = import ./templates;
    overlays = import ./overlays {
      inherit inputs;
      settings = commonSettings;
    };
    nixosConfigurations = {
      nixbook = nixpkgs.lib.nixosSystem {
        system = nixbookSettings.system;
        specialArgs = {
          inherit self inputs outputs;
          settings = nixbookSettings;
          hardware = hardware_asus;
        };
        modules =
          [./hosts/nixbook/configuration.nix]
          ++ moduleLib.common
          ++ moduleLib.desktop;
      };

      nixwslbook = nixpkgs.lib.nixosSystem {
        system = nixwslbookSettings.system;
        specialArgs = {
          inherit self inputs outputs;
          settings = nixwslbookSettings;
          hardware = hardware_wsl;
        };
        modules =
          [./hosts/nixwslbook/configuration.nix]
          ++ moduleLib.common
          ++ moduleLib.wsl;
      };
    };
  };
}
