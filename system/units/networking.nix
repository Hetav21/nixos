{
  pkgs,
  options,
  settings,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Browsers
    latest.firefox
    latest.brave
    latest.mullvad-browser
    latest.chromium

    # Music and streaming
    youtube-music

    # Communication and social
    latest.thunderbird
    zoom-us
    discord
    vesktop

    # Network and internet tools

    # Networking Tools
    networkmanagerapplet
    wireshark
  ];

  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
  };

  users.users.${settings.username}.extraGroups = ["networkmanager" "wireshark"];

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
