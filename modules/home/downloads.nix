{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.home.downloads;
in {
  options.home.downloads = {
    enable = mkEnableOption "Enable CLI/TUI download tools (aria2, yt-dlp)";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Download managers
      aria2
      yt-dlp
    ];
  };
}

