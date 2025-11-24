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
    # Core system
    system.nix.settings.enable = true;
    system.nix.ld.enable = true;

    # Enable essential modules with both CLI and GUI (but not heavy apps)
    system.network = {
      enable = true;
      enableGui = true;
    };
    system.storage = {
      enable = true;
      enableGui = true;
    };
    system.media = {
      enable = true;
      enableGui = true;
    };
    system.productivity.enableGui = true;
    system.services = {
      enable = true;
      enableGui = true;
    };
    system.desktop-environment.enableGui = true;

    # Disable heavy applications
    system.virtualisation.enable = false;
    system.virtualisation.enableGui = false;
    system.communication.enableGui = false;
    system.llm.enable = false;
    system.llm.enableGui = false;

    # Enable hardware modules
    system.hardware.hardware.enable = true;
  };
}
