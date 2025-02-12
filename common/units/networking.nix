{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
  hostName = "nixbook";
in {
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    openssh
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
