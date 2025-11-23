{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.desktop.entertainment;
in {
  options.system.desktop.entertainment = {
    enable = mkEnableOption "Enable entertainment applications configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Gaming and entertainment

      # Music and streaming
      youtube-music

      # Communication and social
      unstable.thunderbird
      unstable.discord
      unstable.vesktop
      zoom-us
    ];

    services.flatpak.packages = [
      "com.spotify.Client"
      "com.stremio.Stremio"
      "de.schmidhuberj.tubefeeder"
    ];
  };
}
