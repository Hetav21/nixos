{extraLib, ...} @ args:
(extraLib.modules.mkModule {
  name = "system.virtualization.guest";
  hasGui = false;
  cliConfig = _: {
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
    services.spice-webdavd.enable = true;
  };
})
args
