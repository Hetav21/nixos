{
  pkgs,
  settings,
  ...
}: {
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
}
