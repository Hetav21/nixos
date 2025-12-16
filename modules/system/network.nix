{
  extraLib,
  lib,
  pkgs,
  config,
  settings,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.network";
  hasGui = true;
  cliConfig = {
    lib,
    pkgs,
    config,
    settings,
    ...
  }: {
    # Networking configuration
    networking = {
      hostName = settings.hostname;
      networkmanager.enable = true;
      # Only set custom nameservers on non-WSL systems (WSL manages resolv.conf)
      nameservers = lib.mkIf (!(config.wsl.enable or false)) ["1.1.1.1" "8.8.8.8"];
      # Firewall configuration
      # Ports are opened by individual services as needed
      # Add custom ports here if required
      firewall = {
        enable = true;
      };
    };

    users.users.${settings.username}.extraGroups = ["networkmanager"];
  };
  guiConfig = {
    pkgs,
    settings,
    ...
  }: {
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
  };
})
args
