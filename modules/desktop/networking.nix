{
  pkgs,
  options,
  settings,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Browsers
    unstable.google-chrome
    unstable.firefox
    unstable.brave
    unstable.mullvad-browser
    custom.browseros
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
      # Allow libvirt's traffic
      allowedUDPPorts = [53 67]; # For DNS and DHCP
      allowedTCPPorts = [53]; # For DNS

      # Allow established connections to pass
      extraCommands = ''
        iptables -A INPUT -i virbr0 -p udp -m udp --dport 53 -j ACCEPT
        iptables -A INPUT -i virbr0 -p tcp -m tcp --dport 53 -j ACCEPT
        iptables -A INPUT -i virbr0 -p udp -m udp --dport 67 -j ACCEPT
        iptables -A FORWARD -i virbr0 -j ACCEPT
      '';
    };
  };
}
