{
  pkgs,
  inputs,
  options,
  ...
}: let
  hostName = "nixbook";
in {
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
    spicetify-cli

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
    openssh
    wireshark
    tailscale
    cloudflare-warp
    avahi
  ];

  networking = {
    hostName = hostName;
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

  services = {
    openssh.enable = true;
    cloudflare-warp = {
      enable = true;
      openFirewall = true;
    };
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
