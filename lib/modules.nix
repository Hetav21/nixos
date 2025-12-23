# NixOS Module System
#
# This file provides:
# - Module lists for different host types (common, desktop, wsl)
# - Helper functions for creating modules with consistent patterns
#
# Namespace Organization:
# - system.*     : System-level configuration (packages, services, system settings)
# - home.*       : Home-manager user-level configuration (dotfiles, user packages)
# - drivers.*    : Hardware driver configuration (nvidia, amd, intel, asus)
# - profiles.*   : Pre-configured bundles of modules for different use cases
inputs: outputs: let
  inputsConfig = import ../config/inputs-config.nix {inherit inputs outputs;};
in rec {
  # Module lists imported from config/inputs-config.nix
  inherit (inputsConfig.modules) common desktop wsl;

  # mkModule: Unified helper for creating modules with CLI/GUI enable options
  #
  # This helper generates consistent module boilerplate with configurable options:
  # - CLI only:   mkModule { name = "home.downloads"; cliConfig = args: {...}; }
  # - CLI + GUI:  mkModule { name = "system.network"; hasGui = true; cliConfig = args: {...}; guiConfig = args: {...}; }
  # - GUI only:   mkModule { name = "system.browser"; hasCli = false; hasGui = true; guiConfig = args: {...}; }
  #
  # Parameters:
  #   name           - Option path e.g. "system.network" or "home.development"
  #   hasCli         - (default: true) Create `enable` option for CLI/TUI tools
  #   hasGui         - (default: false) Create `enableGui` option for GUI tools
  #   guiRequiresCli - (default: true) Auto-enable CLI when GUI is enabled
  #   cliConfig      - Function (args: {...}) or attrset for CLI config
  #   guiConfig      - Function (args: {...}) or attrset for GUI config
  #
  # The config functions receive full module args: { lib, pkgs, config, settings, hardware, pkgs-unstable, pkgs-master, ... }
  mkModule = {
    name,
    hasCli ? true,
    hasGui ? false,
    guiRequiresCli ? true,
    cliConfig ? (_: {}),
    guiConfig ? (_: {}),
  }: {
    lib,
    config,
    pkgs ? null,
    settings ? {},
    hardware ? {},
    pkgs-unstable ? pkgs,
    pkgs-master ? pkgs,
    ...
  } @ args: let
    # Parse the option path (e.g., "system.network" -> ["system" "network"])
    pathParts = lib.splitString "." name;
    # Get the config value at the option path
    cfg = lib.getAttrFromPath pathParts config;
    # Resolve configs - support both functions and static attrsets for backward compatibility
    resolvedCliConfig =
      if builtins.isFunction cliConfig
      then cliConfig args
      else cliConfig;
    resolvedGuiConfig =
      if builtins.isFunction guiConfig
      then guiConfig args
      else guiConfig;
  in {
    options = lib.setAttrByPath pathParts (
      {}
      // lib.optionalAttrs hasCli {
        enable = lib.mkEnableOption "Enable CLI/TUI tools for ${name}";
      }
      // lib.optionalAttrs hasGui {
        enableGui = lib.mkEnableOption "Enable GUI tools for ${name}";
      }
    );

    config = lib.mkMerge [
      # CLI/TUI configuration
      (lib.mkIf (hasCli && cfg.enable or false) resolvedCliConfig)

      # GUI configuration
      (lib.mkIf (hasGui && cfg.enableGui or false) (
        lib.mkMerge [
          # Auto-enable CLI when GUI is enabled (only if hasCli is true)
          (lib.optionalAttrs (hasCli && guiRequiresCli) (
            lib.setAttrByPath (pathParts ++ ["enable"]) true
          ))
          resolvedGuiConfig
        ]
      ))
    ];
  };
}
