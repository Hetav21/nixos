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
    enable = mkEnableOption "Enable wallpaper configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      waypaper
    ];

    services.swww = {
      enable = true;
      package = pkgs.swww;
    };
  };
}

