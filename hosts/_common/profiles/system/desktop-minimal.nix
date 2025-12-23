# Minimal desktop system profile with just window manager essentials
# Includes: window manager, display manager, basic security and XDG config
{
  lib,
  config,
  ...
}: {
  options.profiles.system.desktop-minimal = {
    enable = lib.mkEnableOption "Minimal desktop profile with just window manager essentials";
  };

  config = lib.mkIf config.profiles.system.desktop-minimal.enable {
    # Core system
    system.nix.settings.enable = true;
    system.nix.ld.enable = true;

    # Minimal desktop environment only (individual components)
    system.desktop.environment.enable = true;
    system.desktop.displayManager.enable = true;
    system.desktop.security.enable = true;
    system.desktop.xdgConfig.enable = true;

    # Enable base hardware modules (audio, bluetooth, input, etc.)
    system.hardware.base.enable = true;

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
    system.baseservices.enable = false;
    system.baseservices.enableGui = false;
    system.llm.enable = false;
    system.llm.enableGui = false;
    system.desktopEnvironment.enableGui = false;
  };
}
