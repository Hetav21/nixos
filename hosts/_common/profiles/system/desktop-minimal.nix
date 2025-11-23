# Minimal desktop system profile with just window manager essentials
# Includes: window manager, display manager, basic security and XDG config
{
  lib,
  config,
  ...
}:
with lib; {
  options.profiles.system.desktop-minimal = {
    enable = mkEnableOption "Minimal desktop profile with just window manager essentials";
  };

  config = mkIf config.profiles.system.desktop-minimal.enable {
    # Enable core system modules
    system.nix.settings.enable = true;
    system.nix.ld.enable = true;

    # Enable only essential desktop components
    system.desktop.environment.enable = true;
    system.desktop.display-manager.enable = true;
    system.desktop.security.enable = true;
    system.desktop.xdg-config.enable = true;

    # Enable hardware modules
    system.hardware.hardware.enable = true;

    # Disable everything else
    system.desktop.appimage.enable = false;
    system.desktop.services.enable = false;
    system.desktop.networking.enable = false;
    system.desktop.power-management.enable = false;
    system.desktop.printing.enable = false;
    system.desktop.virtualisation.enable = false;
    system.desktop.entertainment.enable = false;
    system.desktop.llm.enable = false;
    system.desktop.network-storage.enable = false;
    system.desktop.network-tools.enable = false;
    system.desktop.office.enable = false;
  };
}

