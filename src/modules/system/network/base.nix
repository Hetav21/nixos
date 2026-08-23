{
  extraLib,
  settings,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.network.base";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    lib,
    config,
    ...
  }: {
    # --- Network Configuration ---
    networking = {
      hostName = settings.hostname;
      networkmanager.enable = true;
      # Custom nameservers are skipped on WSL because WSL dynamically manages /etc/resolv.conf
      nameservers = lib.mkIf (!(config.wsl.enable or false)) [
        "1.1.1.1"
        "8.8.8.8"
      ];
      firewall.enable = true;
    };

    # --- User Groups ---
    users.users.${settings.username}.extraGroups = ["networkmanager"];
  };
}
