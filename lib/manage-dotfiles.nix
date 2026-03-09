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

  # modeFile: Select a mode-specific dotfile variant with fallback
  #
  # Given a mode string and a base file path, returns the mode-specific variant
  # if it exists, or falls back to the base path. For "personal" mode (the default),
  # always returns the base path directly (short-circuit, no pathExists check).
  #
  # IMPORTANT: In a git-based flake, variant files MUST be tracked by git
  # (git add) for builtins.pathExists to see them.
  #
  # Naming convention: base = config.json → variant = config.work.json
  #
  # Example:
  #   settings = lib.importJSON (modeFile settings.mode ../../dotfiles/.config/opencode/config.json);
  #   # mode = "personal" → loads config.json
  #   # mode = "work"     → loads config.work.json (if exists), else config.json + warning
  #
  modeFile = mode: basePath: let
    # Convert path to string for manipulation
    baseStr = toString basePath;
    # Extract directory and filename parts
    dir = builtins.dirOf basePath;
    fileName = builtins.baseNameOf baseStr;
    # Split filename into name and extension
    # e.g., "config.json" → name="config", ext=".json"
    parts = lib.splitString "." fileName;
    nameWithoutExt = lib.head parts;
    ext = ".${lib.last parts}";
    # Construct mode-specific path: config.json → config.work.json
    modeVariant = dir + "/${nameWithoutExt}.${mode}${ext}";
  in
    if mode == "personal" then
      basePath
    else if builtins.pathExists modeVariant then
      modeVariant
    else
      lib.warn "dotfiles.modeFile: No ${mode} variant found at ${toString modeVariant}, falling back to ${baseStr}"
      basePath;

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
