{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.desktop-environment;
in {
  options.system.desktop-environment = {
    enableGui = mkEnableOption "Enable GUI desktop environment components";
  };

  config = mkIf cfg.enableGui {
    # Import desktop environment sub-modules
    system.desktop.appimage.enable = true;
    system.desktop.environment.enable = true;
    system.desktop.display-manager.enable = true;
    system.desktop.xdg-config.enable = true;
    system.desktop.security.enable = true;
    system.desktop.power-management.enable = true;
    system.desktop.printing.enable = true;
  };
}
