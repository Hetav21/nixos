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
    # Core system
    system.nix.settings.enable = true;
    system.nix.ld.enable = true;

    # Minimal desktop environment only (individual components)
    system.desktop.environment.enable = true;
    system.desktop.display-manager.enable = true;
    system.desktop.security.enable = true;
    system.desktop.xdg-config.enable = true;

    # Enable hardware modules
    system.hardware.hardware.enable = true;

    # Disable all categorized modules
    system.virtualisation.enable = false;
    system.virtualisation.enableGui = false;
    system.network.enable = false;
    system.network.enableGui = false;
    system.storage.enable = false;
    system.storage.enableGui = false;
    system.media.enable = false;
    system.media.enableGui = false;
    system.productivity.enableGui = false;
    system.communication.enableGui = false;
    system.services.enable = false;
    system.services.enableGui = false;
    system.llm.enable = false;
    system.llm.enableGui = false;
    system.desktop-environment.enableGui = false;
  };
}
