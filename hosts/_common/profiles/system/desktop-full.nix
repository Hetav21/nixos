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
    # Core system
    system.nix.settings.enable = true;
    system.nix.ld.enable = true;

    # Enable all categorized modules with both CLI and GUI
    system.virtualisation = { enable = true; enableGui = true; };
    system.network = { enable = true; enableGui = true; };
    system.storage = { enable = true; enableGui = true; };
    system.media = { enable = true; enableGui = true; };
    system.productivity.enableGui = true;
    system.communication.enableGui = true;
    system.services = { enable = true; enableGui = true; };
    system.llm = { enable = true; enableGui = true; };
    system.desktop-environment.enableGui = true;

    # Enable hardware modules
    system.hardware.hardware.enable = true;

    # Enable misc modules
    system.misc.disk-decryption.enable = true;
  };
}

