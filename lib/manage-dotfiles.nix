# Dotfile/Config Processing Helpers
#
# This file provides:
# - mkSubstitute: Eval-time @placeholder@ substitution in JSON/attrsets
# - mkProcessFile: Build-time @placeholder@ substitution in text files
#
# Usage:
#   mkSubstitute { "@path@" = "/nix/store/..."; } jsonAttrset
#   mkProcessFile pkgs { "@color@" = "#ff0000"; } ./template.qml
{lib, ...}: rec {
  # mkSubstitute: Recursively substitute @placeholder@ patterns in Nix attrsets
  #
  # Use for JSON configs read with lib.importJSON that need path/value substitution.
  # Runs at eval-time, so result becomes a Nix attrset for programs.*.settings.
  #
  # Example:
  #   settings = mkSubstitute {
  #     "@bunxPath@" = lib.getExe' pkgs.bun "bunx";
  #     "@configDir@" = "/home/user/.config";
  #   } (lib.importJSON ./config.json);
  #
  mkSubstitute = replacements: let
    keys = builtins.attrNames replacements;
    vals = builtins.attrValues replacements;
    substituteStr = s:
      if builtins.isString s
      then builtins.replaceStrings keys vals s
      else s;
    process = v:
      if builtins.isAttrs v
      then lib.mapAttrs (_: process) v
      else if builtins.isList v
      then map process v
      else substituteStr v;
  in
    process;

  # mkProcessFile: Substitute @placeholder@ patterns in text files at build-time
  #
  # Use for raw config files (QML, INI, etc.) that need variable substitution.
  # Returns a derivation (store path) for use with home.file.*.source.
  #
  # Example:
  #   source = mkProcessFile pkgs {
  #     "@baseColor@" = "#1e1e2e";
  #     "@fontFamily@" = "JetBrains Mono";
  #   } ./template.qml;
  #
  mkProcessFile = pkgs: replacements: file:
    pkgs.replaceVars file replacements;
}
