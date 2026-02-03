---
name: nixos
description: Use when writing NixOS configurations, modules, or flakes. Includes CLI commands, flake structure, and module syntax.
---

# NixOS Configuration Reference

## Overview
Reference for NixOS system configuration, Flake architecture, and Module syntax.

## 1. Essential CLI Commands

| Context | Command | Description |
| :--- | :--- | :--- |
| **Rebuild** | `nixos-rebuild switch --flake .#<host>` | Build and activate configuration |
| **Test** | `nixos-rebuild test --flake .#<host>` | Build and activate without boot entry |
| **Update** | `nix flake update` | Update all flake inputs |
| **Lock** | `nix flake lock --update-input <name>` | Update specific input |
| **GC** | `nix-collect-garbage -d` | Remove old generations |
| **Repl** | `nix repl` | Interactive Nix shell (load flake with `:lf .`) |
| **Check** | `nix flake check` | Check flake outputs for errors |

## 2. Flake Structure (`flake.nix`)

```nix
{
  description = "System Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    # Other inputs
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.my-host = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; }; # Pass inputs to modules
      modules = [ ./hosts/my-host/configuration.nix ];
    };
  };
}
```

## 3. Module Syntax

Standard structure for any NixOS module file.

```nix
{ config, pkgs, lib, ... }: 

with lib; # Brings mkIf, mkOption, types into scope

let
  cfg = config.services.my-service;
in {
  # 1. INTERFACE (Define Options)
  options.services.my-service = {
    enable = mkEnableOption "My Service";
    
    port = mkOption {
      type = types.port;
      default = 8080;
      description = "Port to listen on.";
    };
    
    package = mkOption {
      type = types.package;
      default = pkgs.hello;
      description = "Package to use.";
    };
  };

  # 2. IMPLEMENTATION (Apply Config)
  config = mkIf cfg.enable {
    # Systemd Service
    systemd.services.my-service = {
      description = "My Custom Service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/hello --port ${toString cfg.port}";
        Restart = "always";
      };
    };

    # Install Package
    environment.systemPackages = [ cfg.package ];
    
    # Open Firewall
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
```

## 4. Common Module Patterns

### Importing Modules
```nix
imports = [
  ./hardware-configuration.nix
  ../../modules/system/desktop
];
```

### NixOS Library Helpers
- `lib.mkIf condition config`: Apply config only if condition is true.
- `lib.mkMerge [ ... ]`: Merge multiple config definitions.
- `lib.mkForce value`: Force a value, overriding lower priorities.
- `lib.mkDefault value`: Set a default value (lowest priority).
