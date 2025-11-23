{
  lib,
  pkgs,
  config,
  settings,
  ...
}:
with lib; let
  cfg = config.system.desktop.network-tools;
in {
  options.system.desktop.network-tools = {
    enable = mkEnableOption "Enable networking applications configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
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
  };
}
