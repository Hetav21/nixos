# ASUS-specific hardware support (asusd, supergfxd, rog-control-center)
{extraLib, ...} @ args:
(extraLib.modules.mkModule {
  name = "drivers.asus";
  hasGui = false;
  cliConfig = _: {
    services = {
      # supergfxd controls GPU switching
      supergfxd.enable = true;

      # ASUS specific software. This also installs asusctl.
      asusd = {
        enable = true;
        enableUserService = true;
      };
    };

    programs = {
      rog-control-center = {
        enable = true;
        autoStart = true;
      };
    };
  };
})
args
