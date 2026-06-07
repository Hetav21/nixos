{extraLib, ...} @ args:
(extraLib.modules.mkModule {
  name = "system.baseservices.gnupg";
  hasCli = true;
  hasGui = false;
  cliConfig = _: {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
})
args
