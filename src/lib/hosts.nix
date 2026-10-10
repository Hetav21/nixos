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

  # Checks whether desktop graphical environment is enabled for a host
  hasDesktop = config: config.profiles.system.desktop.enable or false;

  # Checks whether system is running under WSL
  isWsl = config: config.profiles.system.wsl.enable or false;

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
