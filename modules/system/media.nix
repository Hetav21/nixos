{
  mkModule,
  pkgs,
  ...
} @ args:
(mkModule {
  name = "system.media";
  hasGui = true;
  cliConfig = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      mpv # Can be used CLI
      yt-dlp # CLI video downloader
    ];
  };
  guiConfig = {pkgs, ...}: {
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
  };
})
args
