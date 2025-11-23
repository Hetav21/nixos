# Full desktop system profile with all features enabled
# Includes: all system modules, desktop environment, applications, hardware support
{
  lib,
  config,
  ...
}:
with lib; {
  options.profiles.system.desktop-full = {
    enable = mkEnableOption "Full desktop profile with all features";
  };

  config = mkIf config.profiles.system.desktop-full.enable {
    # Enable all system modules
    system.nix.settings.enable = true;
    system.nix.ld.enable = true;

    # Enable all desktop system modules
    system.desktop.appimage.enable = true;
    system.desktop.environment.enable = true;
    system.desktop.display-manager.enable = true;
    system.desktop.services.enable = true;
    system.desktop.networking.enable = true;
    system.desktop.power-management.enable = true;
    system.desktop.printing.enable = true;
    system.desktop.security.enable = true;
    system.desktop.xdg-config.enable = true;
    system.desktop.virtualisation.enable = true;

    # Enable desktop application modules
    system.desktop.entertainment.enable = true;
    system.desktop.llm.enable = true;
    system.desktop.network-storage.enable = true;
    system.desktop.network-tools.enable = true;
    system.desktop.office.enable = true;

    # Enable hardware modules
    system.hardware.hardware.enable = true;

    # Enable misc modules
    system.misc.disk-decryption.enable = true;
  };
}

