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
        # Only set custom nameservers on non-WSL systems (WSL manages resolv.conf)
        nameservers = mkIf (!(config.wsl.enable or false)) ["1.1.1.1" "8.8.8.8"];
        # Firewall configuration
        # Ports are opened by individual services as needed
        # Add custom ports here if required
        firewall = {
          enable = true;
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
