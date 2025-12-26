# Minimal WSL system profile (CLI/TUI only, no GUI)
# Includes: core system modules only, all desktop features disabled
{
  lib,
  config,
  ...
}: {
  options.profiles.system.wsl-minimal = {
    enable = lib.mkEnableOption "Minimal WSL profile with CLI/TUI only";
  };

  config = lib.mkIf config.profiles.system.wsl-minimal.enable {
    # Core system (always needed)
    system.nix.settings.enable = true;
    system.nix.ld.enable = true;
    system.locale.enable = true;

    # Enable Stylix for fonts and TUI theming
    system.stylix.enable = true;

    # CLI/TUI tools only (no GUI)
    system.virtualisation.enable = true;
    system.network.enable = true;
    system.storage.enable = true;
    system.baseservices.enable = true;
    system.llm.enable = true;

    # Disable all GUI components
    system.virtualisation.enableGui = false;
    system.network.enableGui = false;
    system.storage.enableGui = false;
    system.media.enable = false;
    system.media.enableGui = false;
    system.productivity.enableGui = false;
    system.communication.enableGui = false;
    system.baseservices.enableGui = false;
    system.llm.enableGui = false;
    system.desktopEnvironment.enableGui = false;

    # Disable base hardware modules (not needed for WSL)
    system.hardware.base.enable = false;

    # Disable desktop sub-modules (not needed for WSL)
    system.desktop.security.enable = false;

    # Disable misc modules (not needed for WSL)
    system.misc.diskDecryption.enable = false;
  };
}
