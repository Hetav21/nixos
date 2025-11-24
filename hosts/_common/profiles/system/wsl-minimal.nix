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
    # Core system (always needed)
    system.nix.settings.enable = true;
    system.nix.ld.enable = true;

    # CLI/TUI tools only (no GUI)
    system.virtualisation.enable = true;
    system.network.enable = true;
    system.storage.enable = true;
    system.services.enable = true;

    # Disable all GUI components
    system.virtualisation.enableGui = false;
    system.network.enableGui = false;
    system.storage.enableGui = false;
    system.media.enable = false;
    system.media.enableGui = false;
    system.productivity.enableGui = false;
    system.communication.enableGui = false;
    system.services.enableGui = false;
    system.llm.enable = false;
    system.llm.enableGui = false;
    system.desktop-environment.enableGui = false;

    # Disable hardware modules (not needed for WSL)
    system.hardware.hardware.enable = false;

    # Disable desktop sub-modules (not needed for WSL)
    system.desktop.security.enable = false;

    # Disable misc modules (not needed for WSL)
    system.misc.disk-decryption.enable = false;
  };
}

