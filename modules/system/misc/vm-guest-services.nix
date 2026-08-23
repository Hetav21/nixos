{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.virtualisation.guest";
  hasGui = false;
  cliConfig = {
    # --- Guest Integration Services ---
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
    services.spice-webdavd.enable = true;
    services.spice-autorandr = {
      enable = true;
      package = pkgs.spice-autorandr;
    };
  };
}
