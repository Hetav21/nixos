{extraLib, ...} @ args:
(extraLib.modules.mkModule {
  name = "system.productivity.teams";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    services.flatpak.packages = [
      "com.github.IsmaelMartinez.teams_for_linux"
    ];
  };
})
args
