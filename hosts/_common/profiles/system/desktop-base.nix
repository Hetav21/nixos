# Base desktop system profile without heavy applications
# Includes: core desktop, essential services, lighter applications
{
  lib,
  config,
  ...
}:
with lib; {
  options.profiles.system.desktop-base = {
    enable = mkEnableOption "Base desktop profile without heavy applications";
  };

  config = mkIf config.profiles.system.desktop-base.enable {
    # Enable core system modules
    system.nix.settings.enable = true;
    system.nix.ld.enable = true;

    # Enable essential desktop system modules
    system.desktop.appimage.enable = true;
    system.desktop.environment.enable = true;
    system.desktop.display-manager.enable = true;
    system.desktop.services.enable = true;
    system.desktop.networking.enable = true;
    system.desktop.security.enable = true;
    system.desktop.xdg-config.enable = true;

    # Enable hardware modules
    system.hardware.hardware.enable = true;

    # Disable heavy applications
    system.desktop.entertainment.enable = false;
    system.desktop.llm.enable = false;
    system.desktop.virtualisation.enable = false;
    
    # Enable lighter applications
    system.desktop.network-tools.enable = true;
    system.desktop.office.enable = true;
  };
}

