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
  ];

  services.flatpak.packages = [
    "com.microsoft.Edge" # Microsoft Edge Browser
  ];

  systemd.user.services = {
    networkd-wait-online = {
      enable = true;
      description = "User Wait for Network to be Configured";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/lib/systemd/systemd-networkd-wait-online";
        RemainAfterExit = "yes";
      };
    };
  };

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
