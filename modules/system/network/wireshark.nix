{
  extraLib,
  pkgs,
  settings,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.network.wireshark";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Packages ---
    environment.systemPackages = [pkgs.wireshark];

    # --- Programs ---
    programs.wireshark = {
      enable = true;
      dumpcap.enable = true;
      usbmon.enable = true;
    };

    # --- User Groups ---
    users.users.${settings.username}.extraGroups = ["wireshark"];
  };
}
