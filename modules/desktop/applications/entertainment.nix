{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Gaming and entertainment

    # Music and streaming
    youtube-music

    # Communication and social
    latest.thunderbird
    zoom-us
    discord
    vesktop
  ];

  services.flatpak.packages = [
    "com.spotify.Client" # Spotify Client
    "com.stremio.Stremio" # Media Streaming
    "de.schmidhuberj.tubefeeder" # YouTube Client
  ];
}
