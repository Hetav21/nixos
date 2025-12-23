# Base desktop system profile without heavy applications
# Includes: core desktop, essential services, lighter applications
{
  lib,
  config,
  hardware ? {},
  ...
}: {
  options.profiles.system.desktop-base = {
    enable = lib.mkEnableOption "Base desktop profile without heavy applications";
  };

  config = lib.mkIf config.profiles.system.desktop-base.enable {
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
    system.baseservices = {
      enable = true;
      enableGui = true;
    };
    system.desktopEnvironment.enableGui = true;

    # Disable heavy applications
    system.virtualisation.enable = false;
    system.virtualisation.enableGui = false;
    system.communication.enableGui = false;
    system.llm.enable = false;
    system.llm.enableGui = false;

    # Enable base hardware modules (audio, bluetooth, input, etc.)
    system.hardware.base.enable = true;

    # Enable hardware drivers based on hardware config
    drivers.nvidia.enable = hardware.nvidia.enable or false;
    drivers.intel.enable = hardware.intel.enable or false;
    drivers.amdgpu.enable = hardware.amdgpu.enable or false;
    drivers.asus.enable = hardware.asus.enable or false;
  };
}
