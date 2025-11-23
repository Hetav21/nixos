# Minimal WSL system profile (CLI/TUI only, no GUI)
# Includes: core system modules only, all desktop features disabled
{
  lib,
  config,
  ...
}:
with lib; {
  options.profiles.system.wsl-minimal = {
    enable = mkEnableOption "Minimal WSL profile with CLI/TUI only";
  };

  config = mkIf config.profiles.system.wsl-minimal.enable {
    # Enable only core system modules for WSL
    system.nix.settings.enable = true;
    system.nix.ld.enable = true;

    # Disable all desktop system modules (not needed for WSL)
    system.desktop.appimage.enable = false;
    system.desktop.environment.enable = false;
    system.desktop.display-manager.enable = false;
    system.desktop.services.enable = false;
    system.desktop.networking.enable = false;
    system.desktop.power-management.enable = false;
    system.desktop.printing.enable = false;
    system.desktop.security.enable = false;
    system.desktop.xdg-config.enable = false;
    system.desktop.virtualisation.enable = false;

    # Disable all desktop application modules
    system.desktop.entertainment.enable = false;
    system.desktop.llm.enable = false;
    system.desktop.network-storage.enable = false;
    system.desktop.network-tools.enable = false;
    system.desktop.office.enable = false;

    # Disable hardware modules (not needed for WSL)
    system.hardware.hardware.enable = false;

    # Disable misc modules (not needed for WSL)
    system.misc.disk-decryption.enable = false;
  };
}

