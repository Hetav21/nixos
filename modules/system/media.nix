{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.media;
in {
  options.system.media = {
    enable = mkEnableOption "Enable CLI/TUI media tools (mpv, yt-dlp)";
    enableGui = mkEnableOption "Enable GUI media tools (obs-studio, pavucontrol, kdenlive)";
  };

  config = mkMerge [
    # CLI/TUI media tools
    (mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        mpv # Can be used CLI
        yt-dlp # CLI video downloader
      ];
    })

    # GUI media tools
    (mkIf cfg.enableGui {
      # Auto-enable CLI tools
      system.media.enable = true;

      environment.systemPackages = with pkgs; [
        obs-studio
        pavucontrol
        upscayl
        youtube-music
      ];

      services.flatpak.packages = [
        "org.gnome.Loupe" # Image viewer
        "org.kde.kdenlive" # Video editor
        "com.github.PintaProject.Pinta" # Image editor
        "com.spotify.Client" # Music streaming
        "com.stremio.Stremio" # Video streaming
        "de.schmidhuberj.tubefeeder" # YouTube client
      ];
    })
  ];
}
