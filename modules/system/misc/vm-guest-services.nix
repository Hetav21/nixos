{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.virtualisation.guest";
  hasGui = false;
  cliConfig = _: {
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
    services.spice-webdavd.enable = true;
    services.spice-autorandr = {
      enable = true;
      package = pkgs.spice-autorandr;
    };
  };
})
args
