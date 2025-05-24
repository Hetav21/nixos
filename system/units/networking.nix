{
  pkgs,
  inputs,
  options,
  settings,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Browsers
    firefox
    microsoft-edge
    brave
    mullvad-browser
    chromium
    inputs.zen-browser.packages."${system}".default

    # Music and streaming
    youtube-music

    # Communication and social
    thunderbird
    zoom-us
    discord
    vesktop

    # Network and internet tools
    yt-dlp
    qbittorrent

    # Networking Tools
    networkmanagerapplet
    wireshark
  ];

  networking = {
    hostName = settings.hostname;
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
    firewall = {
      ##      enable = false; ## Disable firewall
      allowedTCPPortRanges = [
        {
          from = 8060;
          to = 8090;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 8060;
          to = 8090;
        }
      ];
    };
  };
}
