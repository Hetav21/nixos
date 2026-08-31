{
  extraLib,
  pkgs,
  settings,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.misc.locate";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    # --- Locate Service ---
    services.locate = {
      enable = true;
      package = pkgs.mlocate;
    };

    # --- User Groups ---
    users.users.${settings.username}.extraGroups = ["mlocate"];
  };
}
