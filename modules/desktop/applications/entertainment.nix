{pkgs, ...}: {
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
    "com.spotify.Client" # Spotify Client
    "com.stremio.Stremio" # Media Streaming
    "de.schmidhuberj.tubefeeder" # YouTube Client
  ];
}
