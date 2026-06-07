{
  extraLib,
  settings,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.network.base";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    lib,
    config,
    ...
  }: {
    networking = {
      hostName = settings.hostname;
      networkmanager.enable = true;
      # Only set custom nameservers on non-WSL systems (WSL manages resolv.conf)
      nameservers = lib.mkIf (!(config.wsl.enable or false)) ["1.1.1.1" "8.8.8.8"];
      # Firewall configuration
      firewall = {
        enable = true;
      };
    };

    users.users.${settings.username}.extraGroups = ["networkmanager"];
  };
})
args
