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
  # - CLI only:   mkModule { name = "home.downloads"; cliConfig = {...}; }
  # - CLI + GUI:  mkModule { name = "system.network"; hasGui = true; cliConfig = {...}; guiConfig = {...}; }
  # - GUI only:   mkModule { name = "system.browser"; hasCli = false; hasGui = true; guiConfig = {...}; }
  #
  # Parameters:
  #   name           - Option path e.g. "system.network" or "home.development"
  #   hasCli         - (default: true) Create `enable` option for CLI/TUI tools
  #   hasGui         - (default: false) Create `enableGui` option for GUI tools
  #   guiRequiresCli - (default: true) Auto-enable CLI when GUI is enabled
  #   cliConfig      - Config to apply when CLI enabled (required if hasCli)
  #   guiConfig      - Config to apply when GUI enabled (required if hasGui)
  #
  # Note: This helper is exposed via specialArgs as `moduleHelpers.mkModule`
  # for use within module files.
  mkModule = {
    name,
    hasCli ? true,
    hasGui ? false,
    guiRequiresCli ? true,
    cliConfig ? {},
    guiConfig ? {},
  }: {
    lib,
    config,
    ...
  }:
    with lib; let
      # Parse the option path (e.g., "system.network" -> ["system" "network"])
      pathParts = lib.splitString "." name;
      # Get the config value at the option path
      cfg = lib.getAttrFromPath pathParts config;
    in {
      options = lib.setAttrByPath pathParts (
        {}
        // lib.optionalAttrs hasCli {
          enable = mkEnableOption "Enable CLI/TUI tools for ${name}";
        }
        // lib.optionalAttrs hasGui {
          enableGui = mkEnableOption "Enable GUI tools for ${name}";
        }
      );

      config = mkMerge [
        # CLI/TUI configuration
        (mkIf (hasCli && cfg.enable or false) cliConfig)

        # GUI configuration
        (mkIf (hasGui && cfg.enableGui or false) (
          mkMerge [
            # Auto-enable CLI when GUI is enabled (if configured)
            (mkIf (hasCli && guiRequiresCli) (
              lib.setAttrByPath (pathParts ++ ["enable"]) true
            ))
            guiConfig
          ]
        ))
      ];
    };
}
