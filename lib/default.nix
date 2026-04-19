# Unified Library Exports
#
# This file exposes all custom lib functions as a single extraLib object.
# Usage: extraLib.modules.mkModule, extraLib.dotfiles.mkSubstitute, etc.
#
# Namespaces:
#   - extraLib.modules   : Module helpers (mkModule, common, desktop, wsl)
#   - extraLib.hosts     : Host settings helpers (mkHostSettings)
#   - extraLib.dotfiles  : Config file helpers (mkSubstitute, mkProcessFile)
{
  lib,
  inputs,
  outputs,
}: {
  modules = import ./modules.nix inputs outputs;
  hosts = import ./hosts.nix {inherit lib;};
  dotfiles = import ./manage-dotfiles.nix {inherit lib;};
}
