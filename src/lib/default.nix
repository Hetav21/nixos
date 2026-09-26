# Unified Library Exports
#
# This file exposes all custom lib functions as a single extraLib object.
# Usage: extraLib.modules.mkModule, extraLib.dotfiles.mkSubstitute, etc.
#
# Namespaces:
#   - extraLib.modules   : Module helpers (mkModule, common, desktop, wsl)
#   - extraLib.hosts     : Host & system helpers (mkHostSettings, mkSystem)
#   - extraLib.dotfiles  : Config file helpers (mkSubstitute, mkProcessFile)
#   - extraLib.paths     : Path & Resource helpers (root, dotfile, wallpaper, ...)
{
  lib,
  inputs,
  outputs,
  self ? inputs.self,
}: let
  extraLib = rec {
    modules = import ./modules.nix inputs outputs;
    hosts = import ./hosts.nix {
      inherit
        lib
        self
        inputs
        outputs
        extraLib
        ;
    };
    dotfiles = import ./manage-dotfiles.nix {inherit lib;};
    paths = import ./paths.nix {inherit lib;};
  };
in
  extraLib
