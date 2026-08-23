{
  extraLib,
  pkgs,
  settings,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.virtualisation.android";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    # --- Packages ---
    environment.systemPackages = [pkgs.android-tools];

    # --- User Groups ---
    users.users.${settings.username}.extraGroups = ["adbusers"];
  };
}
