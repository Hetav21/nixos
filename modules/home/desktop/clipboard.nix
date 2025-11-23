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
    enable = mkEnableOption "Enable clipboard configuration";
  };

  config = mkIf cfg.enable {
    services.cliphist = {
      enable = true;
      package = pkgs.cliphist;
      allowImages = true;
      systemdTargets = ["hyprland-session.target"];
      extraOptions = ["-max-dedupe-search" "10" "-max-items" "500"];
    };
  };
}

