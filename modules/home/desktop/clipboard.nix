{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.home.desktop.clipboard;
in {
  options.home.desktop.clipboard = {
    enableGui = mkEnableOption "Enable GUI clipboard manager";
  };

  config = mkIf cfg.enableGui {
    services.cliphist = {
      enable = true;
      package = pkgs.cliphist;
      allowImages = true;
      systemdTargets = ["hyprland-session.target"];
      extraOptions = ["-max-dedupe-search" "10" "-max-items" "500"];
    };
  };
}
