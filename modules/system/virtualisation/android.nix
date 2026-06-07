{
  extraLib,
  pkgs,
  settings,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.virtualisation.android";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    environment.systemPackages = with pkgs; [
      android-tools
    ];
    users.users.${settings.username}.extraGroups = ["adbusers"];
  };
})
args
