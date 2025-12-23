# Full desktop system profile with all features enabled
# Includes: all system modules, desktop environment, applications, hardware support
{
  lib,
  config,
  hardware ? {},
  ...
}: {
  options.profiles.system.desktop-full = {
    enable = lib.mkEnableOption "Full desktop profile with all features";
  };

  config = lib.mkIf config.profiles.system.desktop-full.enable {
    # Core system
    system.nix.settings.enable = true;
    system.nix.ld.enable = true;

    # Enable all categorized modules with both CLI and GUI
    system.virtualisation = {
      enable = true;
      enableGui = true;
    };
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
    system.communication.enableGui = true;
    system.browser.enableGui = true;
    system.baseservices = {
      enable = true;
      enableGui = true;
    };
    system.llm = {
      enable = true;
      enableGui = true;
    };
    system.desktopEnvironment.enableGui = true;

    # Enable base hardware modules (audio, bluetooth, input, etc.)
    system.hardware.base.enable = true;

    # Enable misc modules
    system.misc.diskDecryption.enable = true;

    # Enable hardware drivers based on hardware config
    drivers.nvidia.enable = hardware.nvidia.enable or false;
    drivers.intel.enable = hardware.intel.enable or false;
    drivers.amdgpu.enable = hardware.amdgpu.enable or false;
    drivers.asus.enable = hardware.asus.enable or false;
  };
}
