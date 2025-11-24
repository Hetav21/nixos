{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.home.desktop.wallpaper;
in {
  options.home.desktop.wallpaper = {
    enableGui = mkEnableOption "Enable GUI wallpaper manager";
  };

  config = mkIf cfg.enableGui {
    home.packages = with pkgs; [
      waypaper
    ];

    services.swww = {
      enable = true;
      package = pkgs.swww;
    };
  };
}
