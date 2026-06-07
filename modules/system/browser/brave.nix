{
  extraLib,
  pkgs-unstable,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.browser.brave";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    environment.systemPackages = [
      pkgs-unstable.brave
    ];
  };
})
args
