{
  lib,
  pkgs,
  config,
  settings,
  ...
}:
with lib; let
  cfg = config.system.network;
in {
  options.system.network = {
    enable = mkEnableOption "Enable base networking configuration";
    enableGui = mkEnableOption "Enable GUI network tools (wireshark, network-manager-applet)";
  };

  config = mkMerge [
    # Base CLI networking
    (mkIf cfg.enable {
      # Networking configuration
      networking = {
        hostName = settings.hostname;
        networkmanager.enable = true;
        nameservers = ["1.1.1.1" "8.8.8.8"];
        # firewall configuration
        firewall = {
          enable = true;
          allowedTCPPorts = [];
          allowedUDPPorts = [];
        };
      };

      users.users.${settings.username}.extraGroups = ["networkmanager"];
    })

    # GUI network tools
    (mkIf cfg.enableGui {
      # Auto-enable base networking
      system.network.enable = true;

      environment.systemPackages = with pkgs; [
        networkmanagerapplet
        wireshark
      ];

      programs.wireshark = {
        enable = true;
        dumpcap.enable = true;
        usbmon.enable = true;
      };

      users.users.${settings.username}.extraGroups = ["wireshark"];
    })
  ];
}
