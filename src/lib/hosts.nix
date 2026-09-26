# Host Settings and System Helpers
{
  lib,
  self,
  inputs,
  outputs,
  extraLib,
}: {
  # Merges common settings with host overrides
  mkHostSettings = common: overrides: lib.recursiveUpdate common overrides;

  # Builds a NixOS system configuration for a host
  mkSystem = {
    settings,
    extraModules ? [],
  }:
    lib.nixosSystem {
      inherit (settings) system;
      specialArgs = {
        inherit
          self
          inputs
          outputs
          extraLib
          settings
          ;
      };
      modules =
        [
          ../core/system.nix
          ../hosts/${settings.hostname}/configuration.nix
        ]
        ++ extraLib.modules.common
        ++ extraModules;
    };
}
